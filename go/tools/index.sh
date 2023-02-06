#! /bin/bash
set -ex
SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTDIR/utils.sh"
run go-autobuilder
