import javascript

from ExprOrStmt node
where node.(ControlFlowNode).isUnreachable() and not node.isAmbient()
select node
