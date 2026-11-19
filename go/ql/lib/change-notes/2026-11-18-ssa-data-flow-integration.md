---
category: minorAnalysis
---
* Local SSA data flow now uses the shared `DataFlowIntegration` library. `DataFlow::localFlowStep` and `TaintTracking::localTaintStep` may now step through intermediate SSA phi and synthetic merge-read nodes at control-flow joins rather than directly between uses across branches. Local flow can also enter uncertain SSA definitions of captured variables from preceding definitions or reads. Phi and synthetic merge-read nodes are hidden from global path explanations.
* `DataFlow::SsaNode.getBasicBlock()` now returns the basic block of the underlying SSA definition, and `IR::EvalInstruction.reads` no longer treats `select` receive assignment targets as variable reads.
