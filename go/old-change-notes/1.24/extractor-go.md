[[ condition: enterprise-only ]]

# Improvements to Go analysis

## Improvements to the autobuilder

* When Makefiles or custom build scripts are present in the codebase, the autobuilder uses them to install dependencies. The build command
  to invoke can be configured via `lgtm.yml`, or by setting the environment variable `CODEQL_EXTRACTOR_GO_BUILD_COMMAND`.
* The autobuilder now attempts to automatically detect when dependencies have been vendored and use `-mod=vendor` appropriately.

## Changes to code extraction

* The extractor now supports Go 1.14.
* In resource-constrained environments, the environment variable `CODEQL_EXTRACTOR_GO_MAX_GOROUTINES` can be used to limit the
  number of parallel goroutines started by the extractor, which reduces CPU and memory requirements. The default value for this
  variable is 32.
* The extractor now uses buffered i/o for writing database files, which reduces the amount of time taken for extraction.
* The extractor now compresses intermediate files used for constructing databases, which reduces the amount of disk space it requires.
* The extractor now supports extracting `go.mod` files, enabling queries on dependencies and their versions.
