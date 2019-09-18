/**
 * @name Test for anonymous object creations
 */

import csharp

from Assignment assign, AnonymousObjectCreation o, Assignment a, Property p
where
  assign.getLValue().(VariableAccess).getTarget().hasName("contacts2") and
  o.getParent+() = assign and
  o.getInitializer().getMemberInitializer(0) = a and
  a.getRValue().getValue() = "Chris Smith" and
  p = a.getLValue().(PropertyAccess).getTarget() and
  p.hasName("Name") and
  p.getDeclaringType() = o.getObjectType()
select o, p.getType().toString()
