/**
 * @name Block with too many statements
 * @description Blocks with too many consecutive statements are candidates for refactoring. Only complex statements are counted here
 *              (eg. 'for', 'while', 'switch' ...). The top-level logic will be clearer if each complex statement is extracted
 *              to a function.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/complex-block
 * @tags maintainability
 *       testability
 *       complexity
 */

import csharp

class ComplexStmt extends Stmt {
  ComplexStmt() {
    this instanceof ForStmt or
    this instanceof WhileStmt or
    this instanceof DoStmt or
    this instanceof SwitchStmt
  }
}

from BlockStmt b, int n
where n = count(ComplexStmt s | s = b.getAStmt()) and n > 3
select b, "Block with too many statements (" + n.toString() + " complex statements in the block)."
