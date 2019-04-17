/**
 * @name Magic numbers
 * @description 'Magic constants' should be avoided: if a nontrivial constant is used repeatedly, it should be encapsulated into a const variable or macro definition.
 * @kind problem
 * @id cpp/magic-number
 * @problem.severity recommendation
 * @precision medium
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import cpp
import MagicConstants

pragma[noopt]
predicate selection(Element e, string msg) {
  magicConstant(e, msg) and
  exists(Literal l, Type t | l = e and t = l.getType() and numberType(t) and l instanceof Literal)
}

from Literal e, string msg
where selection(e, msg)
select e, msg
