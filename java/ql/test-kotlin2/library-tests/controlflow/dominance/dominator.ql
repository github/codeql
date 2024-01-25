import default
import semmle.code.java.controlflow.Dominance

from Method func, ControlFlowNode dominator, ControlFlowNode node
where
  iDominates(dominator, node) and
  dominator.getEnclosingStmt().getEnclosingCallable() = func and
  func.getDeclaringType().hasName("Test")
select dominator, node
