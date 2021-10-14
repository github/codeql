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

from BitField fi, VariableAccess va, Type fct
where
  (
    if va.getFullyConverted().getType() instanceof ReferenceType
    then fct = va.getFullyConverted().getType().(ReferenceType).getBaseType()
    else fct = va.getFullyConverted().getType()
  ) and
  fi.getNumBits() > fct.getSize() * 8 and
  va.getExplicitlyConverted().getType().getSize() > fct.getSize() and
  va.getTarget() = fi and
  not fct.getUnspecifiedType() instanceof BoolType
select va, "Implicit downcast of bitfield $@", fi, fi.toString()
