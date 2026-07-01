# MacOS setup automation

## ⚡ Setup

For pre-commit secret scanning, set up [Gitleaks](https://github.com/gitleaks/):

Assuming you use Mise and UV for Python:

```fish
# install pre-commit and gitleaks
uv tool install pre-commit
brew install gitleaks

# set up pre-commit hook
pre-commit install

# try git leaks
gitleaks dir . --verbose
```

## 🔧 Run the scripts

Run setup.sh

```fish
./setup.sh
```

Or run the scripts per demand

```fish
# Install basics, eg. git
./scripts/setup-basics.sh

# Clone config repo and setup
# Note: needs ssh set up if the repo is private
./scripts/setup-configs.sh

# MacOS preferences - dock, animations, toolbar, etc.
./scripts/setup-macos.sh
```

## 💡 Setup details

### Dotfiles

Uses [GNU Stow](https://www.gnu.org/software/stow/) for dotfile management.

### Applications

Using [Homebrew](https://brew.sh/)

```sh
# Create Brewfile with installed packages
brew bundle dump --describe

# Check validity
brew bundle check --file=Brewfile.personal

# Install packages on a new machine
brew bundle --file=./Brewfile.personal
brew bundle install --file=Brewfile.personal

# Dry-run cleanup
brew bundle cleanup --file=Brewfile.personal
```

## ♥️ Missing

- macOS: scriptify switching ctrl & fn
- macOS: icloud sync
- repos: clone most important repos (eg. obsidian repos)
- scripts: ssh creation

## ✨ Inspiration

- [joelazar/dotfiles](https://github.com/joelazar/dotfiles)
- [omerxx/dotfiles](https://github.com/omerxx/dotfiles)
- [Swiss-Mac-User/macOS-scripted-setup](https://github.com/Swiss-Mac-User/macOS-scripted-setup)
- [MacAutoSetup](https://github.com/NLaundry/MacAutoSetup)
