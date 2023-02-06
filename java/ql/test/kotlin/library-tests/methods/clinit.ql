import java

from Method m
where m.getName() = "<clinit>"
select m, m.getReturnType()
