#!/usr/bin/env bash
# Upgrades the ferstl-depgraph-dependencies bundle used by the buildless Java extractor.
#
# This script:
#   1. Clones ferstl/depgraph-maven-plugin at the upstream 4.0.3 tag.
#   2. Applies the CodeQL patches: version suffix, Guava bump, Jackson bump.
#   3. Builds the plugin (skipping tests) into a throwaway build repo.
#   4. Resolves only the plugin's runtime deps into a clean dist repo and zips it.
#   5. Updates the *.expected integration-test files in this directory.
#
# The generated zip file must be placed (in the companion semmle-code PR) at:
#   resources/lib/ferstl-depgraph-dependencies/ferstl-depgraph-dependencies.zip
#
# Usage:
#   ./update-ferstl-depgraph-dependencies.sh [JACKSON_VERSION [GUAVA_VERSION]]
#
# Output:
#   ferstl-depgraph-dependencies.zip  (written to the current working directory)
#
# Defaults:
#   JACKSON_VERSION = 2.18.6
#   GUAVA_VERSION   = 33.4.0-jre
#
# Requirements:
#   - JDK 17 (or JDK 11+; the plugin targets Java 8+)
#   - Maven 3.9.x  (do NOT use Maven 4.x)
#   - git, python3, zip, sha1sum (or shasum on macOS)

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
JACKSON_VERSION="${1:-2.18.6}"
GUAVA_VERSION="${2:-33.4.0-jre}"

PLUGIN_UPSTREAM_VERSION="4.0.3"
PLUGIN_CODEQL_VERSION="${PLUGIN_UPSTREAM_VERSION}-CodeQL-2"
UPSTREAM_TAG="depgraph-maven-plugin-${PLUGIN_UPSTREAM_VERSION}"
UPSTREAM_REPO="https://github.com/ferstl/depgraph-maven-plugin.git"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$(mktemp -d)"
# The zip is written to the caller's working directory so the cleanup trap can
# safely remove the entire temporary work tree.
ZIP_OUT="$(pwd)/ferstl-depgraph-dependencies.zip"
trap 'rm -rf "${WORK_DIR}"' EXIT

echo "=== ferstl-depgraph-dependencies update ==="
echo "  Jackson:        ${JACKSON_VERSION}"
echo "  Guava:          ${GUAVA_VERSION}"
echo "  Plugin version: ${PLUGIN_CODEQL_VERSION}"
echo "  Work dir:       ${WORK_DIR}"
echo ""

# ---------------------------------------------------------------------------
# Step 1 — Clone plugin source
# ---------------------------------------------------------------------------
echo "[1/5] Cloning ${UPSTREAM_REPO} at tag ${UPSTREAM_TAG} ..."
git clone --depth=1 --branch "${UPSTREAM_TAG}" "${UPSTREAM_REPO}" "${WORK_DIR}/plugin-src"

# ---------------------------------------------------------------------------
# Step 2 — Patch pom.xml
# ---------------------------------------------------------------------------
echo "[2/5] Patching pom.xml ..."
python3 - \
    "${WORK_DIR}/plugin-src/pom.xml" \
    "${PLUGIN_UPSTREAM_VERSION}" \
    "${PLUGIN_CODEQL_VERSION}" \
    "${GUAVA_VERSION}" \
    "${JACKSON_VERSION}" << 'PYEOF'
import sys

pom_path, old_version, new_version, new_guava, new_jackson = sys.argv[1:]

with open(pom_path) as f:
    content = f.read()

# 1. Version suffix: 4.0.3 -> 4.0.3-CodeQL-2  (first occurrence only — the <version> element)
content = content.replace(f'<version>{old_version}</version>', f'<version>{new_version}</version>', 1)

# 2. Guava
content = content.replace('<version>31.1-jre</version>', f'<version>{new_guava}</version>')

# 3. Jackson (jackson-databind drives the transitive jackson-core / jackson-annotations versions)
content = content.replace('<version>2.14.1</version>', f'<version>{new_jackson}</version>')

with open(pom_path, 'w') as f:
    f.write(content)

print(f'  pom.xml patched: version={new_version}, guava={new_guava}, jackson={new_jackson}')
PYEOF

# ---------------------------------------------------------------------------
# Step 3 — Build the plugin, then resolve its runtime deps into a clean repo
# ---------------------------------------------------------------------------
#
# Two separate local repos:
#
#   BUILD_REPO  Throwaway cache for the plugin's own `mvn package install` —
#               accumulates build-lifecycle plugins (compiler, surefire, jar,
#               plugin-plugin, etc.) that the extractor never invokes at
#               runtime.  Discarded after this step.
#
#   DIST_REPO   Clean repo seeded with the freshly built plugin, then
#               populated only with the plugin's runtime transitive deps by
#               invoking the :graph goal against a minimal stub project.
#               This is what gets zipped.
#
BUILD_REPO="${WORK_DIR}/build-repo"
DIST_REPO="${WORK_DIR}/dist-repo"

echo "[3/5] Building plugin (mvn package + install, skipping tests) ..."
cd "${WORK_DIR}/plugin-src"
mvn package install -DskipTests -q -Dmaven.repo.local="${BUILD_REPO}"

echo "      Resolving runtime dependencies into clean dist repo ..."

# Seed DIST_REPO with the freshly built plugin jar+pom so the :graph
# invocation below can resolve its transitive runtime deps without hitting
# Central for the plugin artifact itself.
PLUGIN_REL="com/github/ferstl/depgraph-maven-plugin/${PLUGIN_CODEQL_VERSION}"
mkdir -p "${DIST_REPO}/${PLUGIN_REL}"
cp "${BUILD_REPO}/${PLUGIN_REL}/depgraph-maven-plugin-${PLUGIN_CODEQL_VERSION}.jar" \
   "${BUILD_REPO}/${PLUGIN_REL}/depgraph-maven-plugin-${PLUGIN_CODEQL_VERSION}.pom" \
   "${DIST_REPO}/${PLUGIN_REL}/"

# Create a minimal stub project with no dependencies.  Using an empty project
# avoids polluting DIST_REPO with the stub's own deps (e.g. junit from the
# quickstart archetype).  The sole purpose of this project is to give Maven a
# valid reactor context in which to load and execute the plugin.
mkdir -p "${WORK_DIR}/stub-project"
cat > "${WORK_DIR}/stub-project/pom.xml" << 'STUBPOM'
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>stub</artifactId>
  <version>1.0-SNAPSHOT</version>
</project>
STUBPOM

cd "${WORK_DIR}/stub-project"
mvn -q "com.github.ferstl:depgraph-maven-plugin:${PLUGIN_CODEQL_VERSION}:graph" \
    -Dmaven.repo.local="${DIST_REPO}"

# ---------------------------------------------------------------------------
# Step 4 — Package local-repo zip
# ---------------------------------------------------------------------------
echo "[4/5] Packaging local Maven repo into zip ..."

# Remove build-time-only noise (but keep _remote.repositories for Maven
# cache-validation compatibility).
find "${DIST_REPO}" \( \
    -name "resolver-status.properties" \
    -o -name "*.lastUpdated" \
    -o -name "m2e-lastUpdated.properties" \
    \) -delete

# Add missing SHA-1 files (mvn install doesn't always write them for locally
# built artifacts; they are needed to suppress Maven checksum warnings).
if command -v sha1sum &>/dev/null; then
    SHA1_CMD="sha1sum"
elif command -v shasum &>/dev/null; then
    SHA1_CMD="shasum -a 1"
else
    echo "WARNING: Neither sha1sum nor shasum found; .sha1 files will not be generated." >&2
    SHA1_CMD=""
fi

if [[ -n "${SHA1_CMD}" ]]; then
    while IFS= read -r -d '' f; do
        if [[ ! -f "${f}.sha1" ]]; then
            ${SHA1_CMD} "${f}" | awk '{print $1}' > "${f}.sha1"
        fi
    done < <(find "${DIST_REPO}" \( -name "*.jar" -o -name "*.pom" \) -print0)
fi

(cd "${DIST_REPO}" && zip -r -q "${ZIP_OUT}" .)

echo ""
echo "  Zip created: ${ZIP_OUT}"
echo ""
echo "  *** Place this file in semmle-code at:"
echo "      resources/lib/ferstl-depgraph-dependencies/ferstl-depgraph-dependencies.zip"
echo ""

# ---------------------------------------------------------------------------
# Step 5 — Update integration-test *.expected files
# ---------------------------------------------------------------------------
echo "[5/5] Updating integration-test expected files ..."

# Discover versions currently recorded in the expected files so the script
# is idempotent and can be re-run after a partial update.
# Python is used for portability: grep -oP requires PCRE which is absent on
# macOS's BSD grep.
EXPECTED_FILE="${SCRIPT_DIR}/java/buildless-maven/maven-fetches.expected"

read -r OLD_JACKSON OLD_PLUGIN OLD_OSS_PARENT OLD_JACKSON_PARENT <<< "$(python3 - "${EXPECTED_FILE}" << 'PYEOF'
import sys, re

with open(sys.argv[1]) as f:
    content = f.read()

def extract(pattern):
    m = re.search(pattern, content)
    return m.group(1) if m else ''

print(
    extract(r'jackson-core/([^/]+)/'),
    extract(r'depgraph-maven-plugin/([^/]+)/'),
    extract(r'fasterxml/oss-parent/([^/]+)/'),
    extract(r'jackson-parent/([^/]+)/'),
)
PYEOF
)"

# Resolve new parent-pom versions from the artifacts Maven just resolved.
# Python is used for version-aware max() so that e.g. 2.18.10 sorts after
# 2.18.6 (lexicographic sort would get this wrong).
read -r NEW_JACKSON_PARENT NEW_OSS_PARENT <<< "$(python3 - \
    "${DIST_REPO}/com/fasterxml/jackson/jackson-parent" \
    "${DIST_REPO}/com/fasterxml/oss-parent" << 'PYEOF'
import sys, os, re

def max_version(directory, name_prefix, name_suffix):
    try:
        entries = os.listdir(directory)
    except FileNotFoundError:
        return ''
    versions = []
    for e in entries:
        pom = os.path.join(directory, e, f'{name_prefix}{e}{name_suffix}')
        if os.path.isfile(pom):
            versions.append(e)
    if not versions:
        return ''
    def version_key(v):
        parts = re.split(r'[.\-]', v)
        numeric = tuple(int(p) for p in parts if p.isdigit())
        # A release version (all-numeric parts) beats a snapshot/qualifier with
        # the same numeric prefix; append 1 for pure-release, 0 otherwise.
        is_release = int(all(p.isdigit() for p in parts if p))
        return (numeric, is_release)
    return max(versions, key=version_key)

jackson_parent_dir, oss_parent_dir = sys.argv[1], sys.argv[2]
print(
    max_version(jackson_parent_dir, 'jackson-parent-', '.pom'),
    max_version(oss_parent_dir,     'oss-parent-',     '.pom'),
)
PYEOF
)"

echo "  Jackson:        ${OLD_JACKSON} -> ${JACKSON_VERSION}"
echo "  jackson-parent: ${OLD_JACKSON_PARENT} -> ${NEW_JACKSON_PARENT}"
echo "  oss-parent:     ${OLD_OSS_PARENT} -> ${NEW_OSS_PARENT}"
echo "  Plugin:         ${OLD_PLUGIN} -> ${PLUGIN_CODEQL_VERSION}"

python3 - \
    "${SCRIPT_DIR}" \
    "${OLD_JACKSON}" "${JACKSON_VERSION}" \
    "${OLD_JACKSON_PARENT}" "${NEW_JACKSON_PARENT}" \
    "${OLD_OSS_PARENT}" "${NEW_OSS_PARENT}" \
    "${OLD_PLUGIN}" "${PLUGIN_CODEQL_VERSION}" << 'PYEOF'
import os, sys, glob

(script_dir,
 old_jackson, new_jackson,
 old_jackson_parent, new_jackson_parent,
 old_oss_parent, new_oss_parent,
 old_plugin, new_plugin) = sys.argv[1:]

# Substitutions applied to maven-fetches.expected files
fetch_substitutions = [
    (f"jackson-annotations/{old_jackson}/jackson-annotations-{old_jackson}",
     f"jackson-annotations/{new_jackson}/jackson-annotations-{new_jackson}"),
    (f"jackson-core/{old_jackson}/jackson-core-{old_jackson}",
     f"jackson-core/{new_jackson}/jackson-core-{new_jackson}"),
    (f"jackson-databind/{old_jackson}/jackson-databind-{old_jackson}",
     f"jackson-databind/{new_jackson}/jackson-databind-{new_jackson}"),
    (f"jackson-base/{old_jackson}/jackson-base-{old_jackson}",
     f"jackson-base/{new_jackson}/jackson-base-{new_jackson}"),
    (f"jackson-bom/{old_jackson}/jackson-bom-{old_jackson}",
     f"jackson-bom/{new_jackson}/jackson-bom-{new_jackson}"),
    (f"jackson-parent/{old_jackson_parent}/jackson-parent-{old_jackson_parent}.pom",
     f"jackson-parent/{new_jackson_parent}/jackson-parent-{new_jackson_parent}.pom"),
    (f"com/fasterxml/oss-parent/{old_oss_parent}/oss-parent-{old_oss_parent}.pom",
     f"com/fasterxml/oss-parent/{new_oss_parent}/oss-parent-{new_oss_parent}.pom"),
    (f"depgraph-maven-plugin/{old_plugin}/depgraph-maven-plugin-{old_plugin}.",
     f"depgraph-maven-plugin/{new_plugin}/depgraph-maven-plugin-{new_plugin}."),
]

# Substitutions applied to diagnostics.expected files
diagnostics_substitutions = [
    (f"depgraph-maven-plugin:{old_plugin}:graph",
     f"depgraph-maven-plugin:{new_plugin}:graph"),
]

def update(filepath, substitutions):
    with open(filepath) as f:
        content = f.read()
    updated = content
    for old, new in substitutions:
        updated = updated.replace(old, new)
    if updated != content:
        with open(filepath, 'w') as f:
            f.write(updated)
        print(f"  Updated: {os.path.relpath(filepath, script_dir)}")

for fp in glob.glob(os.path.join(script_dir, "java", "**", "maven-fetches.expected"), recursive=True):
    update(fp, fetch_substitutions)

for fp in glob.glob(os.path.join(script_dir, "java", "**", "diagnostics.expected"), recursive=True):
    update(fp, diagnostics_substitutions)

print("  Expected files updated.")
PYEOF

echo ""
echo "=== Update complete ==="
echo ""
echo "Next steps:"
echo "  1. Copy ${ZIP_OUT} -> semmle-code resources/lib/ferstl-depgraph-dependencies/ferstl-depgraph-dependencies.zip"
echo "  2. In semmle-code, update autobuild/src/com/semmle/util/build/Maven.java:"
echo "     bump the plugin version constant to '${PLUGIN_CODEQL_VERSION}'"
echo "  3. Commit and raise PRs in both repositories."
