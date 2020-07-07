import python
import semmle.python.TestUtils

from ControlFlowNode p, ControlFlowNode s, string what
where
  s = p.getAFalseSuccessor() and what = "false"
  or
  s = p.getATrueSuccessor() and what = "true"
  or
  s = p.getAnExceptionalSuccessor() and what = "exceptional"
  or
  s = p.getANormalSuccessor() and what = "normal"
  or
  // Add fake edges for node that raise out of scope
  p.isExceptionalExit(_) and s = p.getScope().getEntryNode() and what = "exit"
select compact_location(p.getNode()), p.getNode().toString(), compact_location(s.getNode()),
  s.getNode().toString(), what
