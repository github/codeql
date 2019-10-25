import cpp
import semmle.code.cpp.dataflow.DataFlow

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where
  DataFlow::localFlowStep(nodeFrom, nodeTo) and
  nodeFrom.getFunction().getName().matches("%\\_with\\_local\\_flow")
select nodeFrom, nodeTo
