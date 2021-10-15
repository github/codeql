import csharp
import semmle.code.csharp.dispatch.Dispatch

from DispatchCall call, Method m
where
  call.getCall().getEnclosingCallable().getUndecoratedName() = "Run" and
  call.getLocation().getFile().getStem() = "ExactCallable" and
  strictcount(call.getADynamicTarget().getUnboundDeclaration()) = 1 and
  m = call.getADynamicTarget().getUnboundDeclaration() and
  m.fromSource()
select call, m.toString(), m.getDeclaringType().toString()
