import experimental.dataflow.basic.allFlowsConfig

from DataFlow::PathNode fromNode, DataFlow::PathNode toNode
where
  toNode = fromNode.getASuccessor() and
  fromNode.getNode().getLocation().getFile().getBaseName() = "test.py" and
  fromNode.getNode().getLocation().getStartLine() > 1 and
  not toNode.getNode().(DataFlow::CfgNode).getNode().isNormalExit()
select fromNode, toNode
