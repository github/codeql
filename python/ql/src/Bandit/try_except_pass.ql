/**
 * @name Try, Except, Pass detected.
 * @description Try, Except, Pass detected.
 * 		https://bandit.readthedocs.io/en/latest/plugins/b110_try_except_pass.html
 * @kind problem
 * @tags security
 * @problem.severity info
 * @precision high
 * @id py/bandit/try-except-pass
 */

import python


from ExceptStmt e, Pass p
where p.getParentNode() = e
select p, "Try, Except, Pass detected."