
import python
import semmle.python.security.TaintTest
import TaintLib

from CallContext context, Scope s
where exists(CallContext caller | caller.getCallee(_) = context) and context.appliesToScope(s)
select context, s.toString()

