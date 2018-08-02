import csharp
import Common

from MyFlowSource source, Access sink, string s
where
  TaintTracking::localTaintStep+(source, DataFlow::exprNode(sink)) and
  exists(MethodCall mc | mc.getTarget().getName() = "Check" and mc.getAnArgument() = sink) and
  s = sink.toString()
select s
order by s asc
