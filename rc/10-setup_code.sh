#!/bin/bash
#
# Sets up some useful building blocks for coding
#
. $HOME/lib/funcs.sh

export CODE_HOME=$HOME/code
mkdir -p $CODE_HOME/{pkg,src,bin,env}

push_on_path $CODE_HOME/bin

