import default

from BasicBlock b, ControlFlowNode n, int i
where
  b.getNode(i) = n and
  b.getEnclosingCallable().getFile().(CompilationUnit).fromSource()
select b, i, n
