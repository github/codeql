# Improvements to C/C++ analysis

## General improvements

* The logic for identifying auto-generated files via comments and `#line` directives has been improved.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Array argument size mismatch (`cpp/array-arg-size-mismatch`) | reliability | Finds function calls where the size of an array being passed is smaller than the array size of the declared parameter.  Newly displayed on LGTM. |
| Lossy function result cast (`cpp/lossy-function-result-cast`) | correctness | Finds function calls whose result type is a floating point type, which are implicitly cast to an integral type.  Newly available on LGTM but results not displayed by default. |
| Returning stack-allocated memory (`cpp/return-stack-allocated-memory`) | reliability, external/cwe/cwe-825 | Finds functions that may return a pointer or reference to stack-allocated memory. This query existed already but has been rewritten from scratch to make the error rate low enough for use on LGTM. Results displayed by default. |
| Use of string copy function in a condition (`cpp/string-copy-return-value-as-boolean`) | correctness | This query identifies calls to string copy functions used in conditions, where it's likely that a different function was intended to be called. Results are displayed by default on LGTM. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array argument size mismatch (`cpp/array-arg-size-mismatch`) | Fewer false positive results | An exception has been added to this query for variable sized arrays. |
| Call to memory access function may overflow buffer (`cpp/overflow-buffer`) | More correct results | This query now recognizes calls to `RtlCopyMemoryNonTemporal` and `RtlSecureZeroMemory`. |
| Call to memory access function may overflow buffer (`cpp/overflow-buffer`) | More correct results | Calls to `fread` are now examined by this query. |
| Lossy function result cast (`cpp/lossy-function-result-cast`) | Fewer false positive results | The whitelist of rounding functions built into this query has been expanded. |
| Memory is never freed (`cpp/memory-never-freed`) | More correct results | Support for more Microsoft-specific memory allocation/de-allocation functions has been added. |
| Memory may not be freed (`cpp/memory-may-not-be-freed`) | More correct results | Support for more Microsoft-specific memory allocation/de-allocation functions has been added. |
| Mismatching new/free or malloc/delete (`cpp/new-free-mismatch`) | More correct results | Data flow through global variables for this query has been improved. |
| 'new[]' array freed with 'delete' (`cpp/new-array-delete-mismatch`) | More correct results | Data flow through global variables for this query has been improved. |
| 'new' object freed with 'delete[]' (`cpp/new-delete-array-mismatch`) | More correct results | Data flow through global variables for this query has been improved. |
| Potential buffer overflow (`cpp/potential-buffer-overflow`) | Deprecated | This query has been deprecated. Use Potentially overrunning write (`cpp/overrunning-write`) and Potentially overrunning write with float to string conversion (`cpp/overrunning-write-with-float`) instead. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | The query no longer highlights code that releases a resource via a virtual method call, function pointer, or lambda. |
| Returning stack-allocated memory (`cpp/return-stack-allocated-memory`) | More correct results | Many more stack allocated expressions are now recognized. |
| Suspicious add with sizeof (`cpp/suspicious-add-sizeof`) | Fewer false positive results | Pointer arithmetic on `char * const` expressions (and other variations of `char *`) are now correctly excluded from the results. |
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Fewer false positive results | False positive results involving types that are not uniquely named in the snapshot have been fixed. |
| Unused static variable (`cpp/unused-static-variable`) | Fewer false positive results | Variables with the attribute `unused` are now excluded from the query. |
| Use of inherently dangerous function (`cpp/potential-buffer-overflow`) | Cleaned up | This query no longer catches uses of `gets`, and has been renamed 'Potential buffer overflow'. |
| Use of potentially dangerous function (`cpp/potentially-dangerous-function`) | More correct results | This query now catches uses of `gets`. |


## Changes to QL libraries

* The `semmle.code.cpp.dataflow.DataFlow` library now supports _definition by reference_ via output parameters of known functions.
    * Data flows through `memcpy` and `memmove` by default.
    * Custom flow into or out of arguments assigned by reference can be modeled with the new class `DataFlow::DefinitionByReferenceNode`.
    * The data flow library adds flow through library functions that are modeled in `semmle.code.cpp.models.interfaces.DataFlow`. Queries can add subclasses of `DataFlowFunction` to specify additional flow.
* There is a new `Namespace.isInline()` predicate, which holds if the namespace was declared as `inline namespace`.
* The `Expr.isConstant()` predicate now also holds for _address constant expressions_, which are addresses that will be constant after the program has been linked. These address constants do not have a result for `Expr.getValue()`.
* There are new `Function.isDeclaredConstexpr()` and `Function.isConstexpr()` predicates. They can be used to tell whether a function was declared as `constexpr`, and whether it actually is `constexpr`.
* There is a new `Variable.isConstexpr()` predicate. It can be used to tell whether a variable is `constexpr`.
