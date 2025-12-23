#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path

NS = {
    "atom": "http://www.w3.org/2005/Atom",
    "yt": "http://www.youtube.com/xml/schemas/2015",
}

def fetch(url: str, timeout: int = 20) -> bytes:
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) ytcast/1.0"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()

def iso_key(published: str) -> float:
    if not published:
        return 0.0
    try:
        if published.endswith("Z"):
            published = published[:-1] + "+00:00"
        return datetime.fromisoformat(published).timestamp()
    except Exception:
        return 0.0

def parse_rss(xml_bytes: bytes) -> list[tuple[str, str, str]]:
    """
    Returns list of (published_iso, video_id, watch_url)
    """
    root = ET.fromstring(xml_bytes)
    items: list[tuple[str, str, str]] = []

    for entry in root.findall("atom:entry", NS):
        published = entry.findtext("atom:published", default="", namespaces=NS) or ""
        vid = entry.findtext("yt:videoId", default="", namespaces=NS) or ""

        watch = ""
        for link in entry.findall("atom:link", NS):
            if link.attrib.get("rel") == "alternate":
                href = link.attrib.get("href", "")
                if "watch?v=" in href:
                    watch = href
                    break
        if not watch and vid:
            watch = f"https://www.youtube.com/watch?v={vid}"

        if watch and vid:
            items.append((published, vid, watch))

    # newest first
    items.sort(key=lambda t: iso_key(t[0]), reverse=True)
    return items

def yt_dlp(urls: list[str], archive_file: Path, outtmpl: str, audio_format: str, audio_quality: str) -> int:
    cmd = [
        "yt-dlp",
        "--quiet",
        "--no-warnings",
        "--ignore-errors",
        "--download-archive", str(archive_file),

        # Avoid web/safari JS-heavy path without installing deno
        "--extractor-args", "youtube:player_client=android,android_music",

        "-f", "bestaudio/best",
        "--extract-audio",
        "--audio-format", audio_format,
        "--audio-quality", audio_quality,
        "--embed-metadata",
        "--add-metadata",

        "-o", outtmpl,
        *urls,
    ]
    return subprocess.run(cmd).returncode

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--channels", required=True)
    ap.add_argument("--audio-dir", required=True)
    ap.add_argument("--archive-dir", required=True)
    ap.add_argument("--state", required=True)
    ap.add_argument("--audio-format", default="opus")
    ap.add_argument("--audio-quality", default="64K")
    ap.add_argument("--rss-limit", type=int, default=0, help="0=todo el RSS; si no, solo N más nuevos")
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

    total_new = 0

    for ch in channels:
        if ch.get("enabled", True) is False:
            continue

        name = (ch.get("name") or "").strip()
        slug = (ch.get("slug") or "").strip()
        url = (ch.get("url") or "").strip()
        if not slug or not url:
            continue

        print(f"==> Canal: {name or slug}")

        try:
            rss = fetch(url)
            items = parse_rss(rss)
        except Exception as e:
            print(f"WARNING: RSS fetch/parse failed for {slug}: {e}", file=sys.stderr)
            continue

        if args.rss_limit and args.rss_limit > 0:
            items = items[: args.rss_limit]

        if not items:
            continue

        # Build URL list (newest first)
        urls = [watch for _, _, watch in items]

        ch_dir = audio_dir / slug
        ch_dir.mkdir(parents=True, exist_ok=True)

        archive_file = archive_dir / f"{slug}.txt"
        archive_file.touch(exist_ok=True)

        outtmpl = str(ch_dir / "%(upload_date)s - %(title)s.%(ext)s")

        # Before/after to count *new* downloads without using --exec
        before = {p.name for p in ch_dir.iterdir() if p.is_file()}

        rc = yt_dlp(
            urls=urls,
            archive_file=archive_file,
            outtmpl=outtmpl,
            audio_format=args.audio_format,
            audio_quality=args.audio_quality,
        )
        if rc != 0:
            # yt-dlp sometimes returns 1 even if partial success; keep going
            print(f"WARNING: yt-dlp exit code {rc} (posible parcial) para {slug}", file=sys.stderr)

        after = {p.name for p in ch_dir.iterdir() if p.is_file()}
        new_files = sorted(after - before)

        # Append to state.tsv without shell quoting issues.
        # Format: video_id<TAB>absolute_path
        # We can't 100% map ids to files reliably without extra logic, so we store empty id.
        if new_files:
            with state_path.open("a", encoding="utf-8") as f:
                for fn in new_files:
                    f.write(f"\t{(ch_dir / fn).as_posix()}\n")
            total_new += len(new_files)

    print(f"==> Descargas nuevas: {total_new}")

if __name__ == "__main__":
    main()
