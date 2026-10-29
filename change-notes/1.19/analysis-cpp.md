# Improvements to C/C++ analysis

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Cast between `HRESULT` and a Boolean type (`cpp/hresult-boolean-conversion`) | security, external/cwe/cwe-253 | Finds logic errors caused by mistakenly treating the Windows `HRESULT` type as a Boolean instead of testing it with the appropriate macros. Results are shown on LGTM by default. |
| Cast from `char*` to `wchar_t*` (`cpp/incorrect-string-type-conversion`) | security, external/cwe/cwe-704 | Detects potentially dangerous casts from `char*` to `wchar_t*`.  Results are shown on LGTM by default. |
| Dead code due to `goto` or `break` statement (`cpp/dead-code-goto`) | maintainability, external/cwe/cwe-561 | Detects dead code following a `goto` or `break` statement. Results are shown on LGTM by default. |
| Inconsistent direction of for loop (`cpp/inconsistent-loop-direction`) | correctness, external/cwe/cwe-835 | Detects `for` loops where the increment and guard condition don't appear to correspond.  Results are shown on LGTM by default. |
| Incorrect 'not' operator usage (`cpp/incorrect-not-operator-usage`) | security, external/cwe/cwe-480 | Finds uses of the logical not (`!`) operator that look like they should be bit-wise not (`~`).  Results are hidden on LGTM by default. |
| Non-virtual destructor in base class (`cpp/virtual-destructor`) | reliability, readability, language-features | This query, `NonVirtualDestructorInBaseClass.ql`, is a replacement in LGTM for the query: No virtual destructor (`AV Rule 78.ql`). The new query ignores base classes with non-public destructors since we consider those to be adequately protected. The new version retains the query identifier, `cpp/virtual-destructor`, and results are displayed by default on LGTM. The old query is no longer run on LGTM. |
| `NULL` application name with an unquoted path in call to `CreateProcess` (`cpp/unsafe-create-process-call`) | security, external/cwe/cwe-428 | Finds unsafe uses of the `CreateProcess` function.  Results are hidden on LGTM by default. |
| Setting a DACL to `NULL` in a `SECURITY_DESCRIPTOR` (`cpp/unsafe-dacl-security-descriptor`) | security, external/cwe/cwe-732 | Finds code that creates world-writable objects on Windows by setting their DACL to `NULL`. Results are shown on LGTM by default. |

## Changes to existing LGTM queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Comparison result is always the same (`cpp/constant-comparison`) | Fewer false positive results | Comparisons in template instantiations are now excluded from results. |
| Empty branch of conditional (`cpp/empty-block`) | Fewer false positive results | Now recognizes commented blocks more reliably. |
| Expression has no effect (`cpp/useless-expression`) | Fewer false positive results | Expressions in template instantiations are now excluded from results. |
| Missing return statement (`cpp/missing-return`) | Fewer false positive results, visible by default | Improved results when a function returns a template-dependent type, or makes a non-returning call to another function. Precision increased from 'medium' to 'high' so that alerts are shown by default in LGTM. |
| Multiplication result converted to larger type (`cpp/integer-multiplication-cast-to-long`) | Fewer false positive results | Char-typed numbers are no longer considered to be potentially large. |
| No virtual destructor (`cpp/jsf/av-rule-78`) | No results in LGTM | This query is part of the [Joint Strike Fighter](http://www.stroustrup.com/JSF-AV-rules.pdf) suite which defines strict coding rules for air vehicles. Its query identifier has been revised to reflect this. On LGTM this query has been replaced by the similar query "Non-virtual destructor in base class", see New queries above.  The new query highlights only code that is likely to be a problem in the majority of projects. |
| Overloaded assignment does not return 'this' (`cpp/assignment-does-not-return-this`) | Fewer false positive results | Any return statements that are unreachable are now ignored. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | No longer highlights uses of C++ _placement new_ and results are no longer reported for resources where the destructor body is not in the snapshot database. |
| Self comparison (`cpp/comparison-of-identical-expressions`) | Fewer false positive results | Code inside macro invocations is now excluded from the query. |
| Static array access may cause overflow (`cpp/static-buffer-overflow`) | More correct results | Data flow to the `size` argument of a buffer operation is now checked in this query. |
| Suspicious add with sizeof (`cpp/suspicious-add-sizeof`) | Fewer false positive results | Arithmetic with void pointers (where allowed) is now excluded from results. |
| Unsigned comparison to zero (`cpp/unsigned-comparison-zero`) | Fewer false positive results | Comparisons in template instantiations are now excluded from results. |
| Wrong type of arguments to formatting function (`cpp/wrong-type-format-argument`) | Fewer false positive results | False positive results involving `typedef`s have been removed.  Expected argument types are determined more accurately, especially for wide string and pointer types.  Custom (non-standard) formatting functions are also identified more accurately. |

## Changes to other queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array offset used before range check (`cpp/offset-use-before-range-check`) | More results and fewer false positive results | Now recognizes array accesses in different positions within the expression.  Code where the range is checked before and after the array access is no longer highlighted. |
| AV Rule 164 (`cpp/jsf/av-rule-164`) | Fewer false positive results | Now accounts for explicit casts. |
| Call to memory access function may overflow buffer (`cpp/overflow-buffer`) | More correct results | Array indexing with a negative index is now detected by this query. |
| Global could be static (`cpp/jpl-c/limited-scope-file` and `cpp/power-of-10/global-could-be-static`)| Fewer false positive results | Variables with declarations in header files are now excluded from results. |
| Memory is never freed (`cpp/memory-never-freed`)| Fewer false positive results | No longer highlights uses of C++ _placement new_, which returns a pointer that does not need to be freed. |
| Negation of unsigned value (`cpp/jsf/av-rule-165`) | Fewer false positive results | Now accounts for explicit casts. |
| Suspicious call to memset (`cpp/suspicious-call-to-memset`) | Fewer false positive results | Types involving `decltype` are now correctly compared. |
| Variable scope too large (`cpp/jpl-c/limited-scope-function` and `cpp/power-of-10/variable-scope-too-large`) | Fewer false positive results | Variables with declarations in header files, or that are used at file scope, are now excluded from results. |

## Changes to QL libraries

* New hash consing library (`semmle.code.cpp.valuenumbering.HashCons`) for structural comparison of expressions. Unlike the existing library for global value numbering, this library implements a pure syntactic comparison of expressions and will equate expressions even if they may not compute the same value.
* The `Buffer.qll` library has more conservative treatment of arrays embedded in structs. This reduces false positive results in a number of security queries, especially `cpp/overflow-buffer`.
    * Pre-C99 encodings of _flexible array members_ are recognized more reliably.
    * Arrays of zero size are now treated as a special case.
* The library `semmle.code.cpp.dataflow.RecursionPrevention` is now deprecated. It was an aid for transitioning data-flow queries from 1.16 to 1.17, and it no longer has any function. Imports of this library should simply be deleted.
