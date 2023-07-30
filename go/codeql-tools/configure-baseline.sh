#!/bin/sh

if [ -f vendor/modules.txt ]; then
  cat $CODEQL_EXTRACTOR_GO_ROOT/codeql-tools/baseline-config.json
fi
