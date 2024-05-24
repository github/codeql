#!/bin/sh

set -eu

echo Args: "$@"
$@ || exit $?
