# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Cast between HRESULT and a Boolean type (`cpp/hresult-boolean-conversion`) | external/cwe/cwe-253 | Finds logic errors caused by mistakenly treating the Windows `HRESULT` type as a Boolean instead of testing it with the appropriate macros. Enabled by default. |
| Setting a DACL to `NULL` in a `SECURITY_DESCRIPTOR` (`cpp/unsafe-dacl-security-descriptor`) | external/cwe/cwe-732 | This query finds code that creates world-writable objects on Windows by setting their DACL to `NULL`. Enabled by default. |
| Cast from char* to wchar_t* | security, external/cwe/cwe-704 | Detects potentially dangerous casts from char* to wchar_t*.  Enabled by default on LGTM. |
| Dead code due to goto or break statement (`cpp/dead-code-goto`) | maintainability, external/cwe/cwe-561 | Detects dead code following a goto or break statement. Enabled by default on LGTM. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Resource not released in destructor | Fewer false positive results | Placement new is now excluded from the query. |
| Missing return statement (`cpp/missing-return`) | Visible by default | The precision of this query has been increased from 'medium' to 'high', which makes it visible by default in LGTM. It was 'medium' in release 1.17 and 1.18 because it had false positives due to an extractor bug that was fixed in 1.18. |
| Call to memory access function may overflow buffer | More correct results | Array indexing with a negative index is now detected by this query. |
| Suspicious add with sizeof | Fewer false positive results | Arithmetic with void pointers (where allowed) is now excluded from this query. |
| Wrong type of arguments to formatting function | Fewer false positive results | False positive results involving typedefs have been removed.  Expected argument types are determined more accurately, especially for wide string and pointer types.  Custom (non-standard) formatting functions are also identified more accurately. |

## Changes to QL libraries

* Added a hash consing library for structural comparison of expressions.
