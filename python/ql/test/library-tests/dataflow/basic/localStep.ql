import semmle.python.dataflow.new.DataFlow

from DataFlow::Node fromNode, DataFlow::Node toNode
where
  DataFlow::localFlowStep(fromNode, toNode) and
  exists(fromNode.getLocation().getFile().getRelativePath()) and
  exists(toNode.getLocation().getFile().getRelativePath())
select fromNode, toNode
