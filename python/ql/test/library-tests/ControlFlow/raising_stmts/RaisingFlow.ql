/**
 * @name Raising Flow
 * @description Test
 */

import python

from ControlFlowNode p, ControlFlowNode s, string kind
where
  p.getASuccessor() = s and
  (if s = p.getAnExceptionalSuccessor() then kind = "exception" else kind = "  normal ") and
  not p.getNode() instanceof Scope and
  not s.getNode() instanceof Scope
select p.getNode().getLocation().getStartLine(), p.toString(), kind,
  s.getNode().getLocation().getStartLine(), s
