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

def parse_latest_video_url(xml_bytes: bytes) -> str | None:
    root = ET.fromstring(xml_bytes)
    items = []
    for entry in root.findall("atom:entry", NS):
        published = entry.findtext("atom:published", default="", namespaces=NS) or ""
        link_url = ""

        for link in entry.findall("atom:link", NS):
            rel = link.attrib.get("rel", "")
            href = link.attrib.get("href", "")
            if rel == "alternate" and "watch?v=" in href:
                link_url = href
                break

        if not link_url:
            vid = entry.findtext("yt:videoId", default="", namespaces=NS) or ""
            if vid:
                link_url = f"https://www.youtube.com/watch?v={vid}"

        if link_url:
            items.append((published, link_url))

    if not items:
        return None
    items.sort(key=lambda t: iso_key(t[0]), reverse=True)
    return items[0][1]

def yt_dlp_json(url: str) -> dict:
    p = subprocess.run(
        ["yt-dlp", "-J", "--no-warnings", "--no-playlist", url],
        capture_output=True,
        text=True,
        check=False,
    )
    if p.returncode != 0:
        raise RuntimeError(p.stderr.strip() or f"yt-dlp failed for {url}")
    return json.loads(p.stdout)

def pick_avatar_url(info: dict) -> str | None:
    # Prefer explicit channel/uploader avatar fields if present
    for key in ("channel_thumbnail", "uploader_avatar"):
        v = info.get(key)
        if isinstance(v, str) and v.startswith("http"):
            return v

    # Fallback: pick largest thumbnail URL
    thumbs = info.get("thumbnails")
    if isinstance(thumbs, list) and thumbs:
        candidates = []
        for t in thumbs:
            if not isinstance(t, dict):
                continue
            u = t.get("url")
            if isinstance(u, str) and u.startswith("http"):
                w = t.get("width") or 0
                h = t.get("height") or 0
                candidates.append((w * h, u))
        if candidates:
            candidates.sort(key=lambda x: x[0], reverse=True)
            return candidates[0][1]

    return None

def download(url: str, dest: Path):
    dest.parent.mkdir(parents=True, exist_ok=True)
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=30) as r:
        dest.write_bytes(r.read())

def make_square_jpg_ffmpeg(src: Path, dst: Path, size: int):
    cmd = [
        "ffmpeg",
        "-y",
        "-i",
        str(src),
        "-vf",
        f"scale={size}:{size}:force_original_aspect_ratio=increase,crop={size}:{size}",
        "-q:v",
        "2",
        str(dst),
    ]
    p = subprocess.run(cmd, capture_output=True, text=True)
    if p.returncode != 0:
        raise RuntimeError(p.stderr.strip() or "ffmpeg failed")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--channels", required=True)
    ap.add_argument("--artwork-dir", required=True)
    ap.add_argument("--size", type=int, default=3000)
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()

    channels_path = Path(args.channels)
    artwork_dir = Path(args.artwork_dir)
    artwork_dir.mkdir(parents=True, exist_ok=True)

    data = json.loads(channels_path.read_text(encoding="utf-8"))
    channels = data.get("channels", [])

    for ch in channels:
        if ch.get("enabled", True) is False:
            continue
        slug = (ch.get("slug") or "").strip()
        url = (ch.get("url") or "").strip()
        name = (ch.get("name") or slug).strip()

        if not slug or not url:
            continue

        out_jpg = artwork_dir / f"{slug}.jpg"
        if out_jpg.exists() and not args.force:
            print(f"==> Artwork existe, skip: {out_jpg.name}")
            continue

        print(f"==> Generando artwork (avatar): {name}")

        try:
            rss = fetch(url)
            latest_video = parse_latest_video_url(rss)
            if not latest_video:
                print(f"WARNING: no latest video in RSS for {slug}", file=sys.stderr)
                continue

            info = yt_dlp_json(latest_video)
            avatar_url = pick_avatar_url(info)
            if not avatar_url:
                print(f"WARNING: no avatar found for {slug}", file=sys.stderr)
                continue

            tmp = artwork_dir / f".{slug}.tmp"
            download(avatar_url, tmp)
            make_square_jpg_ffmpeg(tmp, out_jpg, args.size)
            tmp.unlink(missing_ok=True)

        except Exception as e:
            print(f"WARNING: artwork failed for {slug}: {e}", file=sys.stderr)

if __name__ == "__main__":
    main()
