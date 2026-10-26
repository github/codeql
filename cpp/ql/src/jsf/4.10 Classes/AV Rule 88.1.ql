/**
 * @name AV Rule 88.1
 * @description A stateful virtual base shall be explicitly declared in each derived class that accesses it. Explicitly declaring a stateful virtual base at each level in a hierarchy (where that base is used), documents that fact that no assumptions can be made with respect to the exclusive use of the data contained within the virtual base.
 * @kind problem
 * @id cpp/jsf/av-rule-88-1
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

predicate derivesVirtual(Class c, Class base) {
  exists(ClassDerivation d |
    d.getDerivedClass() = c and
    d.getBaseClass() = base and
    d.hasSpecifier("virtual")
  )
}

predicate derivesVirtualStar(Class c, Class base) {
  derivesVirtual(c, base) or derivesVirtualStar(c.getABaseClass(), base)
}

from Class c, Class base
where
  c.getABaseClass+() = base and
  derivesVirtualStar(c, base) and
  not derivesVirtual(c, base)
select c, "AV Rule 88.1: The virtual base " + base.getName() + " shall be explicitly declared."
