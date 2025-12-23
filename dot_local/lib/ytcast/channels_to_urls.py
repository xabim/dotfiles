#!/usr/bin/env python3
import argparse
import json

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="inp", required=True)
    ap.add_argument("--out", dest="out", required=True)
    args = ap.parse_args()

    with open(args.inp, "r", encoding="utf-8") as f:
        data = json.load(f)

    urls = []
    for c in data.get("channels", []):
        if c.get("enabled", True) is False:
            continue
        url = (c.get("url") or "").strip()
        if url:
            urls.append(url)

    with open(args.out, "w", encoding="utf-8") as f:
        for u in urls:
            f.write(u + "\n")

if __name__ == "__main__":
    main()
