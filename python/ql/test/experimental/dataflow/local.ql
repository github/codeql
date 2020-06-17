import python
import semmle.code.python.dataflow.DataFlow

from
  DataFlow::Node fromNode,
  DataFlow::Node toNode
where
  DataFlow::localFlowStep(fromNode, toNode)
select
  fromNode, toNode
