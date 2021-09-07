#! /bin/bash
set -xe

echo "Check installed CodeQL version"
CURRENT_CODEQL_BIN=$(readlink -e /usr/local/bin/codeql || echo "")
LATEST=$(gh release list --repo https://github.com/github/codeql-cli-binaries | cut -f 1 | grep -v beta | sort --version-sort | tail -1)

BASE_DIR=/home/vscode/codeql-binaries
mkdir -p "${BASE_DIR}"
LATEST_CODEQL_DIR="${BASE_DIR}/codeql-${LATEST}"
LATEST_CODEQL_BIN="${LATEST_CODEQL_DIR}/codeql/codeql"

if [ "${CURRENT_CODEQL_BIN}" != "${LATEST_CODEQL_BIN}" ]; then
  echo "Installing CodeQL ${LATEST}"
  TMPDIR=$(mktemp -d -p "$(dirname ${LATEST_CODEQL_DIR})")
  gh release download --repo https://github.com/github/codeql-cli-binaries --pattern codeql-linux64.zip -D "${TMPDIR}" "$LATEST" 
  unzip -oq "${TMPDIR}/codeql-linux64.zip" -d "${TMPDIR}"
  rm -f "${TMPDIR}/codeql-linux64.zip"
  mv "${TMPDIR}" "${LATEST_CODEQL_DIR}"
  test -x "${LATEST_CODEQL_BIN}" && sudo ln -sf "${LATEST_CODEQL_BIN}" /usr/local/bin/codeql
  if [[ "${CURRENT_CODEQL_BIN}" =~ .*/codeql/codeql ]]; then
    rm -rf "$(dirname $(dirname ${CURRENT_CODEQL_BIN}))"
  fi
fi

echo "Build the Ruby extractor"

# clone the git dependencies using "git clone" because cargo's builtin git support is rather slow
REPO_DIR="${CARGO_HOME:-/home/vscode/.cargo}/git/db" 
REPO_DIR_ERB="${REPO_DIR}/tree-sitter-embedded-template-4c796e3340c233b6"
REPO_DIR_RUBY="${REPO_DIR}/tree-sitter-ruby-666a40ce046f8e7a"

mkdir -p "${REPO_DIR}"
test -e "${REPO_DIR_ERB}" || git clone -q --bare https://github.com/tree-sitter/tree-sitter-embedded-template "${REPO_DIR_ERB}"
test -e "${REPO_DIR_RUBY}" || git clone -q --bare https://github.com/tree-sitter/tree-sitter-ruby.git "${REPO_DIR_RUBY}"

scripts/create-extractor-pack.sh
