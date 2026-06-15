import java

from MethodCall call, Method m
where
  call.getMethod() = m and
  m.getName() = "<obinit>"
select call.getEnclosingStmt(), call.getEnclosingStmt().getIndex(), call.getMethod().getName(),
  "Instance initializer call at index " + call.getEnclosingStmt().getIndex()
