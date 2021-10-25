import python
import semmle.python.dataflow.Implementation
import TaintLib

from CallContext context, Scope s
where
  exists(CallContext caller | caller.getCallee(_) = context) and
  context.appliesToScope(s)
select s.getLocation().toString(), context, s.toString()
