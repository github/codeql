import cpp

string getASuccessorOrNone(ControlFlowNode n) {
  if exists(n.getASuccessor())
  then
    exists(ControlFlowNode s, string trueSucc, string falseSucc |
      s = n.getASuccessor() and
      (if s = n.getATrueSuccessor() then trueSucc = "<true> " else trueSucc = "") and
      (if s = n.getAFalseSuccessor() then falseSucc = "<false> " else falseSucc = "") and
      result = trueSucc + falseSucc + s.toString()
    )
  else result = "<none>"
}

from ControlFlowNode n
select n.getLocation().getFile().getShortName(), n.getControlFlowScope(),
  n.getLocation().getStartLine(), count(n.getAPredecessor*()), // This helps order things sensibly
  n.getLocation(), n, getASuccessorOrNone(n)
