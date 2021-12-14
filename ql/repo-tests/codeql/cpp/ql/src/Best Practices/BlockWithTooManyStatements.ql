/**
 * @name Block with too many statements
 * @description Blocks with too many consecutive statements are candidates for refactoring. Only complex statements are counted here (eg. for, while, switch ...). The top-level logic will be clearer if each complex statement is extracted to a function.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/complex-block
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp

class ComplexStmt extends Stmt {
  ComplexStmt() {
    exists(BlockStmt body |
      body = this.(Loop).getStmt() or
      body = this.(SwitchStmt).getStmt()
    |
      strictcount(body.getAStmt+()) > 6
    ) and
    not exists(this.getGeneratingMacro())
  }
}

from BlockStmt b, int n, ComplexStmt complexStmt
where
  n = strictcount(ComplexStmt s | s = b.getAStmt()) and
  n > 3 and
  complexStmt = b.getAStmt()
select b,
  "Block with too many statements (" + n.toString() +
    " complex statements in the block). Complex statements at: $@", complexStmt,
  complexStmt.toString()
