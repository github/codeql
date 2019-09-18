/**
 * @name Possible signed bit-field member
 * @description Failing to explicitly assign bit fields to unsigned integer or enumeration types
 *              may result in unexpected sign extension or overflow.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/signed-bit-field
 * @tags correctness
 *       portability
 *       reliability
 *       language-features
 *       external/jsf
 *       external/cwe/cwe-190
 */

import cpp

from BitField bf
where
  not bf.getUnspecifiedType().(IntegralType).isUnsigned() and
  not bf.getUnderlyingType() instanceof Enum and
  not bf.getUnspecifiedType() instanceof BoolType and
  not bf.getType().hasName("BOOL") and // At least for C programs on Windows, BOOL is a common typedef for a type representing BoolType.
  not bf.getDeclaredNumBits() = bf.getType().getSize() * 8 and // If this is true, then there cannot be unsigned sign extension or overflow.
  not bf.isAnonymous()
select bf,
  "Bit field " + bf.getName() + " of type " + bf.getUnderlyingType().getName() +
    " should have explicitly unsigned integral or enumeration type."
