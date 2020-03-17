# Improvements to C/C++ analysis

The following changes in version 1.24 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Implicit function declarations (`cpp/Likely Bugs/Underspecified Functions/ImplicitFunctionDeclaration.ql`) | correctness, maintainability | This query finds calls to undeclared functions that are compiled by a C compiler. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Buffer not sufficient for string (`cpp/overflow-calculated`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Memory is never freed (`cpp/memory-never-freed`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Memory may not be freed (`cpp/memory-may-not-be-freed`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Mismatching new/free or malloc/delete (`cpp/new-free-mismatch`) | Fewer false positive results | Fixed false positive results in template code. |
| Missing return statement (`cpp/missing-return`) | Fewer false positive results | Functions containing `asm` statements are no longer highlighted by this query. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | More correct results | String arguments to formatting functions are now (usually) expected to be null terminated strings. |
| Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) |  | This query is no longer run on LGTM. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | Fewer false positive results | This query has been modified to be more conservative when identifying which pointers point to null-terminated strings.  This approach produces fewer, more accurate results. |
| Overloaded assignment does not return 'this' (`cpp/assignment-does-not-return-this`) | Fewer false positive results | This query no longer reports incorrect results in template classes. |
| Unsafe array for days of the year (`cpp/leap-year/unsafe-array-for-days-of-the-year`) |  | This query is no longer run on LGTM. |
| Unsigned comparison to zero (`cpp/unsigned-comparison-zero`) | More correct results | This query now also looks for comparisons of the form `0 <= x`. |

## Changes to libraries

* The data-flow library has been improved, which affects and improves some security queries. The improvements are:
  - Track flow through functions that combine taint tracking with flow through fields.
  - Track flow through clone-like functions, that is, functions that read contents of a field from a
    parameter and stores the value in the field of a returned object.
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
* The models library models `strlen` in more detail, and includes common variations such as `wcslen`.
* The taint tracking library (`semmle.code.cpp.dataflow.TaintTracking`) has had
  the following improvements:
  * The library now models data flow through `strdup` and similar functions.
  * The library now models data flow through formatting functions such as `sprintf`.
* The security pack taint tracking library (`semmle.code.cpp.security.TaintTracking`) uses a new intermediate representation. This provides a more precise analysis of pointers to stack variables and flow through parameters, improving the results of many security queries.
* The global value numbering library (`semmle.code.cpp.valuenumbering.GlobalValueNumbering`) uses a new intermediate representation to provide a more precise analysis of heap allocated memory and pointers to stack variables.
