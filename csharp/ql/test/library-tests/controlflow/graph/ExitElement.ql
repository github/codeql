import csharp
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl
private import semmle.code.csharp.controlflow.internal.Completion
import Common

from SourceControlFlowElement cfe, Completion c
where cfe.fromSource()
select cfe, last(cfe, c), c
