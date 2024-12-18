import default

from BasicBlock b, int i, ControlFlowNode n
where
  b.getNode(i) = n and
  b.getLocation().getFile().(CompilationUnit).fromSource()
select b, i, n
