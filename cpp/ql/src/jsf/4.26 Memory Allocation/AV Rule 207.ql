/**
 * @name AV Rule 207
 * @description Unencapsulated global data will be avoided. Global non-constant variables should be objects of encapsulated types - not basic types, structs or struct-like classes.
 * @kind problem
 * @id cpp/jsf/av-rule-207
 * @problem.severity warning
 * @tags maintainability
 *       modularity
 *       external/jsf
 */

import cpp

predicate unencapsulated(Type t) {
  exists(Type base |
    base = t.getUnderlyingType() and
    (
      base instanceof ArithmeticType or
      base instanceof Enum or
      base instanceof StructLikeClass or
      unencapsulated(base.(PointerType).getBaseType()) or
      unencapsulated(base.(SpecifiedType).getBaseType()) or
      unencapsulated(base.(ReferenceType).getBaseType())
    )
  )
}

from GlobalVariable gv
where
  unencapsulated(gv.getType()) and
  // Allow immutable global constants
  not gv.getType().isDeeplyConst()
select gv, "AV Rule 207: Unencapsulated global data will be avoided."
