/**
 * @id py/examples/equalitystmt
 * @name Equalities as expression statements
 * @description Finds `==` equality expressions that form a statement
 * @tags comparison
 *       equality
 *       expression statement
 */

import python

from ExprStmt e, Compare eq
where e.getValue() = eq and eq.getOp(0) instanceof Eq
select e
