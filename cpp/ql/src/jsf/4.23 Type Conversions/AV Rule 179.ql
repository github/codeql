/**
 * @name AV Rule 179
 * @description A pointer to a virtual base class shall not be converted
 *              to a pointer to a derived class.
 * @kind problem
 * @id cpp/jsf/av-rule-179
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

from Expr e, Class declared, Class converted, Class sub, Class sup
where
  e.fromSource() and
  declared = e.getUnderlyingType().(PointerType).getBaseType().getUnderlyingType() and
  converted = e.getActualType().(PointerType).getBaseType().getUnderlyingType() and
  converted.getABaseClass*() = sub and
  sub.hasVirtualBaseClass(sup) and
  sup.getABaseClass*() = declared
select e,
  "AV Rule 179: A pointer to a virtual base class shall not be converted to a pointer to a derived class."
