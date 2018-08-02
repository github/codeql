import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

from FinallySplitControlFlowNode f
select f.getTryStmt(), f
