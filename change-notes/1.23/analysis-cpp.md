# Improvements to C/C++ analysis

The following changes in version 1.23 affect C/C++ analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) | reliability, japanese-era | This query is a combination of two old queries that were identical in purpose but separate as an implementation detail.  This new query replaces Hard-coded Japanese era start date in call (`cpp/japanese-era/constructor-or-method-with-exact-era-date`) and Hard-coded Japanese era start date in struct (`cpp/japanese-era/struct-with-exact-era-date`). Results are not shown on LGTM by default. |
| Pointer overflow check (`cpp/pointer-overflow-check`) | correctness, security | Finds overflow checks that rely on pointer addition to overflow, which has undefined behavior. Example: `ptr + a < ptr`. Results are shown on LGTM by default. |
| Signed overflow check (`cpp/signed-overflow-check`) | correctness, security | Finds overflow checks that rely on signed integer addition to overflow, which has undefined behavior. Example: `a + b < a`. Results are shown on LGTM by default. |


## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Comparison of narrow type with wide type in loop condition (`cpp/comparison-with-wider-type`) | Higher precision | The precision of this query has been increased to "high" as the alerts from this query have proved to be valuable on real-world projects. With this precision, results are now displayed by default in LGTM. |
| Hard-coded Japanese era start date in call (`cpp/japanese-era/constructor-or-method-with-exact-era-date`) | Deprecated | This query has been deprecated.  Use the new combined query Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) instead. |
| Hard-coded Japanese era start date in struct (`cpp/japanese-era/struct-with-exact-era-date`) | Deprecated | This query has been deprecated.  Use the new combined query Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) instead. |
| Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) | More correct results | This query now checks for the beginning date of the Reiwa era (1st May 2019). |
| Non-constant format string (`cpp/non-constant-format`) | Fewer false positive results | Fixed false positive results triggrered by mismatching declarations of a formatting function. |
| Sign check of bitwise operation (`cpp/bitwise-sign-check`) | Fewer false positive results | Results involving `>=` or `<=` are no longer reported. |
| Too few arguments to formatting function (`cpp/wrong-number-format-arguments`) | Fewer false positive results | Fixed false positive results triggered by mismatching declarations of a formatting function. |
| Too many arguments to formatting function (`cpp/too-many-format-arguments`) | Fewer false positive results | Fixed false positive results triggered by mismatching declarations of a formatting function. |
| Unclear comparison precedence (`cpp/comparison-precedence`) | Fewer false positive results | False positive results involving template classes and functions have been fixed. |
| Wrong type of arguments to formatting function (`cpp/wrong-type-format-argument`) | More correct results and fewer false positive results | This query now understands explicitly-specified argument numbers in format strings, such as the `1$` in `%1$s`. |

## Changes to libraries

* The data-flow library in `semmle.code.cpp.dataflow.DataFlow` and
  `semmle.code.cpp.dataflow.TaintTracking` have had extensive changes:
  * Data flow through fields is now more complete and reliable.
  * The data-flow library has been extended with a new feature to aid debugging. 
    Previously, to explore the possible flow from all sources you could specify `isSink(Node n) { any() }` on a configuration. 
    Now you can use the new `Configuration::hasPartialFlow` predicate, 
    which gives a more complete picture of the partial flow paths from a given source, including flow that doesn't reach any sink.
    The feature is disabled by default and can be enabled for individual configurations by overriding `int explorationLimit()`.
  * There is now flow out of C++ reference parameters.
  * There is now flow through the address-of operator (`&`).
  * The `DataFlow::DefinitionByReferenceNode` class now considers `f(x)` to be a
    definition of `x` when `x` is a variable of pointer type. It no longer
    considers deep paths such as `f(&x.myField)` to be definitions of `x`. These
    changes are in line with the user expectations we've observed.
  * It's now easier to specify barriers/sanitizers
    arising from guards by overriding the predicate
    `isBarrierGuard`/`isSanitizerGuard` on data-flow and taint-tracking
    configurations respectively.
  * There is now a `DataFlow::localExprFlow` predicate and a
    `TaintTracking::localExprTaint` predicate to make it easy to use the most
    common case of local data flow and taint: from one `Expr` to another.
* The member predicates of the `FunctionInput` and `FunctionOutput` classes have been renamed for
  clarity (for example, `isOutReturnPointer()` to `isReturnValueDeref()`). The existing member predicates
  have been deprecated, and will be removed in a future release. Code that uses the old member
  predicates should be updated to use the corresponding new member predicate.
* The predicate `Declaration.hasGlobalOrStdName` has been added, making it
  easier to recognize C library functions called from C++.
* The control-flow graph is now computed in QL, not in the extractor. This can
  lead to changes in how queries are optimized because
  optimization in QL relies on static size estimates, and the control-flow edge
  relations will now have different size estimates than before.
* Support has been added for non-type template arguments.  This means that the
  return type of `Declaration::getTemplateArgument()` and
  `Declaration::getATemplateArgument` have changed to `Locatable`.  For details, see the
  CodeQL library documentation for `Declaration::getTemplateArgument()` and
  `Declaration::getTemplateArgumentKind()`.
