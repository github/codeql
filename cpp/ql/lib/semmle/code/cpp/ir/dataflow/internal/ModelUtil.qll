/**
 * Provides predicates for mapping the `FunctionInput` and `FunctionOutput`
 * classes used in function models to the corresponding instructions.
 */

private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * Gets the instruction that goes into `input` for `call`.
 */
Operand callInput(CallInstruction call, FunctionInput input) {
  // An argument or qualifier
  exists(int index |
    result = call.getArgumentOperand(index) and
    input.isParameterOrQualifierAddress(index)
  )
  or
  // A value pointed to by an argument or qualifier
  exists(ReadSideEffectInstruction read |
    result = read.getSideEffectOperand() and
    read.getPrimaryInstruction() = call and
    input.isParameterDerefOrQualifierObject(read.getIndex())
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
  // The side effect of a call on the value pointed to by an argument or qualifier
  exists(WriteSideEffectInstruction effect |
    result = effect and
    effect.getPrimaryInstruction() = call and
    output.isParameterDerefOrQualifierObject(effect.getIndex())
  )
  or
  // TODO: modify this when we get return value dereferences
  result = call and
  output.isReturnValueDeref()
}
