@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit /b 1
set "PATH=C:\Program Files\LLVM\bin;C:\Program Files\CMake\bin;%PATH%"
set "VULKAN_SDK=C:\VulkanSDK\1.4.350.0"
cmake -S C:\Coding\NHL-Legacy-Claw\source\sdk -B C:\Coding\NHL-Legacy-Claw\build\sdk -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=-march=x86-64-v3 -DCMAKE_CXX_FLAGS=-march=x86-64-v3 -DREXGLUE_USE_VULKAN=ON -DREXGLUE_USE_D3D12=OFF -DREXGLUE_ENABLE_TRACY=OFF
if errorlevel 1 exit /b 1
cmake --build C:\Coding\NHL-Legacy-Claw\build\sdk --target rexglue --parallel 4
exit /b %errorlevel%
