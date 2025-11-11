## 0.1.19

### Major Analysis Improvements

* Resolution of calls to functions has been improved in a number of ways, to make it more aligned with the behavior of the Rust compiler. This may impact queries that rely on call resolution, such as data flow queries.
* Added basic models for the `actix-web` web framework.

### Minor Analysis Improvements

* Added `ExtractedFile::hasSemantics` and `ExtractedFile::isSkippedByCompilation` predicates.
* Generalized some existing models to improve data flow.
* Added models for the `mysql` and `mysql_async` libraries.
