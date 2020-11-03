import python
import semmle.python.dataflow.new.DataFlow

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where
  DataFlow::localFlowStep(nodeFrom, nodeTo) and
  nodeFrom.getEnclosingCallable().getName().matches("%\\_with\\_local\\_flow")
select nodeFrom, nodeTo
