import semmle.code.cpp.rangeanalysis.SignAnalysis
import semmle.code.cpp.ir.IR

from Instruction i
where positive(i)
select i, i.getAST()