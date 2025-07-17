/**
 * @name Equality check on floating point values
 * @description Comparing results of floating-point computations with '==' or
 *              '!=' is likely to yield surprising results since floating-point
 *              computation does not follow the standard rules of algebra.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/equality-on-floats
 * @tags quality
 *       reliability
 *       correctness
 */

import csharp

from EqualityOperation e
where
  e.getAnOperand().getType() instanceof FloatingPointType and
  not e.getAnOperand() instanceof NullLiteral
select e, "Equality checks on floating point values can yield unexpected results."
