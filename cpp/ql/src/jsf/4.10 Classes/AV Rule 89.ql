/**
 * @name Inconsistent virtual inheritance
 * @description A base class shall not be both virtual and non-virtual in the same hierarchy.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/inconsistent-virtual-inheritance
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate derivesVirtual(Class c, Class base) {
  exists(ClassDerivation d |
    d.getDerivedClass() = c and
    d.getBaseClass() = base and
    d.hasSpecifier("virtual")
  )
  or
  derivesVirtual(c.getABaseClass(), base)
}

predicate derivesNonVirtual(Class c, Class base) {
  exists(ClassDerivation d |
    d.getDerivedClass() = c and
    d.getBaseClass() = base and
    not d.hasSpecifier("virtual")
  )
  or
  derivesNonVirtual(c.getABaseClass(), base)
}

from Class c, Class base
where
  c.getABaseClass+() = base and
  derivesVirtual(c, base) and
  derivesNonVirtual(c, base)
select c,
  "AV Rule 89: The base class " + base.getName() + " is derived both virtual and non-virtual."
