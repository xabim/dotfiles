#!/usr/bin/env python3
import argparse
import html
import json
import mimetypes
import os
from datetime import datetime, timezone
from pathlib import Path

AUDIO_EXTS = (".opus", ".mp3", ".m4a", ".aac", ".ogg", ".wav")

def rfc2822(dt: datetime) -> str:
    return dt.strftime("%a, %d %b %Y %H:%M:%S GMT")

def write_feed(feed_path: Path, title: str, description: str, items: list, base_url: str):
    now = datetime.now(timezone.utc)
    with feed_path.open("w", encoding="utf-8") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<rss version="2.0">\n')
        f.write('<channel>\n')
        f.write(f"<title>{html.escape(title)}</title>\n")
        f.write(f"<link>{html.escape(base_url)}</link>\n")
        f.write(f"<description>{html.escape(description)}</description>\n")
        f.write(f"<lastBuildDate>{rfc2822(now)}</lastBuildDate>\n")

        for mtime, size, rel_url, display_title, mime in items:
            dt = datetime.fromtimestamp(mtime, tz=timezone.utc)
            url = f"{base_url}/{rel_url}"
            f.write("<item>\n")
            f.write(f"  <title>{html.escape(display_title)}</title>\n")
            f.write(f"  <guid isPermaLink='false'>{html.escape(url)}</guid>\n")
            f.write(f"  <pubDate>{rfc2822(dt)}</pubDate>\n")
            f.write(f"  <enclosure url='{html.escape(url)}' length='{size}' type='{html.escape(mime)}'/>\n")
            f.write("</item>\n")

        f.write("</channel>\n</rss>\n")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--channels", required=True)
    ap.add_argument("--base-dir", required=True)
    ap.add_argument("--audio-dir", required=True)
    ap.add_argument("--feeds-dir", required=True)
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--max-items", type=int, default=200)
    args = ap.parse_args()

    channels_path = Path(args.channels)
    base_dir = Path(args.base_dir).resolve()
    audio_dir = Path(args.audio_dir).resolve()
    feeds_dir = Path(args.feeds_dir).resolve()
    feeds_dir.mkdir(parents=True, exist_ok=True)

    # Placeholder; serve.py will patch it to the actual LAN IP
    base_url_placeholder = f"http://__HOST__:{args.port}"

    data = json.loads(channels_path.read_text(encoding="utf-8"))
    channels = data.get("channels", [])

    index = []

    for ch in channels:
        if ch.get("enabled", True) is False:
            continue

        name = (ch.get("name") or "").strip()
        slug = (ch.get("slug") or "").strip()
        if not slug:
            continue

        ch_path = audio_dir / slug
        if not ch_path.is_dir():
            # No audio yet
            continue

        items = []
        for fn in os.listdir(ch_path):
            if not fn.lower().endswith(AUDIO_EXTS):
                continue
            full = ch_path / fn
            try:
                st = full.stat()
            except FileNotFoundError:
                continue

            rel = full.resolve().relative_to(base_dir).as_posix()
            mime, _ = mimetypes.guess_type(str(full))
            if not mime:
                mime = "audio/mpeg"
            display_title = os.path.splitext(fn)[0]
            items.append((st.st_mtime, st.st_size, rel, display_title, mime))

        items.sort(key=lambda x: x[0], reverse=True)
        items = items[: args.max_items]

        feed_path = feeds_dir / f"{slug}.xml"
        write_feed(
            feed_path=feed_path,
            title=f"{name} (YouTube Audio)",
            description=f"Audio-only feed for {name}",
            items=items,
            base_url=base_url_placeholder,
        )

        index.append({"slug": slug, "name": name, "file": feed_path.name, "url_path": f"/feeds/{feed_path.name}"})

    (feeds_dir / "index.json").write_text(json.dumps({"feeds": index}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

if __name__ == "__main__":
    main()
