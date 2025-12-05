---
category: breaking
---

* All modules that depend on the points-to analysis have now been removed from the top level `python.qll` module. To access the points-to functionality, import the new `LegacyPointsTo` module. This also means that some predicates have been removed from various classes, for instance `Function.getFunctionObject()`. To access these predicates, import the `LegacyPointsTo` module and use the `FunctionWithPointsTo` class instead. Most cases follow this pattern, but there are a few exceptions:
  * The `getLiteralObject` method on `ImmutableLiteral` subclasses has been replaced with a predicate `getLiteralObject(ImmutableLiteral l)` in the `LegacyPointsTo` module.
  * The `getMetrics` method on `Function`, `Class`, and `Module` has been removed. To access metrics, import `LegacyPointsTo` and use the classes `FunctionMetrics`, etc. instead.
