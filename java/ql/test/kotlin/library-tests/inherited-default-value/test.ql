import java

from MethodAccess ma
select ma, ma.getCallee(), ma.getCallee().getDeclaringType()
