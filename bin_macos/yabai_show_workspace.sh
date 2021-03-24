#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SPACE="$1"

#yabai -m space "$SPACE" --display "$(~/bin/yabai_current_display.sh)" || true
yabai -m space --focus "$SPACE"
