/**
 * @id cpp/examples/integer-literal
 * @name Integer literal
 * @description Finds places where we use the integer literal `2`
 * @tags integer
 *       literal
 */

import cpp

from Literal literal
where
  literal.getType() instanceof IntType and
  literal.getValue().toInt() = 2
select literal
