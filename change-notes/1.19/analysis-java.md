# Improvements to Java analysis

## General improvements

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
| Unreachable catch clause (`java/unreachable-catch-clause`) | Fewer false-positive results | This rule now accounts for calls to generic methods that throw generic exceptions. |

## Changes to QL libraries

