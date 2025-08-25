/**
 * @name Class has same name as super class
 * @description A class that has the same name as its superclass may be confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/class-name-matches-super-class
 * @tags quality
 *       maintainability
 *       readability
 *       naming
 */

import java

from RefType sub, RefType sup
where
  sub.fromSource() and
  sup = sub.getASupertype() and
  pragma[only_bind_out](sub.getName()) = pragma[only_bind_out](sup.getName())
select sub, sub.getName() + " has the same name as its supertype $@.", sup, sup.getQualifiedName()
