import experimental.dataflow.DataFlow

from DataFlow::Node fromNode, DataFlow::Node toNode
where DataFlow::localFlow(fromNode, toNode)
select fromNode, toNode
