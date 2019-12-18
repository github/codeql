# Improvements to C# analysis

The following changes in version 1.23 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Deserialized delegate (`cs/deserialized-delegate`) | security, external/cwe/cwe-502 | Finds unsafe deserialization of delegate types. Results are shown on LGTM by default. |
| Deserialization of untrusted data (`cs/unsafe-deserialization-untrusted-input`) | security, external/cwe/cwe-502 | Finds flow of untrusted input to calls to unsafe deserializers. Results are shown on LGTM by default. |
| Mishandling the Japanese era start date (`cs/mishandling-japanese-era`) | reliability, date-time | Finds hard-coded Japanese era start dates that could be invalid. Results are not shown on LGTM by default. |
| Unsafe year argument for 'DateTime' constructor (`cs/unsafe-year-construction`) | reliability, date-time | Finds incorrect manipulation of `DateTime` values, which could lead to invalid dates. Results are not shown on LGTM by default. |
| Unsafe deserializer (`cs/unsafe-deserialization`) | security, external/cwe/cwe-502 | Finds calls to unsafe deserializers. By default, the query is not run on LGTM. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`cs/dereferenced-value-may-be-null`) | Fewer false positive results | More `null` checks are now taken into account, including `null` checks for `dynamic` expressions and `null` checks such as `object alwaysNull = null; if (x != alwaysNull) ...`. |
| Missing Dispose call on local IDisposable (`cs/local-not-disposed`) | Fewer false positive results | The query has been rewritten in order to identify more dispose patterns. For example, a local `IDisposable` that is disposed of by passing through a fluent API is no longer reported as missing a dispose call. |

## Changes to code extraction

* `nameof` expressions are now extracted correctly when the name is a namespace.

## Changes to libraries

* The new class `NamespaceAccess` models accesses to namespaces, for example in `nameof` expressions.
* The data-flow library now makes it easier to specify barriers/sanitizers
  arising from guards. You can override the predicate
  `isBarrierGuard`/`isSanitizerGuard` on data-flow and taint-tracking
  configurations respectively.
* The data-flow library has been extended with a new feature to aid debugging.
  Previously, to explore the possible flow from all sources you could specify `isSink(Node n) { any() }` on a configuration. 
  Now you can use the new `Configuration::hasPartialFlow` predicate, 
  which gives a more complete picture of the partial flow paths from a given source, including flow that doesn't reach any sink.
  The feature is disabled by default and can be enabled for individual configurations by
  overriding `int explorationLimit()`.
* `foreach` statements where the body is guaranteed to be executed at least once, such as `foreach (var x in new string[]{ "a", "b", "c" }) { ... }`, are now recognized by all analyses based on the control-flow graph (such as SSA, data flow and taint tracking).
* Fixed the control-flow graph for `switch` statements where the `default` case was not the last case. This had caused the remaining cases to be unreachable. `SwitchStmt.getCase(int i)` now puts the `default` case last.
* There is now a `DataFlow::localExprFlow` predicate and a
  `TaintTracking::localExprTaint` predicate to make it easy to use the most
  common case of local data flow and taint: from one `Expr` to another.
* Data is now tracked through null-coalescing expressions (`??`).
* A new library `semmle.code.csharp.Unification` has been added. This library exposes two predicates `unifiable` and `subsumes` for calculating type unification and type subsumption, respectively.
