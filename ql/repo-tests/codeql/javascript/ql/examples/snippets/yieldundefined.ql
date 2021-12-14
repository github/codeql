/**
 * @id js/examples/yieldundefined
 * @name Empty yield
 * @description Finds yield expressions without an operand
 * @tags generator
 *       yield
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from YieldExpr yield
where not exists(yield.getOperand())
select yield
