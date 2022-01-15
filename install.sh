#!/bin/bash
set -e

# make sure git is installed
hash git 2>&1 >/dev/null || { echo "You'll need Git to run this." >&2 ; exit 1 ; }


# setup homeshick
HOMESHICK="$HOME/.homesick/repos/homeshick"
if [ ! -d $HOMESHICK ]; then
    git clone git@github.com:zdoherty/homeshick $HOMESHICK
fi

