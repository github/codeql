/**
 * @id js/examples/methodcall
 * @name Method calls
 * @description Finds calls of the form `this.isMounted(...)`
 * @tags call
 *       method
 */

import javascript

from MethodCallExpr c
where
  c.getReceiver() instanceof ThisExpr and
  c.getMethodName() = "isMounted"
select c
