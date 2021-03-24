#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SPACE="$1"

yabai -m window --space "space$SPACE"
