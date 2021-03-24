#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

for i in $(yabai -m query --spaces | jq '.[] | .index'); do
  yabai -m space "$i" --label "space$i"
done;
