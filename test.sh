#!/bin/bash

set -e

echo compiling tests/mem
magelang compile tests/mem -o /tmp/tests_mem.wasm
echo tests/mem testcase_1
wasmtime /tmp/tests_mem.wasm --invoke testcase_1
echo tests/mem testcase_2
wasmtime /tmp/tests_mem.wasm --invoke testcase_2

echo compiling tests/vec
magelang compile tests/vec -o /tmp/tests_vec.wasm
echo tests/vec testcase_1
wasmtime /tmp/tests_vec.wasm --invoke testcase_1

