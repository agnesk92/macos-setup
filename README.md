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
# tbd. private repo
./scripts/setup-configs.sh
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

## ✨ Inspiration

- [omerxx/dotfiles](https://github.com/omerxx/dotfiles)
- [MacAutoSetup](https://github.com/NLaundry/MacAutoSetup)
