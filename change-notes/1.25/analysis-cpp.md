# Improvements to C/C++ analysis

The following changes in version 1.25 affect C/C++ analysis in all applications.

## General improvements


## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

## Changes to libraries

* The security pack taint tracking library (`semmle.code.cpp.security.TaintTracking`) now considers that equality checks may block the flow of taint.  This results in fewer false positive results from queries that use this library.
