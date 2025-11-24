## 5.0.2

### Bug Fixes

* Some fixes relating to use of path transformers when extracting a database:
  * Fixed a problem where the path transformer would be ignored when extracting older codebases that predate the use of Go modules.
  * The environment variable `CODEQL_PATH_TRANSFORMER` is now recognized, in addition to `SEMMLE_PATH_TRANSFORMER`.
  * Fixed some cases where the extractor emitted paths without applying the path transformer.
