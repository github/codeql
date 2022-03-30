# Improvements to C/C++ analysis

The following changes in version 1.26 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Declaration hides parameter (`cpp/declaration-hides-parameter`) | Fewer false positive results | False positives involving template functions have been fixed. |
| Inconsistent direction of for loop (`cpp/inconsistent-loop-direction`) | Fewer false positive results | The query now accounts for intentional wrapping of an unsigned loop counter. |
| Overflow in uncontrolled allocation size (`cpp/uncontrolled-allocation-size`) | | The precision of this query has been decreased from "high" to "medium". As a result, the query is still run but results are no longer displayed on LGTM by default. |
| Comparison result is always the same (`cpp/constant-comparison`) | More correct results | Bounds on expressions involving multiplication can now be determined in more cases. |

## Changes to libraries

* The QL class `Block`, denoting the `{ ... }` statement, is renamed to `BlockStmt`.
* The models library now models many taint flows through `std::array`, `std::vector`, `std::deque`, `std::list` and `std::forward_list`.
* The models library now models many more taint flows through `std::string`.
* The models library now models many taint flows through `std::istream` and `std::ostream`.
* The models library now models some taint flows through `std::shared_ptr`, `std::unique_ptr`, `std::make_shared` and `std::make_unique`.
* The models library now models many taint flows through `std::pair`, `std::map`, `std::unordered_map`, `std::set` and `std::unordered_set`.
* The models library now models `bcopy`.
* The `SimpleRangeAnalysis` library now supports multiplications of the form
  `e1 * e2` and `x *= e2` when `e1` and `e2` are unsigned or constant.
