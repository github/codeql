import csharp

from AssignableDefinition def, AssignableRead read, Ssa::Definition ult, Ssa::Definition ssaDef
where
  ssaDef.getAnUltimateDefinition() = ult and
  (
    ult.(Ssa::ExplicitDefinition).getADefinition() = def
    or
    ult.(Ssa::ImplicitParameterDefinition).getParameter() =
      def.(AssignableDefinitions::ImplicitParameterDefinition).getParameter()
  ) and
  read = ssaDef.getARead()
select def, read
