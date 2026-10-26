import javascript

from ControlFlowNode nd, ControlFlowNode succ
where succ = nd.getASuccessor()
select nd.getLocation().getFile().getStem(), nd.getLocation().getStartLine(),
  nd.describeControlFlowNode(), succ.getLocation().getStartLine(), succ.describeControlFlowNode()
