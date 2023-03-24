## 0.4.5

### New Features

* Added support for merging two `PathGraph`s via disjoint union to allow results from multiple data flow computations in a single `path-problem` query.

### Major Analysis Improvements

* The main data flow and taint tracking APIs have been changed. The old APIs
  remain in place for now and translate to the new through a
  backwards-compatible wrapper. If multiple configurations are in scope
  simultaneously, then this may affect results slightly. The new API is quite
  similar to the old, but makes use of a configuration module instead of a
  configuration class.

## 0.4.4

No user-facing changes.

## 0.4.3

### New Features

* Go 1.20 is now supported. The extractor now functions as expected when Go 1.20 is installed; the definition of `implementsComparable` has been updated according to Go 1.20's new, more-liberal rules; and taint flow models have been added for relevant, new standard-library functions.

### Minor Analysis Improvements

* Support for the Twirp framework has been added.

## 0.4.2

No user-facing changes.

## 0.4.1

No user-facing changes.

## 0.4.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

### Minor Analysis Improvements

* The predicate `getNumParameter` on `FuncTypeExpr` has been changed to actually give the number of parameters. It previously gave the number of parameter declarations. `getNumParameterDecl` has been introduced to preserve this functionality.
* The definition of `mayHaveSideEffects` for `ReturnStmt` was incorrect when more than one expression was being returned. Such return statements were effectively considered to never have side effects. This has now been fixed. In rare circumstances `globalValueNumber` may have incorrectly treated two values as the same when they were in fact distinct.
* Queries that care about SQL, such as `go/sql-injection`, now recognise SQL-consuming functions belonging to the `gorqlite` and `GoFrame` packages.
* `rsync` has been added to the list of commands which may evaluate its parameters as a shell command.

### Bug Fixes

* Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

## 0.3.6

No user-facing changes.

## 0.3.5

No user-facing changes.

## 0.3.4

No user-facing changes.

## 0.3.3

No user-facing changes.

## 0.3.2

No user-facing changes.

## 0.3.1

### Minor Analysis Improvements

* Added support for `BeegoInput.RequestBody` as a source of untrusted data.

## 0.3.0

### Deprecated APIs

* Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

## 0.2.5

## 0.2.4

### Minor Analysis Improvements

* Go 1.19 is now supported, including adding new taint propagation steps for new standard-library functions introduced in this release.
* Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.
* Fixed data-flow to captured variable references.
* We now assume that if a channel-typed field is only referred to twice in the user codebase, once in a send operation and once in a receive, then data flows from the send to the receive statement. This enables finding some cross-goroutine flow.

## 0.2.3

## 0.2.2

## 0.2.1

## 0.2.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

## 0.1.4

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
