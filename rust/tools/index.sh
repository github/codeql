#!/bin/bash
# TODO move this to rust code

inputs=($(find -name Cargo.toml))

if [ "${#inputs}" -eq 0 ]; then
  inputs=($(find -name rust-project.json))
  if [ "${#inputs}" -eq 0 ]; then
    inputs=($(find -name '*.rs'))
    if [ "${#inputs}" -eq 0 ]; then
      echo "no source files found" >&2
      exit 1
    fi
  fi
fi

exec "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" "${inputs[@]}"
