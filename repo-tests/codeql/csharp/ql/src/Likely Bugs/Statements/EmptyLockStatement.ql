/**
 * @name Empty lock statement
 * @description Empty lock statements are often a result of commenting-out code in a previously non-empty lock,
 *              but may sometimes be being used as a poor alternative to event wait handles or monitors.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/empty-lock-statement
 * @tags changeability
 *       readability
 *       concurrency
 *       language-features
 *       external/cwe/cwe-585
 */

import csharp

from LockStmt lock
where lock.getBlock().(BlockStmt).getNumberOfStmts() = 0
select lock, "Empty lock statement."
