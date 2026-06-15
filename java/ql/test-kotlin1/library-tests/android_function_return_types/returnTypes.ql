import java

from Method m
where m.fromSource()
select m, m.getNumberOfParameters(), m.getReturnType().(RefType).getQualifiedName()
