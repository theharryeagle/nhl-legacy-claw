# Gameplay capture

1. Start NHL Legacy and enter a match. Warm up before recording.
2. Open C:\Emulation\NHL-Legacy-Claw\Capture 5 minutes.lnk and approve the Windows administrator prompt.
3. Play for five minutes; the recording stops automatically.

Results: C:\Coding\NHL-Legacy-Claw\captures\<timestamp-label>.
frames.csv: PresentMon frame data with absolute timestamps.
telemetry.jsonl: one-second CPU/per-core, process CPU, GPU engine and GPU memory samples. GPU counters are filtered to the game PID. GPU engine percentages must not be summed indiscriminately.
run.json: timestamps/QPC, binary hashes and sensor availability.
settings.ini: saved game settings when present. Label is descriptive, not proof of effective settings.

Power/temperature/clocks: not connected yet. Do not infer watts from utilization or treat missing measurements as zero.

Verified: PresentMon 2.5.1 installed, script parses, Windows CPU/GPU counters return samples. Non-elevated PresentMon test failed with access denied. Elevated frame capture and logging overhead have NOT yet been verified. Raw per-frame data must be inspected before declaring the pipeline passed.
