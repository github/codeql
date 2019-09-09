# Improvements to C# analysis

The following changes in version 1.23 affect C# analysis in all applications.

## New queries

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Unsafe year argument for 'DateTime' constructor (`cs/unsafe-year-construction`) | reliability, date-time | Finds incorrect manipulation of `DateTime` values, which could lead to invalid dates. |
| Mishandling the Japanese era start date (`cs/mishandling-japanese-era`) | reliability, date-time | Finds hard-coded Japanese era start dates that could be invalid. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|

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

## Changes to autobuilder
