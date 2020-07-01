/**
 * @name AV Rule 57
 * @description The public, protected, and private sections of a class will be declared in that order.
 * @kind problem
 * @id cpp/jsf/av-rule-57
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from Class c, Declaration m1, Declaration m2, int pos1, int pos2
where
  m1 = c.getCanonicalMember(pos1) and
  m2 = c.getCanonicalMember(pos2) and
  pos1 < pos2 and
  (
    m1.hasSpecifier("private") and m2.hasSpecifier("protected")
    or
    m1.hasSpecifier("private") and m2.hasSpecifier("public")
    or
    m1.hasSpecifier("protected") and m2.hasSpecifier("public")
  )
select c,
  "AV Rule 57: The public, protected, and private sections of a class will be declared in that order."
