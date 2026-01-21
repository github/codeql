import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate resolvedCall(CallNode call, Function callable) {
  exists(DataFlowCallable dfCallable, DataFlowCall dfCall |
    dfCallable.getScope() = callable and
    dfCall.getNode() = call and
    dfCallable = viableCallable(dfCall)
  )
}

from Function f, CallNode call, string name
where
  resolvedCall(call, f) and
  not call.getLocation().getFile().inStdlib() and
  f.getLocation().getFile().inStdlib() and
  f.getName() = name and
  name != "__init__"
select name, f.getScope()
