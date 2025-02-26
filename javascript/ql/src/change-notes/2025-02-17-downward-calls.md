---
category: majorAnalysis
---
* Improved call resolution logic to better handle calls resolving "downwards", targeting
  a method declared in a subclass of the enclosing class. Data flow analysis
  has also improved to avoid spurious flow between unrelated classes in the class hierarchy.
