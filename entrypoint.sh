#!/bin/bash

# if $2 is equal to "compile", then run the following
if [ "$2" = "bash" ]; then
    /bin/bash
elif [ "$2" = "init" ]; then
    taq -p $1 $2
    cd $1
    npm init -y
    chown -R $USER:$USER ../$1
else
    cd $1
    export PROJECT_DIR="$GITHUB_WORKSPACE/$1"
    ls -ltr
    taq $2
    echo $PROJECT_DIR   
fi
