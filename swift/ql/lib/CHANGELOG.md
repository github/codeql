## 0.3.1

### Minor Analysis Improvements

* Improved taint models for `Numeric` types and `RangeReplaceableCollection`s.
* The nil-coalescing operator `??` is now supported by the CFG construction and dataflow libraries.
* The data flow library now supports flow to the loop variable of for-in loops.
* The methods `getIteratorVar` and `getNextCall` have been added to the `ForEachStmt` class.

## 0.3.0

### Deprecated APIs

* The `ArrayContent` type in the data flow library has been deprecated and made an alias for the `CollectionContent` type, to better reflect the hierarchy of the Swift standard library. Uses of `ArrayElement` in model files will be interpreted as referring to `CollectionContent`.

### Major Analysis Improvements

* The predicates `getABaseType`, `getABaseTypeDecl`, `getADerivedType` and `getADerivedTypeDecl` on `Type` and `TypeDecl` now behave more usefully and consistently. They now explore through type aliases used in base class declarations, and include protocols added in extensions.

To examine base class declarations at a low level without these enhancements, use `TypeDecl.getInheritedType`.

`Type.getABaseType` (only) previously resolved a type alias it was called directly on. This behaviour no longer exists. To find any base type of a type that could be an alias, the construct `Type.getUnderlyingType().getABaseType*()` is recommended.

### Minor Analysis Improvements

* Modelled varargs function in `NSString` more accurately.
* Modelled `CustomStringConvertible.description` and `CustomDebugStringConvertible.debugDescription`, replacing ad-hoc models of these properties on derived classes.
* The regular expressions library now accepts a wider range of mode flags in a regular expression mode flag group (such as `(?u)`). The `(?w`) flag has been renamed from "UNICODE" to "UNICODEBOUNDARY", and the `(?u)` flag is called "UNICODE" in the libraries.
* Renamed `TypeDecl.getBaseType/1` to `getInheritedType`.
* Flow through writes via keypaths is now supported by the data flow library.
* Added flow through variadic arguments, and the `getVaList` function.
* Added flow steps through `Dictionary` keys and values.
* Added taint models for `Numeric` conversions.

### Bug Fixes

* The regular expressions library no longer incorrectly matches mode flag characters against the input.

## 0.2.5

No user-facing changes.

## 0.2.4

### Minor Analysis Improvements

* Flow through optional chaining and forced unwrapping in keypaths is now supported by the data flow library.
* Added flow models of collection `.withContiguous[Mutable]StorageIfAvailable`, `.withUnsafe[Mutable]BufferPointer` and `.withUnsafe[Mutable]Bytes` methods.

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
