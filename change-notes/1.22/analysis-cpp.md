# Improvements to C/C++ analysis

The following changes in version 1.22 affect C/C++ analysis in all applications.

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Call to alloca in a loop (`cpp/alloca-in-loop`) | Fewer false positive results | The query no longer highlights code where the stack allocation could not be reached multiple times in the loop, typically due to a `break` or `return` statement. |
| Continue statement that does not continue (`cpp/continue-in-false-loop`) | Fewer false positive results | Analysis is now restricted to `do`-`while` loops. This query is now run and displayed by default on LGTM. |
| Expression has no effect (`cpp/useless-expression`) | Fewer false positive results | Calls to functions with the `weak` attribute are no longer considered to be side-effect free, because they could be overridden with a different implementation at link time. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | Fewer false positive results | False positive results for strings that are not null-terminated have been excluded. |
| Non-constant format string (`cpp/non-constant-format`) | Fewer false positive results | The query was rewritten using the taint-tracking library. |
| Sign check of bitwise operation (`cpp/bitwise-sign-check`) | Fewer false positive and more true positive results | The query now understands the direction of each comparison, making it more accurate. |
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Lower precision | The precision of this query has been reduced to "medium". This coding pattern is used intentionally and safely in a number of real-world projects. Results are no longer displayed on LGTM unless you choose to display them. |
| Variable used in its own initializer (`cpp/use-in-own-initializer`) | Fewer false positive results | False positive results for constant variables with the same name in different namespaces have been removed. |

## Changes to QL libraries

- The data flow library (`semmle.code.cpp.dataflow.DataFlow`) has had the
  following improvements, all of which benefit the taint tracking library
  (`semmle.code.cpp.dataflow.TaintTracking`) as well.
  - This release includes preliminary support for interprocedural flow through
    fields (non-static data members). In some cases, data stored in a field in
    one function can now flow to a read of the same field in a different
    function.
  - The possibility of specifying barrier edges using
    `isBarrierEdge`/`isSanitizerEdge` in data-flow and taint-tracking
    configurations has been replaced with the option of specifying in- and
    out-barriers on nodes by overriding `isBarrierIn`/`isSanitizerIn` and
    `isBarrierOut`/`isSanitizerOut`. This should be simpler to use effectively,
    as it does not require knowledge about the actual edges used internally by
    the library.
  - The library now models data flow through `std::swap`.
  - Recursion through the `DataFlow` library is now always a compile error. Such recursion has been deprecated since release 1.16 in March 2018. If one `DataFlow::Configuration` needs to depend on the results of another, switch one of them to use one of the `DataFlow2` through `DataFlow4` libraries.
- In the `semmle.code.cpp.dataflow.TaintTracking` library, the second copy of `Configuration` has been renamed from `TaintTracking::Configuration2` to `TaintTracking2::Configuration`, and the old name is now deprecated. Import `semmle.code.cpp.dataflow.TaintTracking2` to access the new name.
- The `semmle.code.cpp.security.TaintTracking` library now considers a pointer difference calculation as blocking taint flow.
- The predicate `Variable.getAnAssignedValue()` now reports assignments to fields resulting from aggregate initialization (` = {...}`).
- The predicate `TypeMention.toString()` has been simplified to always return the string "`type mention`".  This may improve performance when using `Element.toString()` or its descendants.
- Fixed the `LocalScopeVariableReachability.qll` library's handling of loops where the entry condition is always true on first entry, and where there is more than one control flow path through the loop condition. This change increases the accuracy of the `LocalScopeVariableReachability.qll` library and queries that depend on it.
- There is a new `Variable.isThreadLocal()` predicate. It can be used to tell whether a variable is `thread_local`.
- C/C++ code examples have been added to QLDoc comments on many more classes in the QL libraries.
