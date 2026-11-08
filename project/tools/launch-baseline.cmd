@echo off
setlocal
cd /d C:\Emulation\NHL-Legacy-Claw
set "NHL_SWAP_INTERVAL=0"
set "NHL_VK_READBACK_MODE=fast"
set "NHL_DIRECT_PRESENT=1"
set "REX_CLEAR_MEMORY_PAGE_STATE=false"
set "REX_NHL_RT_SKIP_OVERWRITTEN_TRANSFERS=true"
set "NHL_VP6_FFMPEG=C:\Emulation\NHL-Legacy-Claw\ffmpeg.exe"
nhllegacy.exe --game_data_root=C:\Emulation\NHL-Legacy-Claw\game --user_data_root=C:\Emulation\NHL-Legacy-Claw\profiles\baseline
exit /b %errorlevel%
