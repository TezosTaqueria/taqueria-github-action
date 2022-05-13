#!/bin/bash
echo "$INPUT_TASK"
if [ -z "$INPUT_PROJECT_NAME" ] && [ -z "$TASK_NAME" ];then
    echo "No project name or task name provided"
    exit 1
fi

if [ -z "$INPUT_PROJECT_NAME" ];then
    PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
    if [ "$TASK_NAME" == "init" ]; then
        taq "$INPUT_TASK"
        npm init -y
    else
        echo "$PROJECT_DIR"
        taq "$INPUT_TASK"
    fi
else
    PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_NAME
    # When the taq command is init
    if [ "$TASK_NAME" == "init" ]; then
        taq -p "$INPUT_PROJECT_NAME" "$INPUT_TASK"
        cd "$INPUT_PROJECT_NAME" || exit 1
        npm init -y
    else
        echo "$PROJECT_DIR"
        taq -p "$INPUT_PROJECT_NAME" "$INPUT_TASK"
    fi
fi