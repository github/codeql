/**
 * @name Test for anonymous object creations
 */

import csharp

from Assignment assign, AnonymousObjectCreation o, Assignment a, Property p
where
  assign.getLeftOperand().(VariableAccess).getTarget().hasName("list2") and
  o.getParent+() = assign and
  o.getInitializer().getMemberInitializer(0) = a and
  a.getRightOperand().getValue() = "2" and
  p = a.getLeftOperand().(PropertyAccess).getTarget() and
  p.hasName("i") and
  p.getDeclaringType() = o.getObjectType()
select o
