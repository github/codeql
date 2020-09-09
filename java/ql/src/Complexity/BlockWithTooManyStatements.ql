/**
 * @name Block with too many statements
 * @description A block that contains too many complex statements becomes unreadable and
 *              unmaintainable.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/complex-block
 * @tags maintainability
 *       testability
 *       complexity
 */

import java

class ComplexStmt extends Stmt {
  ComplexStmt() {
    this instanceof LoopStmt or
    this instanceof SwitchStmt
  }
}

from BlockStmt b, int n
where n = count(ComplexStmt s | s = b.getAStmt()) and n > 3
select b, "Block with too many statements (" + n.toString() + " complex statements in the block)."
