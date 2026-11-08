$ErrorActionPreference='Continue'
Wait-Process -Id 8060 -ErrorAction SilentlyContinue
$repo='C:\Coding\NHL-Legacy-Megarohas'
if(!(Test-Path "$repo\ref\rexglue-sdk-custom\install\win-amd64\lib\cmake\rexglue\rexglueConfig.cmake")){throw 'SDK install failed; inspect megarohas-sdk.log'}
$env:JOBS='4'
$env:VULKAN_SDK='C:\VulkanSDK\1.4.350.0'
cmd /c "$repo\nhl-legacy-port\build.cmd" > C:\Coding\NHL-Legacy-Claw\logs\megarohas-game.log 2>&1
if($LASTEXITCODE -ne 0){throw 'Game build failed; inspect megarohas-game.log'}
cmd /c "$repo\nhl-legacy-port\launcher\build.cmd" > C:\Coding\NHL-Legacy-Claw\logs\megarohas-launcher.log 2>&1
if($LASTEXITCODE -ne 0){throw 'Launcher build failed'}
$dest='C:\Emulation\NHL-Legacy-Megarohas'
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item "$repo\nhl-legacy-port\out\build\win-amd64-release\*.exe","$repo\nhl-legacy-port\out\build\win-amd64-release\*.dll" $dest
Copy-Item "$repo\nhl-legacy-port\out\launcher\nhllegacy_launcher.exe" $dest
if(!(Test-Path "$dest\game")){New-Item -ItemType Junction -Path "$dest\game" -Target 'C:\Emulation\NHL-Legacy-Claw\game' | Out-Null}
$config=Get-Content "$repo\nhl-legacy-port\nhllegacy.example.toml" -Raw
$config=$config -replace '(?m)^game_data_root\s*=.*','game_data_root = "C:/Emulation/NHL-Legacy-Claw/game"'
$config=$config -replace '(?m)^user_data_root\s*=.*','user_data_root = "C:/Emulation/NHL-Legacy-Megarohas/userdata"'
$config=$config -replace '(?m)^log_file\s*=.*','log_file = "C:/Emulation/NHL-Legacy-Megarohas/game.log"'
[IO.File]::WriteAllText("$dest\nhllegacy.toml",$config,[Text.UTF8Encoding]::new($false))
$shell=New-Object -ComObject WScript.Shell
$link=$shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'NHL Legacy - Megarohas.lnk'))
$link.TargetPath="$dest\nhllegacy_launcher.exe";$link.WorkingDirectory=$dest;$link.Save()
Get-FileHash "$dest\*.exe","$dest\*.dll" | ConvertTo-Json | Set-Content "$dest\build-hashes.json"
'Installed successfully' | Set-Content C:\Coding\NHL-Legacy-Claw\logs\megarohas-install-status.txt
