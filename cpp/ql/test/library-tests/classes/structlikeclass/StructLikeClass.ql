import cpp

from StructLikeClass slc, string relation, Function f, Variable v
where
  slc.getASetter(v) = f and
  relation = "getASetter"
  or
  slc.getAGetter(v) = f and
  relation = "getAGetter"
select slc, relation, f, v
