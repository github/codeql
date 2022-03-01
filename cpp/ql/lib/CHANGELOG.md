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
