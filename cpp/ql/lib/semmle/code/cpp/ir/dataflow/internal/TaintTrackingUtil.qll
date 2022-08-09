private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import ModelUtil
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.models.interfaces.SideEffect
private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.models.Models

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  DataFlow::localFlowStep(nodeFrom, nodeTo) // TODO: Is this needed?
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
  instructionToOperandTaintStep(nodeFrom.asInstruction(), nodeTo.asOperand())
  or
  modeledTaintStep(nodeFrom, nodeTo)
}

// private predicate indirectionTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
//   exists(Instruction instr |
//     instr instanceof ArithmeticInstruction
//     or
//     instr instanceof BitwiseInstruction
//     or
//     instr instanceof PointerArithmeticInstruction
//   |
//     nodeFrom.(OperandNode).getOperand() = instr.getAnOperand() and
//     nodeTo.(IndirectInstruction).getInstruction() = instr and
//     nodeTo.(IndirectInstruction).getIndex() = 1
//   )
// }
private predicate instructionToOperandTaintStep(Instruction fromInstr, Operand toOperand) {
  // Propagate flow from the definition of an operand to the operand, even when the overlap is inexact.
  // We only do this in certain cases:
  // 1. The instruction's result must not be conflated, and
  // 2. The instruction's result type is one the types where we expect element-to-object flow. Currently
  // this is array types and union types. This matches the other two cases of element-to-object flow in
  // `DefaultTaintTracking`.
  toOperand.getAnyDef() = fromInstr and
  not fromInstr.isResultConflated() and
  (
    fromInstr.getResultType() instanceof ArrayType or
    fromInstr.getResultType() instanceof Union
  )
  or
  exists(ReadSideEffectInstruction readInstr |
    fromInstr = readInstr.getArgumentDef() and
    toOperand = readInstr.getSideEffectOperand()
  )
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
  // The `CopyInstruction` case is also present in non-taint data flow, but
  // that uses `getDef` rather than `getAnyDef`. For taint, we want flow
  // from a definition of `myStruct` to a `myStruct.myField` expression.
  instrTo.(CopyInstruction).getSourceValueOperand() = opFrom
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
 * Holds if taint can flow from `instrIn` to `instrOut` through a call to a
 * modeled function.
 */
predicate modeledTaintStep(DataFlow::Node nodeIn, DataFlow::Node nodeOut) {
  // Normal taint steps
  exists(CallInstruction call, TaintFunction func, FunctionInput modelIn, FunctionOutput modelOut |
    call.getStaticCallTarget() = func and
    func.hasTaintFlow(modelIn, modelOut)
  |
    (
      nodeIn = callInput(call, modelIn)
      or
      exists(int n |
        modelIn.isParameterDerefOrQualifierObject(n) and
        if n = -1
        then nodeIn = callInput(call, any(InQualifierAddress inQualifier))
        else nodeIn = callInput(call, any(InParameter inParam | inParam.getIndex() = n))
      )
    ) and
    nodeOut = callOutput(call, modelOut)
    or
    exists(int d |
      nodeIn = callInput(call, modelIn, d)
      or
      exists(int n |
        d = 1 and // TODO
        modelIn.isParameterDerefOrQualifierObject(n) and
        if n = -1
        then nodeIn = callInput(call, any(InQualifierAddress inQualifier))
        else nodeIn = callInput(call, any(InParameter inParam | inParam.getIndex() = n))
      )
    |
      call.getStaticCallTarget() = func and
      func.hasTaintFlow(modelIn, modelOut) and
      nodeOut = callOutput(call, modelOut, d)
    )
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

private import cpp as Cpp

// private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private predicate into(ArgumentNode node1, ParameterNode node2) {
  exists(CallInstruction call, ParameterPosition pos |
    node1.argumentOf(call, pos) and
    node2.isParameterOf(call.getStaticCallTarget(), pos)
  )
}

private predicate outOf(
  DataFlowImplCommon::ReturnNodeExt node1, DataFlowImplCommon::OutNodeExt node2, string msg
) {
  exists(DataFlowImplCommon::ReturnKindExt kind |
    node1.getKind() = kind and
    kind.getAnOutNode(any(CallInstruction call |
        call.getStaticCallTarget() = node1.getEnclosingCallable()
      )) = node2 and
    msg = kind.toString()
  )
}

private predicate argumentValueFlowsThrough(ArgumentNode n2, Content c, OutNode n1) {
  exists(Node mid1, ParameterNode p, ReturnNode r, Node mid2 |
    into(n2, p) and
    simpleLocalFlowStep*(p, mid2) and
    readStep(mid2, c, mid1) and
    simpleLocalFlowStep*(mid1, r) and
    outOf(r, n1, _)
  )
}

private predicate step(Node node1, Node node2, string msg) {
  stepFwd(_, node1) and
  (
    localTaintStep(node1, node2) and msg = "."
    or
    exists(Content c, string after | after = c.toString() |
      readStep(node1, c, node2) and msg = "Read " + after
      or
      storeStep(node1, c, node2) and msg = "Store " + after
      or
      exists(Node n1, Node n2 |
        n1 = node1.(PostUpdateNode).getPreUpdateNode() and
        n2 = node2.(PostUpdateNode).getPreUpdateNode() and
        readStep(n2, c, n1) and
        msg = "Reverse read " + c
      )
      or
      exists(OutNode n1, ArgumentNode n2 |
        n2 = node2.(PostUpdateNode).getPreUpdateNode() and
        n1 = node1.(PostUpdateNode).getPreUpdateNode() and
        argumentValueFlowsThrough(n2, c, n1) and
        msg = "Through " + after
      )
    )
    or
    into(node1, node2) and msg = "into"
    or
    outOf(node1, node2, msg)
  )
}

private predicate isSource(Node source) {
  source.(IndirectReturnOutNode).getCallInstruction().getStaticCallTarget().hasName("source")
}

private predicate stepFwd(Node node1, Node node2) {
  node1 = node2 and
  isSource(node1)
  or
  exists(Node mid |
    stepFwd(node1, mid) and
    step(mid, node2, _)
  )
}
