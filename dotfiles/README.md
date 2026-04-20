# Stow

```fish
# Stow package
stow --verbose --target="$HOME" --dir=./dotfiles zed

# Unstow package
stow --verbose -D --target="$HOME" --dir=./dotfiles zed

# Restow package
stow --verbose --target="$HOME" --dir=./dotfiles --restow zed

# Partial stow
stow --verbose --adopt --target="$HOME" --dir=./dotfiles zed
```
