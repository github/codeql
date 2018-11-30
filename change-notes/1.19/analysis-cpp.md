# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Cast between `HRESULT` and a Boolean type (`cpp/hresult-boolean-conversion`) | security, external/cwe/cwe-253 | Finds logic errors caused by mistakenly treating the Windows `HRESULT` type as a Boolean instead of testing it with the appropriate macros. Enabled by default. |
| Setting a DACL to `NULL` in a `SECURITY_DESCRIPTOR` (`cpp/unsafe-dacl-security-descriptor`) | security, external/cwe/cwe-732 | This query finds code that creates world-writable objects on Windows by setting their DACL to `NULL`. Enabled by default. |
| Cast from `char*` to `wchar_t*` | security, external/cwe/cwe-704 | Detects potentially dangerous casts from `char*` to `wchar_t*`.  Enabled by default on LGTM. |
| Dead code due to `goto` or `break` statement (`cpp/dead-code-goto`) | maintainability, external/cwe/cwe-561 | Detects dead code following a `goto` or `break` statement. Enabled by default on LGTM. |
| Inconsistent direction of for loop | correctness, external/cwe/cwe-835 | This query detects `for` loops where the increment and guard condition don't appear to correspond.  Enabled by default on LGTM. |
| Incorrect Not Operator Usage | security, external/cwe/cwe-480 | This query finds uses of the logical not (`!`) operator that look like they should be bit-wise not (`~`).  Available but not displayed by default on LGTM. |
| NULL application name with an unquoted path in call to CreateProcess | security, external/cwe/cwe-428 | This query finds unsafe uses of the `CreateProcess` function.  Available but not displayed by default on LGTM. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array offset used before range check | More results and fewer false positive results | The query now recognizes array accesses in different positions within the expression.  False positives where the range is checked before and after the array access have been fixed. |
| Empty branch of conditional | Fewer false positive results | The query now recognizes commented blocks more reliably. |
| Expression has no effect | Fewer false positive results | Expressions in template instantiations are now excluded from this query. |
| Global could be static | Fewer false positive results | Variables with declarations in header files are now excluded from this query. |
| Resource not released in destructor | Fewer false positive results | Placement new is now excluded from the query. Also fixed an issue where false positives could occur if the destructor body was not in the snapshot. |
| Memory is never freed | Fewer false positive results | This query now accounts for C++ _placement new_, which returns a pointer that does not need to be freed. |
| Missing return statement (`cpp/missing-return`) | Visible by default | The precision of this query has been increased from 'medium' to 'high', which makes it visible by default in LGTM. It was 'medium' in release 1.17 and 1.18 because it had false positives due to an extractor bug that was fixed in 1.18. |
| Missing return statement | Fewer false positive results | The query is now produces correct results when a function returns a template-dependent type, or makes a non-returning call to another function. |
| Multiplication result converted to larger type (`cpp/integer-multiplication-cast-to-long`) | Fewer false positive results | Char-typed numbers are no longer considered to potentially large. |
| Non-virtual destructor in base class (`cpp/virtual-destructor`) | Fewer false positive results | This query was renamed from "No virtual destructor" and moved from file name `AV Rule 78.ql` to `NonVirtualDestructorInBaseClass.ql`. The new version ignores base classes with non-public destructors since we consider those to be adequately protected. |
| Overloaded assignment does not return 'this' (`cpp/assignment-does-not-return-this`) | Fewer false positive results | This query now ignores any return statements that are unreachable. |
| Static array access may cause overflow | More correct results | Data flow to the size argument of a buffer operation is now checked in this query. |
| Call to memory access function may overflow buffer | More correct results | Array indexing with a negative index is now detected by this query. |
| Self comparison | Fewer false positive results | Code inside macro invocations is now excluded from the query. |
| Suspicious call to memset | Fewer false positive results | Types involving decltype are now correctly compared. |
| Suspicious add with sizeof | Fewer false positive results | Arithmetic with void pointers (where allowed) is now excluded from this query. |
| Wrong type of arguments to formatting function | Fewer false positive results | False positive results involving typedefs have been removed.  Expected argument types are determined more accurately, especially for wide string and pointer types.  Custom (non-standard) formatting functions are also identified more accurately. |
| AV Rule 164 | Fewer false positive results | This query now accounts for explicit casts. |
| Negation of unsigned value | Fewer false positive results | This query now accounts for explicit casts. |
| Variable scope too large | Fewer false positive results | Variables with declarations in header files, or that are used at file scope, are now excluded from this query. |
| Comparison result is always the same | Fewer false positive results | Comparisons in template instantiations are now excluded from this query. |
| Unsigned comparison to zero | Fewer false positive results | Comparisons in template instantiations are now excluded from this query. |

## Changes to QL libraries

* Added a hash consing library (`semmle.code.cpp.valuenumbering.HashCons`) for structural comparison of expressions. Unlike the existing library for global value numbering, this library implements a pure syntactic comparison of expressions and will equate expressions even if they may not compute the same value.
* The `Buffer.qll` library has more conservative treatment of arrays embedded in structs. This reduces false positives in a number of security queries, especially `cpp/overflow-buffer`.
    * Pre-C99 encodings of _flexible array members_ are recognized more reliably.
    * Arrays of zero size are now treated as a special case.
* The library `semmle.code.cpp.dataflow.RecursionPrevention` is now deprecated. It was an aid for transitioning data-flow queries from 1.16 to 1.17, and it no longer has any function. Imports of this library should simply be deleted.
