---
category: fix
---
* `Function`'s predicate `getACall` now returns more results in some situations. For a function implementing an interface method, calls to that interface method are now returned for all functions. Previously this only happened if the function was in the source code being analysed.
