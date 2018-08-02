import semmle.code.cil.ConsistencyChecks

from InstructionViolation v
select v, v.getMessage()
