import java

from MethodAccess ma
select ma.getMethod().getDeclaringType().getName(), ma.getMethod().getStringSignature()
