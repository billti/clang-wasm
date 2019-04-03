REM If LLVM 8 installed to a different location, update below.
REM Below is default install location if installed from https://releases.llvm.org/8.0.0/LLVM-8.0.0-win64.exe
SET LLVM_BIN=C:\Program Files\LLVM\bin

SET CC=%LLVM_BIN%\clang++.exe
SET CC_FLAGS=--target=wasm32 -Os -flto -nostdlib -fvisibility=hidden -std=c++14 -D _M_IX86 ^
  -ffunction-sections -fdata-sections -fms-extensions -fms-compatibility -fms-compatibility-version=19.16.27026

SET LD=%LLVM_BIN%\wasm-ld.exe
SET LD_FLAGS=--no-entry --export-dynamic --initial-memory=131072 -error-limit=0 --lto-O3 -O3 --gc-sections

"%CC%" -c %CC_FLAGS% -o library.o library.cpp
"%CC%" -c %CC_FLAGS% nanolibc\libc.cpp nanolibc\memory.cpp nanolibc\printf.cpp nanolibc\putchar.cpp
"%LD%" -o library.wasm %LD_FLAGS% library.o libc.o memory.o printf.o putchar.o
exit /b
