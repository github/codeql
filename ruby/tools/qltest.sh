#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.rb \
    --include-extension=.erb \
    --include-extension=.gemspec \
    --include="**/Gemfile" \
    --size-limit=5m \
    --language=ruby \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_RUBY_WIP_DATABASE"
