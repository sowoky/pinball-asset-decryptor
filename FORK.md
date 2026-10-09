# Kyle's fork

`origin` is `sowoky/pinball-asset-decryptor`; `upstream` is David Vanderburgh's
`davidvanderburgh/pinball-asset-decryptor`. Our own work (mostly macOS support)
is committed here on `main`.

To take David's updates:

```bash
git fetch upstream && git merge upstream/main && git push origin main
```

What this fork adds:

- `tools/dcsexplorer_macos/build.sh` builds a universal macOS DCSExplorer into
  `pinball_decryptor/plugins/williams/vendor/DCSExplorer`, so Williams and CGC
  DCS audio decode on a Mac. Re-run it after bumping its pinned commit.
- `core/transcribe.py` decodes PCM WAVs itself, because faster-whisper 1.2.1's
  PyAV loader fails under PyAV 15+.

Not done on macOS yet: DCSEncoder (the Cactus Canyon DCS repack) has no
macOS build.
