
import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
import Util

from EssaVariable v, EssaDefinition def, Object o, ClassObject cls
where def = v.getDefinition() and
PointsTo::ssa_variable_points_to(v, _, o, cls, _)
select locate(def.getLocation(), "abcdegjqmns_"), v.getRepresentation() + " = " + def.getRepresentation(), repr(o), repr(cls)
