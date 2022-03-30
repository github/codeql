// Every reachable node has a dominator
import cpp
import semmle.code.cpp.controlflow.Dominance

from Function func, ControlFlowNode dom1, ControlFlowNode dom2, ControlFlowNode node
where
  iDominates(dom1, node) and
  iDominates(dom2, node) and
  dom1 != dom2 and
  node.getControlFlowScope() = func
select func, node, dom1, dom2
