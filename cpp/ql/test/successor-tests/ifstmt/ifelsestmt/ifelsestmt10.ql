/**
 * @name ifelsestmt10
 * @description Control flow test for always_true_2.
 */

import cpp

from Function f, ControlFlowNode n, ControlFlowNode s, int fStart, int nOffset, int sOffset
where
  f.hasName("always_true_2") and
  f = n.getControlFlowScope() and
  s = n.getASuccessor() and
  fStart = f.getLocation().getStartLine() and
  (
    if n.getLocation() instanceof UnknownLocation
    then nOffset = -1
    else nOffset = n.getLocation().getStartLine() - fStart
  ) and
  (
    if s.getLocation() instanceof UnknownLocation
    then sOffset = -1
    else sOffset = s.getLocation().getStartLine() - fStart
  )
select nOffset, n, sOffset, s
