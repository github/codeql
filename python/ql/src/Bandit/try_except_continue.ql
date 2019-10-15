/**
 * @name Try, Except, Continue detected.
 * @description Try, Except, Continue detected.
 *         https://bandit.readthedocs.io/en/latest/plugins/b112_try_except_continue.html
 * @kind problem
 * @tags security
 * @problem.severity info
 * @precision medium
 * @id py/bandit/try-except-continue
 */

import python

from ExceptStmt e, Continue c
where c.getParentNode() = e
select c, "Try, Except, Continue detected."