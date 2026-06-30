#!/usr/bin/env bash

# Run from repo root. Prints dotfiles package names currently stowed into $HOME.
# Uses simulated unstow only (no filesystem changes).

set -u

if [ ! -d "dotfiles" ]; then
  echo "Run this from the repo root (missing ./dotfiles)." >&2
  exit 1
fi

for d in dotfiles/*/; do
  [ -d "$d" ] || continue

  pkg=${d#dotfiles/}
  pkg=${pkg%/}

  # If a dry-run unstow would UNLINK/RMDIR something, this package is stowed.
  out="$(stow -n -D -v2 -t "$HOME" -d ./dotfiles "$pkg" 2>&1 || true)"

  if printf '%s\n' "$out" | grep -Eq 'UNLINK:|RMDIR:'; then
    echo "$pkg"
  fi
done | sort -u
