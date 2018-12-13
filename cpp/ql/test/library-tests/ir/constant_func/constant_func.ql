import default
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.implementation.aliased_ssa.constant.ConstantAnalysis
import semmle.code.cpp.ir.internal.IntegerConstant

from FunctionIR funcIR, int value
where 
  value = getValue(getConstantValue(funcIR.getReturnInstruction().(ReturnValueInstruction).getReturnValue()))
select funcIR, value
