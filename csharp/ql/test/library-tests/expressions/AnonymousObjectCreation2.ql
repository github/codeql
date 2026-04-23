/**
 * @name Test for anonymous object creations
 */

import csharp

from Assignment assign, AnonymousObjectCreation o, Assignment a, Property p
where
  assign.getLeftOperand().(VariableAccess).getTarget().hasName("contacts2") and
  o.getParent+() = assign and
  o.getInitializer().getMemberInitializer(0) = a and
  a.getRightOperand().getValue() = "Chris Smith" and
  p = a.getLeftOperand().(PropertyAccess).getTarget() and
  p.hasName("Name") and
  p.getDeclaringType() = o.getObjectType()
select o, p.getType().toString()
