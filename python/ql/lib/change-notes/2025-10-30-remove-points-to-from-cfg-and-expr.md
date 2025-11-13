---
category: breaking
---

- The classes `ControlFlowNode`, `Expr`, and `Module` no longer expose predicates that invoke the points-to analysis. To access these predicates, import the module `LegacyPointsTo` and follow the instructions given therein.
