import semmle.code.cpp.rangeanalysis.SignAnalysis
import semmle.code.cpp.ir.IR

from Instruction i
where strictlyNegative(i)
select i, i.getAST()