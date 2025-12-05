#!/bin/bash

set -eu

# Get the extractor root directory
if [[ -z "${CODEQL_EXTRACTOR_CIL_ROOT:-}" ]]; then
  export CODEQL_EXTRACTOR_CIL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

# Get the trap directory from CodeQL environment
TRAP_DIR="${CODEQL_EXTRACTOR_CIL_TRAP_DIR}"
SRC_ARCHIVE="${CODEQL_EXTRACTOR_CIL_SOURCE_ARCHIVE_DIR}"

echo "C# IL Extractor: Starting extraction"
echo "Source root: $(pwd)"
echo "TRAP directory: ${TRAP_DIR}"
echo "Extractor root: ${CODEQL_EXTRACTOR_CIL_ROOT}"

# Ensure TRAP directory exists
mkdir -p "${TRAP_DIR}"
mkdir -p "${SRC_ARCHIVE}"

# Determine the platform-specific extractor path
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)
    PLATFORM_DIR="osx-arm64"
    ;;
  Darwin-x86_64)
    PLATFORM_DIR="osx-x64"
    ;;
  Linux-x86_64)
    PLATFORM_DIR="linux-x64"
    ;;
  *)
    PLATFORM_DIR="win64"
    ;;
esac

EXTRACTOR_DLL="${CODEQL_EXTRACTOR_CIL_ROOT}/tools/${PLATFORM_DIR}/Semmle.Extraction.CSharp.IL.dll"

if [[ ! -f "${EXTRACTOR_DLL}" ]]; then
  echo "ERROR: Extractor not found at ${EXTRACTOR_DLL}"
  exit 1
fi

# Create a temporary file list
FILE_LIST=$(mktemp)
trap "rm -f ${FILE_LIST}" EXIT

# Find all DLL and EXE files in the source root
find . -type f \( -name "*.dll" -o -name "*.exe" \) > "${FILE_LIST}"

FILE_COUNT=$(wc -l < "${FILE_LIST}" | tr -d ' ')
echo "Found ${FILE_COUNT} assemblies to extract"

if [[ "${FILE_COUNT}" -gt 0 ]]; then
  # Run the extractor with the file list
  dotnet "${EXTRACTOR_DLL}" "${FILE_LIST}"
fi

echo "C# IL Extractor: Completed extraction"
