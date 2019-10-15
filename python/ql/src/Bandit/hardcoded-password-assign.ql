/**
 * @name Possible hardcoded password.
 * @description Possible hardcoded password
 * 		https://bandit.readthedocs.io/en/latest/plugins/b105_hardcoded_password_string.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/password-assign
 */

import python

from AssignStmt a
where 	a.getValue().isConstant()
	and   (
			a.getATarget().toString().toLowerCase().regexpMatch("(?i).*pass(wd|word|code|phrase).*")
			or 	a.getATarget().toString().toLowerCase().regexpMatch("(?i).*secret.*")
		)
select a, "Possible hardcoded password."