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
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate initSelfCallOverridden(
  Function init, DataFlow::Node self, DataFlow::MethodCallNode call, Function target,
  Function override
) {
  init.isInitMethod() and
  call.getScope() = init and
  exists(Class superclass, Class subclass, DataFlow::ParameterNode selfArg |
    superclass = init.getScope() and
    subclass = override.getScope() and
    subclass = getADirectSubclass+(superclass) and
    selfArg.getParameter() = init.getArg(0) and
    DataFlow::localFlow(selfArg, self) and
    call.calls(self, override.getName()) and
    target = superclass.getAMethod() and
    target.getName() = override.getName()
  )
}

predicate lastUse(DataFlow::Node node) {
  not exists(DataFlow::Node next | DataFlow::localFlow(node, next) and node != next)
}

predicate readsFromSelf(Function method) {
  exists(DataFlow::ParameterNode self, DataFlow::Node sink |
    self.getParameter() = method.getArg(0) and
    DataFlow::localFlow(self, sink)
  |
    sink instanceof DataFlow::ArgumentNode
    or
    sink = any(DataFlow::AttrRead a).getObject()
  )
}

from
  Function init, DataFlow::Node self, DataFlow::MethodCallNode call, Function target,
  Function override
where
  initSelfCallOverridden(init, self, call, target, override) and
  readsFromSelf(override) and
  not isClassmethod(override) and
  not lastUse(self) and
  not target.getName().matches("\\_%")
select call, "This call to $@ in an initialization method is overridden by $@.", target,
  target.getQualifiedName(), override, override.getQualifiedName()
