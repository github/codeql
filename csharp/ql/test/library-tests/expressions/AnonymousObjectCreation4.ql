/**
 * @name Test for anonymous object creations
 */

import csharp

from
  Assignment assign, AnonymousObjectCreation o, Assignment a, AnonymousObjectCreation p,
  Assignment b
where
  assign.getLValue().(VariableAccess).getTarget().hasName("contacts2") and
  o.getParent+() = assign and
  o.getInitializer().getMemberInitializer(1) = a and
  p.getParent+() = assign and
  p.getInitializer().getMemberInitializer(1) = b and
  o != p and
  o.getObjectType() = p.getObjectType()
select o, p
