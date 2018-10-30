import csharp
import semmle.code.csharp.controlflow.ControlFlowElement
import Common

from Callable c, SourceControlFlowElement cfn
where c.getEntryPoint().getASuccessor().getElement() = cfn
select c, cfn
