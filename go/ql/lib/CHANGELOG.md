## 0.7.1

### Minor Analysis Improvements

* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.
* Support has been added for file system access sinks in the following libraries: [net/http](https://pkg.go.dev/net/http), [Afero](https://github.com/spf13/afero), [beego](https://pkg.go.dev/github.com/astaxie/beego), [Echo](https://pkg.go.dev/github.com/labstack/echo), [Fiber](https://github.com/kataras/iris), [Gin](https://pkg.go.dev/github.com/gin-gonic/gin), [Iris](https://github.com/kataras/iris).
* Added `GoKit.qll` to `go.qll` enabling the GoKit framework by default

## 0.7.0

### Minor Analysis Improvements

* Added Numeric and Boolean types to SQL injection sanitzers.

## 0.6.5

No user-facing changes.

## 0.6.4

### Minor Analysis Improvements

* Added [http.Error](https://pkg.go.dev/net/http#Error) to XSS sanitzers.

## 0.6.3

No user-facing changes.

## 0.6.2

### Minor Analysis Improvements

* Logrus' `WithContext` methods are no longer treated as if they output the values stored in that context to a log message.

## 0.6.1

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* Parameter nodes now exist for unused parameters as well as used parameters.
* Add support for v4 of the [Go Micro framework](https://github.com/go-micro/go-micro).
* Support for the [Bun framework](https://bun.uptrace.dev/) has been added.
* Support for [gqlgen](https://github.com/99designs/gqlgen) has been added.
* Support for the [go-pg framework](https://github.com/go-pg/pg) has been improved.

## 0.6.0

### Deprecated APIs

* The `LogInjection::Configuration` taint flow configuration class has been deprecated. Use the `LogInjection::Flow` module instead.

### Minor Analysis Improvements

* When a result of path query flows through a function modeled using `DataFlow::FunctionModel` or `TaintTracking::FunctionModel`, the path now includes nodes corresponding to the input and output to the function. This brings it in line with functions modeled using Models-as-Data.

## 0.5.4

No user-facing changes.

## 0.5.3

No user-facing changes.

## 0.5.2

### Minor Analysis Improvements

* Fixed data flow through variadic function parameters. The arguments corresponding to a variadic parameter are no longer returned by `CallNode.getArgument(int i)` and `CallNode.getAnArgument()`, and hence aren't `ArgumentNode`s. They now have one result, which is an `ImplicitVarargsSlice` node. For example, a call `f(a, b, c)` to a function `f(T...)` is treated like `f([]T{a, b, c})`. The old behaviour is preserved by `CallNode.getSyntacticArgument(int i)` and `CallNode.getASyntacticArgument()`. `CallExpr.getArgument(int i)` and `CallExpr.getAnArgument()` are unchanged, and will still have three results in the example given.

## 0.5.1

### Minor Analysis Improvements

* Taking a slice is now considered a sanitizer for `SafeUrlFlow`.

## 0.5.0

### Deprecated APIs

* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.

### Bug Fixes

* Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular `DataFlow::hasFlowPath`, `DataFlow::hasFlow`, `DataFlow::hasFlowTo`, and `DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

## 0.4.6

No user-facing changes.

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
