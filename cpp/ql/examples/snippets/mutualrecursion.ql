/**
 * @id cpp/examples/mutualrecursion
 * @name Mutual recursion
 * @description Finds pairs of functions that call each other
 * @tags function
 *       method
 *       recursion
 */

import cpp

from Function m, Function n
where
  exists(FunctionCall c | c.getEnclosingFunction() = m and c.getTarget() = n) and
  exists(FunctionCall c | c.getEnclosingFunction() = n and c.getTarget() = m) and
  m != n
select m, n
