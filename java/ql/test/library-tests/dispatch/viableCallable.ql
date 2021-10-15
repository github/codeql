import java
import semmle.code.java.dispatch.VirtualDispatch

from MethodAccess ma, Method m
where
  ma.getFile().toString().matches("ViableCallable%") and
  ma.getMethod().getSourceDeclaration().fromSource() and
  m = viableImpl(ma)
select ma, m.toString(), m.getDeclaringType().getLocation().getStartLine(),
  m.getDeclaringType().toString()
