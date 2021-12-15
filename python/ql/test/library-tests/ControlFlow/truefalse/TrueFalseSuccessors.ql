/**
 * @name TrueFalseSuccessors Test
 * @description Tests true/false successors
 * @kind table
 * @problem.severity warning
 */

import python

from ControlFlowNode p, ControlFlowNode s, string which
where
  s = p.getAFalseSuccessor() and which = "False"
  or
  s = p.getATrueSuccessor() and which = "True"
select p.getLocation().getFile().getShortName(), p.getLocation().getStartLine(), p, s.toString(),
  which
