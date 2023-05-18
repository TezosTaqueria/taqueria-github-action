#!/bin/bash
## Because of the docker-in-docker setup for the action we need to set 'localhost' to the host docker IP
echo "172.17.0.1       localhost" >/etc/hosts

exit_code=0

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

if [ -n "$INPUT_TAQ_LIGO_IMAGE" ]; then
    echo "overriding Ligo version with $INPUT_TAQ_LIGO_IMAGE"
    export TAQ_LIGO_IMAGE=$INPUT_TAQ_LIGO_IMAGE
fi

if [ -n "$INPUT_PLUGINS" ]; then
    # for each plugin in the comma separated INPUT_PLUGINS install the plugin
    for plugin in $(echo $INPUT_PLUGINS | tr "," "\n"); do
        echo "Installing plugin $plugin"
        taq install $plugin
    done
fi

if [ -n "$INPUT_LIGO_LIBRARIES" ]; then
    # for each ligo lib in the comma separated INPUT_LIGO_LIBRARIES install the library
    for ligo_lib in $(echo $INPUT_LIGO_LIBRARIES | tr "," "\n"); do
        echo "Installing ligo lib $ligo_lib"
        taq ligo --command "install $ligo_lib"
    done
fi

if [ -n "$INPUT_CONTRACTS" ]; then
    # for each contract in the comma separated INPUT_CONTRACTS register the contract
    for contract in $(echo $INPUT_CONTRACTS | tr "," "\n"); do
        echo "Registering contract $contract"
        taq add-contract "$contract"
    done
fi

if [ -n "$INPUT_COMPILE_CONTRACTS" ] && [ -n "$INPUT_COMPILE_PLUGIN" ]; then
    # for each contract in the comma separated INPUT_CONTRACTS register the contract
    for contract in $(echo $INPUT_COMPILE_CONTRACTS | tr "," "\n"); do
        echo "Compiling $contract"
        taq compile "$contract" --plugin "$INPUT_COMPILE_PLUGIN"
        result=$?
        exit_code=$(($exit_code + $result))
    done
    chmod -R 777 ./artifacts
fi

if [ -n "$INPUT_TEST_FILES" ] && [ -n "$INPUT_COMPILE_PLUGIN" ]; then
    for file in $(echo $INPUT_TEST_FILES | tr "," "\n"); do
        echo "Testing $file"
        taq test $file --plugin "$INPUT_COMPILE_PLUGIN" > results.log
        cat results.log
        if grep -q "Some tests failed" results.log; then
            exit_code=$(($exit_code + 1))
        fi
    done
fi

if [ -n "$INPUT_DEPLOY_CONTRACTS" ] && [ $exit_code == 0 ]; then
    # for each contract in the comma separated INPUT_CONTRACTS register the contract
    for contract in $(echo "$INPUT_DEPLOY_CONTRACTS" | tr "," "\n"); do
        echo "Deploying $contract"
        taq deploy "$contract" --env "$INPUT_ENVIRONMENT" > results.log
        cat results.log
        if grep -q "No operations performed" results.log; then
            exit_code=$(($exit_code + 1))
        fi
        exit_code=$(($exit_code + $result))
    done
fi

if [ -n "$INPUT_TASK" ] && [ "$INPUT_TASK" != "init" ]; then
    echo "Running task: $INPUT_TASK"
    taq "$INPUT_TASK"
fi

if [ -n "$INPUT_SANDBOX_NAME" ]; then
    taq start sandbox "$INPUT_SANDBOX_NAME"
fi

if [ -n "$INPUT_TEST_PLUGIN" ]; then
    chmod -R 777 ./.taq
    echo "Running tests using plugin $INPUT_TEST_PLUGIN"
    taq test --plugin "$INPUT_TEST_PLUGIN"
    result=$?
    exit_code=$(($exit_code + $result))
    chmod -R 755 ./.taq
fi

echo "Exit code : $exit_code"
exit $exit_code
