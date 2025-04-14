## 2.0.0

### Breaking Changes

* Deleted many deprecated taint-tracking configurations based on `TaintTracking::Configuration`. 
* Deleted many deprecated dataflow configurations based on `DataFlow::Configuration`. 
* Deleted the deprecated `hasQualifiedName` and `isDefined` predicates from the `Declaration` class, use `hasGlobalName` and `hasDefinition` respectively instead.
* Deleted the `getFullSignature` predicate from the `Function` class, use `getIdentityString(Declaration)` from `semmle.code.cpp.Print` instead.
* Deleted the deprecated `freeCall` predicate from `Alloc.qll`. Use `DeallocationExpr` instead.
* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
* Deleted the deprecated `getFieldExpr` predicate from `ClassAggregateLiteral`, use `getAFieldExpr` instead.
* Deleted the deprecated `getElementExpr` predicate from `ArrayOrVectorAggregateLiteral`, use `getAnElementExpr` instead.

### New Features

* Added a class `C11GenericExpr` to represent C11 generic selection expressions. The generic selection is represented as a `Conversion` on the expression that will be selected.
* Added subclasses of `BuiltInOperations` for the `__is_scoped_enum`, `__is_trivially_equality_comparable`, and `__is_trivially_relocatable` builtin operations.
* Added a subclass of `Expr` for `__datasizeof` expressions.

### Minor Analysis Improvements

* Added a data flow model for `swap` member functions, which were previously modeled as taint tracking functions. This change improves the precision of queries where flow through `swap` member functions might affect the results.
* Added a data flow model for `realloc`-like functions, which were previously modeled as a taint tracking functions. This change improves the precision of queries where flow through `realloc`-like functions might affect the results.
