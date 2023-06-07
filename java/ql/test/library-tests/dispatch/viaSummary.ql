import java
import semmle.code.java.dispatch.VirtualDispatch

from MethodAccess ma, Method m
where
  m = viableImpl(ma) and
  m.fromSource() and
  ma.getFile().toString().matches("CallableViaSummary")
select ma, m
