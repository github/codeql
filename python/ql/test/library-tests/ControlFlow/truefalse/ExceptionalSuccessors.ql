/**
 * @name TrueFalseSuccessors Test
 * @description Tests true/false successors
 * @kind table
 * @problem.severity warning
 */

import python

from ControlFlowNode p, ControlFlowNode s
where
  s = p.getAnExceptionalSuccessor()
  or
  // Add fake edges for node that raise out of scope
  p.isExceptionalExit(_) and s = p.getScope().getEntryNode()
select p.getLocation().getFile().getShortName(), p.getLocation().getStartLine(), p, s.toString()
