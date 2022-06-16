## 0.1.3

## 0.1.2

### New Features

* Go 1.18 generics are now extracted and can be explored using the new CodeQL classes `TypeParamDecl`, `GenericFunctionInstantiationExpr`, `GenericTypeInstantiationExpr`, `TypeSetTerm`, and `TypeSetLiteralType`, as well as using new predicates defined on the existing `InterfaceType`. Class- and predicate-level documentation can be found in the [Go CodeQL library reference](https://codeql.github.com/codeql-standard-libraries/go/).

## 0.1.1

### Minor Analysis Improvements

* The method predicate `getACalleeIncludingExternals` on `DataFlow::CallNode` and the function `viableCallable` in `DataFlowDispatch` now also work for calls to functions via a variable, where the function can be determined using local flow.

## 0.1.0

### Minor Analysis Improvements

* Fixed a bug where dataflow steps were ignored if both ends were inside the initialiser routine of a file-level variable.

## 0.0.12

## 0.0.11

## 0.0.10

## 0.0.9

## 0.0.8

## 0.0.7

### Deprecated APIs

* The `codeql/go-upgrades` CodeQL pack has been removed. All database upgrade scripts have been merged into the `codeql/go-all` CodeQL pack.

### Bug Fixes

* `Function`'s predicate `getACall` now returns more results in some situations. It now always returns callers that may call a method indirectly via an interface method that it implements. Previously this only happened if the method was in the source code being analysed.

## 0.0.6

## 0.0.5

## 0.0.4

## 0.0.3
