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

predicate dangerousMethod(string pack, string type, string name) {
  pack = "java.lang" and type = "Thread" and name = "stop"
}

from MethodCall call, Method target, string pack, string type, string name
where
  call.getCallee() = target and
  target.hasQualifiedName(pack, type, name) and
  dangerousMethod(pack, type, name)
select call, "Call to " + pack + "." + type + "." + name + " is potentially dangerous."
