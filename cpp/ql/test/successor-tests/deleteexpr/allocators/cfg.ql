import cpp

from ControlFlowNode node
where node.getControlFlowScope().getName() = "main"
select node, node.getASuccessor()
