import java

from Method m
where m.getDeclaringType().getName() = ["Number", "Byte"]
select m.getDeclaringType().getQualifiedName(), m.toString()
