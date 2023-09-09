#!/bin/bash

set -e

magelang compile tests/mem -o /tmp/tests_mem.wasm
wasmtime /tmp/tests_mem.wasm --invoke testcase_1
wasmtime /tmp/tests_mem.wasm --invoke testcase_2

