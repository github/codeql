import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

from ConditionBlock cb, BasicBlock controlled, boolean testIsTrue
where cb.controls(controlled, testIsTrue)
select cb.getLastNode(), controlled.getFirstNode(), testIsTrue
