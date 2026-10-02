import java
import semmle.code.java.dispatch.VirtualDispatch

from MethodCall mc, Method m
where viableImpl(mc) = m
select mc, m
