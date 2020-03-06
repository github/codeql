[[ condition: enterprise-only ]]

# Improvements to Go analysis

## Changes to code extraction

* The autobuilder now runs Makefiles or custom build scripts present in the codebase to install dependencies.
* The extractor now supports extracting go.mod files, enabling queries on dependencies and their versions.
