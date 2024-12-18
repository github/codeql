import java

from MethodCall ma
select ma.getQualifier(), ma.getCallee(), ma.getCallee().getSignature(),
  ma.getCallee().getAParamType().toString(), ma.getCallee().getDeclaringType()
