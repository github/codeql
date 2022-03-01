import csharp

from LocalFunctionCall call
where call.fromSource()
select call, call.getTarget(), call.getARuntimeTarget()
