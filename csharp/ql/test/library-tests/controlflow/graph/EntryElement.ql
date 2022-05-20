import csharp
import Common
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl

from SourceControlFlowElement cfe, ControlFlowElement first
where first(cfe, first)
select cfe, first
