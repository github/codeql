import semmle.code.cil.ConsistencyChecks

from CfgViolation v
select v, v.getMessage()
