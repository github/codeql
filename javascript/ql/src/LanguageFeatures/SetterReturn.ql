/**
 * @name Useless return in setter
 * @description Returning a value from a setter function is useless, since it will
 *              always be ignored.
 * @kind problem
 * @problem.severity warning
 * @id js/setter-return
 * @tags maintainability
 *       language-features
 * @precision very-high
 */

import javascript

from FunctionExpr f, ReturnStmt ret
where
  ret.getContainer() = f and
  f.isSetter() and
  exists(ret.getExpr())
select ret, "Useless return statement in setter function."
