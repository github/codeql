# Improvements to C/C++ analysis

## General improvements

* The logic for identifying auto-generated files via `#line` directives has been improved.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Lossy function result cast (`cpp/lossy-function-result-cast`) | correctness | Finds function calls whose result type is a floating point type, which are implicitly cast to an integral type.  Newly available but not displayed by default on LGTM. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Suspicious add with sizeof (`cpp/suspicious-add-sizeof`) | Fewer false positives | Pointer arithmetic on `char * const` expressions (and other variations of `char *`) are now correctly excluded from the results. |
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Fewer false positives | False positives involving types that are not uniquely named in the snapshot have been fixed. |
| Lossy function result cast (`cpp/lossy-function-result-cast`) | Fewer false positive results | The whitelist of rounding functions built into this query has been expanded. |
| Unused static variable (`cpp/unused-static-variable`) | Fewer false positive results | Variables with the attribute `unused` are now excluded from the query. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | Fix false positives where a resource is released via a virtual method call. |

## Changes to QL libraries

There is a new `Namespace.isInline()` predicate, which holds if the namespace was declared as `inline namespace`.
