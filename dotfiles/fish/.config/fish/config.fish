if not status is-interactive
    return
end

/opt/homebrew/bin/brew shellenv | source

# You must call it on initialization or listening to directory switching won't work
load_nvm > /dev/stderr

starship init fish | source
zoxide init fish | source
atuin init fish | source
direnv hook fish | source

# set -gx PATH $HOME/.local/bin $PATH
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.npm/bin

# aliases
alias lsla="ls -la"
alias size="du -hsc *"

# tools
alias gmj="gitmoji -c"
alias lg="lazygit"

# projects
alias projects="cd ~/Projects"
alias pet="cd ~/Projects/Personal"
alias brain="cd ~/Documents/Obsidian/brain"
alias ht="cd ~/Projects/Humanitec"

# default programs
set -gx TERMINAL ghostty

# gcloud
set -gx PATH $PATH ~/google-cloud-sdk/bin

# go
# set -gx PATH /opt/homebrew/opt/go@1.24/bin $PATH
# or
fish_add_path /opt/homebrew/opt/go@1.24/bin
