/**
 * @id cpp/examples/arrayaccess
 * @name Array access
 * @description Finds array access expressions with an index expression
 *              consisting of a postfix increment (`++`) expression.
 * @tags array
 *       access
 *       index
 *       postfix
 *       increment
 */

import cpp

from ArrayExpr a
where a.getArrayOffset() instanceof PostfixIncrExpr
select a
