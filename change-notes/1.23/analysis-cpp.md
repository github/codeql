# Improvements to C/C++ analysis

The following changes in version 1.23 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Query name (`query id`) | tags | Message. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Query name (`query id`) | Expected impact | Message. |

## Changes to QL libraries

* The data-flow library has been extended with a new feature to aid debugging.
  Instead of specifying `isSink(Node n) { any() }` on a configuration to
  explore the possible flow from a source, it is recommended to use the new
  `Configuration::hasPartialFlow` predicate, as this gives a more complete
  picture of the partial flow paths from a given source. The feature is
  disabled by default and can be enabled for individual configurations by
  overriding `int explorationLimit()`.
* The `DataFlow::DefinitionByReferenceNode` class now considers `f(x)` to be a
  definition of `x` when `x` is a variable of pointer type. It no longer
  considers deep paths such as `f(&x.myField)` to be definitions of `x`. These
  changes are in line with the user expectations we've observed.
