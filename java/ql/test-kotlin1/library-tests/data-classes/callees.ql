import java

from Call c
where c.getEnclosingCallable().fromSource()
select c, c.getCallee().getQualifiedName()
