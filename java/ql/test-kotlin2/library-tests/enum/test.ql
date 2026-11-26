import java

from Method m
where m.getDeclaringType().getName().startsWith("Enum")
select m.getName()

query predicate enumConstants(EnumConstant ec) { ec.fromSource() }
