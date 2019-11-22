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
| No space for zero terminator (`cpp/no-space-for-terminator`) | Fewer false positive results | This query has been modified to be more conservative when identifying which pointers point to null-terminated strings.  This approach produces fewer, more accurate results. |

## Changes to libraries

* Created the `semmle.code.cpp.models.interfaces.Allocation` library to model allocation such as `new` expressions and calls to `malloc`. This in intended to replace the functionality in `semmle.code.cpp.commons.Alloc` with a more consistent and useful interface.
* Created the `semmle.code.cpp.models.interfaces.Deallocation` library to model deallocation such as `delete` expressions and calls to `free`. This in intended to replace the functionality in `semmle.code.cpp.commons.Alloc` with a more consistent and useful interface.
