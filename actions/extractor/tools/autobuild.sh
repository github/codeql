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

echo "Initial 'LGTM_INDEX_INCLUDE':"
echo ${LGTM_INDEX_INCLUDE:-}
echo "Initial 'LGTM_INDEX_EXCLUDE':"
echo ${LGTM_INDEX_EXCLUDE:-}
echo "Initial 'LGTM_INDEX_FILTERS':"
echo ${LGTM_INDEX_FILTERS:-}

# If the user has specified any paths to include, we will scan those paths as-is.
# If the user has only specified paths to exclude, or has not specified any paths at all,
# we will scan the default paths, but apply the user-specified exclusions to them.
newline=$'\n'
if [ -n "${LGTM_INDEX_INCLUDE:-}" ] ; then
    echo "'LGTM_INDEX_INCLUDE' set. Passing all path inclusions, exclusions, and filters through to the JavaScript extractor."
elif [[ "${LGTM_INDEX_FILTERS}" =~ (^|$newline)include: ]]; then
    echo "'LGTM_INDEX_FILTERS' contains at least one 'include:' filter. Passing all path inclusions, exclusions, and filters through to the JavaScript extractor."
else
    echo "'LGTM_INDEX_FILTERS' contains no 'include:' filters. Using the default path filters, with any user-specified exclusions applied."
    LGTM_INDEX_FILTERS="${DEFAULT_PATH_FILTERS}${newline}${LGTM_INDEX_FILTERS}"
    export LGTM_INDEX_FILTERS
fi

echo "Final 'LGTM_INDEX_FILTERS':"
echo ${LGTM_INDEX_FILTERS}

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
