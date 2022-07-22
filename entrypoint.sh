#!/bin/bash

echo "Set localhost to 172.17.0.1"
echo "172.17.0.1       localhost" > /etc/hosts

if [ -z "$INPUT_PROJECT_DIRECTORY" ]; then
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}   
else
    export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_DIRECTORY
    cd $INPUT_PROJECT_DIRECTORY || exit 1
fi


if [ "$INPUT_TASK" == "init" ]; then
        echo "Initializing project..."
        taq init
fi


if [ -n "$INPUT_PLUGINS" ]; then
    # for each plugin in the comma separated INPUT_PLUGINS install the plugin
    for plugin in $(echo $INPUT_PLUGINS | tr "," "\n"); do
        echo "Installing plugin $plugin"
        taq install $plugin
    done
fi

if [ -n "$INPUT_CONTRACTS" ]; then
    # for each contract in the comma separated INPUT_CONTRACTS register the contract
    for contract in $(echo $INPUT_CONTRACTS | tr "," "\n"); do
        echo "Registering contract $contract"
        taq add-contract "$contract"
    done
fi

if [ -n "$INPUT_COMPILE_COMMAND" ]; then
    echo "PROJECT_DIR: $PROJECT_DIR"
    echo "Compiling contracts using the command $INPUT_COMPILE_COMMAND"
    taq $INPUT_COMPILE_COMMAND
fi

if [ -n "$INPUT_SANDBOX_NAME" ]; then
    taq start sandbox $INPUT_SANDBOX_NAME
fi

if [ "$INPUT_ORIGINATE" == "true" ] || [ "$INPUT_ORIGINATE" == "True" ]; then
    taq originate --env $INPUT_ENVIRONMENT
fi

if [ -n "$INPUT_TASK" ] && [ "$INPUT_TASK" != "init" ]; then
    echo "Running task: $INPUT_TASK"
    taq $INPUT_TASK
fi

if [ "$INPUT_TESTS" == "true" ] || [ "$INPUT_TESTS" == "True" ]; then
    chown -R root:root "$INPUT_PROJECT_DIRECTORY"
    taq test
    chown -R 1001:121
fi