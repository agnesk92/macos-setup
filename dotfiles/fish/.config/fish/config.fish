if not status is-interactive
    return
end

# PATH additions (canonical)
for p in \
    $HOME/.local/bin \
    $HOME/.npm/bin \
    /opt/homebrew/opt/go/bin \
    /opt/homebrew/opt/postgresql@17/bin \
    $HOME/google-cloud-sdk/bin
    if test -d $p
        # Do not use fish_add_path (added in Fish 3.2) because it
        # potentially changes the order of items in PATH
        # fish_add_path -g $p
        set -gx --prepend PATH $p
    end
end

# Homebrew
/opt/homebrew/bin/brew shellenv | source

# Abbreviations
source ~/.config/fish/abbreviations.fish

# Defaults
set -gx TERMINAL ghostty

# Tools
direnv hook fish | source
starship init fish | source
zoxide init fish | source
atuin init fish | source

# Carapace
set -gx CARAPACE_BRIDGES 'fish,zsh,bash,inshellisense' # optional fallback completions
carapace _carapace | source

# Mise
mise activate fish | source

# 1pwd shell completion
op completion fish | source
