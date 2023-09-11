## 0.2.3

### Major Analysis Improvements

* Added `DataFlow::CollectionContent`, which will enable more accurate flow through collections.

### Minor Analysis Improvements

* Added local flow sources for `UITextInput` and related classes.
* Flow through forced optional unwrapping (`!`) on the left side of assignment now works in most cases.
* `Type.getName` now gets the name of the type alone without any enclosing types. Use `Type.getFullName` for the old behaviour.

## 0.2.2

### Major Analysis Improvements

* Added `DataFlow::ArrayContent`, which will provide more accurate flow through arrays.

### Minor Analysis Improvements

* Flow through forced optional unwrapping (`!`) is modelled more accurately.
* Added flow models for `Sequence.withContiguousStorageIfAvailable`.
* Added taint flow for `NSUserActivity.referrerURL`.

## 0.2.1

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* The regular expression library now understands mode flags specified by `Regex` methods and the `NSRegularExpression` initializer.
* The regular expression library now understands mode flags specified at the beginning of a regular expression (for example `(?is)`).
* Added detail to the taint model for `URL`.
* Added new heuristics to `SensitiveExprs.qll`, enhancing detection from the library.

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
