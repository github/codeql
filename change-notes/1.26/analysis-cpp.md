# Improvements to C/C++ analysis

The following changes in version 1.26 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Inconsistent direction of for loop (`cpp/inconsistent-loop-direction`) | Fewer false positive results | The query now accounts for intentional wrapping of an unsigned loop counter. |
| Overflow in uncontrolled allocation size (`cpp/uncontrolled-allocation-size`) | | The precision of this query has been decreased from "high" to "medium". As a result, the query is still run but results are no longer displayed on LGTM by default. |

## Changes to libraries

