import java

from Callable c
where c.fromSource()
select c, c.getAParamType().toString()
