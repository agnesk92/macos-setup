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
        # fish_add_path -g $p
        set -gx --prepend PATH $p
    end
end

# ASDF - add shims to path
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

/opt/homebrew/bin/brew shellenv | source

# Auto-switching Node by `.nvmrc`.
# note: must call it on initialization or listening to directory switching won't work
load_nvm >/dev/stderr

direnv hook fish | source
starship init fish | source
zoxide init fish | source
atuin init fish | source

# aliases
alias lsla="ls -la"
alias size="du -hsc *"
alias prettypath='printf "%s\n" $PATH'

# tools
alias gmj="gitmoji -c"
alias lg="lazygit"

alias gmc="git-cz"
alias gcz="git-cz"

alias prs="gh search prs --owner humanitec --state open --author @me"
alias reviews="gh search prs --owner humanitec --state open --review-requested @me --review required --draft=false -- -author:app/dependabot"
alias prlinks='echo "🔗 https://github.com/pulls?q=is:open+is:pr+author:@me+org:humanitec" && echo "" && gh search prs --owner humanitec --state open --author @me'

# projects
alias projects="cd ~/Projects"
alias pet="cd ~/Projects/Personal"
alias brain="cd ~/Documents/Obsidian/brain"
alias ht="cd ~/Projects/Humanitec"

# docker
alias dcleannone='docker rmi (docker images | grep "<none>" | awk \'{print $3}\')'
alias dstopall='docker ps -a | awk \'{print $1}\' | tail -n +2 | xargs docker stop'
alias dremoveall='docker ps -a | awk \'{print $1}\' | tail -n +2 | xargs docker rm -fv'

# kubernetes
alias k='kubectl'
alias kd='kubectl describe'
alias kdd='kubectl describe deployment'
alias kdp='kubectl describe pod'
alias kei='kubectl exec -it'
alias kg='kubectl get'
alias kgall='kubectl get --all-namespaces all'
alias kgd='kubectl get deployments'
alias kgp='kubectl get pod'
alias kgsvc='kubectl get service'
alias kl='kubectl logs --all-containers=true'
alias krm='kubectl delete'

# misc infra
alias tf='tofu'
alias ggc='gcloud'

# default programs
set -gx TERMINAL ghostty

set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source
