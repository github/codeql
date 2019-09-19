/**
 * @name Implicit downcast from bitfield
 * @description A bitfield is implicitly downcast to a smaller integer type.
 *              This could lead to loss of upper bits of the bitfield.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/implicit-bitfield-downcast
 * @tags reliability
 *       correctness
 *       types
 */

import cpp

from BitField fi, VariableAccess va
where
  fi.getNumBits() > va.getFullyConverted().getType().getSize() * 8 and
  va.getExplicitlyConverted().getType().getSize() > va.getFullyConverted().getType().getSize() and
  va.getTarget() = fi and
  not va.getActualType() instanceof BoolType
select va, "Implicit downcast of bitfield $@", fi, fi.toString()
