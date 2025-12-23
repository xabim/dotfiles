#!/usr/bin/env python3
import argparse
import http.server
import os
import socket
import sys
from pathlib import Path

def guess_local_ip() -> str:
    ip = "127.0.0.1"
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("1.1.1.1", 80))
        ip = s.getsockname()[0]
        s.close()
    except Exception:
        pass
    return ip

def patch_xml_host(base_dir: Path, host: str, port: int):
    feeds_dir = base_dir / "feeds"
    if not feeds_dir.exists():
        return
    placeholder = f"http://__HOST__:{port}"
    real = f"http://{host}:{port}"
    for feed in feeds_dir.glob("*.xml"):
        data = feed.read_text(encoding="utf-8")
        if placeholder in data:
            feed.write_text(data.replace(placeholder, real), encoding="utf-8")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", required=True)
    ap.add_argument("--port", type=int, default=8000)
    args = ap.parse_args()

    base_dir = Path(args.dir).resolve()
    if not base_dir.exists():
        print(f"ERROR: dir no existe: {base_dir}", file=sys.stderr)
        sys.exit(1)

    host = guess_local_ip()
    patch_xml_host(base_dir, host, args.port)

    os.chdir(base_dir)
    handler = http.server.SimpleHTTPRequestHandler

    print("\nAñade estos feeds en tu app de podcasts (misma Wi-Fi):\n")
    feeds_dir = base_dir / "feeds"
    if feeds_dir.exists():
        for feed in sorted(feeds_dir.glob("*.xml")):
            print(f"  {feed.stem}: http://{host}:{args.port}/feeds/{feed.name}")
        print(f"\n  índice: http://{host}:{args.port}/feeds/index.json\n")
    else:
        print(f"  (no existe {feeds_dir}, ¿generaste feeds?)")

    print("Server running. CTRL+C para parar.\n")
    http.server.ThreadingHTTPServer(("0.0.0.0", args.port), handler).serve_forever()

if __name__ == "__main__":
    main()
