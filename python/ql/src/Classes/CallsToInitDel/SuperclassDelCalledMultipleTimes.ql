/**
 * @name Multiple calls to `__del__` during object destruction
 * @description A duplicated call to a superclass `__del__` method may lead to class instances not be cleaned up properly.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/multiple-calls-to-delete
 */

import python
import MethodCallOrder

predicate multipleCallsToSuperclassDel(Function meth, Function calledMulti) {
  multipleCallsToSuperclassMethod(meth, calledMulti, "__sel__")
}

from Function meth, Function calledMulti
where
  multipleCallsToSuperclassDel(meth, calledMulti) and
  // Don't alert for multiple calls to a superclass del when a subclass will do.
  not exists(Function subMulti |
    multipleCallsToSuperclassDel(meth, subMulti) and
    calledMulti.getScope() = getADirectSuperclass+(subMulti.getScope())
  )
select meth, "This delete method calls $@ multiple times.", calledMulti,
  calledMulti.getQualifiedName()
