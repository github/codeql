/**
 * @name Test for anonymous object creations
 */

import csharp

from Assignment assign, AnonymousObjectCreation o, Assignment a, Property p
where
  assign.getLValue().(VariableAccess).getTarget().hasName("contacts2") and
  o.getParent+() = assign and
  o.getInitializer().getMemberInitializer(1) = a and
  a.getRValue() instanceof ArrayCreation and
  p = a.getLValue().(PropertyAccess).getTarget() and
  p.hasName("PhoneNumbers") and
  p.getDeclaringType() = o.getObjectType()
select o, p.getType().getName()
