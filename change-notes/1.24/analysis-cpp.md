# Improvements to C/C++ analysis

The following changes in version 1.24 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Buffer not sufficient for string (`cpp/overflow-calculated`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Memory is never freed (`cpp/memory-never-freed`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Memory may not be freed (`cpp/memory-may-not-be-freed`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Missing return statement (`cpp/missing-return`) | Fewer false positive results | Functions containing `asm` statements are no longer highlighted by this query. |
| Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) |  | This query is no longer run on LGTM. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | Fewer false positive results | This query has been modified to be more conservative when identifying which pointers point to null-terminated strings.  This approach produces fewer, more accurate results. |
| Overloaded assignment does not return 'this' (`cpp/assignment-does-not-return-this`) | Fewer false positive results | This query no longer reports incorrect results in template classes. |
| Unsafe array for days of the year (`cpp/leap-year/unsafe-array-for-days-of-the-year`) |  | This query is no longer run on LGTM. |

## Changes to libraries

* Created the `semmle.code.cpp.models.interfaces.Allocation` library to model allocation such as `new` expressions and calls to `malloc`. This in intended to replace the functionality in `semmle.code.cpp.commons.Alloc` with a more consistent and useful interface.
* Created the `semmle.code.cpp.models.interfaces.Deallocation` library to model deallocation such as `delete` expressions and calls to `free`. This in intended to replace the functionality in `semmle.code.cpp.commons.Alloc` with a more consistent and useful interface.
* The new class `StackVariable` should be used in place of `LocalScopeVariable`
  in most cases. The difference is that `StackVariable` does not include
  variables declared with `static` or `thread_local`.
  * As a rule of thumb, custom queries about the _values_ of variables should
    be changed from `LocalScopeVariable` to `StackVariable`, while queries
    about the _name or scope_ of variables should remain unchanged.
  * The `LocalScopeVariableReachability` library is deprecated in favor of
    `StackVariableReachability`. The functionality is the same.
* The taint tracking library (`semmle.code.cpp.dataflow.TaintTracking`) has had
  the following improvements:
  * The library now models data flow through `strdup` and similar functions.
  