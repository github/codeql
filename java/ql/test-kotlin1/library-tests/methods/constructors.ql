import java

from Constructor c
where c.fromSource()
select c, c.getDeclaringType(), c.getReturnType()
