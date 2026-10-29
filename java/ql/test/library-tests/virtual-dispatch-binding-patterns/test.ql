import java
import semmle.code.java.dispatch.VirtualDispatch

from Call c, Callable c2
where c2 = viableCallable(c)
select c, c2.getQualifiedName()
