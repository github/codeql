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
| Useless comparison test (`java/constant-comparison`) | Fewer false positive results | Constant comparisons guarding `java.util.ConcurrentModificationException` are no longer reported, as they are intended to always be false in the absence of API misuse. |

## Changes to QL libraries

* The default set of taint sources in the `FlowSources` library is extended to
  cover parameters annotated with Spring framework annotations indicating
  remote user input from servlets. This affects all security queries, which
  will yield additional results on projects using the Spring Web framework.
* The `ParityAnalysis` library is replaced with the more general `ModulusAnalysis` library, which improves the range analysis.

