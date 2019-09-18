/**
 * @name Use of goto
 * @description The goto statement can make the control flow of a function hard
 *              to understand, when used for purposes other than error handling.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/use-of-goto
 * @tags maintainability
 *       readability
 *       language-features
 */

import cpp

class JumpTarget extends Stmt {
  JumpTarget() { exists(GotoStmt g | g.getTarget() = this) }

  FunctionDeclarationEntry getFDE() { result.getBlock() = this.getParentStmt+() }

  predicate isForward() {
    exists(GotoStmt g | g.getTarget() = this |
      g.getLocation().getEndLine() < this.getLocation().getStartLine()
    )
  }

  predicate isBackward() {
    exists(GotoStmt g | g.getTarget() = this |
      this.getLocation().getEndLine() < g.getLocation().getStartLine()
    )
  }
}

from FunctionDeclarationEntry fde, int nforward, int nbackward
where
  nforward = strictcount(JumpTarget t | t.getFDE() = fde and t.isForward()) and
  nbackward = strictcount(JumpTarget t | t.getFDE() = fde and t.isBackward()) and
  nforward != 1 and
  nbackward != 1
select fde,
  "Multiple forward and backward goto statements may make function " + fde.getName() +
    " hard to understand."
