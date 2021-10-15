import default

from BasicBlock b, ControlFlowNode n, int i
where
  b.getNode(i) = n and
  b.getFile().(CompilationUnit).fromSource()
select b, n, i
