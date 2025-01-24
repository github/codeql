## 1.1.9

No user-facing changes.

## 1.1.8

### Minor Analysis Improvements

* Added a module `DataFlow::DeduplicatePathGraph` that can be used to avoid generating duplicate path explanations in queries that use flow state.

## 1.1.7

No user-facing changes.

## 1.1.6

No user-facing changes.

## 1.1.5

No user-facing changes.

## 1.1.4

No user-facing changes.

## 1.1.3

No user-facing changes.

## 1.1.2

No user-facing changes.

## 1.1.1

No user-facing changes.

## 1.1.0

### Deprecated APIs

* The source/sink grouping feature of the data flow library has been removed. It was introduced primarily for debugging, but has not proven useful.

## 1.0.5

No user-facing changes.

## 1.0.4

No user-facing changes.

## 1.0.3

No user-facing changes.

## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Minor Analysis Improvements

* The data flow library now adds intermediate nodes when data flows out of a function via a parameter, in order to make path explanations easier to follow. The intermediate nodes have the same location as the underlying parameter, but must be accessed via `PathNode.asParameterReturnNode` instead of `PathNode.asNode`.

## 0.2.7

No user-facing changes.

## 0.2.6

### Major Analysis Improvements

* The data flow library performs heuristic filtering of code paths that have a high degree of control-flow uncertainty for improved performance in cases that are deemed unlikely to yield true positive flow paths. This filtering can be controlled with the `fieldFlowBranchLimit` predicate in configurations. Two bugs have been fixed in relation to this: Some cases of high uncertainty were not being correctly identified. This fix improves performance in certain scenarios. Another group of cases of low uncertainty were also being misidentified, which led to false negatives. Taken together, we generally expect some additional query results with more true positives and fewer false positives.

## 0.2.5

### New Features

* The `PathGraph` result of a data flow computation has been augmented with model provenance information for each of the flow steps. Any qltests that include the edges relation in their output (for example, `.qlref`s that reference path-problem queries) will need to be have their expected output updated accordingly.

## 0.2.4

### Minor Analysis Improvements

* Path explanations now include flow that goes through callbacks passed into library functions. For example, if `map` is a library function, then in `result = map(xs, x => x + 1)` we will now include the step from `x` to `x + 1` in the path explanation, instead of going directly from `xs` to `result`. Note that this change does not affect actual query results, but only how path explanations are computed.

## 0.2.3

No user-facing changes.

## 0.2.2

No user-facing changes.

## 0.2.1

No user-facing changes.

## 0.2.0

### Breaking Changes

* The `edges` predicate contained in `PathGraph` now contains two additional columns for propagating model provenance information. This is primarily an internal change without any impact on any APIs, except for specialised queries making use of `MergePathGraph` in conjunction with custom `PathGraph` implementations. Such queries will need to be updated to reference the two new columns. This is expected to be very rare, as `MergePathGraph` is an advanced feature, but it is a breaking change for any such affected queries.

## 0.1.8

No user-facing changes.

## 0.1.7

No user-facing changes.

## 0.1.6

### Deprecated APIs

* The old configuration-class based data flow api has been deprecated. The configuration-module based api should be used instead. For details, see https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries/.

## 0.1.5

No user-facing changes.

## 0.1.4

No user-facing changes.

## 0.1.3

No user-facing changes.

## 0.1.2

### Bug Fixes

* The API for debugging flow using partial flow has changed slightly. Instead of using `module Partial = FlowExploration<limit/0>` and choosing between `Partial::partialFlow` and `Partial::partialFlowRev`, you now choose between `module Partial = FlowExplorationFwd<limit/0>` and `module Partial = FlowExplorationRev<limit/0>`, and then always use `Partial::partialFlow`.

## 0.1.1

No user-facing changes.

## 0.1.0

### Major Analysis Improvements

* Added support for type-based call edge pruning. This removes data flow call edges that are incompatible with the set of flow paths that reach it based on type information. This improves dispatch precision for constructs like lambdas, `Object.toString()` calls, and the visitor pattern. For now this is only enabled for Java and C#.

### Minor Analysis Improvements

* The `isBarrierIn` and `isBarrierOut` predicates in `DataFlow::StateConfigSig` now have overloaded variants that block a specific `FlowState`.

## 0.0.4

No user-facing changes.

## 0.0.3

### New Features

* The various inline flow test libraries have been consolidated as a shared library part in the dataflow qlpack.

### Minor Analysis Improvements

* The shared taint-tracking library is now part of the dataflow qlpack.

## 0.0.2

### Major Analysis Improvements

* Initial release. Adds a library to implement flow through captured variables that properly adheres to inter-procedural control flow.

## 0.0.1

### New Features

* The `StateConfigSig` signature now supports a unary `isSink` predicate that does not specify the `FlowState` for which the given node is a sink. Instead, any `FlowState` is considered a valid `FlowState` for such a sink.

### Minor Analysis Improvements

* Initial release. Moves the shared inter-procedural data-flow library into its own qlpack.
