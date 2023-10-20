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
 * Gets the instruction that holds the `output` for `call`.
 */
Node callOutput(CallInstruction call, FunctionOutput output) {
  // The return value
  simpleOutNode(result, call) and
  output.isReturnValue()
  or
  // The side effect of a call on the value pointed to by an argument or qualifier
  exists(int index, int indirectionIndex |
    result.(IndirectArgumentOutNode).getArgumentIndex() = index and
    result.(IndirectArgumentOutNode).getIndirectionIndex() = indirectionIndex and
    result.(IndirectArgumentOutNode).getCallInstruction() = call and
    output.isParameterDerefOrQualifierObject(index, indirectionIndex)
  )
  or
  exists(int ind |
    result = getIndirectReturnOutNode(call, ind) and
    output.isReturnValueDeref(ind)
  )
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
  exists(DataFlow::Node n | n = callOutput(call, output) and d > 0 |
    // The return value
    result = getIndirectReturnOutNode(n.asInstruction(), d)
    or
    // If there isn't an indirect out node for the call with indirection `d` then
    // we conflate this with the underlying `CallInstruction`.
    not exists(getIndirectReturnOutNode(call, d)) and
    n = result
    or
    // The side effect of a call on the value pointed to by an argument or qualifier
    exists(Operand operand, int indirectionIndex |
      Ssa::outNodeHasAddressAndIndex(n, operand, indirectionIndex) and
      Ssa::outNodeHasAddressAndIndex(result, operand, indirectionIndex + d)
    )
  )
}
