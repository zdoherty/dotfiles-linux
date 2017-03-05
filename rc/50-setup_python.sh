#!/bin/bash

. $HOME/lib/funcs.sh

[ -d $CODE_HOME ] || { echo "This requires a code workspace to work." >&2 && exit 1 ; }
hash pip 2>/dev/null || { echo "You need to install pip for this to work." >&2 && exit 1 ; }

# Virtualenv wrapper environment variables
export WORKON_HOME="$CODE_HOME/env"

push_on_python_path "$(python -m site --user-site)"
push_on_path "$(python -m site --user-base)/bin"

VENV_WRAPPER="$(python -m site --user-base)/bin/virtualenvwrapper.sh"
if [ ! -f $VENV_WRAPPER ]; then
    pip install --user virtualenvwrapper
fi

. $VENV_WRAPPER
