---
category: minorAnalysis
---
* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.
* Deleted the deprecated `getAUse`, `getAnImmediateUse`, `getARhs`, and `getAValueReachingRhs` predicates from the `API::Node` class.
* Deleted the deprecated `fullyQualifiedToAPIGraphPath` class from `SubclassFinder.qll`, use `fullyQualifiedToApiGraphPath` instead.
* Deleted the deprecated `Paths.qll` file.
* Deleted the deprecated `semmle.python.security.performance` folder, use `semmle.python.security.regexp` instead.
* Deleted the deprecated `semmle.python.security.strings` and `semmle.python.web` folders.
