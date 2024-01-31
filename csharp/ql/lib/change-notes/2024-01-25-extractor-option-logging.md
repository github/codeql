---
category: minorAnalysis
---
* The C# extractor now accepts an extractor option `logging.verbosity` that specifies the verbosity of the logs. The
option is added via `codeql database create --language=csharp -Ologging.verbosity=debug ...` or by setting the
corresponding environment variable `CODEQL_EXTRACTOR_CSHARP_OPTION_LOGGING_VERBOSITY`.