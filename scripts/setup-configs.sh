#!/usr/bin/env bash

set -euo pipefail

REPO_URL="git@github.com:agnesk92/macos-setup.git"
CLONE_DIR="$HOME/Projects/Personal/macos-setup"

# Clone configs repo if needed
if [ ! -d "$CLONE_DIR" ]; then
  echo "Cloning macos-setup into $CLONE_DIR... 📥"
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone "$REPO_URL" "$CLONE_DIR"
else
  echo "Directory $CLONE_DIR already exists. Skipping clone. ⏭️"
fi

cd "$CLONE_DIR"

# Install from Brewfile.personal
if [[ -f ./Brewfile.personal ]]; then
  echo "Installing applications from Brewfile.personal..."
  brew bundle --file=./Brewfile.personal
else
  echo "Warning: Brewfile.personal not found in current directory"
fi

# Install from Brewfile.work
if [[ -f ./Brewfile.work ]]; then
  echo "Installing applications from Brewfile.work..."
  brew bundle --file=./Brewfile.work
else
  echo "Warning: Brewfile.work not found in current directory"
fi

# Install additional packages
if [[ -f "scripts/utils/package-installs.sh" ]]; then
  echo "Installing additional packages... 📦"
  bash scripts/utils/package-installs.sh
else
  echo "Package install script not found, skipping... ⚠️"
fi

# Use GNU Stow to symlink dotfiles
echo "Setting up dotfiles with GNU Stow..."
# Real dirs so stow links files inside, not the whole dir (keeps runtime state out of the repo)
mkdir -p "$HOME/.claude/plugins" "$HOME/Library/Application Support/k9s"
stow --target="$HOME" --dir=./dotfiles aerospace agents claude fish gh gh-dash ghostty git git-cz gitmoji k9s mise pi starship vim zed
# Claude Code doesn't read ~/.agents/skills yet
ln -sfn ../.agents/skills "$HOME/.claude/skills"
