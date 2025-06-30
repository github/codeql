/**
 * @name Missing call to superclass `__init__` during object initialization
 * @description An omitted call to a super-class `__init__` method may lead to objects of this class not being fully initialized.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/missing-call-to-init
 */

import python
import MethodCallOrder

predicate missingCallToSuperclassInit(Function base, Function shouldCall, Class mroStart) {
  missingCallToSuperclassMethod(base, shouldCall, mroStart, "__init__")
}

from Function base, Function shouldCall, Class mroStart, string msg
where
  missingCallToSuperclassInit(base, shouldCall, mroStart) and
  (
    // Simple case: the method that should be called is directly overridden
    mroStart = base.getScope() and
    msg = "This initialization method does not call $@, which may leave $@ partially initialized."
    or
    // Only alert for a different mro base if there are no alerts for direct overrides
    not missingCallToSuperclassInit(base, _, base.getScope()) and
    msg =
      "This initialization method does not call $@, which follows it in the MRO of $@, leaving it partially initialized."
  )
select base, msg, shouldCall, shouldCall.getQualifiedName(), mroStart, mroStart.getName()
