/**
 * @name Unnecessary cast
 * @description Casting an object to its own type is unnecessary.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/redundant-cast
 * @tags maintainability
 *       external/cwe/cwe-561
 */

import java

from CastExpr redundant, Type type
where
  redundant.getType() = type and
  type = redundant.getExpr().getType()
select redundant, "This cast is redundant - the expression is already of type '" + type + "'."
