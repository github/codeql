import default
import semmle.code.java.dataflow.DefUse

from RValue u, Parameter v
where parameterDefUsePair(v, u)
select v, u.getLocation().getStartLine()
