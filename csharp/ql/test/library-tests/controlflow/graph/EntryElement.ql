import csharp
import Common
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl

from SourceControlFlowElement cfe
where cfe.fromSource()
select cfe, first(cfe)
