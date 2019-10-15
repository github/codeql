/**
 * @name subprocess call
 * @description subprocess call - check for execution of untrusted input.
 * 		https://bandit.readthedocs.io/en/latest/plugins/b603_subprocess_without_shell_equals_true.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/skip
 */

import python


predicate isObjectAttributeArgFalse(Expr e, string objectName, string methodName, string argName) {
  e.(Call).getFunc().(Attribute).getName().toString() = methodName
  and e.(Call).getFunc().(Attribute).getObject().toString() = objectName
  and exists(Keyword k | k = e.(Call).getANamedArg() 
  			and k.getArg() = argName
  			and k.getValue().toString() != "True")
}

from  Expr e
where isObjectAttributeArgFalse(e, "subprocess", "call", "shell")

select e, "subprocess call - check for execution of untrusted input."