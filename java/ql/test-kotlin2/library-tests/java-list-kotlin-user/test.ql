import java

from Method m
where m.getDeclaringType().getName().matches("MyList%")
select m.toString()
