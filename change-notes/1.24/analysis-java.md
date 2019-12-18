# Improvements to Java analysis

The following changes in version 1.24 affect Java analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Expression always evaluates to the same value (`java/evaluation-to-constant`) | Fewer false positives | Expressions of the form `0 * x` are usually intended and no longer reported. |

## Changes to libraries

