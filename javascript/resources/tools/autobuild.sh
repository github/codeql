#!/bin/sh

set -eu

jvm_args=-Xss16m

# If CODEQL_RAM is set, use half for Java and half for TS.
if [ -n "${CODEQL_RAM:-}" ] ; then
    half_ram="$(( CODEQL_RAM / 2 ))"
    LGTM_TYPESCRIPT_RAM="$half_ram"
    export LGTM_TYPESCRIPT_RAM
    jvm_args="$jvm_args -Xmx${half_ram}m"
fi

# If CODEQL_THREADS is set, propagate via LGTM_THREADS.
if [ -n "${CODEQL_THREADS:-}" ] ; then
    LGTM_THREADS="$CODEQL_THREADS"
    export LGTM_THREADS
fi

# The JS autobuilder expects to find typescript modules under SEMMLE_DIST/tools.
# They are included in the pack, but we need to set SEMMLE_DIST appropriately.
# We want to word-split $jvm_args, so disable the shellcheck warning.
# shellcheck disable=SC2086
env SEMMLE_DIST="$CODEQL_EXTRACTOR_JAVASCRIPT_ROOT" \
    LGTM_SRC="$(pwd)" \
    "${CODEQL_JAVA_HOME}/bin/java" $jvm_args \
    -cp "$CODEQL_EXTRACTOR_JAVASCRIPT_ROOT/tools/extractor-javascript.jar" \
    com.semmle.js.extractor.AutoBuild
