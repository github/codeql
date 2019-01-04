

import python
import Util

from EssaVariable v, EssaDefinition def
where def = v.getDefinition()
select locate(def.getLocation(), "abdefghijknrs_"), v.getRepresentation() + " = " + def.getRepresentation()
