/**
 * @name Comparison with zero
 * @description Finds comparisons between an unsigned value and zero.
 * @id go/examples/unsignedgez
 * @tags comparison
 *       unsigned
 */

import go

from DataFlow::RelationalComparisonNode cmp, DataFlow::Node unsigned, DataFlow::Node zero
where
  zero.getNumericValue() = 0 and
  unsigned.getType().getUnderlyingType() instanceof UnsignedIntegerType and
  cmp.leq(_, zero, unsigned, 0)
select cmp, unsigned
