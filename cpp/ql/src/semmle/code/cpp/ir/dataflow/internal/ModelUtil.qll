/**
 * Provides predicates for mapping the `FunctionInput` and `FunctionOutput`
 * classes used in function models to the corresponding instructions.
 */

private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * Gets the instruction that goes into `input` for `call`.
 */
DataFlow::Node callInput(CallInstruction call, FunctionInput input) {
  // A positional argument
  exists(int index |
    result.asInstruction() = call.getPositionalArgument(index) and
    input.isParameter(index)
  )
  or
  // A value pointed to by a positional argument
  exists(ReadSideEffectInstruction read |
    result.asOperand() = read.getSideEffectOperand() and
    read.getPrimaryInstruction() = call and
    input.isParameterDeref(read.getIndex())
  )
  or
  // The qualifier pointer
  result.asInstruction() = call.getThisArgument() and
  input.isQualifierAddress()
  or
  // The qualifier object
  exists(ReadSideEffectInstruction read |
    result.asOperand() = read.getSideEffectOperand() and
    read.getPrimaryInstruction() = call and
    read.getIndex() = -1 and
    input.isQualifierObject()
  )
}

/**
 * Gets the instruction that holds the `output` for `call`.
 */
Instruction callOutput(CallInstruction call, FunctionOutput output) {
  // The return value
  result = call and
  output.isReturnValue()
  or
  // The side effect of a call on the value pointed to by a positional argument
  exists(WriteSideEffectInstruction effect |
    result = effect and
    effect.getPrimaryInstruction() = call and
    output.isParameterDeref(effect.getIndex())
  )
  or
  // The side effect of a call on the qualifier object
  exists(WriteSideEffectInstruction effect |
    result = effect and
    effect.getPrimaryInstruction() = call and
    effect.getIndex() = -1 and
    output.isQualifierObject()
  )
  // TODO: return value dereference
}
