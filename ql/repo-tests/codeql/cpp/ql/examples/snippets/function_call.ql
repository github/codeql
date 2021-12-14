/**
 * @id cpp/examples/function-call
 * @name Call to function
 * @description Finds calls to `std::map<...>::find()`
 * @tags call
 *       function
 *       method
 */

import cpp

from FunctionCall call, Function fcn
where
  call.getTarget() = fcn and
  fcn.getDeclaringType().getSimpleName() = "map" and
  fcn.getDeclaringType().getNamespace().getName() = "std" and
  fcn.hasName("find")
select call
