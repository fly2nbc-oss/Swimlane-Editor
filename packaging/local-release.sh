#!/usr/bin/env bash
# Copies a published release into dist/vX.Y.Z/ (git-ignored): downloads the Windows installer zip and
# SHA256SUMS.txt from GitHub, checks the sum and unpacks every file of the zip into that folder.
# Usage: packaging/local-release.sh [x.y.z]   (default: APP_VERSION in src/app.html)
set -euo pipefail
cd "$(dirname "$0")/.."
PY=python3
"$PY" -c '' 2>/dev/null || PY=python
VERSION="${1:-$(sed -n "s/^const APP_VERSION = '\([0-9.]*\)'.*/\1/p" src/app.html)}"
VERSION="${VERSION#v}"
[ -n "$VERSION" ] || { echo "No version given and none found in src/app.html" >&2; exit 1; }
ZIP="swimlane-editor_${VERSION}_windows-installer.zip"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
gh release download "v$VERSION" -p "$ZIP" -p SHA256SUMS.txt -D "$TMP"
(cd "$TMP" && grep " $ZIP\$" SHA256SUMS.txt | sha256sum -c -)
DEST="dist/v$VERSION"
rm -rf "$DEST"
mkdir -p "$DEST"
# the zip holds one top folder ("Swimlane Editor/"); its files go straight into dist/vX.Y.Z
"$PY" - "$TMP/$ZIP" "$DEST" <<'PY'
import sys, zipfile, os
zf, dest = zipfile.ZipFile(sys.argv[1]), sys.argv[2]
for info in zf.infolist():
    if info.is_dir():
        continue
    parts = info.filename.replace('\\', '/').split('/')
    rel = parts[1:] if len(parts) > 1 else parts
    if any(p in ('', '.', '..') for p in rel):
        sys.exit(f'unsafe path in zip: {info.filename}')
    out = os.path.join(dest, *rel)
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with zf.open(info) as src, open(out, 'wb') as dst:
        dst.write(src.read())
PY
echo "Release v$VERSION unpacked to $DEST:"
ls -1 "$DEST"
