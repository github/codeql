## 2.1.0

### New Features

* Added a new predicate `DataFlow::getARuntimeTarget` for getting a function that may be invoked by a `Call` expression. Unlike `Call.getTarget` this new predicate may also resolve function pointers.
* Added the predicate `mayBeFromImplicitlyDeclaredFunction()` to the `Call` class to represent calls that may be the return value of an implicitly declared C function.
* Added the predicate `getAnExplicitDeclarationEntry()` to the `Function` class to get a `FunctionDeclarationEntry` that is not implicit.
* Added classes `RequiresExpr`, `SimpleRequirementExpr`, `TypeRequirementExpr`, `CompoundRequirementExpr`, and `NestedRequirementExpr` to represent C++20 requires expressions and the simple, type, compound, and nested requirements that can occur in `requires` expressions.

### Minor Analysis Improvements

* The function call target resolution algorithm has been improved to resolve more calls through function pointers. As a result, dataflow queries may have more results.
