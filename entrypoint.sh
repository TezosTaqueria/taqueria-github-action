#!/bin/bash

# If PROJECT_DIR is empty 
if [ -z "$PROJECT_DIR" ];then
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_NAME
fi

# When the taq command is init
if [ "$2" == "init" ]; then
    ls -la
    taq -p $INPUT_PROJECT_NAME $INPUT_TASK
    cd $1
    npm init -y
else
    echo $PROJECT_DIR
    taq -p $INPUT_PROJECT_NAME $INPUT_TASK
fi
