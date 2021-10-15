// Every reachable node has a dominator
import default
import semmle.code.java.controlflow.Dominance

from Method func, ControlFlowNode dom1, ControlFlowNode dom2, ControlFlowNode node
where
  iDominates(dom1, node) and
  iDominates(dom2, node) and
  dom1 != dom2 and
  func = node.getEnclosingStmt().getEnclosingCallable()
select func, node, dom1, dom2
