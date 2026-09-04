/**
 * Finds expressions in test functions that lack a timer annotation
 * and are not part of the timer mechanism or otherwise excluded.
 * An empty result means every annotatable expression is covered.
 */

import python
import TimerUtils

from TestFunction f, Expr e
where
  e.getScope().getEnclosingScope*() = f and
  not isTimerMechanism(e, f) and
  not isUnannotatable(e)
select e, "Missing annotation in $@", f, f.getName()
