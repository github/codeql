## 0.8.7

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `SSL`, `XML`, `URI`, `SSA` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getALocalFlowSucc` predicate and `TaintType` class from the dataflow library.
* Deleted the deprecated `Newobj` and `Rethrow` classes, use `NewObj` and `ReThrow` instead.
* Deleted the deprecated `getAFirstRead`, `hasAdjacentReads`, `lastRefBeforeRedef`, and `hasLastInputRef` predicates from the SSA library.
* Deleted the deprecated `getAReachableRead` predicate from the `AssignableRead` and `VariableRead` classes.
* Deleted the deprecated `hasQualifiedName` predicate from the `NamedElement` class.
* C# 12: Add extractor support and QL library support for inline arrays.
* Fixed a Log forging false positive when logging the value of a nullable simple type. This fix also applies to all other queries that use the simple type sanitizer.
* The diagnostic query `cs/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned C# files, now considers any C# file seen during extraction, even one with some errors, to be extracted / scanned.
* Added a new library `semmle.code.csharp.security.dataflow.flowsources.FlowSources`, which provides a new class `ThreatModelFlowSource`. The `ThreatModelFlowSource` class can be used to include sources which match the current *threat model* configuration.
* A manual neutral summary model for a callable now blocks all generated summary models for that callable from having any effect.
* C# 12: Add extractor support for lambda expressions with parameter defaults like `(int x, int y = 1) => ...` and lambda expressions with a `param` parameter like `(params int[] x) => ...)`.
