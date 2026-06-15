import csharp

from AssignableDefinition def, AssignableRead read, SsaDefinition ult, SsaDefinition ssaDef
where
  ssaDef.getAnUltimateDefinition() = ult and
  ult.(SsaExplicitWrite).getDefinition() = def and
  read = ssaDef.getARead()
select def, read
