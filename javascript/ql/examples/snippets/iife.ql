/**
 * @id js/examples/iife
 * @name Immediately invoked function expressions
 * @description Finds calls of the form `(function(...) { ... })(...)`
 * @tags call
 *       function
 *       immediately invoked
 */

import javascript

from CallExpr c
where c.getCallee().stripParens() instanceof FunctionExpr
select c
