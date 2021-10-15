/**
 * @id cs/examples/integer-literal
 * @name Integer literal
 * @description Finds places where we use the integer literal '0'.
 * @tags integer
 *       literal
 */

import csharp

from IntegerLiteral literal
where literal.getValue().toInt() = 0
select literal
