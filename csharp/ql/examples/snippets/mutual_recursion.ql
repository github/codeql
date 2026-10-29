/**
 * @id cs/examples/mutual-recursion
 * @name Mutual recursion
 * @description Finds pairs of methods that call each other.
 * @tags method
 *       recursion
 */

import csharp

from Method m, Method n
where
  m.calls(n) and
  n.calls(m) and
  m != n
select m, n
