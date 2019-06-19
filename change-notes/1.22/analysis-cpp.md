# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Suspicious pointer scaling (`cpp/suspicious-pointer-scaling`) | Lower precision | The precision of this query has been reduced to "medium". This coding pattern is used intentionally and safely in a number of real-world projects. Results are no longer displayed on LGTM unless you choose to display them. |

## Changes to QL libraries

- The predicate `Variable.getAnAssignedValue()` now reports assignments to fields resulting from aggregate initialization (` = {...}`).
- The predicate `TypeMention.toString()` has been simplified to always return the string "`type mention`".  This may improve performance when using `Element.toString()` or its descendants.
- The `semmle.code.cpp.security.TaintTracking` library now considers a pointer difference calculation as blocking taint flow.
- Fixed the `LocalScopeVariableReachability.qll` library's handling of loops with an entry condition is both always true upon first entry, and where there is more than one control flow path through the loop condition.  This change increases the accuracy of the `LocalScopeVariableReachability.qll` library and queries which depend on it.
