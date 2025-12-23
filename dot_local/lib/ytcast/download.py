#!/usr/bin/env python3
import argparse
import json
import subprocess
import sys
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime

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

def parse_rss_video_urls(xml_bytes: bytes) -> list[tuple[str, str]]:
    """
    Returns list of (published_iso, watch_url).
    """
    root = ET.fromstring(xml_bytes)
    items: list[tuple[str, str]] = []

    for entry in root.findall("atom:entry", NS):
        published = entry.findtext("atom:published", default="", namespaces=NS) or ""
        link_url = ""

        # Prefer <link rel="alternate" href="...watch?v=...">
        for link in entry.findall("atom:link", NS):
            rel = link.attrib.get("rel", "")
            href = link.attrib.get("href", "")
            if rel == "alternate" and "watch?v=" in href:
                link_url = href
                break

        # Fallback: yt:videoId
        if not link_url:
            vid = entry.findtext("yt:videoId", default="", namespaces=NS) or ""
            if vid:
                link_url = f"https://www.youtube.com/watch?v={vid}"

        if link_url:
            items.append((published, link_url))

    return items

def iso_key(published: str) -> float:
    if not published:
        return 0.0
    try:
        if published.endswith("Z"):
            published = published[:-1] + "+00:00"
        dt = datetime.fromisoformat(published)
        return dt.timestamp()
    except Exception:
        return 0.0

def run(cmd: list[str]) -> int:
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
    ap.add_argument("--rss-limit", type=int, default=0, help="0 = all entries in RSS, else keep N newest")
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

    for ch in channels:
        if ch.get("enabled", True) is False:
            continue

        name = (ch.get("name") or "").strip()
        slug = (ch.get("slug") or "").strip()
        url = (ch.get("url") or "").strip()

        if not slug or not url:
            print(f"SKIP: channel missing slug/url: {ch}", file=sys.stderr)
            continue

        print(f"\n==> Canal: {name or slug}")

        try:
            xml_bytes = fetch(url)
        except Exception as e:
            print(f"WARNING: cannot fetch RSS for {slug}: {e}", file=sys.stderr)
            continue

        items = parse_rss_video_urls(xml_bytes)
        if not items:
            print(f"INFO: no entries found in RSS for {slug}")
            continue

        # newest first
        items.sort(key=lambda t: iso_key(t[0]), reverse=True)

        if args.rss_limit and args.rss_limit > 0:
            items = items[: args.rss_limit]

        urls = [u for _, u in items]

        ch_dir = audio_dir / slug
        ch_dir.mkdir(parents=True, exist_ok=True)

        archive_file = archive_dir / f"{slug}.txt"
        archive_file.touch(exist_ok=True)

        outtmpl = str(ch_dir / "%(upload_date)s - %(title)s.%(ext)s")

        exec_after_move = (
            "bash -c "
            + " ".join([
                "'printf \"%s\\t%s\\n\"",
                "\"%(id)s\"",
                "\"%(filepath)s\"",
                f">> \"{state_path}\"'"
            ])
        )

        cmd = [
            "yt-dlp",
            "--no-progress",
            "--ignore-errors",
            "--download-archive", str(archive_file),
            "-f", "bestaudio/best",
            "--extract-audio",
            "--audio-format", args.audio_format,
            "--audio-quality", args.audio_quality,
            "--embed-metadata",
            "--add-metadata",
            "--exec", f"after_move:{exec_after_move}",
            "-o", outtmpl,
            *urls,
        ]

        rc = run(cmd)
        if rc != 0:
            print(f"WARNING: yt-dlp exit code {rc} for channel {slug}", file=sys.stderr)

if __name__ == "__main__":
    main()
