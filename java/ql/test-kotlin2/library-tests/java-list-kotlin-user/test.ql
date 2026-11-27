import java

from Method m
where m.getDeclaringType().getName().startsWith("MyList")
select m.toString()
