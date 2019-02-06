# Improvements to C/C++ analysis

## General improvements

* The logic for identifying auto-generated files via comments and `#line` directives has been improved.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Use of string copy function in a condition (`cpp/string-copy-return-value-as-boolean`) | correctness | This query identifies calls to string copy functions used in conditions, where it's likely that a different function was intended to be called. |
| Lossy function result cast (`cpp/lossy-function-result-cast`) | correctness | Finds function calls whose result type is a floating point type, which are implicitly cast to an integral type.  Newly available but not displayed by default on LGTM. |
| Array argument size mismatch (`cpp/array-arg-size-mismatch`) | reliability | Finds function calls where the size of an array being passed is smaller than the array size of the declared parameter.  Newly displayed on LGTM. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array argument size mismatch (`cpp/array-arg-size-mismatch`) | Fewer false positives | An exception has been added to this query for variable sized arrays. |
| Suspicious add with sizeof (`cpp/suspicious-add-sizeof`) | Fewer false positives | Pointer arithmetic on `char * const` expressions (and other variations of `char *`) are now correctly excluded from the results. |
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Fewer false positives | False positives involving types that are not uniquely named in the snapshot have been fixed. |
| Call to memory access function may overflow buffer (`cpp/overflow-buffer`) | More correct results | Calls to `fread` are now examined by this query. |
| Lossy function result cast (`cpp/lossy-function-result-cast`) | Fewer false positive results | The whitelist of rounding functions built into this query has been expanded. |
| Unused static variable (`cpp/unused-static-variable`) | Fewer false positive results | Variables with the attribute `unused` are now excluded from the query. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | Fix false positives where a resource is released via a virtual method call, function pointer, or lambda. |

## Changes to QL libraries

* There is a new `Namespace.isInline()` predicate, which holds if the namespace was declared as `inline namespace`.
* The `Expr.isConstant()` predicate now also holds for _address constant expressions_, which are addresses that will be constant after the program has been linked. These address constants do not have a result for `Expr.getValue()`.
