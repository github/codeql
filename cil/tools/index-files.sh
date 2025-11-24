#!/bin/bash

set -eu

if [[ -z "${CODEQL_EXTRACTOR_CSHARPIL_ROOT:-}" ]]; then
  export CODEQL_EXTRACTOR_CSHARPIL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

# Get the trap directory from CodeQL environment
TRAP_DIR="${CODEQL_EXTRACTOR_CSHARPIL_TRAP_DIR}"
SRC_ARCHIVE="${CODEQL_EXTRACTOR_CSHARPIL_SOURCE_ARCHIVE_DIR}"

echo "C# IL Extractor: Starting extraction"
echo "Source root: $(pwd)"
echo "TRAP directory: ${TRAP_DIR}"

# Ensure TRAP directory exists
mkdir -p "${TRAP_DIR}"

# Find all DLL and EXE files in the source root
EXTRACTOR_PATH="${CODEQL_EXTRACTOR_CSHARPIL_ROOT}/extractor/Semmle.Extraction.CSharp.IL/bin/Debug/net8.0/Semmle.Extraction.CSharp.IL"

if [[ ! -f "${EXTRACTOR_PATH}" ]]; then
  echo "ERROR: Extractor not found at ${EXTRACTOR_PATH}"
  echo "Please build the extractor first with: dotnet build extractor/Semmle.Extraction.CSharp.IL"
  exit 1
fi

# Extract all DLL and EXE files
FILE_COUNT=0
find . -type f \( -name "*.dll" -o -name "*.exe" \) | while read -r assembly; do
  echo "Extracting: ${assembly}"
  
  # Normalize the assembly path (remove leading ./)
  normalized_path="${assembly#./}"
  
  # Create a unique trap file name based on the assembly path
  TRAP_FILE="${TRAP_DIR}/$(echo "${assembly}" | sed 's/[^a-zA-Z0-9]/_/g').trap"
  
  # Run the extractor
  "${EXTRACTOR_PATH}" "${assembly}" "${TRAP_FILE}" || echo "Warning: Failed to extract ${assembly}"
  
  # Copy the assembly to the source archive
  ARCHIVE_PATH="${SRC_ARCHIVE}/${normalized_path}"
  ARCHIVE_DIR="$(dirname "${ARCHIVE_PATH}")"
  mkdir -p "${ARCHIVE_DIR}"
  cp "${assembly}" "${ARCHIVE_PATH}"
  echo "Archived: ${assembly} -> ${ARCHIVE_PATH}"
  
  FILE_COUNT=$((FILE_COUNT + 1))
done

echo "C# IL Extractor: Completed extraction of ${FILE_COUNT} assemblies"
