/**
 * @name `__init__` method calls overridden method
 * @description Calling a method from `__init__` that is overridden by a subclass may result in a partially
 *              initialized instance being observed.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity low
 * @precision high
 * @id py/init-calls-subclass
 */

import python

from
  ClassObject supercls, string method, Call call, FunctionObject overriding,
  FunctionObject overridden
where
  exists(FunctionObject init, SelfAttribute sa |
    supercls.declaredAttribute("__init__") = init and
    call.getScope() = init.getFunction() and
    call.getFunc() = sa
  |
    sa.getName() = method and
    overridden = supercls.declaredAttribute(method) and
    overriding.overrides(overridden)
  )
select call, "Call to self.$@ in __init__ method, which is overridden by $@.", overridden, method,
  overriding, overriding.descriptiveString()
