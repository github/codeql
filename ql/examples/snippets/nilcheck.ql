/**
 * @name Comparison with nil
 * @description Finds comparisons with nil.
 * @id go/examples/nilcheck
 * @tags comparison
 *       nil
 */

import go

from DataFlow::EqualityTestNode eq, DataFlow::Node nd, DataFlow::Node nil
where
  nil = Builtin::nil().getARead() and
  eq.eq(_, nd, nil)
select eq
