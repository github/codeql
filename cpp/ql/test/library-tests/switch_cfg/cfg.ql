import cpp

string successorInfo(ControlFlowNode x) {
  if exists(x.getASuccessor())
  then
    exists(ControlFlowNode y | y = x.getASuccessor() |
      result = y.getLocation().getStartLine().toString() + " " + y.toString()
    )
  else result = "<no successors>"
}

from ControlFlowNode x
select x.getLocation().getStartLine(),
  count(x.getAPredecessor*()), // This helps order things sensibly
  x.toString(), successorInfo(x)
