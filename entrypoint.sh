#!/bin/bash

WORKDIR=$(pwd)

if [ -z "$INPUT_PROJECT_DIRECTORY" ]; then

    # Set the PROJECT_DIR variable if it has not already been set
    if [ -z "$PROJECT_DIR" ]; then
        export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}
        echo "PROJECT_DIR has been set to $PROJECT_DIR"
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

else

    # Set the PROJECT_DIR variable if it has not already been set
    if [ -z "$PROJECT_DIR" ]; then
        export PROJECT_DIR=$RUNNER_WORKSPACE/${GITHUB_REPOSITORY#*/}/$INPUT_PROJECT_DIRECTORY
        echo "PROJECT_DIR has been set to $PROJECT_DIR"
    fi

    taq -p $INPUT_PROJECT_DIRECTORY init
    cd "$INPUT_PROJECT_DIRECTORY" || exit 1
    npm init -y &> '/dev/null'
    cd $WORKDIR || exit 1

    if [ -n "$INPUT_PLUGINS" ]; then
        # for each plugin in the comma separated INPUT_PLUGINS install the plugin
        npm init -y &> '/dev/null'
        for plugin in $(echo $INPUT_PLUGINS | tr "," "\n"); do
            echo "Installing plugin $plugin"
            taq -p $INPUT_PROJECT_DIRECTORY install $plugin
        done
    fi

    if [ -n "$INPUT_COMPILE_COMMAND" ]; then
        echo "Compiling contracts using the command $INPUT_COMPILE_COMMAND"
        taq -p $INPUT_PROJECT_DIRECTORY $INPUT_COMPILE_COMMAND
    fi
fi
    