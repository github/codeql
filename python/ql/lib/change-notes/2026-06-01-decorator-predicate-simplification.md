---
category: minorAnalysis
---
* Simplified the internal predicates that detect `@staticmethod`, `@classmethod` and `@property` decorators to match the decorator's AST `Name` directly, rather than going through the CFG and requiring the name to resolve globally. Code that shadows these three builtin decorators at the module-scope will now be classified by the decorator name alone; in practice, shadowing these names is extremely rare and the call-graph results are unchanged.
