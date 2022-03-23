import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
import Util

predicate ssa_variable_points_to(
  EssaVariable var, PointsToContext context, Object obj, ClassObject cls, @py_object origin
) {
  exists(ObjectInternal value |
    PointsToInternal::variablePointsTo(var, context, value, origin) and
    cls = value.getClass().getSource()
  |
    obj = value.getSource()
  )
}

from EssaVariable v, EssaDefinition def, Object o, ClassObject cls
where
  def = v.getDefinition() and
  not v.getSourceVariable() instanceof SpecialSsaSourceVariable and
  ssa_variable_points_to(v, _, o, cls, _)
select locate(def.getLocation(), "abcdegjqmns_"),
  v.getRepresentation() + " = " + def.getRepresentation(), repr(o), repr(cls)
