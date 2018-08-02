import default
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.PrintIR

from Instruction instr
where none()
select instr
