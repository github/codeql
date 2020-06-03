/**
 * Provides predicates for mapping the `FunctionInput` and `FunctionOutput`
 * classes used in function models to the corresponding instructions.
 */

private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * Gets the instruction that goes into `input` for `call`.
 */
Instruction callInput(CallInstruction call, FunctionInput input) {
  // A positional argument
  exists(int index |
    result = call.getPositionalArgument(index) and
    input.isParameter(index)
  )
  or
  // A value pointed to by a positional argument
  exists(ReadSideEffectInstruction read |
    result = read.getSideEffectOperand().getAnyDef() and
    read.getPrimaryInstruction() = call and
    input.isParameterDeref(read.getIndex())
  )
  or
  // The qualifier pointer
  result = call.getThisArgument() and
  input.isQualifierAddress()
  //TODO: qualifier deref
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
  // TODO: qualifiers, return value dereference
}
