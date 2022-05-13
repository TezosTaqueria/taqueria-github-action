#!/bin/bash

if [ -z "$INPUT_PROJECT_NAME" ];then
    PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
    if [ "$TASK_NAME" == "init" ]; then
        taq $INPUT_TASK
        npm init -y
    else
        taq $INPUT_TASK
    fi
else
    PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_NAME
    # When the taq command is init
    if [ "$TASK_NAME" == "init" ]; then
        taq -p $INPUT_PROJECT_NAME $INPUT_TASK
        cd $INPUT_PROJECT_NAME
        npm init -y
    else
        echo $PROJECT_DIR
        taq -p $INPUT_PROJECT_NAME $INPUT_TASK
    fi
fi