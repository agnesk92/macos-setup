if not status is-interactive
    return
end

/opt/homebrew/bin/brew shellenv | source

starship init fish | source
zoxide init fish | source
atuin init fish | source

fish_add_path $HOME/.local/bin

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

# default programs
set -gx TERMINAL ghostty
