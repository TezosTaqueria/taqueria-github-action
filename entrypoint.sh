#!/bin/bash
# Uncomment for local development
# if [ -z "$INPUT_PROJECT_DIRECTORY" ] && [ -z "$INPUT_TASK" ]; then
#     # TODO: These are for testing and should be removed after
#     INPUT_PROJECT_DIRECTORY=$1
#     INPUT_TASK=$2
#     if [ "$INPUT_TASK" == "bash" ]; then
#         /bin/bash
#     fi
# fi

# echo "$INPUT_TASK"
WORKDIR=$(pwd)

if [ -z "$INPUT_PROJECT_DIRECTORY" ] && [ -z "$INPUT_TASK" ]; then
    echo "No project name or task name provided"
    exit 1
fi

if [ -z "$INPUT_PROJECT_DIRECTORY" ]; then
    if [ -z "$PROJECT_DIR" ]; then
        export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
    fi
    echo $PROJECT_DIR
    taq init
    npm init -y
    taq $INPUT_TASK
else
    if [ -z "$PROJECT_DIR" ]; then
        export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_DIRECTORY
    fi
    echo $PROJECT_DIR
    taq -p $INPUT_PROJECT_DIRECTORY init
    cd "$INPUT_PROJECT_DIRECTORY" || exit 1
    npm init -y
    cd $WORKDIR || exit 1
    taq -p $INPUT_PROJECT_DIRECTORY $INPUT_TASK
fi
