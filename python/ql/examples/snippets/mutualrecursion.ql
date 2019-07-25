/**
 * @id py/examples/mutualrecursion
 * @name Mutual recursion
 * @description Finds pairs of functions that call each other
 * @tags method
 *       recursion
 */

import python

from FunctionObject m, FunctionObject n
where m != n and m.getACallee() = n and n.getACallee() = m
select m, n
