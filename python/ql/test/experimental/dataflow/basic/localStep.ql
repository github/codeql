import semmle.python.dataflow.new.DataFlow

from DataFlow::Node fromNode, DataFlow::Node toNode
where DataFlow::localFlowStep(fromNode, toNode)
select fromNode, toNode
