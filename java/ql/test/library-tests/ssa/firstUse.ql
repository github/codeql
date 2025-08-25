import java
import semmle.code.java.dataflow.SSA

from SsaVariable ssa, VarRead use
where use = ssa.getAFirstUse()
select ssa, use
