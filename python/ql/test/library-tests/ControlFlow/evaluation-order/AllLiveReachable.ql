/**
 * Checks that every live (non-dead) annotation in the test function's
 * own scope is reachable from the function entry in the CFG.
 * Annotations in nested scopes (generators, async, lambdas, comprehensions)
 * have separate CFGs and are excluded from this check.
 */

import python
import TimerUtils

from TimerCfgNode a, TestFunction f
where
  not a.isDead() and
  f = a.getTestFunction() and
  a.getScope() = f and
  not f.getEntryNode().getBasicBlock().reaches(a.getBasicBlock())
select a, "Unreachable live annotation; entry of $@ does not reach this node", f, f.getName()
