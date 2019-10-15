/**
 * @name  Security implications associated with Popen module.
 * @description Consider possible security implications associated with Popen module.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b404-import-subprocess
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/imports-function-popen
 */

import python

from Expr e
where (e.(Call).toString() = "__import__()"
	and e.(Call).getPositionalArg(_).(StrConst).getText() = "Popen")
or
	(
	 exists(Attribute a | a = e.(Call).getFunc() | a.getName() = "__import__"
	 and e.(Call).getPositionalArg(_).(StrConst).getText() = "Popen")
	)
or
	(
	 exists(Attribute a | a = e.(Call).getFunc() | a.getName() = "import_module"
	 and e.(Call).getPositionalArg(_).(StrConst).getText() = "Popen")
	)

select e, "Consider possible security implications associated with Popen module"