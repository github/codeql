/**
 * @name AV Rule 182
 * @description Type casting from any type to or from pointers shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-182
 * @problem.severity error
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

class NullPointer extends Expr {
  NullPointer() {
    this.getValue() = "0" and this.getType() instanceof IntegralType
    or
    this instanceof NULL
  }
}

from Expr e, Type t1, Type t2
where
  t1 = e.getUnspecifiedType() and
  t2 = e.getFullyConverted().getUnspecifiedType() and
  t1 != t2 and
  (t1 instanceof PointerType or t2 instanceof PointerType) and
  not (t2 instanceof VoidPointerType and t1 instanceof PointerType) and
  // Conversion to bool type is always fine
  not t2 instanceof BoolType and
  // Ignore assigning NULL to a pointer
  not e instanceof NullPointer and
  // Allow array -> pointer conversion
  not t1.(ArrayType).getBaseType() = t2.(PointerType).getBaseType()
select e,
  "AV Rule 182: illegal cast from type " + t1.toString() + " to type " + t2.toString() +
    ". Casting to or from pointers shall not be used"
