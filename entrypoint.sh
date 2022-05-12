#!/bin/bash

# if $2 is equal to "compile", then run the following
# if [ "$2" = "bash" ]; then
#     /bin/bash
export PROJECT_DIR=/home/runner/work/taqueria-github-action/taqueria-github-action
if [ "$2" == "init" ]; then
    ls -la
    taq -p $1 $2
    cd $1
    npm init -y
elif [ "$2" == "compile" ]; then
    ls -la
    sudo ls -ltr /home/runner/work/taqueria-github-action/taqueria-github-action
    sudo ls -ltr /home/runner/work/taqueria-github-action/taqueria-github-action
    sudo ls -ltr /home/runner/work/taqueria-github-action/taqueria-github-action
    echo "The value of -p is $1"
    echo $PROJECT_DIR
    taq -p $1 compile --logPluginRequests
    ls -ltr ./test-project/artifacts
else
    ls -la
    sudo ls -ltr /home/runner/work/taqueria-github-action/taqueria-github-action
    sudo ls -ltr /home/runner/work/taqueria-github-action/taqueria-github-action
    sudo ls -ltr /home/runner/work/taqueria-github-action/taqueria-github-action
    echo "The value of -p is $1"
    echo $PROJECT_DIR
    taq -p $1 $2
fi
