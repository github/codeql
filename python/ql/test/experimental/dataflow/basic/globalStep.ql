import allFlowsConfig

from AllFlowsFlow::PathNode fromNode, AllFlowsFlow::PathNode toNode
where
  toNode = fromNode.getASuccessor() and
  exists(fromNode.getNode().getLocation().getFile().getRelativePath()) and
  exists(toNode.getNode().getLocation().getFile().getRelativePath())
select fromNode, toNode
