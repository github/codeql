# Improvements to C# analysis

The following changes in version 1.23 affect C# analysis in all applications.

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

## Changes to autobuilder
