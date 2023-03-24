import java

from MethodAccess ma
select ma, ma.getCallee().toString(), ma.getCallee().getAParamType().toString()
