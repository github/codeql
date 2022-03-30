/**
 * @name Class has same name as super class
 * @description Finds classes that have the same name as their super class; this may be confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/class-name-matches-base-class
 * @tags maintainability
 *       readability
 *       naming
 */

import csharp

from RefType sub, RefType sup
where
  sub.getABaseType() = sup and
  sub.getName() = sup.getName() and
  sub.fromSource()
select sub, "Class has the same name as its base class."
