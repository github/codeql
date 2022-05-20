/**
 * @name AV Rule 178
 * @description Down casting (casting from base to derived class) shall only be
 *              allowed through virtual functions.
 * @kind problem
 * @id cpp/jsf/av-rule-178
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

predicate subtype(Type sub, Type sup) {
  sub.getUnderlyingType().(Class).getABaseClass+() = sup.getUnderlyingType()
}

from Expr e, Type declared, Type converted
where
  e.fromSource() and
  declared = e.getUnderlyingType() and
  converted = e.getActualType() and
  (
    subtype(converted.(ReferenceType).getBaseType(), declared.(ReferenceType).getBaseType())
    or
    subtype(converted.(PointerType).getBaseType(), declared.(PointerType).getBaseType())
  )
select e, "AV Rule 178: Down casting shall only be allowed through virtual functions."
