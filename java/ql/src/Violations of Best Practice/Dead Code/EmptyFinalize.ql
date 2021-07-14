/**
 * @name Empty body of finalizer
 * @description An empty 'finalize' method is useless and prevents its superclass's 'finalize'
 *              method (if any) from being called.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/empty-finalizer
 * @tags reliability
 *       readability
 *       external/cwe/cwe-568
 */

import java

from FinalizeMethod finalize
where
  finalize.fromSource() and
  not exists(Stmt s | s.getEnclosingCallable() = finalize | not s instanceof BlockStmt)
select finalize, "Empty finalize method."
