import java
import semmle.code.java.dispatch.VirtualDispatch

from MethodCall ma, Method m
where
  m = viableImpl(ma) and
  m.fromSource() and
  ma.getFile().toString() = "CallableViaSummary"
select ma, m
