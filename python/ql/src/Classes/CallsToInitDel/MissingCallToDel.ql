/**
 * @name Missing call to superclass `__del__` during object destruction
 * @description An omitted call to a superclass `__del__` method may lead to class instances not being cleaned up properly.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       performance
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/missing-call-to-delete
 */

import python
import MethodCallOrder

predicate missingCallToSuperclassDel(Function base, Function shouldCall, Class mroStart) {
  missingCallToSuperclassMethod(base, shouldCall, mroStart, "__del__")
}

from Function base, Function shouldCall, Class mroStart, string msg
where
  missingCallToSuperclassDel(base, shouldCall, mroStart) and
  (
    // Simple case: the method that should be called is directly overridden
    mroStart = base.getScope() and
    msg = "This deletion method does not call $@, which may leave $@ not properly cleaned up."
    or
    // Only alert for a different mro base if there are no alerts for direct overrides
    not missingCallToSuperclassDel(base, _, base.getScope()) and
    msg =
      "This deletion method does not call $@, which follows it in the MRO of $@, leaving it not properly cleaned up."
  )
select base, msg, shouldCall, shouldCall.getQualifiedName(), mroStart, mroStart.getName()
