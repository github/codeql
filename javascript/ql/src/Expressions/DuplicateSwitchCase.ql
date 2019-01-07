/**
 * @name Duplicate switch case
 * @description If two cases in a switch statement have the same label, the second case
 *              will never be executed.
 * @kind problem
 * @problem.severity warning
 * @id js/duplicate-switch-case
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import Clones

/**
 * A clone detector for finding structurally identical case labels.
 */
class DuplicateSwitchCase extends StructurallyCompared {
  DuplicateSwitchCase() { exists(Case c | this = c.getExpr()) }

  override Expr candidate() {
    exists(SwitchStmt s, int i, int j |
      this = s.getCase(i).getExpr() and
      result = s.getCase(j).getExpr() and
      i < j
    )
  }
}

from DuplicateSwitchCase e, Expr f
where e.same(f)
select f, "This case label is a duplicate of $@.", e, e.toString()
