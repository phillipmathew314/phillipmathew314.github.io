#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/content/brain-candy"
output_dir="$source_dir/_site"
published_dir="$repo_root/blog/brain-candy"

quarto render "$source_dir"

# Quarto's category script resolves listings.json from the post directory.
if [[ -f "$output_dir/listings.json" && -d "$output_dir/posts" ]]; then
  cp "$output_dir/listings.json" "$output_dir/posts/listings.json"
fi

mkdir -p "$published_dir"

if [[ "$published_dir" != "$repo_root/blog/brain-candy" ]]; then
  echo "Refusing to replace an unexpected output directory." >&2
  exit 1
fi

find "$published_dir" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
cp -a "$output_dir/." "$published_dir/"

