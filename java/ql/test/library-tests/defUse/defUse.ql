import default
import semmle.code.java.dataflow.DefUse

from VariableUpdate d, VarRead u, Variable v
where defUsePair(d, u) and u.getVariable() = v
select v, d.getLocation().getStartLine(), u.getLocation().getStartLine()
