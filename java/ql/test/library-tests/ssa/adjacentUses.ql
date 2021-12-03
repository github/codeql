import java
import semmle.code.java.dataflow.SSA

from RValue use1, RValue use2
where adjacentUseUse(use1, use2)
select use1, use2
