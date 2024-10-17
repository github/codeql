private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import ModelUtil
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.models.interfaces.SideEffect
private import DataFlowUtil
private import DataFlowPrivate
private import SsaInternals as Ssa
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.cpp.ir.dataflow.FlowSteps

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step. This relation is only used for local taint flow
 * (for example `TaintTracking::localTaint(source, sink)`) so it may contain
 * special cases that should only apply to local taint flow.
 */
predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // dataflow step
  DataFlow::localFlowStep(nodeFrom, nodeTo)
  or
  // taint flow step
  localAdditionalTaintStep(nodeFrom, nodeTo, _)
  or
  // models-as-data summarized flow for local data flow (i.e. special case for flow
  // through calls to modeled functions, without relying on global dataflow to join
  // the dots).
  FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, _)
}

/**
 * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo` excluding
 * local data flow steps. That is, `nodeFrom` and `nodeTo` are likely to represent
 * different objects.
 */
cached
predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
  operandToInstructionTaintStep(nodeFrom.asOperand(), nodeTo.asInstruction()) and
  model = ""
  or
  modeledTaintStep(nodeFrom, nodeTo, model)
  or
  // Flow from (the indirection of) an operand of a pointer arithmetic instruction to the
  // indirection of the pointer arithmetic instruction. This provides flow from `source`
  // in `x[source]` to the result of the associated load instruction.
  exists(PointerArithmeticInstruction pai, int indirectionIndex |
    nodeHasOperand(nodeFrom, pai.getAnOperand(), pragma[only_bind_into](indirectionIndex)) and
    hasInstructionAndIndex(nodeTo, pai, indirectionIndex + 1)
  ) and
  model = ""
  or
  any(Ssa::Indirection ind).isAdditionalTaintStep(nodeFrom, nodeTo) and
  model = ""
  or
  // models-as-data summarized flow
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
    nodeTo.(FlowSummaryNode).getSummaryNode(), false, model)
  or
  // object->field conflation for content that is a `TaintInheritingContent`.
  exists(DataFlow::ContentSet f |
    readStep(nodeFrom, f, nodeTo) and
    f.getAReadContent() instanceof TaintInheritingContent
  ) and
  model = ""
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
  Ssa::isDereference(instrTo, opFrom, _)
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
  or
  // Taint from int to boolean casts. This ensures that we have flow to `!x` in:
  // ```cpp
  // x = integer_source();
  // if(!x) { ... }
  // ```
  exists(Operand zero |
    zero.getDef().(ConstantValueInstruction).getValue() = "0" and
    instrTo.(CompareNEInstruction).hasOperands(opFrom, zero)
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
predicate defaultAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink, string model) {
  localAdditionalTaintStep(src, sink, model)
}

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) {
  node instanceof ArgumentNode and
  c.isSingleton(any(ElementContent ec))
}

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if taint can flow from `nodeIn` to `nodeOut` through a call to a
 * modeled function.
 */
predicate modeledTaintStep(DataFlow::Node nodeIn, DataFlow::Node nodeOut, string model) {
  // Normal taint steps
  exists(CallInstruction call, TaintFunction func, FunctionInput modelIn, FunctionOutput modelOut |
    call.getStaticCallTarget() = func and
    func.hasTaintFlow(modelIn, modelOut)
  |
    nodeIn = callInput(call, modelIn) and nodeOut = callOutput(call, modelOut)
    or
    exists(int d | nodeIn = callInput(call, modelIn, d) and nodeOut = callOutput(call, modelOut, d))
  ) and
  model = "TaintFunction"
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
    modelMidIn.isParameter(indexMid) and
    model = "TaintFunction"
  )
  or
  // Taint flow from a pointer argument to an output, when the model specifies flow from the deref
  // to that output, but the deref is not modeled in the IR for the caller.
  exists(
    CallInstruction call, DataFlow::SideEffectOperandNode indirectArgument, Function func,
    FunctionInput modelIn, FunctionOutput modelOut
  |
    indirectArgument = callInput(call, modelIn) and
    indirectArgument.hasAddressOperandAndIndirectionIndex(nodeIn.asOperand(), _) and
    call.getStaticCallTarget() = func and
    (
      func.(DataFlowFunction).hasDataFlow(modelIn, modelOut) and
      model = "DataFlowFunction"
      or
      func.(TaintFunction).hasTaintFlow(modelIn, modelOut) and
      model = "TaintFunction"
    ) and
    nodeOut = callOutput(call, modelOut)
  )
}

import SpeculativeTaintFlow

private module SpeculativeTaintFlow {
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowDispatch as DataFlowDispatch
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate as DataFlowPrivate

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    exists(DataFlowCall call, ArgumentPosition argpos |
      // TODO: exclude neutrals and anything that has QL modeling.
      not exists(DataFlowDispatch::viableCallable(call)) and
      src.(DataFlowPrivate::ArgumentNode).argumentOf(call, argpos)
    |
      not argpos.(DirectPosition).getIndex() = -1 and
      sink.(PostUpdateNode)
          .getPreUpdateNode()
          .(DataFlowPrivate::ArgumentNode)
          .argumentOf(call, any(DirectPosition qualpos | qualpos.getIndex() = -1))
      or
      sink.(DataFlowPrivate::OutNode).getCall() = call
    )
  }
}
