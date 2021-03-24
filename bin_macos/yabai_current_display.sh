#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

yabai -m query --displays --display | jq .index
