/**
 * @name Multiple calls to `__init__` during object initialization
 * @description A duplicated call to a superclass `__init__` method may lead to objects of this class not being properly initialized.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/multiple-calls-to-init
 */

import python
import MethodCallOrder

predicate multipleCallsToSuperclassInit(
  Function meth, Function calledMulti, DataFlow::MethodCallNode call1,
  DataFlow::MethodCallNode call2
) {
  multipleCallsToSuperclassMethod(meth, calledMulti, call1, call2, "__init__")
}

from
  Function meth, Function calledMulti, DataFlow::MethodCallNode call1,
  DataFlow::MethodCallNode call2, Function target1, Function target2, string msg
where
  multipleCallsToSuperclassInit(meth, calledMulti, call1, call2) and
  // Only alert for the lowest method in the hierarchy that both calls will call.
  not exists(Function subMulti |
    multipleCallsToSuperclassInit(meth, subMulti, _, _) and
    calledMulti.getScope() = getADirectSuperclass+(subMulti.getScope())
  ) and
  target1 = getDirectSuperCallTargetFromCall(meth.getScope(), meth, call1, _) and
  target2 = getDirectSuperCallTargetFromCall(meth.getScope(), meth, call2, _) and
  (
    target1 != target2 and
    msg =
      "This initialization method calls $@ multiple times, via $@ and $@, resolving to $@ and $@ respectively."
    or
    target1 = target2 and
    // The targets themselves are called multiple times (either is calledMulti, or something earlier in the MRO)
    // Mentioning them again would be redundant.
    msg = "This initialization method calls $@ multiple times, via $@ and $@."
  )
select meth, msg, calledMulti, calledMulti.getQualifiedName(), call1, "this call", call2,
  "this call", target1, target1.getQualifiedName(), target2, target2.getQualifiedName()
