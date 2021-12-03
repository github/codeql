/**
 * @id js/examples/namedfnexpr
 * @name Named function expression
 * @description Finds function expressions that have a name
 * @tags function expression
 */

import javascript

from FunctionExpr fn
where exists(fn.getName())
select fn
