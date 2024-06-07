import semmle.python.dataflow.new.DataFlow

from DataFlow::Node fromNode, DataFlow::Node toNode
where
  DataFlow::localFlow(fromNode, toNode) and
  exists(fromNode.getLocation().getFile().getRelativePath()) and
  exists(toNode.getLocation().getFile().getRelativePath())
select fromNode, toNode
