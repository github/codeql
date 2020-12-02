import cpp

string getASuccessorOrNone(ControlFlowNode n) {
  if exists(n.getASuccessor()) then result = n.getASuccessor().toString() else result = "None"
}

from ControlFlowNode n
select n.getLocation().getStartLine(),
  count(n.getAPredecessor*()), // This helps order things sensibly
  n, getASuccessorOrNone(n)
