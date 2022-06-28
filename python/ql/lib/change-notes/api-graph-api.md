---
category: library
---

* The documentation of API graphs (the `API` module) has been expanded, and some of the members predicates of `API::Node`
  have been renamed as follows:
  - `getAnImmediateUse` -> `asSource`
  - `getARhs` -> `asSink`
  - `getAUse` -> `getAValueReachableFromSource`
  - `getAValueReachingRhs` -> `getAValueReachingSink`
