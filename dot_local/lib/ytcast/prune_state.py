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
    archive_dir = Path(args.archive_dir)

    if not state_path.exists():
        return
    archive_dir.mkdir(parents=True, exist_ok=True)

    # Read & keep only existing paths
    kept_lines: list[str] = []
    kept_ids_by_slug: dict[str, set[str]] = {}

    for raw in state_path.read_text(encoding="utf-8", errors="replace").splitlines():
        if not raw.strip():
            continue
        parts = raw.split("\t", 1)
        if len(parts) != 2:
            continue
        vid, path = parts[0].strip(), parts[1].strip()
        if not vid or not path:
            continue
        if not os.path.exists(path):
            continue

        kept_lines.append(f"{vid}\t{path}")

        # Infer slug from path .../audio/<slug>/...
        # We try to find "/audio/<slug>/" segment.
        norm = path.replace("\\", "/")
        slug = None
        if "/audio/" in norm:
            try:
                slug = norm.split("/audio/", 1)[1].split("/", 1)[0]
            except Exception:
                slug = None
        if not slug:
            slug = "_unknown"

        kept_ids_by_slug.setdefault(slug, set()).add(vid)

    # Rewrite state.tsv
    tmp_state = state_path.with_suffix(".tsv.tmp")
    tmp_state.write_text("\n".join(kept_lines) + ("\n" if kept_lines else ""), encoding="utf-8")
    tmp_state.replace(state_path)

    # Rewrite each archive file based on remaining ids
    for archive_file in archive_dir.glob("*.txt"):
        slug = archive_file.stem
        kept = kept_ids_by_slug.get(slug, set())

        tmp = archive_file.with_suffix(".txt.tmp")
        tmp.write_text("".join(f"{vid}\n" for vid in sorted(kept)), encoding="utf-8")
        tmp.replace(archive_file)

if __name__ == "__main__":
    main()
