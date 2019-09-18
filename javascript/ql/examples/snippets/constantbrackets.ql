/**
 * @id js/examples/constantbrackets
 * @name Constant property name in `[]` property access
 * @description Finds property accesses using the square bracket notation
 *              where the property name is a constant string
 * @tags property access
 *       computed
 *       brackets
 *       index
 *       constant
 */

import javascript

from IndexExpr idx
where idx.getIndex() instanceof StringLiteral
select idx
