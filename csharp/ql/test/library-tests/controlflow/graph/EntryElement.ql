import csharp
import Common

predicate first(SourceControlFlowElement cfe, ControlFlowNode first) {
  first.isBefore(cfe)
  or
  exists(ControlFlowNode mid |
    first(cfe, mid) and not mid.injects(_) and first = mid.getASuccessor()
  )
}

from SourceControlFlowElement cfe, ControlFlowElement first
where first(cfe, first.getControlFlowNode())
select cfe, first
