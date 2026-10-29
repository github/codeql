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
  cc.hasName("Rectangle2") and
  i = e.getInitializer() and
  a = i.getMemberInitializer(0) and
  a.getLeftOperand().(PropertyAccess).getTarget().hasName("P1") and
  a.getRightOperand() instanceof ObjectInitializer and
  b = i.getMemberInitializer(1) and
  b.getLeftOperand().(PropertyAccess).getTarget().hasName("P2") and
  b.getRightOperand() instanceof ObjectInitializer and
  i.getNumberOfMemberInitializers() = 2
select m, e
