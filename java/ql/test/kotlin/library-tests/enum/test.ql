import java

from Method m
where m.getDeclaringType().getName().matches("Enum%")
select m.getName()
