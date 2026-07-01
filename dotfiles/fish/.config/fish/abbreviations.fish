abbr -a up "brew update && brew upgrade"

abbr -a lsla "ls -la"
abbr -a size "du -hsc *"
abbr -a prettypath 'printf "%s\n" $PATH'

# questions
abbr -a q "pi --model big-pickle -p"

# git / github
abbr -a gmj "gitmoji -c"
abbr -a lg lazygit

abbr -a gmc git-cz
abbr -a gcz git-cz

abbr -a prs "gh search prs --owner humanitec --state open --author @me"
abbr -a reviews "gh search prs --owner humanitec --state open --review-requested @me --review required --draft=false -- -author:app/dependabot"
abbr -a prlinks 'echo "🔗 https://github.com/pulls?q=is:open+is:pr+author:@me+org:humanitec" && echo "" && gh search prs --owner humanitec --state open --author @me'

# projects
abbr -a projects "cd ~/Projects"
abbr -a pet "cd ~/Projects/Personal"
abbr -a brain "cd ~/Documents/Obsidian/brain"
abbr -a ht "cd ~/Projects/Humanitec"

# docker
abbr -a dcleannone 'docker rmi (docker images | grep "<none>" | awk \'{print $3}\')'
abbr -a dstopall 'docker ps -a | awk \'{print $1}\' | tail -n +2 | xargs docker stop'
abbr -a dremoveall 'docker ps -a | awk \'{print $1}\' | tail -n +2 | xargs docker rm -fv'

# kubernetes
abbr -a k kubectl
abbr -a kd 'kubectl describe'
abbr -a kdd 'kubectl describe deployment'
abbr -a kdp 'kubectl describe pod'
abbr -a kei 'kubectl exec -it'
abbr -a kg 'kubectl get'
abbr -a kgall 'kubectl get --all-namespaces all'
abbr -a kgd 'kubectl get deployments'
abbr -a kgp 'kubectl get pod'
abbr -a kgsvc 'kubectl get service'
abbr -a kl 'kubectl logs --all-containers=true'
abbr -a krm 'kubectl delete'

# misc infra
abbr -a tf tofu
abbr -a ggc gcloud
