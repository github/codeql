/**
 * @name Integer literal
 * @description Finds places where we use the integer literal `0`
 * @tags integer
 *       literal
 */
 
import java

from IntegerLiteral literal
where literal.getLiteral().toInt() = 0
select literal
