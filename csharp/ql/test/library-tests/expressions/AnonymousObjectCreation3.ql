/**
 * @name Test for anonymous object creations
 */

import csharp

from Assignment assign, AnonymousObjectCreation o, Assignment a, Property p
where
  assign.getLeftOperand().(VariableAccess).getTarget().hasName("contacts2") and
  o.getParent+() = assign and
  o.getInitializer().getMemberInitializer(1) = a and
  a.getRightOperand() instanceof ArrayCreation and
  p = a.getLeftOperand().(PropertyAccess).getTarget() and
  p.hasName("PhoneNumbers") and
  p.getDeclaringType() = o.getObjectType()
select o, p.getType().getName()
