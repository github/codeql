# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Cast between HRESULT and a Boolean type (`cpp/hresult-boolean-conversion`) | external/cwe/cwe-253 | Finds logic errors caused by mistakenly treating the Windows `HRESULT` type as a Boolean instead of testing it with the appropriate macros. Enabled by default. |
| Setting a DACL to `NULL` in a `SECURITY_DESCRIPTOR` (`cpp/unsafe-dacl-security-descriptor`) | external/cwe/cwe-732 | This query finds code that creates world-writable objects on Windows by setting their DACL to `NULL`. Enabled by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Resource not released in destructor | Fewer false positive results | Placement new is now excluded from the query. |


## Changes to QL libraries

* Added a hash consing library for structural comparison of expressions.
