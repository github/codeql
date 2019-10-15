/**
 * @name Possible hardcoded password.
 * @description Possible hardcoded password
 *         https://bandit.readthedocs.io/en/latest/plugins/b105_hardcoded_password_string.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/password-compare
 */

import python

from Compare c
where    c.getLeft().toString() = "password"
and     c.getComparator(0).isConstant()
select c, "Possible hardcoded password"

