#!/bin/sh

set -eu

jvm_args=-Xss16m

# If CODEQL_RAM is set, try to automatically calculate how much memory is available for TS and Java
# if no explicit values are set for them.
if [ -n "${CODEQL_RAM:-}" ] ; then
    half_ram="$(( CODEQL_RAM / 2 ))"

    # If either CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY or CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY is set,
    # calculate the other by subtracting from CODEQL_RAM. If neither is set, then use
    # half of the available CODEQL_RAM for each.
    if [ -n "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY:-}" ] && [ -z "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY}" ] ; then
        CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY="$(( $CODEQL_RAM - $CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY ))"
    elif [ -n "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY:-}" ] && [ -z "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY}" ] ; then
        CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY="$(( $CODEQL_RAM - $CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY ))"
    elif [ -z "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY}" ] && [ -z "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY}" ] ; then
        CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY="$half_ram"
        CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY="$half_ram"
    fi
fi

# If CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY is set, use it for TS by exporting it as LGTM_TYPESCRIPT_RAM.
if [ -n "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY:-}" ] ; then
    LGTM_TYPESCRIPT_RAM="$CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY"
    export LGTM_TYPESCRIPT_RAM
fi

# If CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY is set, use it for Java by adding it to the JVM arguments.
if [ -n "${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY:-}" ] ; then
    jvm_args="$jvm_args -Xmx${CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY}m"
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
