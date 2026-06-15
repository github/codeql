import java

from MethodCall ma
select ma, ma.getCallee().toString(), ma.getCallee().getAParamType().toString()
