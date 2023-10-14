import allFlowsConfig

from DataFlow::PathNode fromNode, DataFlow::PathNode toNode
where
  toNode = fromNode.getASuccessor() and
  exists(fromNode.getNode().getLocation().getFile().getRelativePath()) and
  exists(toNode.getNode().getLocation().getFile().getRelativePath())
select fromNode, toNode
