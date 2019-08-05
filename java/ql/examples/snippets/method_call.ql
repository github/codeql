/**
 * @id java/examples/method-call
 * @name Call to method
 * @description Finds calls to com.example.Class.methodName
 * @tags call
 *       method
 */

import java

from MethodAccess call, Method method
where
  call.getMethod() = method and
  method.hasName("methodName") and
  method.getDeclaringType().hasQualifiedName("com.example", "Class")
select call
