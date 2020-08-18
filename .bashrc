#!/bin/bash

. ~/lib/funcs.sh

# varz
export GOPATH=~/code
export GOPRIVATE="github.com/elevatestartupdev"
export EDITOR=vim
export TERM=xterm-256color

# history
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# pathz
push_on_path /sbin
push_on_path /usr/sbin
push_on_path ~/bin
push_on_path ~/.local/bin
push_on_path ~/.yarn/bin
push_on_path ~/.gem/ruby/2.7.0/bin
push_on_path /usr/local/go/bin
push_on_path $GOPATH/bin

# load homeshick if it's there
[ -f ~/.homesick/repos/homeshick/homeshick.sh ] && . ~/.homesick/repos/homeshick/homeshick.sh

# ctrl
setxkbmap -option caps:ctrl_modifier

# pretty colors
PROMPT_COMMAND='RET=$? ; \
if [[ $PWD =~ ^$HOME/code/.* ]]; then
    DNAME=$(sed \
        -e s,^$HOME,~, \
        -e s,/code/,/c/, \
        -e s,/src/,/s/, \
        -e s,/bin/,s, \
        -e s,/github.com/,/gh/, \
        -e s,/git.poundadm.net/,/gpa/, \
        -e s,kubernetes,k8s, \
        -e s,/anachronism/,/me/, \
        -e s,/zdoherty/,/me/, \
        -e s,/elevatestartupdev/,/E^/, \
        -e s,/modules/,/m/, \
        -e s,/deploy/,/d/, \
        <<< $PWD
    )
else
    DNAME=$(sed -e s,^$HOME,~, <<< $PWD)
fi ; \

PS1="\[\e[0;36m\]\u\[\e[1;38m\]@\[\e[0;36m\]\h\[\e[1;38m\]:\[\e[0;36m\]$DNAME\[\e[m\]\[\e[1;36m\]\$\[\e[m\] "
'
#PS1="\[\e[0;36m\]\u\[\e[1;38m\]@\[\e[0;36m\]\h\[\e[1;38m\]:\[\e[0;36m\]\w\[\e[m\]\[\e[1;36m\]\$\[\e[m\] "
[ -d /Library ] && alias ls='ls -G' || alias ls='ls --color=auto'
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias zgrep="zgrep --color=auto"

# ssh agent
[ -f ~/.ssh/environment ] && . ~/.ssh/environment

# direnv
eval "$(direnv hook bash)"

# gcloud
if [ -f '~/google-cloud-sdk/path.bash.inc' ]; then source '~/google-cloud-sdk/path.bash.inc'; fi
if [ -f '~/google-cloud-sdk/completion.bash.inc' ]; then source '~/google-cloud-sdk/completion.bash.inc'; fi

setxkbmap -option caps:ctrl_modifier
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# command aliases and helpers
alias k="kubectl"
alias kns="kubens"
alias kctx="kubectx"
alias tf="terraform"
alias hs="homeshick"

function podname {
    kubectl get po -o name $@ | fzf | cut -d/ -f2-
}

function kexec {
    POD=$(podname $@)
    kubectl exec -it $@ $POD -- bash || kubectl exec -it $@ $POD -- sh
}

function pro {
    export AWS_PROFILE=$(awk '/^\[profile/ {print $2}' ~/.aws/config | tr -d '[]' | fzf)
}

function wd {
    cd ~/code/src/github.com/$(cat \
        <(cd ~/code/src/github.com && find zdoherty -type d -maxdepth 1 -mindepth 1 2>/dev/null) \
        <(cd ~/code/src/github.com && find elevatestartupdev -type d -maxdepth 1 -mindepth 1 2>/dev/null) | fzf
    )
}

push_on_path "$HOME/.pyenv/bin"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export MINIKUBE_HOME=/mnt/vms/minikube
