lgtm,codescanning
* The Go extractor now supports build tracing, allowing users to supply a build command when
  creating databases with the CodeQL CLI or via configuration. It currently only supports projects
  that use Go modules. To opt-in, set the environment variable `CODEQL_EXTRACTOR_GO_BUILD_TRACING`
  to `on`, or supply a build command.
