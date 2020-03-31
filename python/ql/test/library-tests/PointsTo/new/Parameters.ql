import python
import Util

from ParameterDefinition param, boolean self
where if param.isSelf() then self = true else self = false
select locate(param.getLocation(), "g"), param.toString(), self
