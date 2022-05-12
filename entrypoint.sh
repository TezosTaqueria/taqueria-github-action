#!/bin/bash

# if $2 is equal to "compile", then run the following
# if [ "$2" = "bash" ]; then
#     /bin/bash
export PROJECT_DIR=/home/runner/work/taqueria-github-action/taqueria-github-action/new-plugin-project
if [ "$2" == "init" ]; then
    ls -la
    taq -p $1 $2
    cd $1
    npm init -y
else
    ls -la
    cd $1
    ls -la
    echo $PROJECT_DIR
    taq $2
fi
