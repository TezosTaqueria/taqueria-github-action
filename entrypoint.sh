#!/bin/bash

# if $2 is equal to "compile", then run the following
# if [ "$2" = "bash" ]; then
#     /bin/bash
echo "The initial value of PROJECT_DIR is: $PROJECT_DIR"
export PROJECT_DIR=/home/runner/work/taqueria-github-action/taqueria-github-action/test-project

if [ "$2" == "init" ]; then
    ls -la
    taq -p $1 $2
    cd $1
    npm init -y
# elif [ "$2" == "compile" ]; then
#     ls -la
#     echo "The value of -p is $1"
#     echo $PROJECT_DIR
#     echo "Try the old way"
#     cd $1
#     taq compile
#     echo "Try the new way"
#     cd ..
#     taq -p $1 compile
#     ls -ltr ./test-project/artifacts
else
    ls -la
    echo "The value of -p is $1"
    echo $PROJECT_DIR
    taq -p $1 $2
fi
