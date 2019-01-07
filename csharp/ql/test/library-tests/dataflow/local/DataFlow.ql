import csharp
import Common

from MyFlowSource source, Access target, string s
where
  DataFlow::localFlowStep+(source, DataFlow::exprNode(target)) and
  exists(MethodCall mc | mc.getTarget().getName() = "Check" and mc.getAnArgument() = target) and
  s = target.toString()
select s order by s
