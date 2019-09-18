import csharp
import semmle.code.csharp.dispatch.Dispatch

from DispatchCall call, Callable callable
where
  callable = call.getADynamicTarget() and
  callable.fromSource()
select call, callable.getQualifiedNameWithTypes()
