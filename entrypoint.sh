#!/bin/bash
## Because of the docker-in-docker setup for the action we need to set 'localhost' to the host docker IP
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

if [ -n "$INPUT_COMPILE_CONTRACTS" ]; then
    echo "PROJECT_DIR: $PROJECT_DIR"
    # for each contract in the comma separated INPUT_CONTRACTS register the contract
    for contract in $(echo $INPUT_COMPILE_CONTRACTS | tr "," "\n"); do
        echo "Compiling $contract"
        taq compile "$contract" --plugin "$INPUT_COMPILE_PLUGIN"
    done
fi

if [ -n "$INPUT_SANDBOX_NAME" ]; then
    taq start sandbox "$INPUT_SANDBOX_NAME"
fi

if [ -n "$INPUT_DEPLOY_CONTRACTS" ]; then
    # for each contract in the comma separated INPUT_CONTRACTS register the contract
    for contract in $(echo "$INPUT_DEPLOY_CONTRACTS" | tr "," "\n"); do
        echo "Deploying $contract"
        taq deploy "$contract" --env "$INPUT_ENVIRONMENT"
    done
fi

if [ -n "$INPUT_TASK" ] && [ "$INPUT_TASK" != "init" ]; then
    echo "Running task: $INPUT_TASK"
    taq "$INPUT_TASK"
fi

if [ -n "$INPUT_TEST_PLUGIN" ]; then
    chmod -R 777 ./
    echo "Running tests using plugin $INPUT_TEST_PLUGIN"
    taq test --plugin "$INPUT_TEST_PLUGIN"
    exit_code=$?
    chmod -R 755 ./
    exit $exit_code
fi
