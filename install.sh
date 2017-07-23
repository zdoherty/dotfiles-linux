#!/bin/bash

# setup homeshick
mkdir -p $HOME/.homesick/repos/homeshick
git clone git@github.com:zdoherty/homeshick $HOME/.homesick/repos/homeshick

# append loader to bashrc
printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc

