import java

from MethodCall ma
select ma.getMethod().getDeclaringType().getName(), ma.getMethod().getStringSignature()
