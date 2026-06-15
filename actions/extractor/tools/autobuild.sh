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

if [ -n "${LGTM_INDEX_FILTERS:-}" ]; then
    echo "LGTM_INDEX_FILTERS set. Using the default filters together with the user-provided filters, and passing through to the JavaScript extractor."
    # Begin with the default path inclusions only,
    # followed by the user-provided filters.
    # If the user provided `paths`, those patterns override the default inclusions
    # (because `LGTM_INDEX_FILTERS` will begin with `exclude:**/*`).
    # If the user provided `paths-ignore`, those patterns are excluded.
    PATH_FILTERS="$(cat << END
${DEFAULT_PATH_FILTERS}
${LGTM_INDEX_FILTERS}
END
)"
    LGTM_INDEX_FILTERS="${PATH_FILTERS}"
    export LGTM_INDEX_FILTERS
else
    echo "LGTM_INDEX_FILTERS not set. Using the default filters, and passing through to the JavaScript extractor."
    LGTM_INDEX_FILTERS="${DEFAULT_PATH_FILTERS}"
    export LGTM_INDEX_FILTERS
fi

# Find the JavaScript extractor directory via `codeql resolve extractor`.
CODEQL_EXTRACTOR_JAVASCRIPT_ROOT="$("${CODEQL_DIST}/codeql" resolve extractor --language javascript)"
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
    "${JAVASCRIPT_AUTO_BUILD}"
