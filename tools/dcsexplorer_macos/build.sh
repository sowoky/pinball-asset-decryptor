#!/usr/bin/env bash
# Build DCSExplorer for macOS (universal arm64 + x86_64) into the Williams
# plugin's vendor/ folder, where dcs_decode.find_dcs_explorer() looks for it
# on every platform but Windows.
#
# Upstream (github.com/mjrgh/DCSExplorer, BSD-3-Clause) is a Visual Studio
# project. The decoder library is portable C++; only the command-line front
# end leans on Win32 (Windows.h types, the *_s CRT functions, conio key
# polling, DirectSound playback, a QueryPerformanceCounter timer). shim/
# supplies those: the CRT bits map to POSIX, playback is a no-op stub (the
# --info / --extract-tracks modes the plugin uses never play audio), and the
# timer uses std::chrono.
#
# Usage: tools/dcsexplorer_macos/build.sh
set -euo pipefail

DCSX_REPO=https://github.com/mjrgh/DCSExplorer.git
DCSX_COMMIT=99ce1c3474c75c1702d8b764cd5f8c446599f73d

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
OUT="$ROOT/pinball_decryptor/plugins/williams/vendor/DCSExplorer"
WORK="$(mktemp -d -t dcsx)"
trap 'rm -rf "${WORK:?}"' EXIT

git -C "$WORK" init -q src
git -C "$WORK/src" fetch -q --depth 1 "$DCSX_REPO" "$DCSX_COMMIT"
git -C "$WORK/src" checkout -q FETCH_HEAD

cd "$WORK/src"
# The front end includes these two by relative path; replace them in the copy.
cp "$HERE/shim/SimpleWindowsAudio.h" SimpleWindowsAudio/SimpleWindowsAudio.h
cp "$HERE/shim/HiResTimer.h" HiResTimer/HiResTimer.h

ARCH=(-arch arm64 -arch x86_64)
CXXFLAGS=(-std=c++17 -O2 -w "${ARCH[@]}" -mmacosx-version-min=11.0
          -I"$HERE/shim" -include "$HERE/shim/Windows.h"
          -DHAS_ADSP2101=1 -DHAS_ADSP2105=1 -DLSB_FIRST -DINLINE=inline)
mkdir -p obj
for f in miniz/miniz.c miniz/miniz_tdef.c miniz/miniz_tinfl.c miniz/miniz_zip.c; do
    clang -O2 -w "${ARCH[@]}" -mmacosx-version-min=11.0 -c "$f" -o "obj/$(basename "$f").o"
done
for f in DCSExplorer/DCSExplorer.cpp DCSDecoder/DCSDecoder.cpp \
         DCSDecoder/DCSDecoderNative.cpp DCSDecoder/DCSDecoderEmu.cpp \
         DCSDecoder/DCSDecoderZipLoader.cpp DCSDecoder/adsp2100/2100dasm.cpp \
         DCSDecoder/adsp2100/adsp2100.cpp Utilities/BuildDate.cpp; do
    clang++ "${CXXFLAGS[@]}" -c "$f" -o "obj/$(basename "$f").o"
done
clang++ "${ARCH[@]}" -mmacosx-version-min=11.0 obj/*.o -o "$OUT"
# vendor/DCSExplorer-LICENSE.txt already carries upstream's license.txt.
{ "$OUT" 2>&1 || true; } | sed -n 1p
lipo -archs "$OUT"
