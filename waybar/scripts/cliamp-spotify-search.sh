#!/usr/bin/env bash

title=$("$HOME/.config/waybar/scripts/cliamp-now-playing.py" --plain 2>/dev/null) || exit 0

query=$(jq -rn --arg q "$title" '$q | @uri')
spotify_uri="spotify:search:$query"
beatport_url="https://www.beatport.com/search?q=$query"
cliamp_pattern='^org\.omarchy\.cliamp$'
spotify_pattern='spotify'
beatport_pattern='beatport|www\.beatport\.com'

launch_detached() {
  if command -v setsid >/dev/null 2>&1; then
    setsid -f "$@" >/dev/null 2>&1
  else
    "$@" >/dev/null 2>&1 &
  fi
}

client_address() {
  local pattern="$1"
  local match="${2:-any}"

  hyprctl clients -j 2>/dev/null |
    jq -r --arg pattern "$pattern" --arg match "$match" '
      def is_match:
        if $match == "class" then
          (.class // "" | test($pattern; "i"))
        else
          ((.class // "" | test($pattern; "i")) or (.title // "" | test($pattern; "i")))
        end;

      .[]
      | select(is_match)
      | .address
    ' |
    head -n1
}

client_workspace() {
  local pattern="$1"
  local match="${2:-any}"

  hyprctl clients -j 2>/dev/null |
    jq -r --arg pattern "$pattern" --arg match "$match" '
      def is_match:
        if $match == "class" then
          (.class // "" | test($pattern; "i"))
        else
          ((.class // "" | test($pattern; "i")) or (.title // "" | test($pattern; "i")))
        end;

      .[]
      | select(is_match)
      | .workspace.name // (.workspace.id | tostring)
    ' |
    head -n1
}

active_workspace() {
  hyprctl activeworkspace -j 2>/dev/null |
    jq -r '.name // (.id | tostring)' 2>/dev/null
}

wait_for_client() {
  local pattern="$1"
  local attempts="${2:-30}"
  local match="${3:-any}"
  local address=""

  while ((attempts > 0)); do
    address=$(client_address "$pattern" "$match")
    if [[ -n $address ]]; then
      printf '%s\n' "$address"
      return 0
    fi

    sleep 0.1
    ((attempts--))
  done

  return 1
}

move_to_workspace() {
  local address="$1"
  local workspace="$2"

  [[ -n $address && -n $workspace ]] || return 0
  hyprctl dispatch movetoworkspacesilent "$workspace,address:$address" >/dev/null 2>&1 || true
}

focus_window() {
  local address="$1"

  [[ -n $address ]] || return 0
  hyprctl dispatch focuswindow "address:$address" >/dev/null 2>&1 || true
}

preselect_split() {
  local direction="$1"

  [[ -n $direction ]] || return 0
  hyprctl dispatch layoutmsg "preselect $direction" >/dev/null 2>&1 || true
}

window_size() {
  local address="$1"

  hyprctl clients -j 2>/dev/null |
    jq -r --arg address "$address" '
      .[]
      | select(.address == $address)
      | "\(.size[0]) \(.size[1])"
    ' |
    head -n1
}

resize_window_exact() {
  local address="$1"
  local width="$2"
  local height="$3"

  [[ -n $address && -n $width && -n $height ]] || return 0
  hyprctl dispatch resizewindowpixel "exact $width $height,address:$address" >/dev/null 2>&1 || true
}

resize_cliamp_for_bottom_group() {
  local cliamp_address="$1"
  local bottom_address="$2"
  local cliamp_size=""
  local bottom_size=""
  local width=""
  local cliamp_height=""
  local bottom_height=""
  local total_height=""
  local target_height=""

  [[ -n $cliamp_address && -n $bottom_address ]] || return 0

  cliamp_size=$(window_size "$cliamp_address")
  bottom_size=$(window_size "$bottom_address")
  [[ -n $cliamp_size && -n $bottom_size ]] || return 0

  read -r width cliamp_height <<<"$cliamp_size"
  read -r _ bottom_height <<<"$bottom_size"
  total_height=$((cliamp_height + bottom_height))
  target_height=$((total_height * 35 / 100))

  resize_window_exact "$cliamp_address" "$width" "$target_height"
}

open_spotify_search() {
  if command -v spotify >/dev/null 2>&1; then
    launch_detached spotify --uri="$spotify_uri"
  elif command -v xdg-open >/dev/null 2>&1; then
    launch_detached xdg-open "$spotify_uri"
  else
    return 1
  fi
}

cliamp_workspace=$(client_workspace "$cliamp_pattern" class)
target_workspace="${cliamp_workspace:-$(active_workspace)}"
cliamp_address=$(client_address "$cliamp_pattern" class)

if [[ -n $target_workspace ]]; then
  hyprctl dispatch workspace "$target_workspace" >/dev/null 2>&1 || true
fi

if [[ -n $cliamp_address ]]; then
  focus_window "$cliamp_address"
  preselect_split d
fi

open_spotify_search || exit 0

spotify_address=$(wait_for_client "$spotify_pattern" 40 || true)
move_to_workspace "$spotify_address" "$target_workspace"
focus_window "$spotify_address"
preselect_split r

beatport_address=$(client_address "$beatport_pattern")

if [[ -n $beatport_address ]]; then
  hyprctl dispatch closewindow "address:$beatport_address" >/dev/null 2>&1 || true
  sleep 0.2
fi

launch_detached omarchy-launch-webapp "$beatport_url"
beatport_address=$(wait_for_client "$beatport_pattern" 50 || true)
move_to_workspace "$beatport_address" "$target_workspace"
focus_window "$beatport_address"

if [[ -n $cliamp_address ]]; then
  focus_window "$cliamp_address"
  resize_cliamp_for_bottom_group "$cliamp_address" "$beatport_address"
  focus_window "$beatport_address"
fi
