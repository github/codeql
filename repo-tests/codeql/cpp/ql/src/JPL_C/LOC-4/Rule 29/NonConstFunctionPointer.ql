/**
 * @name Use of non-constant function pointer
 * @description Non-constant pointers to functions should not be used.
 * @kind problem
 * @id cpp/jpl-c/non-const-function-pointer
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from ExprCall c
where not c.getExpr().getType().isConst()
select c, "This call does not go through a const function pointer."
