/**
 * @name Test for object creations
 */

import csharp

from
  Method m, ObjectCreation e, Constructor cc, ObjectInitializer i, MemberInitializer a,
  MemberInitializer b
where
  m.hasName("MainCreations") and
  e.getEnclosingCallable() = m and
  e.getTarget() = cc and
  e.getNumberOfArguments() = 0 and
  cc.hasName("Point") and
  i = e.getInitializer() and
  a = i.getMemberInitializer(0) and
  a.getLeftOperand().(PropertyAccess).getTarget().hasName("X") and
  a.getRightOperand().getValue() = "2" and
  b = i.getMemberInitializer(1) and
  b.getLeftOperand().(PropertyAccess).getTarget().hasName("Y") and
  b.getRightOperand().getValue() = "3" and
  i.getNumberOfMemberInitializers() = 2
select i, a, b
