# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Fewer false positives | False positives involving types that are not uniquely named in the snapshot have been fixed. |
| Unused static variable (`cpp/unused-static-variable`) | Fewer false positive results | Variables with the attribute `unused` are now excluded from the query. |

## Changes to QL libraries
