import cpp
import semmle.code.cpp.dataflow.TaintTracking

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string msg
where
  TaintTracking::localTaintStep(nodeFrom, nodeTo) and
  if DataFlow::localFlowStep(nodeFrom, nodeTo) then msg = "" else msg = "TAINT"
select nodeFrom, nodeTo, msg
