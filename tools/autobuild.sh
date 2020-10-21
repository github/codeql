#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --include-extension=.rb \
    --size-limit=5m \
    --language=ruby \
    "$CODEQL_EXTRACTOR_RUBY_WIP_DATABASE"
