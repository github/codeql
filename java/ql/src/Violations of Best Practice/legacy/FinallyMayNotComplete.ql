/**
 * @name Finally block may not complete normally
 * @description A 'finally' block that runs because an exception has been thrown, and that does not
 *              complete normally, causes the exception to disappear silently.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/abnormal-finally-completion
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-584
 */

import java

Block finallyBlock() { exists(TryStmt try | try.getFinally() = result) }

Stmt statementIn(Block finally) {
  finallyBlock() = finally and
  result.getParent+() = finally
}

predicate banned(Stmt s, Block finally) {
  s = statementIn(finally) and
  (
    s instanceof ReturnStmt
    or
    exists(ThrowStmt throw | s = throw and not throw.getLexicalCatchIfAny() = statementIn(finally))
    or
    exists(JumpStmt jump | s = jump and not jump.getTarget() = statementIn(finally))
  )
}

from Stmt s, Block finally
where banned(s, finally)
select s, "Leaving a finally-block with this statement can cause exceptions to silently disappear."
