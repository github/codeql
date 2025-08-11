---
category: minorAnalysis
---
* Improved dataflow through global variables in the new dataflow library (`semmle.code.cpp.dataflow.new.DataFlow` and `semmle.code.cpp.dataflow.new.TaintTracking`). Queries based on these libraries will produce more results on codebases with many global variables.