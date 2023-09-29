#!/bin/bash

echo Compiling
magelang compile main -o main.wasm

echo Optimizing
./wasm-opt --enable-reference-types --enable-multivalue -O4 main.wasm -o main.opt.wasm > /dev/null 2>&1
if [ ! -f main.opt.wasm ]; then
  echo "wasm-opt program cannot be executed in your machine, will use unoptimized webassembly"
  cp main.wasm main.opt.wasm
fi

mkdir -p build/
cp index.html build/index.html
cp main.js build/main.js
mv main.wasm build/main.wasm
mv main.opt.wasm build/main.opt.wasm
cp assets/favicon.ico build/favicon.ico
