# MacOS setup automation

## ⚡ Setup

For pre-commit secret scanning, set up [Gitleaks](https://github.com/gitleaks/):

```shell
# install pre-commit and gitleaks
pipx install pre-commit
brew install gitleaks

# set up pre-commit hook
pre-commit install
```

## 🔧 Run the scripts

```shell
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

# Install packages on a new machine
brew bundle --file=./Brewfile
```

## ♥️ Missing

- macOS: scriptify switching ctrl & fn
- macOS: icloud sync
- repos: clone most important repos (eg. obsidian repos)
- [zen configs](https://www.reddit.com/r/zen_browser/comments/1l051dx/managing_zen_with_dotfiles/)
- scripts: ssh creation

## ✨ Inspiration

- [joelazar/dotfiles](https://github.com/joelazar/dotfiles)
- [omerxx/dotfiles](https://github.com/omerxx/dotfiles)
- [Swiss-Mac-User/macOS-scripted-setup](https://github.com/Swiss-Mac-User/macOS-scripted-setup)
- [MacAutoSetup](https://github.com/NLaundry/MacAutoSetup)
