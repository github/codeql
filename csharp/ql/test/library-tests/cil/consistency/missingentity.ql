import semmle.code.cil.ConsistencyChecks

from MissingEntityViolation v
select v, v.getMessage()
