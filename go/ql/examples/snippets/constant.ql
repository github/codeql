/**
 * @name Compile-time constant
 * @description Finds compile-time constants with value zero.
 * @id go/examples/zeroconstant
 * @tags expression
 *       numeric value
 *       constant
 */

import go

from DataFlow::Node zero
where zero.getNumericValue() = 0
select zero
