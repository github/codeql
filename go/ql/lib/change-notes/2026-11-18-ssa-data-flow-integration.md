---
category: minorAnalysis
---
* Local SSA data flow now uses the shared `DataFlowIntegration` library. `DataFlow::localFlowStep` and `TaintTracking::localTaintStep` may now step through intermediate SSA phi and synthetic merge-read nodes at control-flow joins rather than directly between uses across branches; `DataFlow::localFlow` reachability and global path explanations are unchanged.
* `DataFlow::SsaNode.getBasicBlock()` now returns the basic block of the underlying SSA definition, and `IR::EvalInstruction.reads` no longer treats `select` receive assignment targets as variable reads.
