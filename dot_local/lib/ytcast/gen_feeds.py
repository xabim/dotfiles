#!/usr/bin/env python3
import argparse
import html
import json
import mimetypes
import os
import re
from datetime import datetime, timezone

AUDIO_EXTS = (".opus", ".mp3", ".m4a", ".aac", ".ogg", ".wav")

def rfc2822(dt: datetime) -> str:
    return dt.strftime("%a, %d %b %Y %H:%M:%S GMT")

def slugify(name: str) -> str:
    s = name.strip().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s)
    s = re.sub(r"-+", "-", s).strip("-")
    return s or "channel"

def write_feed(feed_path: str, title: str, description: str, channel_items: list, base_url: str):
    now = datetime.now(timezone.utc)
    with open(feed_path, "w", encoding="utf-8") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<rss version="2.0">\n')
        f.write('<channel>\n')
        f.write(f"<title>{html.escape(title)}</title>\n")
        f.write(f"<link>{html.escape(base_url)}</link>\n")
        f.write(f"<description>{html.escape(description)}</description>\n")
        f.write(f"<lastBuildDate>{rfc2822(now)}</lastBuildDate>\n")

        for mtime, size, rel_url, display_title, mime in channel_items:
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
    p = argparse.ArgumentParser()
    p.add_argument("--base-dir", required=True)
    p.add_argument("--audio-dir", required=True)
    p.add_argument("--feeds-dir", required=True)
    p.add_argument("--channel-map", required=True)
    p.add_argument("--port", type=int, required=True)
    p.add_argument("--max-items", type=int, default=200)
    args = p.parse_args()

    base_dir = os.path.abspath(args.base_dir)
    audio_dir = os.path.abspath(args.audio_dir)
    feeds_dir = os.path.abspath(args.feeds_dir)
    os.makedirs(feeds_dir, exist_ok=True)

    base_url_placeholder = f"http://__HOST__:{args.port}"

    with open(args.channel_map, "r", encoding="utf-8") as f:
        cmap = json.load(f)

    # Map URL -> {name, slug} for pretty feed filenames.
    # We still generate feeds "por carpeta" (porque no queremos depender de folder config).
    url_to_meta = {k: v for k, v in cmap.get("by_url", {}).items() if v.get("enabled", True)}

    # We can't reliably map a folder to a URL without storing extra state, so:
    # - title: folder name (lo que crea yt-dlp)
    # - filename: slug del nombre humano si existe solo 1 canal con ese nombre; si no, slug del folder.
    # For simplicity, usamos slug del folder siempre. (URLs estables)
    for folder in sorted(os.listdir(audio_dir)):
        ch_path = os.path.join(audio_dir, folder)
        if not os.path.isdir(ch_path):
            continue

        items = []
        for fn in os.listdir(ch_path):
            if not fn.lower().endswith(AUDIO_EXTS):
                continue
            full = os.path.join(ch_path, fn)
            try:
                st = os.stat(full)
            except FileNotFoundError:
                continue

            rel = os.path.relpath(full, base_dir).replace(os.sep, "/")
            mime, _ = mimetypes.guess_type(full)
            if not mime:
                mime = "audio/mpeg"
            display_title = os.path.splitext(fn)[0]
            items.append((st.st_mtime, st.st_size, rel, display_title, mime))

        items.sort(key=lambda x: x[0], reverse=True)
        items = items[: args.max_items]

        name = folder
        slug = slugify(folder)
        feed_path = os.path.join(feeds_dir, f"{slug}.xml")

        write_feed(
            feed_path=feed_path,
            title=f"{name} (YouTube Audio)",
            description=f"Audio-only feed for {name}",
            channel_items=items,
            base_url=base_url_placeholder,
        )

    # index
    index_path = os.path.join(feeds_dir, "index.json")
    feeds = []
    for fn in sorted(os.listdir(feeds_dir)):
        if fn.endswith(".xml"):
            feeds.append({"file": fn, "url_path": f"/feeds/{fn}"})
    with open(index_path, "w", encoding="utf-8") as idx:
        json.dump({"feeds": feeds}, idx, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    main()
