[[ condition: enterprise-only ]]

# Improvements to Go analysis

## Changes to code extraction

* The autobuilder now runs Makefiles or custom build scripts present in the codebase to install dependencies. The build command
  to invoke can be configured via `lgtm.yml`, or by setting the environment variable `CODEQL_EXTRACTOR_GO_BUILD_COMMAND`.
* The autobuilder now attempts to automatically detect when dependencies have been vendored and use `-mod=vendor` appropriately.
* The extractor now supports extracting go.mod files, enabling queries on dependencies and their versions.
* The extractor now supports Go 1.14.
