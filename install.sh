#!/bin/bash
set -ex
#
# dotfiles repo installer. assumes this will be run from within the dotfiles repo
#
hash git 2>&1 >/dev/null || { echo "You'll need Git to run this." >&2 ; exit 1 ; }

# try to ensure we're doing the right thing
pushd $(dirname $0) >/dev/null
SCRIPTPATH="$(pwd)"
popd >/dev/null
if $(GIT_DIR=$SCRIPTPATH git status 2>/dev/null 1>&2); then
    echo "This isn't running from inside a git repo. Probably gonna break something." >&2
    exit 1
fi

homeshick_path="$HOME/.homesick/repos/homeshick"

# setup homeshick
if [ ! -d $homeshick_path ]; then
    mkdir -p $homeshick_path
    git clone git@github.com:zdoherty/homeshick $homeshick_path
fi

# append loader to bashrc
if ! grep -q "source $SCRIPTPATH/.bashrc.load" $HOME/.bashrc; then
    printf "\nsource $SCRIPTPATH/.bashrc.load\n" >> $HOME/.bashrc
fi

