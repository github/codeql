import cpp
import semmle.code.cpp.exprs.ObjectiveC

from ControlFlowNode x, ControlFlowNode y, string entryPoint
where
  y = x.getASuccessor() and
  if exists(Function f | f.getEntryPoint() = x)
  then forex(Function f | f.getEntryPoint() = x | entryPoint = f.toString())
  else entryPoint = "-----"
select x.getLocation().getStartLine(),
  count(x.getAPredecessor*()), // This helps order things sensibly
  x.toString(), entryPoint, y.getLocation().getStartLine(), y.toString()
