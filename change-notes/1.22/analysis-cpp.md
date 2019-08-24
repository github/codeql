# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Call to alloca in a loop (`cpp/alloca-in-loop`) | Fewer false positive results | Fixed false positives where the stack allocation could not be reached multiple times in the loop, typically due to a `break` or `return` statement. |
| Continue statement that does not continue (`cpp/continue-in-false-loop`) | Fewer false positive results | Analysis is now restricted to `do`-`while` loops. This query is now run and displayed by default on LGTM. |
| Expression has no effect (`cpp/useless-expression`) | Fewer false positive results | Calls to functions with the `weak` attribute are no longer considered to be side effect free, because they could be overridden with a different implementation at link time. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | Fewer false positive results | False positives involving strings that are not null-terminated have been excluded. |
| Sign check of bitwise operation (`cpp/bitwise-sign-check`) | Fewer false positive results and more true positive results | The query now understands the direction of each comparison, making it more accurate. |
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Lower precision | The precision of this query has been reduced to "medium". This coding pattern is used intentionally and safely in a number of real-world projects. Results are no longer displayed on LGTM unless you choose to display them. |
| Non-constant format string (`cpp/non-constant-format`) | Fewer false positive results | Rewritten using the taint-tracking library. |
| Variable used in its own initializer (`cpp/use-in-own-initializer`) | Fewer false positive results | False positives for constant variables with the same name in different namespaces have been removed. |

## Changes to QL libraries

- The predicate `Variable.getAnAssignedValue()` now reports assignments to fields resulting from aggregate initialization (` = {...}`).
- The predicate `TypeMention.toString()` has been simplified to always return the string "`type mention`".  This may improve performance when using `Element.toString()` or its descendants.
- The `semmle.code.cpp.security.TaintTracking` library now considers a pointer difference calculation as blocking taint flow.
- The second copy of the interprocedural `TaintTracking` library has been renamed from `TaintTracking::Configuration2` to `TaintTracking2::Configuration`, and the old name is now deprecated. Import `semmle.code.cpp.dataflow.TaintTracking2` to access the new name.
- Fixed the `LocalScopeVariableReachability.qll` library's handling of loops with an entry condition is both always true upon first entry, and where there is more than one control flow path through the loop condition.  This change increases the accuracy of the `LocalScopeVariableReachability.qll` library and queries which depend on it.
- The `semmle.code.cpp.models` library now models data flow through `std::swap`.
- There is a new `Variable.isThreadLocal()` predicate. It can be used to tell whether a variable is `thread_local`.
- Recursion through the `DataFlow` library is now always a compile error. Such recursion has been deprecated since release 1.16. If one `DataFlow::Configuration` needs to depend on the results of another, switch one of them to use one of the `DataFlow2` through `DataFlow4` libraries.
- The possibility of specifying barrier edges using
  `isBarrierEdge`/`isSanitizerEdge` in data-flow and taint-tracking
  configurations has been replaced with the option of specifying in- and
  out-barriers on nodes by overriding `isBarrierIn`/`isSanitizerIn` and
  `isBarrierOut`/`isSanitizerOut`. This should be simpler to use effectively,
  as it does not require knowledge about the actual edges used internally by
  the library.
- Added C/C++ code examples to QLDoc comments on many more classes in the QL libraries.
