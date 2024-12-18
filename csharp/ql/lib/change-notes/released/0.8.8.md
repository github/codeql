## 0.8.8

### Minor Analysis Improvements

* Added a new database relation to store compiler arguments specified inside `@[...].rsp` file arguments. The arguments
are returned by `Compilation::getExpandedArgument/1` and `Compilation::getExpandedArguments/0`.
* C# 12: Added extractor, QL library and data flow support for collection expressions like `[1, y, 4, .. x]`.
* The C# extractor now accepts an extractor option `logging.verbosity` that specifies the verbosity of the logs. The
option is added via `codeql database create --language=csharp -Ologging.verbosity=debug ...` or by setting the
corresponding environment variable `CODEQL_EXTRACTOR_CSHARP_OPTION_LOGGING_VERBOSITY`.
