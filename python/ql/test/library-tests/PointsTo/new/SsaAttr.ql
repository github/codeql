import python
private import LegacyPointsTo
import Util

from EssaVariable var, string name, ObjectInternal o, Context ctx
where
  AttributePointsTo::variableAttributePointsTo(var, ctx, name, o, _) and
  not var.getSourceVariable() instanceof SpecialSsaSourceVariable
select locate(var.getDefinition().getLocation(), "abdfgikm"), var.getRepresentation(), name,
  var.getDefinition().getRepresentation(), o, ctx
