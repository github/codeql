import java
import semmle.code.java.controlflow.Dominance

from IfStmt i, BlockStmt b
where
  b = i.getThen() and
  dominates(i.getThen().getControlFlowNode(), b.getControlFlowNode()) and
  dominates(i.getElse().getControlFlowNode(), b.getControlFlowNode())
select i, b
