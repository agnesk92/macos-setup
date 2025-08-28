#!/usr/bin/env bash

set -euo pipefail

REPO_URL="git@github.com:agnesk92/macos-setup.git"
CLONE_DIR="$HOME/Projects/Personal/macos-setup"

# Clone configs repo if needed
if [ ! -d "$CLONE_DIR" ]; then
  echo "📥 Cloning macos-setup into $CLONE_DIR..."
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone "$REPO_URL" "$CLONE_DIR"
else
  echo "📁 Directory $CLONE_DIR already exists. Skipping clone."
fi

# Install with Brew
if [[ -f ./Brewfile ]]; then
  echo "Installing applications from Brewfile..."
  brew bundle --file=./Brewfile
else
  echo "Warning: Brewfile not found in current directory"
fi

# Use GNU Stow to symlink dotfiles
echo "Setting up dotfiles with GNU Stow..."
stow --target="$HOME" --dir=./dotfiles aerospace
