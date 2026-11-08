import ctypes
import time
from pathlib import Path

# Temporary system-sleep inhibition; no persistent power-plan changes.
stop = Path(__file__).with_name('stop-keep-awake')
try:
    if not ctypes.windll.kernel32.SetThreadExecutionState(0x80000001):
        raise OSError('SetThreadExecutionState failed')
    deadline = time.monotonic() + 7200
    while time.monotonic() < deadline and not stop.exists():
        time.sleep(10)
finally:
    ctypes.windll.kernel32.SetThreadExecutionState(0x80000000)
