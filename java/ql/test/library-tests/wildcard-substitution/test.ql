import java

Type notVoid(Type t) { result = t and not result instanceof VoidType }

from Callable c
where c.getSourceDeclaration().fromSource()
select c.getDeclaringType(), c, notVoid([c.getAParamType(), c.getReturnType()]).toString()
