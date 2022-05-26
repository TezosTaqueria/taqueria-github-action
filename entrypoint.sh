#!/bin/bash

if [ -z "$INPUT_PROJECT_DIRECTORY" ]; then
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}   
else
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_DIRECTORY
    cd $INPUT_PROJECT_DIRECTORY || exit 1
fi

taq init
npm init -y &> '/dev/null'

if [ -n "$INPUT_PLUGINS" ]; then
    # for each plugin in the comma separated INPUT_PLUGINS install the plugin
    for plugin in $(echo $INPUT_PLUGINS | tr "," "\n"); do
        echo "Installing plugin $plugin"
        taq install $plugin
    done
fi

if [ -n "$INPUT_COMPILE_COMMAND" ]; then
    echo "Compiling contracts using the command $INPUT_COMPILE_COMMAND"
    taq $INPUT_COMPILE_COMMAND
fi

if [ -n "$INPUT_SANDBOX_NAME" ]; then
    taq start sandbox $INPUT_SANDBOX_NAME
fi


if [ -n "$INPUT_TAQUITO_COMMAND" ]; then
    if [ "$INPUT_TAQUITO_COMMAND" != "originate" ]; then
        echo "The command $INPUT_TAQUITO_COMMAND is not supported yet. Only 'origintate' is currently supported"
        exit 1
    fi
    taq $INPUT_TAQUITO_COMMAND
fi

if [ -n "$INPUT_TASK" ]; then
    echo "Running task: $INPUT_TASK"
    taq $INPUT_TASK
fi