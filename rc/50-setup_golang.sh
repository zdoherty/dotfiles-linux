#!/bin/bash

unset STOP

[ -d $CODE_HOME ] || { echo "This requires a code workspace to work." >&2 && STOP="dir" ; }
hash go 2>/dev/null || { echo "This requires a golang binary to work." >&2 && STOP="go" ; }

if [ "x$STOP" = "x" ]; then
    export GOPATH=$CODE_HOME
    push_on_path /usr/local/go/bin
fi

