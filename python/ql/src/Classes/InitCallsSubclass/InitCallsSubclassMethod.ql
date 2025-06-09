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

predicate initSelfCallOverridden(Function init, DataFlow::MethodCallNode call, Function override) {
  initSelfCall(init, call) and
  exists(Class superclass, Class subclass |
    superclass = init.getScope() and
    subclass = override.getScope() and
    subclass = getADirectSubclass+(superclass) and
    call.calls(_, override.getName())
  )
}

from Function init, DataFlow::MethodCallNode call, Function override
where initSelfCallOverridden(init, call, override)
select call,
  "This call to " + override.getName() + " in initialization method is overridden by " +
    override.getScope().getName() + ".$@.", override, override.getName()
