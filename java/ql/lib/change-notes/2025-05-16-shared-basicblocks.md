---
category: deprecated
---
* Java now uses the shared `BasicBlock` library. This means that several member predicates now use the preferred names. The old predicates have been deprecated. The `BasicBlock` class itself no longer extends `ControlFlowNode` - the predicate `getFirstNode` can be used to fix any QL code that somehow relied on this.
