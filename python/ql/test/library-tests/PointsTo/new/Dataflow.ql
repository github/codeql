import python
import Util

from EssaVariable v, EssaDefinition def
where def = v.getDefinition() and not v.getSourceVariable() instanceof SpecialSsaSourceVariable
select locate(def.getLocation(), "abdefghijknrs_"),
  v.getRepresentation() + " = " + def.getRepresentation()
