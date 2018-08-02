import csharp
import semmle.code.csharp.dispatch.Dispatch

from DispatchCall call, Callable c
where
  call.getLocation().getFile().getStem() = "ViableCallable" and
  c = call.getADynamicTarget().getSourceDeclaration() and
  (c.fromSource() implies c.getFile().getStem() = "ViableCallable") and
  (c instanceof Method implies c.getName().regexpMatch("M[0-9]*")) and
  (c instanceof Accessor implies c.fromSource()) and
  call.getCall().getEnclosingCallable().hasName("Run")
select call, c.toString(), c.getDeclaringType().toString()
