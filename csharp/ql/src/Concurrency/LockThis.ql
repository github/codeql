/**
 * @name Locking the 'this' object in a lock statement
 * @description It is bad practice to lock the 'this' object because
 *              it might be locked elsewhere.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/lock-this
 * @tags reliability
 *       maintainability
 *       modularity
 *       external/cwe/cwe-662
 */

import csharp

from LockStmt s, ThisAccess a
where a = s.getExpr()
select a, "'this' used in lock statement."
