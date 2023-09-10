#!/bin/bash

function embed() {
  name=$1
  file=$2
  echo -n let $name: [*]u8 = \"
  xxd -p "$file" | awk '{ gsub(/../, "\\x&"); print }' | tr -d \\n
  echo "\";"
}

rm embed.mg
touch embed.mg

embed base_bmp base.bmp >> embed.mg
embed background_bmp background.bmp >> embed.mg
embed favicon_ico favicon.ico >> embed.mg

magelang compile main -o main.wasm

