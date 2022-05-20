import default

from ControlFlowNode n
where n.getEnclosingStmt().getCompilationUnit().fromSource()
select n, n.getASuccessor()
