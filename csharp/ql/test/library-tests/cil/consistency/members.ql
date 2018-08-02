import semmle.code.cil.ConsistencyChecks

from DeclarationViolation v
select v, v.getMessage()
