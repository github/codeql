#!/bin/sh

if [ -f vendor/modules.txt ]; then
  cat $CODEQL_EXTRACTOR_GO_ROOT/tools/baseline-config-vendor.json
else
  cat $CODEQL_EXTRACTOR_GO_ROOT/tools/baseline-config-empty.json
fi
