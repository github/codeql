/**
 * @id py/examples/integer-literal
 * @name Integer literal
 * @description Finds places where we use the integer literal `0`
 * @tags integer
 *       literal
 */

import python

from IntegerLiteral literal
where literal.getValue() = 0
select literal
