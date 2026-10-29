import java
import semmle.code.java.dataflow.SSA

from VarRead use1, VarRead use2
where adjacentUseUse(use1, use2)
select use1, use2
