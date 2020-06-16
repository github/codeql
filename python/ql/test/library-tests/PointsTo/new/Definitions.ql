import python
import Util

from EssaDefinition def, Variable v
where v = def.getSourceVariable() and not v instanceof SpecialSsaSourceVariable
select locate(def.getLocation(), "abdgk"), v.toString(), def.getAQlClass()
