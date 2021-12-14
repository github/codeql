/**
 * @id js/examples/equalitystmt
 * @name Equalities as expression statements
 * @description Finds `==` equality expressions that form an expression statement
 * @tags comparison
 *       equality
 *       non-strict
 *       expression statement
 */

import javascript

from ExprStmt e
where e.getExpr() instanceof EqExpr
select e
