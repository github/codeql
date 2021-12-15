/**
 * @name Use of a potentially dangerous function
 * @description Certain standard library routines are dangerous to call.
 * @kind problem
 * @problem.severity warning
 * @security-severity 10.0
 * @precision medium
 * @id java/potentially-dangerous-function
 * @tags reliability
 *       security
 *       external/cwe/cwe-676
 */

import java

predicate dangerousMethod(string descriptor) { descriptor = "java.lang.Thread.stop" }

from MethodAccess call, Method target, string descriptor
where
  call.getCallee() = target and
  descriptor = target.getDeclaringType().getQualifiedName() + "." + target.getName() and
  dangerousMethod(descriptor)
select call, "Call to " + descriptor + " is potentially dangerous."
