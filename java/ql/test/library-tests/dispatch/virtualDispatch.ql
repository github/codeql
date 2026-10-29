import default
import semmle.code.java.dispatch.VirtualDispatch

from MethodCall m
where
  m.getEnclosingCallable().getName() = "run" and
  m.getMethod().fromSource()
select m, exactVirtualMethod(m) as def, def.getDeclaringType()
