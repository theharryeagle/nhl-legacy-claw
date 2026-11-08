@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit /b 1
set "PATH=C:\Program Files\LLVM\bin;C:\Program Files\CMake\bin;%PATH%"
set "VULKAN_SDK=C:\VulkanSDK\1.4.350.0"
cd /d C:\Coding\NHL-Legacy-Claw\source\erik
if not exist generated\default\nhllegacy_init.h C:\Coding\NHL-Legacy-Claw\source\sdk\out\win-amd64\rexglue.exe codegen nhllegacy_manifest.toml
if errorlevel 1 exit /b 1
cmake -S . -B C:\Coding\NHL-Legacy-Claw\build\game -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=-march=x86-64-v3 -DCMAKE_CXX_FLAGS=-march=x86-64-v3 -DREXSDK_DIR=C:/Coding/NHL-Legacy-Claw/source/sdk -DREXGLUE_USE_VULKAN=ON -DREXGLUE_USE_D3D12=OFF -DREXGLUE_ENABLE_TRACY=OFF -DNHLLEGACY_SDK010_VULKAN=ON -DNHLLEGACY_VULKAN_BACKEND=ON -DNHLLEGACY_BUILD_PACKAGER=OFF -DNHLLEGACY_BUILD_TRACE_TOOLS=OFF
if errorlevel 1 exit /b 1
cmake --build C:\Coding\NHL-Legacy-Claw\build\game --target nhllegacy --parallel 4
exit /b %errorlevel%
