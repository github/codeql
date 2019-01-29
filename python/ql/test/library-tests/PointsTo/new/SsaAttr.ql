
import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
import Util

from EssaVariable var, string name, Object o, PointsToContext ctx
where PointsTo::Test::ssa_variable_named_attribute_points_to(var, ctx, name, o, _, _) and not var.getSourceVariable() instanceof SpecialSsaSourceVariable
select 
locate(var.getDefinition().getLocation(), "abdfgikm"), var.getRepresentation(), 
name, var.getDefinition().getRepresentation(), repr(o), ctx

