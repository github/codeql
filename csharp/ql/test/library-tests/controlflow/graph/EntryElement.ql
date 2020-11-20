import csharp
import Common
import ControlFlow::Internal

from SourceControlFlowElement cfe
where cfe.fromSource()
select cfe, first(cfe)
