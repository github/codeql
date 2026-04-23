import csharp

from AssignableDefinition def, AssignableRead read, SsaDefinition ult, SsaDefinition ssaDef
where
  ssaDef.getAnUltimateDefinition() = ult and
  (
    ult.(Ssa::ExplicitDefinition).getADefinition() = def
    or
    ult.(Ssa::ParameterDefinition).getParameter() =
      def.(AssignableDefinitions::ImplicitParameterDefinition).getParameter()
  ) and
  read = ssaDef.getARead()
select def, read
