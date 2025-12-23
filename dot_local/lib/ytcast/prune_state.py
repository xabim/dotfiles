#!/usr/bin/env python3
import argparse
import os
from pathlib import Path

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--state", required=True)
    ap.add_argument("--archive-dir", required=True)
    args = ap.parse_args()

    state_path = Path(args.state)
    if not state_path.exists():
        return

    kept = []
    for raw in state_path.read_text(encoding="utf-8", errors="replace").splitlines():
        if not raw.strip():
            continue

        if "\t" in raw:
            _, path = raw.split("\t", 1)
            path = path.strip()
        else:
            path = raw.strip()

        if path and os.path.exists(path):
            kept.append(f"\t{path}")

    tmp = state_path.with_suffix(".tmp")
    tmp.write_text("\n".join(kept) + ("\n" if kept else ""), encoding="utf-8")
    tmp.replace(state_path)

if __name__ == "__main__":
    main()
