# Improvements to JavaScript analysis

## General improvements

* Automatic classification of test files has been improved, in particular `__tests__` and `__mocks__` folders (as used by [Jest](https://jestjs.io)) are now recognized.

* Support for the following frameworks and libraries has been improved:
  - [cross-spawn](https://www.npmjs.com/package/cross-spawn)
  - [cross-spawn-async](https://www.npmjs.com/package/cross-spawn-async)
  - [exec](https://www.npmjs.com/package/exec)
  - [execa](https://www.npmjs.com/package/execa)
  - [exec-async](https://www.npmjs.com/package/exec-async)
  - [express](https://www.npmjs.com/package/express)
  - [remote-exec](https://www.npmjs.com/package/remote-exec)

* Support for tracking data flow and taint through getter functions (that is, functions that return a property of one of their arguments) and through the receiver object of method calls has been improved. This may produce more security alerts.

* Taint tracking through object property names has been made more precise, resulting in fewer false positive results.

* Method calls are now resolved in more cases, due to improved class hierarchy analysis. This may produce more security alerts.

* Jump-to-definition now resolves calls to their definition in more cases, and supports jumping from a JSDoc type annotation to its definition.

## New queries

| **Query**                                                                 | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Indirect uncontrolled command line (`js/indirect-command-line-injection`) | correctness, security, external/cwe/cwe-078, external/cwe/cwe-088 | Highlights command-line invocations that may indirectly introduce a command-line injection vulnerability elsewhere, indicating a possible violation of [CWE-78](https://cwe.mitre.org/data/definitions/78.html). Results are not shown on LGTM by default. |


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Conflicting HTML element attributes (`js/conflicting-html-attribute`) | No changes to results | Results are no longer shown on LGTM by default. |
| Shift out of range (`js/shift-out-of-range`| Fewer false positive results | This rule now correctly handles BigInt shift operands. |
| Superfluous trailing arguments (`js/superfluous-trailing-arguments`) | Fewer false-positive results. | This rule no longer flags calls to placeholder functions that trivially throw an exception. |
| Undocumented parameter (`js/jsdoc/missing-parameter`) | No changes to results | This rule is now run on LGTM, although its results are still not shown by default. |
| Missing space in string concatenation (`js/missing-space-in-concatenation`) | Fewer false positive results | The rule now requires a word-like part exists in the string concatenation. | 

## Changes to QL libraries

- The `getName()` predicate on functions and classes now gets a name that is
  inferred from the context if the function or class was not declared with a name.
- The two-argument and three-argument variants of `DataFlow::Configuration::isBarrier` and
  `TaintTracking::Configuration::isSanitizer` have been deprecated. Overriding them no
  longer has any effect. Use `isBarrierEdge` and `isSanitizerEdge` instead.
- The QLDoc for most AST classes have been expanded with concrete syntax examples.
- Tutorials on how to use [flow labels](https://help.semmle.com/QL/learn-ql/javascript/flow-labels.html)
  and [type tracking](https://help.semmle.com/QL/learn-ql/javascript/type-tracking.html) have been published,
  as well as a [data flow cheat sheet](https://help.semmle.com/QL/learn-ql/javascript/dataflow-cheat-sheet.html) for quick reference.
