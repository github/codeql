/**
 * Provides predicates for mapping the `FunctionInput` and `FunctionOutput`
 * classes used in function models to the corresponding instructions.
 */

private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil

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
  exists(int index, int ind |
    hasOperandAndIndex(result, call.getArgumentOperand(index), ind) and
    input.isParameterDerefOrQualifierObject(index, ind)
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
  result.asInstruction() = call and
  output.isReturnValue()
  or
  // The side effect of a call on the value pointed to by an argument or qualifier
  exists(int index, int ind |
    result.(IndirectArgumentOutNode).getArgumentIndex() = index and
    result.(IndirectArgumentOutNode).getIndex() + 1 = ind and
    result.(IndirectArgumentOutNode).getPrimaryInstruction() = call and
    output.isParameterDerefOrQualifierObject(index, ind)
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
    exists(Operand operand, int index |
      // A value pointed to by an argument or qualifier
      hasOperandAndIndex(n, operand, index) and
      hasOperandAndIndex(result, operand, index + d)
    )
  )
}

private IndirectReturnOutNode getIndirectReturnOutNode(CallInstruction call, int d) {
  // TODO: Properly join order this.
  result.getCallInstruction() = call and
  result.getIndex() = d
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
    not exists(getIndirectReturnOutNode(call, d)) and
    n.asInstruction() = result.asInstruction()
    or
    // The side effect of a call on the value pointed to by an argument or qualifier
    // TODO: Why d - 1?
    result.(IndirectArgumentOutNode).getDef() =
      n.(IndirectArgumentOutNode).getDef().incrementIndexBy(d - 1)
  )
}
