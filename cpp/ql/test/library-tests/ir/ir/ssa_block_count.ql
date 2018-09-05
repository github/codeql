import default
import semmle.code.cpp.ir.IR

from FunctionIR funcIR
select funcIR.toString(), count(funcIR.getABlock())
