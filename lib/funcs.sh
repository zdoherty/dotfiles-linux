#!/bin/bash
# Some hopefully useful functions for writing dotfiles

last_exit_code () {
    if [ "$?" -ne "0" ]; then
        echo -n "$?"
    fi
}

# Idempotent operations for path manipulation
push_on_path () {
    if ! echo $PATH | grep -q $1; then
        export PATH="$1:$PATH"
    fi
}

append_to_path () {
    if ! echo $PATH | grep -q $1; then
        export PATH="$PATH:$1"
    fi
}

push_on_python_path () {
    if ! echo $PYTHONPATH | grep -q $1; then
        export PYTHONPATH="$1:$PYTHONPATH"
    fi
}

append_to_python_path () {
    if ! echo $PATH | grep -q $1; then
        export PYTHONPATH="$PYTHONPATH:$1"
    fi
}
