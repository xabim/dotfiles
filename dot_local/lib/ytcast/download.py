#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

def run(cmd: list[str]) -> int:
    # streaming output
    p = subprocess.Popen(cmd)
    return p.wait()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--channels", required=True)
    ap.add_argument("--audio-dir", required=True)
    ap.add_argument("--archive-dir", required=True)
    ap.add_argument("--state", required=True)
    ap.add_argument("--audio-format", default="opus")
    ap.add_argument("--audio-quality", default="64K")
    args = ap.parse_args()

    channels_path = Path(args.channels)
    audio_dir = Path(args.audio_dir)
    archive_dir = Path(args.archive_dir)
    state_path = Path(args.state)

    audio_dir.mkdir(parents=True, exist_ok=True)
    archive_dir.mkdir(parents=True, exist_ok=True)
    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.touch(exist_ok=True)

    data = json.loads(channels_path.read_text(encoding="utf-8"))
    channels = data.get("channels", [])

    # One archive file per channel to avoid collisions and keep things tidy
    for ch in channels:
        if ch.get("enabled", True) is False:
            continue

        name = (ch.get("name") or "").strip()
        slug = (ch.get("slug") or "").strip()
        url = (ch.get("url") or "").strip()

        if not slug or not url:
            print(f"SKIP: channel missing slug/url: {ch}", file=sys.stderr)
            continue

        ch_dir = audio_dir / slug
        ch_dir.mkdir(parents=True, exist_ok=True)

        archive_file = archive_dir / f"{slug}.txt"
        archive_file.touch(exist_ok=True)

        # Output template: clean folder by slug
        outtmpl = str(ch_dir / "%(upload_date)s - %(title)s.%(ext)s")

        # Append id + filepath to state.tsv after move
        exec_after_move = (
            "bash -c "
            + " ".join([
                "'printf \"%s\\t%s\\n\"",
                "\"%(id)s\"",
                "\"%(filepath)s\"",
                f">> \"{state_path}\"'"
            ])
        )

        print(f"\n==> Canal: {name or slug}")
        cmd = [
            "yt-dlp",
            "--no-progress",
            "--yes-playlist",
            "--ignore-errors",
            "--download-archive", str(archive_file),

            # Helps in many cases; you saw PO token warnings, but it will still download other formats.
            "--extractor-args", "youtube:player_client=android,ios",

            "-f", "bestaudio",
            "--extract-audio",
            "--audio-format", args.audio_format,
            "--audio-quality", args.audio_quality,

            "--embed-metadata",
            "--add-metadata",

            # You can re-enable thumbnails if you really want them, but they can be noisy/slow:
            # "--embed-thumbnail",

            "--exec", f"after_move:{exec_after_move}",

            "-o", outtmpl,
            url,
        ]

        rc = run(cmd)
        if rc != 0:
            print(f"WARNING: yt-dlp exit code {rc} for channel {slug}", file=sys.stderr)

if __name__ == "__main__":
    main()
