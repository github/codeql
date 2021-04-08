import experimental.dataflow.basic.allFlowsConfig

from DataFlow::PathNode fromNode, DataFlow::PathNode toNode
where
  toNode = fromNode.getASuccessor() and
  fromNode.getNode().getLocation().getFile().getParent().getBaseName() = "fieldflow"
select fromNode, toNode
