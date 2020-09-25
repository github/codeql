import python
import experimental.dataflow.DataFlow

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where
  DataFlow::localFlowStep(nodeFrom, nodeTo) and
  nodeFrom.getLocation().getFile().getParent().getBaseName() = "fieldflow"
select nodeFrom, nodeTo
