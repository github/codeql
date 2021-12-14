/**
 * @name AV Rule 94
 * @description An inherited nonvirtual function shall not be redefined in a derived class. Such definitions would hide the function in the base class.
 * @kind problem
 * @id cpp/jsf/av-rule-94
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

from MemberFunction f1, MemberFunction f2
where
  f1 != f2 and
  not f1 instanceof VirtualFunction and
  not f2 instanceof VirtualFunction and
  f1.getDeclaringType().getABaseClass+() = f2.getDeclaringType() and
  f1.getName() = f2.getName() and
  forall(Parameter p1, Parameter p2, int i | f1.getParameter(i) = p1 and f2.getParameter(i) = p2 |
    p1.getType() = p2.getType()
  )
select f1, "AV Rule 94: An inherited nonvirtual function shall not be redefined in a derived class."
