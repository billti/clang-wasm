REM Note: This currently fails to build with the below error:
REM   VC\Tools\MSVC\14.16.27023\include\vcruntime.h(184,30): error: typedef redefinition with different types ('unsigned int' vs 'unsigned long')
REM Other builds and links commented out until addressed.

REM If LLVM 8 installed to a different location, update below.
REM Below is default install location if installed from https://releases.llvm.org/8.0.0/LLVM-8.0.0-win64.exe
SET LLVM_BIN=C:\Program Files\LLVM\bin

SET LD=%LLVM_BIN%\wasm-ld.exe
SET LINK_FLAGS=--no-entry --strip-all --export-dynamic --initial-memory=131072 -error-limit=0 --lto-O3 -O3 --gc-sections

REM Pass the "cl" argument to build using clang-cl instead of clang++
if /i "%1"=="cl" goto clangcl

:clangpp
SET CC=%LLVM_BIN%\clang++.exe
SET COMPILE_FLAGS=--target=wasm32 -Os -flto -nostdlib -fvisibility=hidden -std=c++14 -D _M_IX86 ^
  -ffunction-sections -fdata-sections -fms-extensions -fms-compatibility -fms-compatibility-version=19.16.27026 ^
  -I "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023\include" ^
  -I "C:\Program Files (x86)\Windows Kits\10\Include\10.0.17763.0\ucrt"

"%CC%" -c %COMPILE_FLAGS% -o library.o library.cpp
REM %CC% -c %COMPILE_FLAGS% -o libc.o libc.cpp memory.cpp printf.cpp putchar.cpp
REM %LD% -o library.wasm %LINK_FLAGS% library.o libc.o
exit /b

:clangcl
SET CC=%LLVM_BIN%\clang-cl.exe
SET COMPILE_FLAGS=/c --target=wasm32 -fms-compatibility -D _M_IX86 ^
  -I "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023\include" ^
  -I "C:\Program Files (x86)\Windows Kits\10\Include\10.0.17763.0\ucrt"

"%CC%" %COMPILE_FLAGS% /Folibrary.o library.cpp
REM %CC% %COMPILE_FLAGS% /Folibc.o libc.cpp memory.cpp printf.cpp putchar.cpp
REM %LD% -o library.wasm %LINK_FLAGS% library.o libc.o
exit /b
