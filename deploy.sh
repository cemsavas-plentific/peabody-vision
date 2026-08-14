#!/usr/bin/env bash
# Deploy the newest peabody-vision*.html from ~/Downloads to the live GitHub Pages site.
# Usage: ./deploy.sh            (auto-picks newest peabody-vision* in ~/Downloads)
#        ./deploy.sh <file>     (deploy a specific file)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

if [ "${1:-}" != "" ]; then
  SRC="$1"
else
  SRC="$(ls -t "$HOME"/Downloads/peabody-vision*.html 2>/dev/null | head -1 || true)"
fi

if [ -z "${SRC:-}" ] || [ ! -f "$SRC" ]; then
  echo "No source file found. Pass a path, or download a peabody-vision*.html into ~/Downloads first." >&2
  exit 1
fi

echo "Source: $SRC"

if diff -q "$SRC" index.html >/dev/null 2>&1; then
  echo "Already live — nothing to deploy."
  exit 0
fi

cp "$SRC" peabody-vision.html
cp "$SRC" index.html
git add -A
git commit -q -m "Update Peabody × Plentific vision paper"
git push -q origin main
echo "Pushed. Live in ~1 min: https://cemsavas-plentific.github.io/peabody-vision/"
