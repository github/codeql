## 0.3.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* Added support for getting the link targets of global and namespace variables.
* Added a `BlockAssignExpr` class, which models a `memcpy`-like operation used in compiler generated copy/move constructors and assignment operations.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.3.3

### New Features

* Added a predicate `getValueConstant` to `AttributeArgument` that yields the argument value as an `Expr` when the value is a constant expression.
* A new class predicate `MustFlowConfiguration::allowInterproceduralFlow` has been added to the `semmle.code.cpp.ir.dataflow.MustFlow` library. The new predicate can be overridden to disable interprocedural flow.
* Added subclasses of `BuiltInOperations` for `__builtin_bit_cast`, `__builtin_shuffle`, `__has_unique_object_representations`, `__is_aggregate`, and `__is_assignable`.

### Major Analysis Improvements

* The IR dataflow library now includes flow through global variables. This enables new findings in many scenarios.

## 0.3.2

### Bug Fixes

* Under certain circumstances a variable declaration that is not also a definition could be associated with a `Variable` that did not have the definition as a `VariableDeclarationEntry`. This is now fixed, and a unique `Variable` will exist that has both the declaration and the definition as a `VariableDeclarationEntry`.

## 0.3.1

### Minor Analysis Improvements

* `AnalysedExpr::isNullCheck` and `AnalysedExpr::isValidCheck` have been updated to handle variable accesses on the left-hand side of the C++ logical "and", and variable declarations in conditions.

## 0.3.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

### Bug Fixes

* `UserType.getADeclarationEntry()` now yields all forward declarations when the user type is a `class`, `struct`, or `union`.

## 0.2.3

### New Features

* An `isBraced` predicate was added to the `Initializer` class which holds when a C++ braced initializer was used in the initialization.

## 0.2.2

### Deprecated APIs

 * The `AnalysedString` class in the `StringAnalysis` module has been replaced with `AnalyzedString`, to follow our style guide. The old name still exists as a deprecated alias.

### New Features

* A `getInitialization` predicate was added to the `ConstexprIfStmt`, `IfStmt`, and `SwitchStmt` classes that yields the C++17-style initializer of the `if` or `switch` statement when it exists.

## 0.2.1

## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

### Minor Analysis Improvements

* More Windows pool allocation functions are now detected as `AllocationFunction`s.
* The `semmle.code.cpp.commons.Buffer` library has been enhanced to handle array members of classes that do not specify a size.

## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.

### New Features

* A new library `semmle.code.cpp.security.PrivateData` has been added. The new library heuristically detects variables and functions dealing with sensitive private data, such as e-mail addresses and credit card numbers.

### Minor Analysis Improvements

* The `semmle.code.cpp.security.SensitiveExprs` library has been enhanced with some additional rules for detecting credentials.

## 0.0.13

## 0.0.12

### Breaking Changes

* The flow state variants of `isBarrier` and `isAdditionalFlowStep` are no longer exposed in the taint tracking library. The `isSanitizer` and `isAdditionalTaintStep` predicates should be used instead.

### Deprecated APIs

* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* The data flow and taint tracking libraries have been extended with versions of `isBarrierIn`, `isBarrierOut`, and `isBarrierGuard`, respectively `isSanitizerIn`, `isSanitizerOut`, and `isSanitizerGuard`, that support flow states.

### Minor Analysis Improvements

* `DefaultOptions::exits` now holds for C11 functions with the `_Noreturn` or `noreturn` specifier.
* `hasImplicitCopyConstructor` and `hasImplicitCopyAssignmentOperator` now correctly handle implicitly-deleted operators in templates.
* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.11

### Minor Analysis Improvements

* Many queries now support structured bindings, as structured bindings are now handled in the IR translation.

## 0.0.10

### New Features

* Added a `isStructuredBinding` predicate to the `Variable` class which holds when the variable is declared as part of a structured binding declaration.

## 0.0.9


## 0.0.8

### Deprecated APIs

* The `codeql/cpp-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/cpp-all` CodeQL pack.

### Minor Analysis Improvements

* `FormatLiteral::getMaxConvertedLength` now uses range analysis to provide a
  more accurate length for integers formatted with `%x`

## 0.0.7

## 0.0.6

## 0.0.5

## 0.0.4

### New Features

* The QL library `semmle.code.cpp.commons.Exclusions` now contains a predicate
  `isFromSystemMacroDefinition` for identifying code that originates from a
  macro outside the project being analyzed.
