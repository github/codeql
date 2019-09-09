/**
 * @name Unsigned comparison to zero
 * @description An unsigned value is always non-negative, even if it has been
 *              assigned a negative number, so the comparison is redundant and
 *              may mask a bug because a different check was intended.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/unsigned-comparison-zero
 * @tags maintainability
 *       readability
 */

import cpp
import UnsignedGEZero

from UnsignedGEZero ugez, string msg
where unsignedGEZero(ugez, msg)
select ugez, msg
