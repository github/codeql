import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

ControlFlowNode successor(ControlFlowNode node, boolean kind) {
  (kind = true and result = node.getATrueSuccessor()) or
  (kind = false and result = node.getAFalseSuccessor())
}

from ControlFlowNode node, ControlFlowNode successor, Location nl, Location sl, boolean kind
where successor = successor(node, kind)
  and nl = node.getLocation()
  and sl = successor.getLocation()
select
  nl.getStartLine(), nl.getStartColumn(), node, kind,
  sl.getStartLine(), sl.getStartColumn(), successor
