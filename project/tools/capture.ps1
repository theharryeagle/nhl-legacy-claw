param([int]$Seconds=300,[string]$Label='720p-60-target')
$ErrorActionPreference='Stop'
$root='C:\Coding\NHL-Legacy-Claw'
$run=Join-Path "$root\captures" ((Get-Date -Format 'yyyyMMdd-HHmmss')+'-'+($Label -replace '[^a-zA-Z0-9_-]','_'))
New-Item -ItemType Directory -Path $run | Out-Null
$game=Get-Process nhllegacy -ErrorAction SilentlyContinue | Select-Object -First 1
if(!$game){throw 'Start NHL Legacy and enter gameplay before starting capture.'}
$identity=New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if(!$identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){throw 'Use the elevated capture shortcut; PresentMon requires administrator access on this PC.'}
$meta=[ordered]@{label=$Label;duration_seconds=$Seconds;started_utc=[DateTime]::UtcNow.ToString('o');qpc_start=[Diagnostics.Stopwatch]::GetTimestamp();qpc_frequency=[Diagnostics.Stopwatch]::Frequency;game_pid=$game.Id;logical_processors=[Environment]::ProcessorCount;settings_label_is_user_description=$true;power_watts=$null;temperature_c=$null;sensor_status='Package power, temperatures and clocks not yet connected; null means unavailable, never zero.';presentmon_version='2.5.1'}
$gameExe=$game.MainModule.FileName
$gameDir=Split-Path $gameExe
$meta.executable_path=$gameExe
$meta.binary_hashes=Get-FileHash $gameExe,(Join-Path $gameDir 'rexruntime.dll') -ErrorAction SilentlyContinue | Select-Object Path,Hash
$meta | ConvertTo-Json -Depth 5 | Set-Content "$run\run.json"
Copy-Item (Join-Path $gameDir 'nhl_enhancements.ini') "$run\settings.ini" -ErrorAction SilentlyContinue
$pm=(Get-Command presentmon.exe).Source
$trace=Start-Process $pm -ArgumentList @('--process_id',$game.Id,'--output_file',"$run\frames.csv",'--date_time','--timed',$Seconds,'--terminate_after_timed','--session_name',('NHLClaw'+$PID),'--no_console_stats') -WindowStyle Hidden -PassThru -RedirectStandardOutput "$run\presentmon.out.log" -RedirectStandardError "$run\presentmon.err.log"
$counterObjects=@()
foreach($spec in @(@('Processor Information','% Processor Time'),@('GPU Engine','Utilization Percentage'),@('GPU Process Memory','Dedicated Usage'),@('GPU Process Memory','Shared Usage'))){
 try{
  $category=[Diagnostics.PerformanceCounterCategory]::new($spec[0])
  foreach($instance in $category.GetInstanceNames()){
   if($spec[0] -eq 'Processor Information' -or $instance -like "pid_$($game.Id)_*"){
    $counter=[Diagnostics.PerformanceCounter]::new($spec[0],$spec[1],$instance,$true)
    $null=$counter.NextValue();$counterObjects+=$counter
   }
  }
 }catch{Add-Content "$run\counter-errors.log" $_.Exception.Message}
}

$clock=[Diagnostics.Stopwatch]::StartNew()
$previousCpu=$game.TotalProcessorTime.TotalSeconds
$previousWall=0.0
$writer=[IO.StreamWriter]::new("$run\telemetry.jsonl")
try {
 while($clock.Elapsed.TotalSeconds -lt $Seconds){
  $sample=[ordered]@{utc=[DateTime]::UtcNow.ToString('o');qpc=[Diagnostics.Stopwatch]::GetTimestamp();elapsed_seconds=$clock.Elapsed.TotalSeconds;process_cpu_percent_machine=$null;process_working_set_bytes=$null;counters=@();errors=@()}
  try { $game.Refresh(); $wall=$clock.Elapsed.TotalSeconds; $cpu=$game.TotalProcessorTime.TotalSeconds; if($wall -gt $previousWall){$sample.process_cpu_percent_machine=100*($cpu-$previousCpu)/($wall-$previousWall)/[Environment]::ProcessorCount}; $previousCpu=$cpu; $previousWall=$wall; $sample.process_working_set_bytes=$game.WorkingSet64 }catch{$sample.errors+= $_.Exception.Message}
  $sample.counters=@(foreach($counter in $counterObjects){
   try{[pscustomobject]@{Path=($counter.CategoryName+'\'+$counter.CounterName);InstanceName=$counter.InstanceName;CookedValue=$counter.NextValue();Timestamp=[DateTime]::UtcNow.ToString('o')}}catch{$sample.errors+=$_.Exception.Message}
  })

  $writer.WriteLine(($sample | ConvertTo-Json -Depth 5 -Compress));$writer.Flush()
  Start-Sleep -Milliseconds 1000
  if($trace.HasExited -and $clock.Elapsed.TotalSeconds -lt ($Seconds-2)){throw "PresentMon exited early ($($trace.ExitCode)); inspect presentmon.err.log"}
 }
 $trace.WaitForExit(10000) | Out-Null
 if($trace.ExitCode -ne 0){throw "PresentMon failed ($($trace.ExitCode))"}
}finally{foreach($counter in $counterObjects){$counter.Dispose()};$writer.Dispose();$meta.finished_utc=[DateTime]::UtcNow.ToString('o');$meta | ConvertTo-Json -Depth 5 | Set-Content "$run\run.json"}
Write-Host "Capture saved: $run"
Read-Host 'Press Enter to close'
