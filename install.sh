#!/bin/bash
set -e
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

HOMESHICK_DEFAULT="$HOME/.homesick/repos/homeshick"
RUNCOMS_DEFAULT="$HOME/.rcs"
OUTPUT_PATH="$HOME/.local/bootstrap_env"

echo "Where do you want to put homeshick [$HOMESHICK_DEFAULT]? "
read homeshick_path
homeshick_path="${homeshick_path:-$HOMESHICK_DEFAULT}"

echo "Where do the runcoms live [$RUNCOMS_DEFAULT]? "
read rc_path
rc_path="${rc_path:-$RUNCOMS_DEFAULT}"

# setup homeshick
mkdir -p $homeshick_path
git clone git@github.com:zdoherty/homeshick $homeshick_path

# append loader to bashrc
printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc

# ensure we can place rcs
mkdir -p $rc_path

# drop a config for future loading
mkdir -p $(dirname $OUTPUT_PATH) && echo <<EOF | tee $OUTPUT_PATH
HOMESHICK="${homeshick_path}"
RUNCOMS="${rc_path}"
EOF

