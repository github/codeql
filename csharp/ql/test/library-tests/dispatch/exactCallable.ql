import csharp
import semmle.code.csharp.dispatch.Dispatch

from DispatchCall call, Method m
where
  call.getCall().getEnclosingCallable().getName() = "Run" and
  call.getLocation().getFile().getStem() = "ExactCallable" and
  strictcount(call.getADynamicTarget().getSourceDeclaration()) = 1 and
  m = call.getADynamicTarget().getSourceDeclaration() and
  m.fromSource()
select call, m.toString(), m.getDeclaringType().toString()
