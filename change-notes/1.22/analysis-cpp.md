# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Expression has no effect (`cpp/useless-expression`) | Fewer false positive results | Calls to functions with the `weak` attribute are no longer considered to be side effect free, because they could be overridden with a different implementation at link time. |
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Lower precision | The precision of this query has been reduced to "medium". This coding pattern is used intentionally and safely in a number of real-world projects. Results are no longer displayed on LGTM unless you choose to display them. |

## Changes to QL libraries

- The predicate `Variable.getAnAssignedValue()` now reports assignments to fields resulting from aggregate initialization (` = {...}`).
- The predicate `TypeMention.toString()` has been simplified to always return the string "`type mention`".  This may improve performance when using `Element.toString()` or its descendants.
- Fixed the `LocalScopeVariableReachability.qll` library's handling of loops with an entry condition is both always true upon first entry, and where there is more than one control flow path through the loop condition.  This change increases the accuracy of the `LocalScopeVariableReachability.qll` library and queries which depend on it.
