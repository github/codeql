import default
import semmle.code.java.dataflow.DefUse

from VarRead u, Parameter v
where parameterDefUsePair(v, u)
select v, u.getLocation().getStartLine()
