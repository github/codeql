#!/bin/sh

# Generates a CodeQL data extension that records the `uses:` references pinned by
# the repository's GitHub Actions lockfile (`.github/workflows/actions.lock`),
# populating the `pinnedByLockfileDataModel` extensible predicate consumed by the
# `actions/unpinned-tag` query.
#
# It is invoked by the Actions extractor autobuild during `codeql database
# create`. The generated extension is written into the database as a
# self-contained model pack under:
#
#   <database>/lockfile-extension/
#     qlpack.yml
#     ext/pinned_by_lockfile.model.yml
#
# CodeQL does not auto-apply extensions carried inside a database, so analysis
# must add this pack explicitly, e.g.:
#
#   codeql database analyze <db> ... \
#     --additional-packs <db>/lockfile-extension \
#     --model-packs codeql/actions-lockfile-pins
#
# The step is a clean no-op when the repository has no lockfile, so it is safe to
# run against every database.

set -eu

SRC_ROOT="${1:?usage: generate-lockfile-extension.sh <source-root>}"
LOCKFILE="${SRC_ROOT}/.github/workflows/actions.lock"

if [ ! -f "${LOCKFILE}" ]; then
    echo "No Actions lockfile at '${LOCKFILE}'; skipping lockfile-pinned extension."
    exit 0
fi

if [ -z "${CODEQL_EXTRACTOR_ACTIONS_WIP_DATABASE:-}" ]; then
    echo "CODEQL_EXTRACTOR_ACTIONS_WIP_DATABASE is not set; cannot write lockfile extension." >&2
    exit 0
fi

SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
GEN_DIR="${SCRIPT_DIR}/lockfile-extension-generator"

PACK_DIR="${CODEQL_EXTRACTOR_ACTIONS_WIP_DATABASE}/lockfile-extension"

# Stage the pack in a sibling temp dir inside the database directory (same
# filesystem as the final location) so the final `mv` is an atomic rename, and
# only publish a complete pack on success -- a failure part-way through never
# leaves a half-written pack dir (e.g. an `ext/` with no `qlpack.yml`) that would
# break `--additional-packs`.
STAGE_DIR="$(mktemp -d "${CODEQL_EXTRACTOR_ACTIONS_WIP_DATABASE}/lockfile-extension.XXXXXX")"
trap 'rm -rf "${STAGE_DIR}"' EXIT
mkdir -p "${STAGE_DIR}/ext"

# Resolve the generator: prefer a prebuilt binary shipped with the extractor;
# otherwise build from source with the Go toolchain if it is available.
GEN_BIN="${GEN_DIR}/bin/lockfile-extension-generator"
RUN_GENERATOR=""
if [ -x "${GEN_BIN}" ]; then
    RUN_GENERATOR="${GEN_BIN}"
elif command -v go >/dev/null 2>&1; then
    BUILT_BIN="${STAGE_DIR}/lockfile-extension-generator"
    echo "Building lockfile-extension-generator from source with 'go build'."
    ( cd "${GEN_DIR}" && go build -o "${BUILT_BIN}" . )
    RUN_GENERATOR="${BUILT_BIN}"
else
    echo "No lockfile-extension-generator binary and no Go toolchain; skipping lockfile-pinned extension." >&2
    exit 0
fi

"${RUN_GENERATOR}" "${SRC_ROOT}" "${STAGE_DIR}/ext/pinned_by_lockfile.model.yml"

cat > "${STAGE_DIR}/qlpack.yml" <<'EOF'
name: codeql/actions-lockfile-pins
version: 0.0.1
library: true
warnOnImplicitThis: true
# Generated per-database from the repository's Actions lockfile by the Actions
# extractor. Apply it at analysis time with `--model-packs
# codeql/actions-lockfile-pins` (and `--additional-packs <db>/lockfile-extension`).
extensionTargets:
  codeql/actions-all: "*"
dataExtensions:
  - ext/*.model.yml
EOF

# Publish atomically: the pack only appears in the database once fully written.
rm -f "${STAGE_DIR}/lockfile-extension-generator"
rm -rf "${PACK_DIR}"
mv "${STAGE_DIR}" "${PACK_DIR}"
trap - EXIT

echo "Wrote lockfile-pinned data extension to '${PACK_DIR}'."
