# Improvements to C# analysis

The following changes in version 1.23 affect C# analysis in all applications.

## New queries

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Unsafe year argument for 'DateTime' constructor (`cs/unsafe-year-construction`) | reliability, date-time | Finds incorrect manipulation of `DateTime` values, which could lead to invalid dates. |
| Large 'maxRequestLength' value (`cs/web/large-max-request-length`) | security, frameworks/asp.net, external/cwe/cwe-16 | Finds `web.config` files with large (greater than 4096) `maxRequestLength` attributes. |
| Mishandling the Japanese era start date (`cs/mishandling-japanese-era`) | reliability, date-time | Finds hard-coded Japanese era start dates that could be invalid. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`cs/dereferenced-value-may-be-null`) | Fewer false positive results | More `null` checks are now taken into account, including `null` checks for `dynamic` expressions and `null` checks such as `object alwaysNull = null; if (x != alwaysNull) ...`. |
| Missing Dispose call on local IDisposable (`cs/local-not-disposed`) | Fewer false positive results | The query has been rewritten in order to identify more dispose patterns. For example, a local `IDisposable` that is disposed of by passing through a fluent API is no longer reported. |

## Removal of old queries

## Changes to code extraction

* `nameof` expressions are now extracted correctly when the name is a namespace.

## Changes to QL libraries

* The new class `NamespaceAccess` models accesses to namespaces, for example in `nameof` expressions.
* The data-flow library now makes it easier to specify barriers/sanitizers
  arising from guards by overriding the predicate
  `isBarrierGuard`/`isSanitizerGuard` on data-flow and taint-tracking
  configurations respectively.
* The data-flow library has been extended with a new feature to aid debugging.
  Instead of specifying `isSink(Node n) { any() }` on a configuration to
  explore the possible flow from a source, it is recommended to use the new
  `Configuration::hasPartialFlow` predicate, as this gives a more complete
  picture of the partial flow paths from a given source. The feature is
  disabled by default and can be enabled for individual configurations by
  overriding `int explorationLimit()`.
* `foreach` statements where the body is guaranteed to be executed at least once, such as `foreach (var x in new string[]{ "a", "b", "c" }) { ... }`, are now recognized by all analyses based on the control flow graph (such as SSA, data flow and taint tracking).
* Fixed the control flow graph for `switch` statements where the `default` case was not the last case. This had caused the remaining cases to be unreachable. `SwitchStmt.getCase(int i)` now puts the `default` case last.
* There is now a `DataFlow::localExprFlow` predicate and a
  `TaintTracking::localExprTaint` predicate to make it easy to use the most
  common case of local data flow and taint: from one `Expr` to another.

## Changes to autobuilder
