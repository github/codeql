# Improvements to Java analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array index out of bounds (`java/index-out-of-bounds`) | Fewer false positive results | False positives involving arrays with a length evenly divisible by 3 or some greater number and an index being increased with a similar stride length are no longer reported. |
| Unreachable catch clause (`java/unreachable-catch-clause`) | Fewer false positive results | This rule now accounts for calls to generic methods that throw generic exceptions. |

## Changes to QL libraries

* The `ParityAnalysis` library is replaced with the more general `ModulusAnalysis` library, which improves the range analysis.

