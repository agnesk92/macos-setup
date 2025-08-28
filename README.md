# MacOS setup automation

## ⚡ Setup

Set up the [Gitleaks](https://github.com/gitleaks/) pre-commit hook:

```shell
# install pre-commit and gitleaks
pipx install pre-commit
brew install gitleaks

# set up pre-commit hook
pre-commit install
```

## 🔧 Use autosetup script

Run the script to setup basics, like git.

```shell
./scripts/setup.sh
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
