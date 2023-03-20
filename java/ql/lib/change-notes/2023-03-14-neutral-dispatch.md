---
category: majorAnalysis
---
* Removed low-confidence call edges to known neutral call targets from the call graph used in data flow analysis. This includes, for example, custom `List.contains` implementations when the best inferrable type at the call site is simply `List`.
