# Powershell Extractor

## Directories:
- `extractor`
  - Powershell extractor source code
- `ql`
  - QL libraries and queries for Powershell (to be written)
- `tools`
  - Directory containing files that must be copied to powershell/tools in the directory containing the CodeQL CLI. This will be done automatically by `build.ps1` (see below).

## How to build the Powershell:
- Run `build.ps1 path-to-codeql-cli-folder` where `path-to-codeql-cli-folder` is the path to the folder containing the CodeQL CLI (i.e., `codeql.exe`).