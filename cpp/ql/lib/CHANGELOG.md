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
