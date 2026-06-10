#!/usr/bin/env bash

title=$("$HOME/.config/waybar/scripts/cliamp-now-playing.py" --plain 2>/dev/null) || exit 0

query=$(jq -rn --arg q "$title" '$q | @uri')
uri="spotify:search:$query"

if command -v spotify >/dev/null 2>&1; then
  if command -v setsid >/dev/null 2>&1; then
    setsid -f spotify --uri="$uri" >/dev/null 2>&1
  else
    spotify --uri="$uri" >/dev/null 2>&1 &
  fi
elif command -v xdg-open >/dev/null 2>&1; then
  if command -v setsid >/dev/null 2>&1; then
    setsid -f xdg-open "$uri" >/dev/null 2>&1
  else
    xdg-open "$uri" >/dev/null 2>&1 &
  fi
else
  exit 0
fi

sleep 0.4
omarchy-launch-or-focus spotify >/dev/null 2>&1 || true
