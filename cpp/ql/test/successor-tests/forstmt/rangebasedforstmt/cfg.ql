import cpp

int getCFLine(ControlFlowNode n) {
  if n instanceof Function
  then
    // Functions appear at the end of the control flow, so we get
    // nicer results if we take the last position in the function,
    // rather than the function's position (which is the start).
    result = max(ControlFlowNode c | c.getControlFlowScope() = n | c.getLocation().getStartLine())
  else result = n.getLocation().getStartLine()
}

string getASuccessorOrNone(ControlFlowNode n) {
  if exists(n.getASuccessor())
  then
    exists(ControlFlowNode s, string trueSucc, string falseSucc |
      s = n.getASuccessor() and
      (if s = n.getATrueSuccessor() then trueSucc = "<true> " else trueSucc = "") and
      (if s = n.getAFalseSuccessor() then falseSucc = "<false> " else falseSucc = "") and
      result = trueSucc + falseSucc + getCFLine(s) + ": " + s.toString()
    )
  else result = "<none>"
}

from ControlFlowNode n
select n.getLocation().getFile().getShortName(), n.getControlFlowScope(), getCFLine(n),
  count(n.getAPredecessor*()), // This helps order things sensibly
  n.getLocation(), n, getASuccessorOrNone(n)
