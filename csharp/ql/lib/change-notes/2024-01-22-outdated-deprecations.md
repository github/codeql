---
category: minorAnalysis
---
* Deleted many deprecated predicates and classes with uppercase `SSL`, `XML`, `URI`, `SSA` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getALocalFlowSucc` predicate and `TaintType` class from the dataflow library.
* Deleted the deprecated `Newobj` and `Rethrow` classes, use `NewObj` and `ReThrow` instead.
* Deleted the deprecated `getAFirstRead`, `hasAdjacentReads`, `lastRefBeforeRedef`, and `hasLastInputRef` predicates from the SSA library.
* Deleted the deprecated `getAReachableRead` predicate from the `AssignableRead` and `VariableRead` classes.
* Deleted the deprecated `hasQualifiedName` predicate from the `NamedElement` class.
