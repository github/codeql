import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.implementation.aliased_ssa.constant.ConstantAnalysis
import semmle.code.cpp.ir.internal.IntegerConstant

from IRFunction irFunc, int value
where
  value =
    getValue(getConstantValue(irFunc
            .getReturnInstruction()
            .(ReturnValueInstruction)
            .getReturnValue()))
select irFunc, value
