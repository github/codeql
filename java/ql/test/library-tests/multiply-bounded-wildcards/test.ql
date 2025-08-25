import java

from MethodCall ma
select ma.getCallee(), ma.getCallee().getDeclaringType(), ma.getCallee().getReturnType().toString(),
  ma.getCallee().getAParamType().toString()
