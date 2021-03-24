#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

yabai -m query --spaces --space | jq .index
