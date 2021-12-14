/**
 * @name Class has same name as super class
 * @description A class that has the same name as its superclass may be confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/class-name-matches-super-class
 * @tags maintainability
 *       readability
 *       naming
 */

import java

from RefType sub, RefType sup
where
  sub.fromSource() and
  sup = sub.getASupertype() and
  sub.getName() = sup.getName()
select sub, sub.getName() + " has the same name as its supertype $@.", sup, sup.getQualifiedName()
