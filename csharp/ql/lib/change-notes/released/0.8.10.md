## 0.8.10

### Major Analysis Improvements

* Improved support for flow through captured variables that properly adheres to inter-procedural control flow.
* We no longer make use of CodeQL database stats, which may affect join-orders in custom queries. It is therefore recommended to test performance of custom queries after upgrading to this version.

### Minor Analysis Improvements

* C# 12: Add QL library support (`ExperimentalAttribute`) for the experimental attribute.
* C# 12: Add extractor and QL library support for `ref readonly` parameters.
* C#: The table `expr_compiler_generated` has been deleted and its content has been added to `compiler_generated`.
* Data flow via get only properties like `public object Obj { get; }` is now captured by the data flow library.
