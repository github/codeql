#!/bin/bash

set -eu

# Build script for macOS (ARM64)
# Usage:
#   ./build-macos.sh -cil -cliFolder /path/to/cli    # Build CIL extractor
#   ./build-macos.sh -cil -clean                      # Clean CIL build artifacts
#   ./build-macos.sh -cil -init -cliFolder /path/to/cli  # Initialize and build CIL
#
# Future: x86 extractor support will be added

# Defensive script directory detection
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [[ -n "${0:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
else
  echo "Error: Unable to determine script directory"
  exit 1
fi

if [[ -z "${SCRIPT_DIR}" || "${SCRIPT_DIR}" != /* ]]; then
  echo "Error: Failed to determine absolute script directory"
  exit 1
fi

# Verify we're in the expected directory by checking for a known file
if [[ ! -f "${SCRIPT_DIR}/build-win64.ps1" ]]; then
  echo "Error: Script directory validation failed - expected files not found"
  echo "SCRIPT_DIR: ${SCRIPT_DIR}"
  exit 1
fi

# Parse arguments
BUILD_CIL=false
BUILD_X86=false
CLEAN=false
INIT=false
CLI_FOLDER=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -cil)
      BUILD_CIL=true
      shift
      ;;
    -x86)
      BUILD_X86=true
      shift
      ;;
    -clean)
      CLEAN=true
      shift
      ;;
    -init)
      INIT=true
      shift
      ;;
    -cliFolder)
      CLI_FOLDER="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [-cil|-x86] [-clean|-init] [-cliFolder <path>]"
      exit 1
      ;;
  esac
done

# If no extractor specified, show usage
if [[ "$BUILD_CIL" == false && "$BUILD_X86" == false ]]; then
  echo "Usage: $0 [-cil|-x86] [-clean|-init] [-cliFolder <path>]"
  echo ""
  echo "Options:"
  echo "  -cil        Build the CIL (C# IL) extractor"
  echo "  -x86        Build the x86 extractor (not yet implemented)"
  echo "  -clean      Clean build artifacts"
  echo "  -init       Initialize dependencies (x86 only)"
  echo "  -cliFolder  Path to the CodeQL CLI folder (required for build)"
  exit 1
fi

# Validate arguments
if [[ "$CLEAN" == false && -z "$CLI_FOLDER" ]]; then
  echo "Error: -cliFolder is required unless -clean is specified"
  exit 1
fi

build_cil() {
  local tools_folder="${CLI_FOLDER}/cil/tools/osx64"
  local cil_folder="${CLI_FOLDER}/cil"

  pushd "${SCRIPT_DIR}/extractor/cil" > /dev/null

  dotnet build Semmle.Extraction.CSharp.IL -o "${tools_folder}" -c Release --self-contained
  if [[ $? -ne 0 ]]; then
    echo "Build failed"
    popd > /dev/null
    exit 1
  fi

  popd > /dev/null

  # Create directories
  mkdir -p "${tools_folder}"
  mkdir -p "${cil_folder}"

  # Copy extractor configuration
  cp "${SCRIPT_DIR}/extractor/cil/codeql-extractor.yml" "${cil_folder}/"

  # Copy downgrades if they exist
  if [[ -d "${SCRIPT_DIR}/downgrades" ]]; then
    cp -r "${SCRIPT_DIR}/downgrades" "${cil_folder}/"
  fi

  # Copy dbscheme files
  local ql_lib_folder="${SCRIPT_DIR}/ql/lib"
  cp "${ql_lib_folder}/semmlecode.binary.dbscheme" "${cil_folder}/"
  if [[ -f "${ql_lib_folder}/semmlecode.binary.dbscheme.stats" ]]; then
    cp "${ql_lib_folder}/semmlecode.binary.dbscheme.stats" "${cil_folder}/"
  fi

  # Copy tool scripts
  mkdir -p "${cil_folder}/tools"
  cp "${SCRIPT_DIR}/tools/cil/"* "${cil_folder}/tools/"
  chmod +x "${cil_folder}/tools/"*.sh

  echo "CIL extractor built successfully to ${cil_folder}"
}

clean_cil() {
  echo "Cleaning CIL build artifacts..."
  
  local bin_dir="${SCRIPT_DIR}/extractor/cil/Semmle.Extraction.CSharp.IL/bin"
  local obj_dir="${SCRIPT_DIR}/extractor/cil/Semmle.Extraction.CSharp.IL/obj"

  [[ -d "${bin_dir}" ]] && rm -rf "${bin_dir}"
  [[ -d "${obj_dir}" ]] && rm -rf "${obj_dir}"

  echo "CIL clean complete"
}

build_x86() {
  echo "x86 extractor build for macOS is not yet implemented"
  echo "This will require:"
  echo "  - LIEF library (build with cmake/make)"
  echo "  - Zydis library (build with cmake/make)"
  echo "  - fmt library"
  echo "  - Boost headers"
  echo "  - args library"
  echo "  - clang++ compiler"
  exit 1
}

clean_x86() {
  echo "Cleaning x86 build artifacts..."
  
  local x86_dir="${SCRIPT_DIR}/extractor/x86"

  [[ -d "${x86_dir}/args" ]] && rm -rf "${x86_dir}/args"
  [[ -d "${x86_dir}/boost-minimal" ]] && rm -rf "${x86_dir}/boost-minimal"
  [[ -d "${x86_dir}/fmt" ]] && rm -rf "${x86_dir}/fmt"
  [[ -d "${x86_dir}/LIEF" ]] && rm -rf "${x86_dir}/LIEF"
  [[ -d "${x86_dir}/zydis" ]] && rm -rf "${x86_dir}/zydis"
  [[ -f "${x86_dir}/extractor" ]] && rm -f "${x86_dir}/extractor"
  [[ -f "${x86_dir}/main.o" ]] && rm -f "${x86_dir}/main.o"

  echo "x86 clean complete"
}

init_x86() {
  echo "x86 extractor initialization for macOS is not yet implemented"
  exit 1
}

# Execute requested builds
if [[ "$BUILD_CIL" == true ]]; then
  if [[ "$CLEAN" == true ]]; then
    clean_cil
  else
    build_cil
  fi
fi

if [[ "$BUILD_X86" == true ]]; then
  if [[ "$CLEAN" == true ]]; then
    clean_x86
  elif [[ "$INIT" == true ]]; then
    init_x86
  else
    build_x86
  fi
fi
