#!/bin/bash

# if $2 is equal to "compile", then run the following
# if [ "$2" = "bash" ]; then
#     /bin/bash
# export PROJECT_DIR=/home/runner/work/taqueria-github-action/taqueria-github-action/test-project
# export PROJECT_DIR=/home/gino/Documents/Repositories/taqueria-github-action/new-plugin-project
if [ "$2" == "init" ]; then
    ls -la
    taq -p $1 $2
    cd $1
    npm init -y
else
    echo $PROJECT_DIR
    echo $GITHUB_WORKSPACE
    echo $GITHUB_ENV
    taq -p $1 $2
fi
