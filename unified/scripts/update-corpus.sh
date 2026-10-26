#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")/.."

cd extractor
UNIFIED_UPDATE_CORPUS=1 cargo test
