#!/bin/bash
echo $GITHUB_WORKSPACE
echo $RUNNER_WORKSPACE
ls -ltr
# Uncomment for local development
if [ -z "$INPUT_PROJECT_DIRECTORY" ] && [ -z "$INPUT_TASK" ]; then
    # TODO: These are for testing and should be removed after
    INPUT_PROJECT_DIRECTORY=$1
    INPUT_TASK=$2
    if [ "$INPUT_TASK" == "bash" ]; then
        /bin/bash
    fi
fi

# echo "$INPUT_TASK"
# if [ -z "$INPUT_PROJECT_DIRECTORY" ] && [ -z "$INPUT_TASK" ]; then
#     echo "No project name or task name provided"
#     exit 1
# fi

if [ -z "$INPUT_PROJECT_DIRECTORY" ]; then
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
    echo $PROJECT_DIR
    if [ "$INPUT_TASK" == "init" ]; then
        taq init
        npm init -y
    else
        taq $INPUT_TASK
    fi
else
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_DIRECTORY
    echo $PROJECT_DIR
    # When the taq command is init
    if [ "$INPUT_TASK" == "init" ]; then
        taq -p $INPUT_PROJECT_DIRECTORY init
        echo "command exit code is $?"
        cd "$INPUT_PROJECT_DIRECTORY" || exit 1
        npm init -y
    # elif [[ "$INPUT_TASK" == *"start sandbox"* ]]; then
    #     cd "$INPUT_PROJECT_DIRECTORY" || exit 1
    #     taq start sandbox local
    else
        taq -p $INPUT_PROJECT_DIRECTORY $INPUT_TASK
        echo "command exit code is $?"
    fi
fi
