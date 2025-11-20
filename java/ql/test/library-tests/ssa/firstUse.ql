import java
import semmle.code.java.dataflow.SSA

from SsaDefinition ssa, VarRead use
where use = ssaGetAFirstUse(ssa)
select ssa, use
