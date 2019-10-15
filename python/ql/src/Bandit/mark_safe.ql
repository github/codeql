/**
 * @name Use of mark_safe() should be reviewed
 * @description Use of mark_safe() may expose cross-site scripting vulnerabilities and should be reviewed.
 * 				This is similar, though in many ways worse, then using eval. On Python 2, use raw_input instead, input is safe in Python 3.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b308-mark-safe
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/mark-safe
 */

import python

predicate isMethodCall(Call c, string objectName, string methodName) {
  c.getFunc().(Attribute).getObject().toString() = objectName
  and c.getFunc().(Attribute).getName() = methodName
}

from Call c
where isMethodCall(c, "safestring", "mark_safe")
   or isMethodCall(c, "safestring", "SafeUnicode")
   or isMethodCall(c, "safestring", "SafeText")
   or isMethodCall(c, "safestring", "SafeString")
   or isMethodCall(c, "safestring", "SafeBytes")
   
select c, "Use of mark_safe() may expose cross-site scripting vulnerabilities"