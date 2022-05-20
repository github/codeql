/**
 * @name Calls to unmanaged code
 * @description Finds calls to "extern" methods (which are implemented by unmanaged code).
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/call-to-unmanaged-code
 * @tags reliability
 *       maintainability
 */

import csharp

from Class c, Method m, MethodCall call
where
  m.isExtern() and
  m.getDeclaringType() = c and
  call.getTarget() = m
select call, "Replace this call with a call to managed code if possible."
