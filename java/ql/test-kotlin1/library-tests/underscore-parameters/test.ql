import java

from Parameter p
where p.getCallable().fromSource()
select p, p.getName()
