
import python

import Util

from EssaDefinition def, Variable v
where v = def.getSourceVariable()
select locate(def.getLocation(), "abdgk"), v.toString(), def.getAQlClass()