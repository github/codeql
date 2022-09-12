---
category: minorAnalysis
---
* `getStarArg` member-predicate on `Call` and `CallNode` has been changed for calls that have multiple `*args` arguments (for example `func(42, *my_args, *other_args)`): Instead of producing no results, it will always have a result for the _first_ such `*args` argument.
