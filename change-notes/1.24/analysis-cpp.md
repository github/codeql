# Improvements to C/C++ analysis

The following changes in version 1.24 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

## Changes to QL libraries

* The new class `StackVariable` should be used in place of `LocalScopeVariable`
  in most cases. The difference is that `StackVariable` does not include
  variables declared with `static` or `thread_local`.
  * As a rule of thumb, custom queries about the _values_ of variables should
    be changed from `LocalScopeVariable` to `StackVariable`, while queries
    about the _name or scope_ of variables should remain unchanged.
  * The `LocalScopeVariableReachability` library is deprecated in favor of
    `StackVariableReachability`. The functionality is the same.
