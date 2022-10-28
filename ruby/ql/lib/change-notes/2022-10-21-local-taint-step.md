---
 category: minorAnalysis
---
 * There was a bug in `TaintTracking::localTaint` and `TaintTracking::localTaintStep` such that they only tracked non-value-preserving flow steps. They have been fixed and now also include value-preserving steps.