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

# Install from Brewfile.private
if [[ -f ./Brewfile.private ]]; then
  echo "Installing applications from Brewfile.private..."
  brew bundle --file=./Brewfile.private
else
  echo "Warning: Brewfile.private not found in current directory"
fi

# Install from Brewfile.work
if [[ -f ./Brewfile.work ]]; then
  echo "Installing applications from Brewfile.work..."
  brew bundle --file=./Brewfile.work
else
  echo "Warning: Brewfile.work not found in current directory"
fi

# Use GNU Stow to symlink dotfiles
echo "Setting up dotfiles with GNU Stow..."
stow --target="$HOME" --dir=./dotfiles aerospace
