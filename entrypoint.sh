#!/bin/bash

WORKDIR=$(pwd)

if [ -z "$INPUT_PROJECT_DIRECTORY" ]; then

    # Set the PROJECT_DIR variable if it has not already been set
    if [ -z "$PROJECT_DIR" ]; then
        export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
        echo "PROJECT_DIR has been set to $PROJECT_DIR"
    fi

    taq init

    # The project will be initialized each time there is a task unless the task itself is to initialize the project
    if [ "$INPUT_TASK" == "init" ]; then
        npm init -y &> '/dev/null'
    else
        taq $INPUT_TASK
    fi

else

    # Set the PROJECT_DIR variable if it has not already been set
    if [ -z "$PROJECT_DIR" ]; then
        export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_DIRECTORY
        echo "PROJECT_DIR has been set to $PROJECT_DIR"
    fi

    taq -p $INPUT_PROJECT_DIRECTORY init

    # The project will be initialized each time there is a task unless the task itself is to initialize the project
    if [ "$INPUT_TASK" == "init" ]; then
        cd "$INPUT_PROJECT_DIRECTORY" || exit 1
        npm init -y &> '/dev/null'
        cd $WORKDIR || exit 1
    else
        taq -p $INPUT_PROJECT_DIRECTORY $INPUT_TASK
    fi
    
fi
    