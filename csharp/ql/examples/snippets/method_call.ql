/**
 * @id cs/examples/method-call
 * @name Call to method
 * @description Finds calls to method 'Company.Class.MethodName'.
 * @tags call
 *       method
 */

import csharp

from MethodCall call, Method method
where
  call.getTarget() = method and
  method.hasName("MethodName") and
  method.getDeclaringType().hasFullyQualifiedName("Company", "Class")
select call
