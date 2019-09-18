import csharp

from AssignableDefinition def, AssignableRead read, Ssa::Definition ssaDef
where
  ssaDef.getAnUltimateDefinition().(Ssa::ExplicitDefinition).getADefinition() = def and
  read = ssaDef.getARead()
select def, read
