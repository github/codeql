#!/usr/bin/env bash -e

go test -c
# comment above and uncomment below to enable the race builder
#go test -c -race
PKG=$(basename $(pwd))

while true ; do
        export GOMAXPROCS=$[ 1 + $[ RANDOM % 128 ]]
        ./$PKG.test $@ 2>&1
done