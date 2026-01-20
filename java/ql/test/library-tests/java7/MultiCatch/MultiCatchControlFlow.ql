import default

from ControlFlowNode n
where n.getEnclosingCallable().getCompilationUnit().fromSource()
select n, n.getASuccessor()
