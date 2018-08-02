import semmle.code.cil.ConsistencyChecks

from TypeViolation v
select v, v.getMessage()
