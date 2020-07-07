import allFlowsConfig

from DataFlow::PathNode fromNode, DataFlow::PathNode toNode
where toNode = fromNode.getASuccessor()
select fromNode, toNode
