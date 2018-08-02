import csharp
import semmle.code.csharp.controlflow.ControlFlowElement

from Callable c, ControlFlowElement cfn
where c.getEntryPoint().getASuccessor().getElement() = cfn
select c, cfn
