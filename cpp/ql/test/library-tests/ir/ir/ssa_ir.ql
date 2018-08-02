import semmle.code.cpp.ssa.SSAIR
import semmle.code.cpp.ssa.PrintSSAIR

from Instruction instr
where none()
select instr
