/**
 * @name Calls to function
 * @description Finds function calls of the form `eval(...)`
 * @tags call
 *       function
 *       eval
 */
 
import javascript

from CallExpr c
where c.getCalleeName() = "eval"
select c
