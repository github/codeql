import semmle.code.cpp.ssa.AliasedSSAIR
import semmle.code.cpp.ssa.PrintAliasedSSAIR

from Instruction instr
where none()
select instr
