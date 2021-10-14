#!/bin/bash

# This is a bash script
export FOO="$(whereis ls)"
exec "$FOO" "$(dirname "$0")"
