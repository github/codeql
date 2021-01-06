import csharp
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl
private import semmle.code.csharp.controlflow.internal.Completion
import Common

from SourceControlFlowElement cfe, ControlFlowElement last, Completion c
where last(cfe, last, c)
select cfe, last, c
