#!/usr/bin/env python3
import argparse
import os

AUDIO_EXTS = (".opus", ".mp3", ".m4a", ".aac", ".ogg", ".wav")

def list_audio_files(ch_dir: str):
    files = []
    for fn in os.listdir(ch_dir):
        if not fn.lower().endswith(AUDIO_EXTS):
            continue
        full = os.path.join(ch_dir, fn)
        try:
            st = os.stat(full)
        except FileNotFoundError:
            continue
        files.append((st.st_mtime, full))
    files.sort(key=lambda x: x[0], reverse=True)
    return [p for _, p in files]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--audio-dir", required=True)
    ap.add_argument("--keep", type=int, default=60)
    args = ap.parse_args()

    audio_dir = os.path.abspath(args.audio_dir)
    keep = int(args.keep)

    for slug in os.listdir(audio_dir):
        ch_path = os.path.join(audio_dir, slug)
        if not os.path.isdir(ch_path):
            continue

        files = list_audio_files(ch_path)
        if len(files) <= keep:
            continue

        for fpath in files[keep:]:
            try:
                os.remove(fpath)
            except FileNotFoundError:
                pass

if __name__ == "__main__":
    main()
