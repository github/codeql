/**
 * @id java/examples/mutualrecursion
 * @name Mutual recursion
 * @description Finds pairs of methods that call each other
 * @tags method
 *       recursion
 */

import java

from Method m, Method n
where
  exists(MethodCall ma | ma.getCaller() = m and ma.getCallee() = n) and
  exists(MethodCall ma | ma.getCaller() = n and ma.getCallee() = m) and
  m != n
select m, n
