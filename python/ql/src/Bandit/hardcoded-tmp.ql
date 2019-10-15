/**
 * @name Probable insecure usage of temp file/directory.
 * @description Probable insecure usage of temp file/directory.
 * 		https://bandit.readthedocs.io/en/latest/plugins/b108_hardcoded_tmp_directory.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/temp
 */

import python

from Expr e
where e.(Call).toString() = "open()"
and (
	e.(Call).getArg(0).(StrConst).getText().toLowerCase().regexpMatch("/tmp/.*")
	or e.(Call).getArg(0).(StrConst).getText().toLowerCase().regexpMatch("/var/tmp/.*")
	or e.(Call).getArg(0).(StrConst).getText().toLowerCase().regexpMatch("/dev/.*")
	)
select e, "Probable insecure usage of temp file/directory."


