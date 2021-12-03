/**
 * @name Discarded exception
 * @description Dropping an exception may allow an unusual program state to continue
 *              without recovery.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/discarded-exception
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-391
 */

import java

from CatchClause cc
where
  not exists(cc.getBlock().getAStmt()) and
  not cc.getBlock().getNumberOfCommentLines() > 0 and
  not cc.getEnclosingCallable().getDeclaringType() instanceof TestClass
select cc, "Exceptions should not be dropped."
