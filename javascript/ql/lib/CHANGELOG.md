## 0.1.0

### Bug Fixes

* The following predicates on `API::Node` have been changed so as not to include the receiver. The receiver should now only be accessed via `getReceiver()`.
  - `getParameter(int i)` previously included the receiver when `i = -1`
  - `getAParameter()` previously included the receiver
  - `getLastParameter()` previously included the receiver for calls with no arguments

## 0.0.14

## 0.0.13

### Deprecated APIs

* Some predicates from `DefUse.qll`, `DataFlow.qll`, `TaintTracking.qll`, `DOM.qll`, `Definitions.qll` that weren't used by any query have been deprecated. 
  The documentation for each predicate points to an alternative.
* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.
* Some modules that started with a lowercase letter have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.12

### Major Analysis Improvements

* Added support for TypeScript 4.6.

### Minor Analysis Improvements

* Added sources from the [`jszip`](https://www.npmjs.com/package/jszip) library to the `js/zipslip` query.

## 0.0.11

## 0.0.10

## 0.0.9

### Deprecated APIs

* The `codeql/javascript-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/javascript-all` CodeQL pack.

## 0.0.8

## 0.0.7

## 0.0.6

### New Features

* TypeScript 4.5 is now supported.

## 0.0.5
