#!/bin/bash
echo "$INPUT_TASK"
if [ -z "$INPUT_PROJECT_NAME" ] && [ -z "$INPUT_TASK" ]; then
    echo "No project name, task name provided, or config file provided"
fi

echo "Project name: $INPUT_PROJECT_NAME"
echo "Task name: $INPUT_TASK"

if [ -z "$INPUT_PROJECT_NAME" ]; then
    PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
    if [ "$INPUT_TASK" == "init" ]; then
        taq $INPUT_TASK
        npm init -y
    else
        echo "$PROJECT_DIR"
        taq $INPUT_TASK
    fi
else
    PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_NAME
    # When the taq command is init
    if [ "$INPUT_TASK" == "init" ]; then
        echo "I come back"
        taq -p $INPUT_PROJECT_NAME $INPUT_TASK
        cd "$INPUT_PROJECT_NAME" || exit 1
        npm init -y
    else
        echo "$PROJECT_DIR"
        taq -p $INPUT_PROJECT_NAME $INPUT_TASK
    fi
fi
