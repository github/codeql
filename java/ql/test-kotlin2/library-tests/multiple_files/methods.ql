import java

from Method m
where m.fromSource()
select m, m.getQualifiedName(), m.getDeclaringType()
