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

predicate multipleCallsToSuperclassInit(Function meth, Function calledMulti) {
  multipleCallsToSuperclassMethod(meth, calledMulti, "__init__")
}

from Function meth, Function calledMulti
where
  multipleCallsToSuperclassInit(meth, calledMulti) and
  // Don't alert for multiple calls to a superclass init when a subclass will do.
  not exists(Function subMulti |
    multipleCallsToSuperclassInit(meth, subMulti) and
    calledMulti.getScope() = getADirectSuperclass+(subMulti.getScope())
  )
select meth, "This initialization method calls $@ multiple times.", calledMulti,
  calledMulti.getQualifiedName()
