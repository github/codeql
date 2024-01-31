---
category: minorAnalysis
---
* Added a new database relation to store compiler arguments specified inside `@[...].rsp` file arguments. The arguments
are returned by `Compilation::getExpandedArgument/1` and `Compilation::getExpandedArguments/0`.
