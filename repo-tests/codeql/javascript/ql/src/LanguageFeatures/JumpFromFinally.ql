/**
 * @name Jump from finally
 * @description Avoid using unstructured control flow statements (return, continue, or break) inside
 *              a 'finally' block.
 * @kind problem
 * @problem.severity warning
 * @id js/exit-from-finally
 * @tags reliability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-584
 * @precision low
 */

import javascript

/**
 * A "jump" statement, that is, `break`, `continue` or `return`.
 */
class Jump extends Stmt {
  Jump() {
    this instanceof BreakOrContinueStmt or
    this instanceof ReturnStmt
  }

  /** Gets the target to which this jump refers. */
  Stmt getTarget() {
    result = this.(BreakOrContinueStmt).getTarget() or
    result = this.(ReturnStmt).getContainer().(Function).getBody()
  }
}

from TryStmt try, BlockStmt finally, Jump jump
where
  finally = try.getFinally() and
  jump.getContainer() = try.getContainer() and
  jump.getParentStmt+() = finally and
  finally.getParentStmt+() = jump.getTarget()
select jump, "This statement jumps out of the finally block, potentially hiding an exception."
