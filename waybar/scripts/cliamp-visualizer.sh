#!/usr/bin/env bash

fps="${CLIAMP_WAYBAR_VIS_FPS:-8}"

hide() {
  printf '{"text":"","tooltip":"","class":["unavailable"]}\n'
}

case "$fps" in
  ''|*[!0-9]*)
    fps=8
    ;;
esac

if ((fps < 1)); then
  fps=1
elif ((fps > 30)); then
  fps=30
fi

hide

cliamp visstream --fps "$fps" 2>/dev/null | while IFS= read -r frame; do
  jq -cer '
    def bar:
      (tonumber? // 0) as $v
      | if $v < 0.08 then "▁"
        elif $v < 0.20 then "▂"
        elif $v < 0.34 then "▃"
        elif $v < 0.48 then "▄"
        elif $v < 0.62 then "▅"
        elif $v < 0.76 then "▆"
        elif $v < 0.90 then "▇"
        else "█"
        end;

    if (.ok != true) or ((.bands // []) | type != "array") then
      {text: "", tooltip: "", class: ["unavailable"]}
    else
      {
        text: ((.bands // []) | map(bar) | join("")),
        tooltip: (
          "cliamp visualizer: " + (.visualizer // "active" | tostring)
          + "\nbands: " + ((.bands // []) | length | tostring)
        ),
        class: ["active"]
      }
    end
  ' <<<"$frame" 2>/dev/null || hide
done
