#! /bin/bash
set -e
SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTDIR/utils.sh"
run go-extractor -mod=vendor ./...
