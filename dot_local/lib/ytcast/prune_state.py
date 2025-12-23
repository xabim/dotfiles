#!/usr/bin/env python3
import argparse
import os

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--state", required=True, help="state.tsv path (id\\tfilepath)")
    p.add_argument("--archive", required=True, help="archive.txt path (one id per line)")
    args = p.parse_args()

    state_path = args.state
    archive_path = args.archive

    if not os.path.exists(state_path):
        return

    kept_lines = []
    kept_ids = set()

    with open(state_path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line.strip():
                continue
            parts = line.split("\t", 1)
            if len(parts) != 2:
                continue
            vid, path = parts[0].strip(), parts[1].strip()
            if not vid or not path:
                continue
            if os.path.exists(path):
                kept_lines.append(f"{vid}\t{path}")
                kept_ids.add(vid)

    tmp_state = state_path + ".tmp"
    with open(tmp_state, "w", encoding="utf-8") as out:
        out.write("\n".join(kept_lines) + ("\n" if kept_lines else ""))
    os.replace(tmp_state, state_path)

    tmp_archive = archive_path + ".tmp"
    with open(tmp_archive, "w", encoding="utf-8") as out:
        for vid in sorted(kept_ids):
            out.write(vid + "\n")
    os.replace(tmp_archive, archive_path)

if __name__ == "__main__":
    main()
