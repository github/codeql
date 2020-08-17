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
| Comparison result is always the same (`cpp/constant-comparison`) | More correct results | Bounds on expressions involving multiplication can now be determined in more cases. |

## Changes to libraries

* The models library now models many more taint flows through `std::string`.
* The `SimpleRangeAnalysis` library now supports multiplications of the form
  `e1 * e2` when `e1` and `e2` are unsigned.
