#!/bin/sh

set -eu

# Note: We're adding the `reusable_workflows` subdirectories to proactively
# record workflows that were called cross-repo, check them out locally,
# and enable an interprocedural analysis across the workflow files.
# These workflows follow the convention `.github/reusable_workflows/<nwo>/*.ya?ml`
DEFAULT_PATH_FILTERS=$(cat << END
exclude:**/*
include:.github/workflows/*.yml
include:.github/workflows/*.yaml
include:.github/reusable_workflows/**/*.yml
include:.github/reusable_workflows/**/*.yaml
include:**/action.yml
include:**/action.yaml
END
)

if [ -n "${LGTM_INDEX_INCLUDE:-}" ] || [ -n "${LGTM_INDEX_EXCLUDE:-}" ] || [ -n "${LGTM_INDEX_FILTERS:-}" ] ; then
    echo "Path filters set. Passing them through to the JavaScript extractor."
else
    echo "No path filters set. Using the default filters."
    LGTM_INDEX_FILTERS="${DEFAULT_PATH_FILTERS}"
    export LGTM_INDEX_FILTERS
fi

# Find the JavaScript extractor directory via `codeql resolve extractor`.
CODEQL_EXTRACTOR_JAVASCRIPT_ROOT="$($CODEQL_DIST/codeql resolve extractor --language javascript)"
export CODEQL_EXTRACTOR_JAVASCRIPT_ROOT

echo "Found JavaScript extractor at '${CODEQL_EXTRACTOR_JAVASCRIPT_ROOT}'."

# Run the JavaScript autobuilder
JAVASCRIPT_AUTO_BUILD="${CODEQL_EXTRACTOR_JAVASCRIPT_ROOT}/tools/autobuild.sh"
echo "Running JavaScript autobuilder at '${JAVASCRIPT_AUTO_BUILD}'."

# Copy the values of the Actions extractor environment variables to the JavaScript extractor environment variables.
env CODEQL_EXTRACTOR_JAVASCRIPT_DIAGNOSTIC_DIR="${CODEQL_EXTRACTOR_ACTIONS_DIAGNOSTIC_DIR}" \
    CODEQL_EXTRACTOR_JAVASCRIPT_LOG_DIR="${CODEQL_EXTRACTOR_ACTIONS_LOG_DIR}" \
    CODEQL_EXTRACTOR_JAVASCRIPT_SCRATCH_DIR="${CODEQL_EXTRACTOR_ACTIONS_SCRATCH_DIR}" \
    CODEQL_EXTRACTOR_JAVASCRIPT_SOURCE_ARCHIVE_DIR="${CODEQL_EXTRACTOR_ACTIONS_SOURCE_ARCHIVE_DIR}" \
    CODEQL_EXTRACTOR_JAVASCRIPT_TRAP_DIR="${CODEQL_EXTRACTOR_ACTIONS_TRAP_DIR}" \
    CODEQL_EXTRACTOR_JAVASCRIPT_WIP_DATABASE="${CODEQL_EXTRACTOR_ACTIONS_WIP_DATABASE}" \
    ${JAVASCRIPT_AUTO_BUILD}
