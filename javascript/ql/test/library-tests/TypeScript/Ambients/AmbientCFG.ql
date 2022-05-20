import javascript

from ExprOrStmt node
where node.isAmbient() and not node.isUnreachable()
select node
