# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Mismatching new/free or malloc/delete (`cpp/new-free-mismatch`) | Fewer false positive results | Fixed an issue where functions were being identified as allocation functions inappropriately.  Also affects `cpp/new-array-delete-mismatch` and `cpp/new-delete-array-mismatch`. |
| Memory may not be freed (`cpp/memory-may-not-be-freed`) | More correct results | Support added for more Microsoft-specific allocation functions, including `LocalAlloc`, `GlobalAlloc`, `HeapAlloc` and `CoTaskMemAlloc`. |
| Memory is never freed (`cpp/memory-never-freed`) | More correct results | Support added for more Microsoft-specific allocation functions, including `LocalAlloc`, `GlobalAlloc`, `HeapAlloc` and `CoTaskMemAlloc`. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | Resource allocation and deallocation functions are now determined more accurately. |

## Changes to QL libraries
