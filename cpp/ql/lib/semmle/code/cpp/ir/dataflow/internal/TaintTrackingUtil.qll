private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import ModelUtil
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.models.interfaces.SideEffect
private import DataFlowUtil
private import DataFlowPrivate
private import SsaInternals as Ssa

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  DataFlow::localFlowStep(nodeFrom, nodeTo)
  or
  localAdditionalTaintStep(nodeFrom, nodeTo)
}

/**
 * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo` excluding
 * local data flow steps. That is, `nodeFrom` and `nodeTo` are likely to represent
 * different objects.
 */
cached
predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  operandToInstructionTaintStep(nodeFrom.asOperand(), nodeTo.asInstruction())
  or
  modeledTaintStep(nodeFrom, nodeTo)
  or
  // Flow from (the indirection of) an operand of a pointer arithmetic instruction to the
  // indirection of the pointer arithmetic instruction. This provides flow from `source`
  // in `x[source]` to the result of the associated load instruction.
  exists(PointerArithmeticInstruction pai, int indirectionIndex |
    nodeHasOperand(nodeFrom, pai.getAnOperand(), pragma[only_bind_into](indirectionIndex)) and
    hasInstructionAndIndex(nodeTo, pai, indirectionIndex + 1)
  )
  or
  any(Ssa::Indirection ind).isAdditionalTaintStep(nodeFrom, nodeTo)
}

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
private predicate operandToInstructionTaintStep(Operand opFrom, Instruction instrTo) {
  // Taint can flow through expressions that alter the value but preserve
  // more than one bit of it _or_ expressions that follow data through
  // pointer indirections.
  instrTo.getAnOperand() = opFrom and
  (
    instrTo instanceof ArithmeticInstruction
    or
    instrTo instanceof BitwiseInstruction
    or
    instrTo instanceof PointerArithmeticInstruction
  )
  or
  // Taint flow from an address to its dereference.
  Ssa::isDereference(instrTo, opFrom)
  or
  // Unary instructions tend to preserve enough information in practice that we
  // want taint to flow through.
  // The exception is `FieldAddressInstruction`. Together with the rules below for
  // `LoadInstruction`s and `ChiInstruction`s, flow through `FieldAddressInstruction`
  // could cause flow into one field to come out an unrelated field.
  // This would happen across function boundaries, where the IR would not be able to
  // match loads to stores.
  instrTo.(UnaryInstruction).getUnaryOperand() = opFrom and
  (
    not instrTo instanceof FieldAddressInstruction
    or
    instrTo.(FieldAddressInstruction).getField().getDeclaringType() instanceof Union
  )
}

/**
 * Holds if taint may propagate from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow from `i1` to `i2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localInstructionTaint(Instruction i1, Instruction i2) {
  localTaint(DataFlow::instructionNode(i1), DataFlow::instructionNode(i2))
}

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(Expr e1, Expr e2) {
  localTaint(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/**
 * Holds if the additional step from `src` to `sink` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
  localAdditionalTaintStep(src, sink)
}

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::Content c) { none() }

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if taint can flow from `nodeIn` to `nodeOut` through a call to a
 * modeled function.
 */
predicate modeledTaintStep(DataFlow::Node nodeIn, DataFlow::Node nodeOut) {
  // Normal taint steps
  exists(CallInstruction call, TaintFunction func, FunctionInput modelIn, FunctionOutput modelOut |
    call.getStaticCallTarget() = func and
    func.hasTaintFlow(modelIn, modelOut)
  |
    nodeIn = callInput(call, modelIn) and nodeOut = callOutput(call, modelOut)
    or
    exists(int d | nodeIn = callInput(call, modelIn, d) and nodeOut = callOutput(call, modelOut, d))
  )
  or
  // Taint flow from one argument to another and data flow from an argument to a
  // return value. This happens in functions like `strcat` and `memcpy`. We
  // could model this flow in two separate steps, but that would add reverse
  // flow from the write side-effect to the call instruction, which may not be
  // desirable.
  exists(
    CallInstruction call, Function func, FunctionInput modelIn, OutParameterDeref modelMidOut,
    int indexMid, InParameter modelMidIn, OutReturnValue modelOut
  |
    nodeIn = callInput(call, modelIn) and
    nodeOut = callOutput(call, modelOut) and
    call.getStaticCallTarget() = func and
    func.(TaintFunction).hasTaintFlow(modelIn, modelMidOut) and
    func.(DataFlowFunction).hasDataFlow(modelMidIn, modelOut) and
    modelMidOut.isParameterDeref(indexMid) and
    modelMidIn.isParameter(indexMid)
  )
  or
  // Taint flow from a pointer argument to an output, when the model specifies flow from the deref
  // to that output, but the deref is not modeled in the IR for the caller.
  exists(
    CallInstruction call, DataFlow::SideEffectOperandNode indirectArgument, Function func,
    FunctionInput modelIn, FunctionOutput modelOut
  |
    indirectArgument = callInput(call, modelIn) and
    indirectArgument.getAddressOperand() = nodeIn.asOperand() and
    call.getStaticCallTarget() = func and
    (
      func.(DataFlowFunction).hasDataFlow(modelIn, modelOut)
      or
      func.(TaintFunction).hasTaintFlow(modelIn, modelOut)
    ) and
    nodeOut = callOutput(call, modelOut)
  )
}
