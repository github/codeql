## 3.1.1

### Minor Analysis Improvements

* The sensitive data library has been improved so that `snake_case` style variable names are recognized more reliably. This may result in more sensitive data being identified, and more results from queries that use the sensitive data library.

## 3.1.0

### Major Analysis Improvements

* Upgraded to allow analysis of Swift 6.0.2.

## 3.0.0

### Breaking Changes

* Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

## 2.0.4

No user-facing changes.

## 2.0.3

No user-facing changes.

## 2.0.2

No user-facing changes.

## 2.0.1

### Minor Analysis Improvements

* All AST classes in `codeql.swift.elements` are now `final`, which means that it is no longer possible to `override` predicates defined in those classes (it is, however, still possible to `extend` the classes).

## 2.0.0

### Breaking Changes

* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
* Deleted the deprecated `getDerivedTypeDecl` predicate from the `TypeDecl` class, use `getADerivedTypeDecl` or `getABaseTypeDecl` instead.

## 1.1.3

No user-facing changes.

## 1.1.2

No user-facing changes.

## 1.1.1

### Minor Analysis Improvements

* The model for `FileManager` no longer considers methods that return paths on the file system as taint sources. This is because these sources have been found to produce results of low value.
* An error in the model for `URL.withUnsafeFileSystemRepresentation(_:)` has been corrected. This may result in new data flow paths being found during analysis.

## 1.1.0

### New Features

* Swift support is now out of beta, and generally available.

### Minor Analysis Improvements

* Additional heuristics for sensitive private information have been added to the `SensitiveExprs.qll` library, improving coverage for credit card and social security numbers. This may result in additional results for queries that use sensitive data such as `swift/cleartext-transmission`.

## 1.0.3

No user-facing changes.

## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

## 0.3.16

No user-facing changes.

## 0.3.15

No user-facing changes.

## 0.3.14

No user-facing changes.

## 0.3.13

### Major Analysis Improvements

* Upgraded to Swift 5.10
* New AST node is extracted: `ThenStmt`

## 0.3.12

No user-facing changes.

## 0.3.11

No user-facing changes.

## 0.3.10

### Bug Fixes

* Fixed an issue where `TypeDecl.getFullName` would get stuck in an loop and fail when minor database inconsistencies are present.

## 0.3.9

### Minor Analysis Improvements

* The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.

## 0.3.8

No user-facing changes.

## 0.3.7

### Minor Analysis Improvements

* Swift upgraded to 5.9.2
* The control flow graph library (`codeql.swift.controlflow`) has been transitioned to use the shared implementation from the `codeql/controlflow` qlpack. No result changes are expected due to this change.

## 0.3.6

### Minor Analysis Improvements

* Expanded flow models for `UnsafePointer` and similar classes.
* Added flow models for non-member `withUnsafePointer` and similar functions.
* Added flow models for `withMemoryRebound`, `assumingMemoryBound` and `bindMemory` member functions of library pointer classes.
* Added a sensitive data model for `SecKeyCopyExternalRepresentation`.
* Added imprecise flow models for `append` and `insert` methods, and initializer calls with a `data` argument.
* Tyes for patterns are now included in the database and made available through the `Pattern::getType()` method.

## 0.3.5

No user-facing changes.

## 0.3.4

### Minor Analysis Improvements

* Extracts Swift's `DiscardStmt` and `MaterizliePackExpr`
* Expanded and improved flow models for `Set` and `Sequence`.
* Added imprecise flow sources matching initializers such as `init(contentsOfFile:)`.
* Extracts `MacroDecl` and some related information

## 0.3.3

### Major Analysis Improvements

* Added Swift 5.9.1 support
* New AST node is extracted: `SingleValueStmtExpr`

### Minor Analysis Improvements

* AST and types related to parameter packs are now extracted
* Added taint flow models for the `NSString.enumerate*` methods.
* Generalized the data flow model for subscript writes (`a[index] = b`) so that it applies to subscripts on all kinds of objects, not just arrays.
* Fixed a bug where some flow sinks at field accesses were not being correctly identified.
* Added indexed `getVariable` to `CaptureListExpr`, improving its AST printing and data flow.
* Added flow models for `String` methods involving closures such as `String.withUTF8(_:)`.
* AST and types related to move semantics (`copy`, `consume`, `_borrow`) are now extracted

## 0.3.2

### Minor Analysis Improvements

* Improved support for flow through captured variables that properly adheres to inter-procedural control flow.
* Added children of `UnspecifiedElement`, which will be present only in certain downgraded databases.
* Collection content is now automatically read at taint flow sinks. This removes the need to define an `allowImplicitRead` predicate on data flow configurations where the sink might be an array, set or similar type with tainted contents. Where that step had not been defined, taint may find additional results now.
* Added taint models for `StringProtocol.appendingFormat` and `String.decodeCString`.
* Added taint flow models for members of `Substring`.
* Added taint flow models for `RawRepresentable`.
* The contents of autoclosure function parameters are now included in the control flow graph and data flow libraries.
* Added models of `StringProtocol` and `NSString` methods that evaluate regular expressions.
* Flow through 'open existential expressions', implicit expressions created by the compiler when a method is called on a protocol. This may apply, for example, when the method is a modelled taint source.

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
