## 0.2.0

### Breaking Changes

* The `BraceStmt` AST node's `AstNode getElement(index)` member predicate no longer returns `VarDecl`s after the `PatternBindingDecl` that declares them. Instead, a new `VarDecl getVariable(index)` predicate has been introduced for accessing the variables declared in a `BraceStmt`.

### New Features

* Added new libraries `Regex.qll` and `RegexTreeView.qll` for reasoning about regular expressions
in Swift code and places where they are evaluated.

### Minor Analysis Improvements

* Added a data flow model for `swap(_:_:)`.

## 0.1.2

No user-facing changes.

## 0.1.1

### Major Analysis Improvements

* Incorporated the cross-language `SensitiveDataHeuristics.qll` heuristics library into the Swift `SensitiveExprs.qll` library. This adds a number of new heuristics enhancing detection from the library.

### Minor Analysis Improvements

* Some models for the `Data` class have been generalized to `DataProtocol` so that they apply more widely.

### Bug Fixes

* Fixed a number of inconsistencies in the abstract syntax tree (AST) and in the control-flow graph (CFG). This may lead to more results in queries that use these libraries, or libraries that depend on them (such as dataflow).
