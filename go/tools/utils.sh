#! /bin/bash

if [ -z "$SEMMLE_PLATFORM" ]
then
    case "$OSTYPE" in
    linux*)     SEMMLE_PLATFORM="linux";;
    darwin*)    SEMMLE_PLATFORM="osx64";;
    msys*)      SEMMLE_PLATFORM="win";;
    *)          echo "This script only works on Linux, macOS and msys; OSTYPE: $OSTYPE" && exit 1
    esac
fi

if [ "$SEMMLE_PLATFORM" = "win" ]
then
    EXE=".exe"
else
    EXE=""
fi

run() {
    cmd=$1
    shift
    "$SCRIPTDIR/$SEMMLE_PLATFORM/$cmd$EXE" "$@"
}
