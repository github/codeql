/**
 * Provides predicates for mapping the `FunctionInput` and `FunctionOutput`
 * classes used in function models to the corresponding instructions.
 */

private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import DataFlowUtil
private import DataFlowPrivate
private import SsaInternals as Ssa

/**
 * Gets the instruction that goes into `input` for `call`.
 */
DataFlow::Node callInput(CallInstruction call, FunctionInput input) {
  // An argument or qualifier
  exists(int index |
    result.asOperand() = call.getArgumentOperand(index) and
    input.isParameterOrQualifierAddress(index)
  )
  or
  // A value pointed to by an argument or qualifier
  exists(int index, int indirectionIndex |
    hasOperandAndIndex(result, call.getArgumentOperand(index), indirectionIndex) and
    input.isParameterDerefOrQualifierObject(index, indirectionIndex)
  )
  or
  exists(int ind |
    result = getIndirectReturnOutNode(call, ind) and
    input.isReturnValueDeref(ind)
  )
}

/**
 * Gets the node that represents the output of `call` with kind `output` at
 * indirection index `indirectionIndex`.
 */
private Node callOutputWithIndirectionIndex(
  CallInstruction call, FunctionOutput output, int indirectionIndex
) {
  // The return value
  simpleOutNode(result, call) and
  output.isReturnValue() and
  indirectionIndex = 0
  or
  // The side effect of a call on the value pointed to by an argument or qualifier
  exists(int index |
    result.(IndirectArgumentOutNode).getArgumentIndex() = index and
    result.(IndirectArgumentOutNode).getIndirectionIndex() = indirectionIndex - 1 and
    result.(IndirectArgumentOutNode).getCallInstruction() = call and
    output.isParameterDerefOrQualifierObject(index, indirectionIndex - 1)
  )
  or
  result = getIndirectReturnOutNode(call, indirectionIndex) and
  output.isReturnValueDeref(indirectionIndex)
}

/**
 * Gets the instruction that holds the `output` for `call`.
 */
Node callOutput(CallInstruction call, FunctionOutput output) {
  result = callOutputWithIndirectionIndex(call, output, _)
}

DataFlow::Node callInput(CallInstruction call, FunctionInput input, int d) {
  exists(DataFlow::Node n | n = callInput(call, input) and d > 0 |
    // An argument or qualifier
    hasOperandAndIndex(result, n.asOperand(), d)
    or
    exists(Operand operand, int indirectionIndex |
      // A value pointed to by an argument or qualifier
      hasOperandAndIndex(n, operand, indirectionIndex) and
      hasOperandAndIndex(result, operand, indirectionIndex + d)
    )
  )
}

private IndirectReturnOutNode getIndirectReturnOutNode(CallInstruction call, int d) {
  result.getCallInstruction() = call and
  result.getIndirectionIndex() = d
}

/**
 * Gets the instruction that holds the `output` for `call`.
 */
bindingset[d]
Node callOutput(CallInstruction call, FunctionOutput output, int d) {
  exists(DataFlow::Node n, int indirectionIndex |
    n = callOutputWithIndirectionIndex(call, output, indirectionIndex) and d > 0
  |
    // The return value
    result = callOutputWithIndirectionIndex(call, output, indirectionIndex + d)
    or
    // If there isn't an indirect out node for the call with indirection `d` then
    // we conflate this with the underlying `CallInstruction`.
    not exists(getIndirectReturnOutNode(call, indirectionIndex + d)) and
    n = result
  )
}
