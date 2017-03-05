#!/bin/bash

# Make sure we've got pip, at least.
hash pip 2>/dev/null || { echo "You need to install pip for this to work." >&2 && exit 1 ; }

# Build a place to put all our code
CODE_HOME="$HOME/code/"
mkdir -p "$CODE_HOME"{src,bin,pkg,env}

export WORKON_HOME="$CODE_HOME/env"
if ! $(echo "$PYTHONPATH" | fgrep -q "$(python -m site --user-site)"); then
	export PYTHONPATH="$PYTHONPATH:$(python -m site --user-site)"
fi

# Put a tool for making more virtualenvs in our home directory
VENV_WRAPPER="$(python -m site --user-base)/bin/virtualenvwrapper.sh"
if [ ! -f $VENV_WRAPPER ]; then
	pip install --user virtualenvwrapper
fi

. $VENV_WRAPPER

OLD_PATH=$PATH
