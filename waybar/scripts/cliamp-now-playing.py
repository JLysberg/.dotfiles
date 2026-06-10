#!/usr/bin/env python3

import argparse
import json
import re
import subprocess
import sys
import urllib.request

TRACK_ICON = ""
STATION_ICON = ""


def trim(value):
    return re.sub(r"\s+", " ", str(value or "")).strip()


def empty_waybar():
    print(json.dumps({"text": "", "tooltip": "", "class": ["unavailable"]}))


def cliamp_status():
    output = subprocess.check_output(
        ["cliamp", "status", "--json"],
        stderr=subprocess.DEVNULL,
        text=True,
        timeout=2,
    )
    return json.loads(output)


def valid_stream_title(title, fallback):
    title = trim(title).strip("\x00")
    if not title:
        return ""

    folded = title.casefold()
    fallback_folded = trim(fallback).casefold()

    if fallback_folded and folded == fallback_folded:
        return ""
    if folded.startswith("tracklist:"):
        return ""
    if re.fullmatch(r"https?://\S+", title, flags=re.IGNORECASE):
        return ""

    return title


def icy_stream_title(url, fallback):
    if not url.startswith(("http://", "https://")):
        return ""

    request = urllib.request.Request(
        url,
        headers={
            "Icy-MetaData": "1",
            "User-Agent": "waybar-cliamp/1.0",
        },
    )

    try:
        with urllib.request.urlopen(request, timeout=3.5) as response:
            metaint = int(response.headers.get("icy-metaint") or 0)
            if metaint <= 0:
                return ""

            response.read(metaint)
            length_byte = response.read(1)
            if not length_byte:
                return ""

            metadata = response.read(length_byte[0] * 16).decode(
                "utf-8", errors="replace"
            )
    except Exception:
        return ""

    match = re.search(r"StreamTitle='(.*?)';", metadata, flags=re.DOTALL)
    if not match:
        return ""

    return valid_stream_title(match.group(1), fallback)


def current_track():
    status = cliamp_status()
    state = trim(status.get("state") or "unavailable").casefold()
    track = status.get("track") or {}
    fallback = trim(track.get("title"))
    url = trim(track.get("path"))

    if status.get("ok") is not True or state == "stopped" or not fallback:
        return None

    stream_title = icy_stream_title(url, fallback)
    title = stream_title or fallback
    source = "track" if stream_title else "station"

    return {
        "state": state,
        "title": title,
        "source": source,
        "fallback": fallback,
        "url": url,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--plain", action="store_true")
    args = parser.parse_args()

    try:
        track = current_track()
    except Exception:
        track = None

    if not track:
        if args.plain:
            return 1
        empty_waybar()
        return 0

    if args.plain:
        print(track["title"])
        return 0

    tooltip = [
        f"cliamp: {track['state']}",
    ]
    if track["source"] == "track":
        tooltip.append(f"Track: {track['title']}")
        tooltip.append(f"Station: {track['fallback']}")
    else:
        tooltip.append(f"Station: {track['title']}")
    if track["url"]:
        tooltip.append(track["url"])

    icon = TRACK_ICON if track["source"] == "track" else STATION_ICON

    print(
        json.dumps(
            {
                "text": f"{icon} {track['title']}",
                "tooltip": "\n".join(tooltip),
                "class": ["active", track["state"], track["source"]],
            }
        )
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
