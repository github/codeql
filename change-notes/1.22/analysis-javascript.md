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
  
## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
|           |          |             |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Shift out of range | Fewer false positive results | This rule now correctly handles BigInt shift operands. |

## Changes to QL libraries

- The `getName()` predicate on functions and classes now gets a name
  inferred from the context if the function or class was not declared with a name.
