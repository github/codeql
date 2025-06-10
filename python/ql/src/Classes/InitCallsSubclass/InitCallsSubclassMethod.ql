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

predicate initSelfCall(Function init, DataFlow::MethodCallNode call) {
  init.isInitMethod() and
  call.getScope() = init and
  exists(DataFlow::Node self, DataFlow::ParameterNode selfArg |
    call.calls(self, _) and
    selfArg.getParameter() = init.getArg(0) and
    DataFlow::localFlow(selfArg, self)
  )
}

predicate initSelfCallOverridden(
  Function init, DataFlow::MethodCallNode call, Function target, Function override
) {
  init.isInitMethod() and
  call.getScope() = init and
  exists(Class superclass, Class subclass, DataFlow::Node self, DataFlow::ParameterNode selfArg |
    superclass = init.getScope() and
    subclass = override.getScope() and
    subclass = getADirectSubclass+(superclass) and
    selfArg.getParameter() = init.getArg(0) and
    DataFlow::localFlow(selfArg, self) and
    call.calls(self, override.getName()) and
    target = superclass.getAMethod() and
    target.getName() = override.getName() and
    not lastUse(self)
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

from Function init, DataFlow::MethodCallNode call, Function target, Function override
where
  initSelfCallOverridden(init, call, target, override) and
  readsFromSelf(override) and
  not isClassmethod(override)
select call, "This call to $@ in an initialization method is overridden by $@.", target,
  target.getQualifiedName(), override, override.getQualifiedName()
