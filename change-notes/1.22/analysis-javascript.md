# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [cross-spawn](https://www.npmjs.com/package/cross-spawn)
  - [cross-spawn-async](https://www.npmjs.com/package/cross-spawn-async)
  - [exec](https://www.npmjs.com/package/exec)
  - [execa](https://www.npmjs.com/package/execa)
  - [exec-async](https://www.npmjs.com/package/exec-async)
  - [express](https://www.npmjs.com/package/express)
  - [remote-exec](https://www.npmjs.com/package/remote-exec)

* Support for tracking data flow and taint through getter functions (that is, functions that return a property of one of their arguments) and through the receiver object of method calls has been improved. This may produce more security alerts.
  
## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
|           |          |             |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Shift out of range | Fewer false positive results | This rule now correctly handles BigInt shift operands. |

## Changes to QL libraries

- `FunctionNode.getName()` and `ClassNode.getName()` now return a name
  inferred from the context if the function or class was not declared with a name.
