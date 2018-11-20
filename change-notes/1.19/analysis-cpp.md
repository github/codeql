# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Cast between `HRESULT` and a Boolean type (`cpp/hresult-boolean-conversion`) | external/cwe/cwe-253 | Finds logic errors caused by mistakenly treating the Windows `HRESULT` type as a Boolean instead of testing it with the appropriate macros. Enabled by default. |
| Setting a DACL to `NULL` in a `SECURITY_DESCRIPTOR` (`cpp/unsafe-dacl-security-descriptor`) | external/cwe/cwe-732 | This query finds code that creates world-writable objects on Windows by setting their DACL to `NULL`. Enabled by default. |
| Cast from `char*` to `wchar_t*` | security, external/cwe/cwe-704 | Detects potentially dangerous casts from `char*` to `wchar_t*`.  Enabled by default on LGTM. |
| Dead code due to `goto` or `break` statement (`cpp/dead-code-goto`) | maintainability, external/cwe/cwe-561 | Detects dead code following a goto or break statement. Enabled by default on LGTM. |
| Inconsistent direction of for loop | correctness, external/cwe/cwe-835 | This query detects for loops where the increment and guard condition don't appear to correspond.  Enabled by default on LGTM. |
| Incorrect Not Operator Usage | security, external/cwe/cwe-480 | This query finds uses of the logical not (!) operator that look like they should be bit-wise not (~).  Available but not displayed by default on LGTM. |
| NULL application name with an unquoted path in call to CreateProcess | security, external/cwe/cwe-428 | This query finds unsafe uses of the CreateProcess function.  Available but not displayed by default on LGTM. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Empty branch of conditional | Fewer false positive results | The query now recognizes commented blocks more reliably. |
| Expression has no effect | Fewer false positive results | Expressions in template instantiations are now excluded from this query. |
| Resource not released in destructor | Fewer false positive results | Placement new is now excluded from the query. Also fixed an issue where false positives could occur if the destructor body was not in the snapshot. |
| Missing return statement (`cpp/missing-return`) | Visible by default | The precision of this query has been increased from 'medium' to 'high', which makes it visible by default in LGTM. It was 'medium' in release 1.17 and 1.18 because it had false positives due to an extractor bug that was fixed in 1.18. |
| Missing return statement | Fewer false positive results | The query is now produces correct results when a function returns a template-dependent type. |
| Call to memory access function may overflow buffer | More correct results | Array indexing with a negative index is now detected by this query. |
| Suspicious call to memset | Fewer false positive results | Types involving decltype are now correctly compared. |
| Suspicious add with sizeof | Fewer false positive results | Arithmetic with void pointers (where allowed) is now excluded from this query. |
| Wrong type of arguments to formatting function | Fewer false positive results | False positive results involving typedefs have been removed.  Expected argument types are determined more accurately, especially for wide string and pointer types.  Custom (non-standard) formatting functions are also identified more accurately. |
| Missing return statement | Fewer false positive results | Functions which make a non-returning function call are no longer expected to have a return statement after that call. |
| AV Rule 164 | Fewer false positive results | This query now accounts for explicit casts. |
| Negation of unsigned value | Fewer false positive results | This query now accounts for explicit casts. |
| Variable scope too large | Fewer false positive results | Variables with declarations in header files, or that are used at file scope, are now excluded from this query. |

## Changes to QL libraries

* Added a hash consing library for structural comparison of expressions.
* `getBufferSize` now detects variable size structs more reliably.
* Buffer.qll now treats arrays of zero size as a special case.
