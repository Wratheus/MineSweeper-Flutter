#!/usr/bin/env bash
set -euo pipefail

# Usage: deploy.sh <repo_name>
REPO_NAME="${1:-}"
if [[ -z "$REPO_NAME" ]]; then
  echo "Repo name is required as the first argument"
  exit 1
fi

echo "Using base href: /$REPO_NAME/"

# Ensure pub deps are installed
flutter pub get

# Build Flutter web with correct base-href for GitHub Pages
flutter build web --release --base-href "/$REPO_NAME/"

echo "Build completed. Output at build/web"


