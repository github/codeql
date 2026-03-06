import java
import utils.test.AstCfg

from ControlFlowNode n, ControlFlowNode m
where
  m = getAnAstSuccessor(n) and
  n.getLocation().getFile().(CompilationUnit).fromSource()
select n, n.getAstNode().getPrimaryQlClasses(), m, m.getAstNode().getPrimaryQlClasses()

query predicate missingSuccessor(Expr e) {
  exists(ControlFlowNode n | n = e.getControlFlowNode() and not exists(n.getASuccessor())) and
  e.getFile().(CompilationUnit).fromSource() and
  not e instanceof TypeAccess and
  not e instanceof VarWrite
}
