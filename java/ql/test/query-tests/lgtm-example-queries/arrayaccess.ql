/**
 * @name Array access
 * @description Finds array access expressions with an index expression
 *              consisting of a unary assignment
 * @tags array
 *       access
 *       index
 *       unary
 *       assignment
 */

import java

from ArrayAccess a
where a.getIndexExpr() instanceof UnaryAssignExpr
select a
