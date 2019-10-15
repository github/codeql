/**
 * @name  Security implications associated with pickle module.
 * @description Consider possible security implications associated with pickle module.
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b404-import-subprocess
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/imports-function-pickle
 */

import python

from Expr e
where (e.(Call).toString() = "__import__()"
    and e.(Call).getPositionalArg(_).(StrConst).getText() = "pickle")
or
    (
     exists(Attribute a | a = e.(Call).getFunc() | a.getName() = "__import__"
     and e.(Call).getPositionalArg(_).(StrConst).getText() = "pickle")
    )
or
    (
     exists(Attribute a | a = e.(Call).getFunc() | a.getName() = "import_module"
     and e.(Call).getPositionalArg(_).(StrConst).getText() = "pickle")
    )

select e, "Consider possible security implications associated with pickle module"