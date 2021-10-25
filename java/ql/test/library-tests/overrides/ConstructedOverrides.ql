import java

from Callable c
where c.getSourceDeclaration().fromSource()
select c.getDeclaringType(), c.getStringSignature()
