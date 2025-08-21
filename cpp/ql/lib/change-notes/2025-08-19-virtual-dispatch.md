---
category: minorAnalysis
---
* The new dataflow/taint-tracking library (`semmle.code.cpp.dataflow.new.DataFlow` and `semmle.code.cpp.dataflow.new.TaintTracking`) now resolves virtual function calls more precisely. This results in fewer false positives when running dataflow/taint-tracking queries on C++ projects.