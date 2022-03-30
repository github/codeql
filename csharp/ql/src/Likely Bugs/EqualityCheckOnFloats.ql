/**
 * @name Equality check on floating point values
 * @description Equality checks on floating point values can yield unexpected results.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/equality-on-floats
 * @tags reliability
 *       correctness
 */

import csharp

from EqualityOperation e
where
  e.getAnOperand().getType() instanceof FloatingPointType and
  not e.getAnOperand() instanceof NullLiteral
select e, "Equality checks on floating point values can yield unexpected results."
