import default

from BasicBlock b, int i, ControlFlowNode n
where
  b.getNode(i) = n and
  b.getFile().(CompilationUnit).fromSource()
select b, i, n
