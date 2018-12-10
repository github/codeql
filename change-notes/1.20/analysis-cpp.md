# Improvements to C/C++ analysis

## General improvements

* The logic for identifying auto-generated files via `#line` directives has been improved.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Fewer false positives | False positives involving types that are not uniquely named in the snapshot have been fixed. |
| Unused static variable (`cpp/unused-static-variable`) | Fewer false positive results | Variables with the attribute `unused` are now excluded from the query. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | Fix false positives where a resource is released via a virtual method call. |

## Changes to QL libraries
