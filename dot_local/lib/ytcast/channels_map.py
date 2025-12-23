#!/usr/bin/env python3
import argparse
import json
import re

def slugify(name: str) -> str:
    s = name.strip().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s)
    s = re.sub(r"-+", "-", s).strip("-")
    return s or "channel"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="inp", required=True)
    ap.add_argument("--out", dest="out", required=True)
    args = ap.parse_args()

    with open(args.inp, "r", encoding="utf-8") as f:
        data = json.load(f)

    out = {"by_url": {}}
    for c in data.get("channels", []):
        url = (c.get("url") or "").strip()
        if not url:
            continue
        name = (c.get("name") or url).strip()
        enabled = (c.get("enabled", True) is not False)
        out["by_url"][url] = {
            "name": name,
            "enabled": enabled,
            "slug": slugify(name),
        }

    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    main()
