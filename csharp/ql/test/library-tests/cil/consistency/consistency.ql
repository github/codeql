import cil
import semmle.code.cil.ConsistencyChecks

from ConsistencyViolation v
select v, v.getMessage()
