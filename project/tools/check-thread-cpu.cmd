@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
"C:\Program Files\LLVM\bin\clang++.exe" -O2 -std=c++23 C:\Coding\NHL-Legacy-Claw\tools\check-thread-cpu.cpp -o C:\Coding\NHL-Legacy-Claw\tools\check-thread-cpu.exe
if errorlevel 1 exit /b 1
C:\Coding\NHL-Legacy-Claw\tools\check-thread-cpu.exe
exit /b %errorlevel%
