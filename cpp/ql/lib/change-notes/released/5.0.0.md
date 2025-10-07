## 5.0.0

### Breaking Changes

* Deleted the deprecated `userInputArgument` predicate and its convenience accessor from the `Security.qll`.
* Deleted the deprecated `userInputReturned` predicate and its convenience accessor from the `Security.qll`.
* Deleted the deprecated `userInputReturn` predicate from the `Security.qll`.
* Deleted the deprecated `isUserInput` predicate and its convenience accessor from the `Security.qll`.
* Deleted the deprecated `userInputArgument` predicate from the `SecurityOptions.qll`.
* Deleted the deprecated `userInputReturned` predicate from the `SecurityOptions.qll`.

### New Features

* Added local flow source models for `ReadFile`, `ReadFileEx`, `MapViewOfFile`, `MapViewOfFile2`, `MapViewOfFile3`, `MapViewOfFile3FromApp`, `MapViewOfFileEx`, `MapViewOfFileFromApp`, `MapViewOfFileNuma2`, and `NtReadFile`.
* Added the `pCmdLine` arguments of `WinMain` and `wWinMain` as local flow sources.
* Added source models for `GetCommandLineA`, `GetCommandLineW`, `GetEnvironmentStringsA`, `GetEnvironmentStringsW`, `GetEnvironmentVariableA`, and `GetEnvironmentVariableW`.
* Added summary models for `CommandLineToArgvA` and `CommandLineToArgvW`.
* Added support for `wmain` as part of the ArgvSource model.

### Bug Fixes

* Fixed a problem where `asExpr()` on `DataFlow::Node` would never return `ArrayAggregateLiteral`s.
* Fixed a problem where `asExpr()` on `DataFlow::Node` would never return `ClassAggregateLiteral`s.
