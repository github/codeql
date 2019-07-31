/**
 * @id py/examples/recursion
 * @name Recursion
 * @description Finds functions that call themselves
 * @tags method
 *       recursion
 */

import python

from FunctionObject f
where f.getACallee() = f
select f
