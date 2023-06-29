---
category: deprecated
---
* The `codeql.ruby.typetracking.TypeTracker` library has been renamed to `codeql.ruby.dataflow.TypeTracker`.
  Additionally, the `TypeTracker` and `TypeBackTracker` classes can now be accessed as `DataFlow::TypeTracker`
  and `DataFlow::TypeBackTracker`, respectively, meaning an import is usually not required to use them.
