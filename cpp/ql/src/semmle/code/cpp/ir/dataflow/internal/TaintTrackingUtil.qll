private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import ModelUtil
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.models.interfaces.SideEffect

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
  instructionToOperandTaintStep(nodeFrom.asInstruction(), nodeTo.asOperand())
}

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
  or
  toOperand.(LoadOperand).getAnyDef() = fromInstr
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
    or
    instrTo instanceof FieldAddressInstruction
    or
    // The `CopyInstruction` case is also present in non-taint data flow, but
    // that uses `getDef` rather than `getAnyDef`. For taint, we want flow
    // from a definition of `myStruct` to a `myStruct.myField` expression.
    instrTo instanceof CopyInstruction
  )
  or
  instrTo.(LoadInstruction).getSourceAddressOperand() = opFrom
  or
  // Flow from an element to an array or union that contains it.
  instrTo.(ChiInstruction).getPartialOperand() = opFrom and
  not instrTo.isResultConflated() and
  exists(Type t | instrTo.getResultLanguageType().hasType(t, false) |
    t instanceof Union
    or
    t instanceof ArrayType
  )
  or
  modeledTaintStep(opFrom, instrTo)
}

/**
 * Holds if taint may propagate from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow from `i1` to `i2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localInstructionTaint(Instruction i1, Instruction i2) {
  localTaint(DataFlow::instructionNode(i1), DataFlow::instructionNode(i2))
}

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
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
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if taint can flow from `instrIn` to `instrOut` through a call to a
 * modeled function.
 */
predicate modeledTaintStep(Operand nodeIn, Instruction nodeOut) {
  exists(CallInstruction call, TaintFunction func, FunctionInput modelIn, FunctionOutput modelOut |
    (
      nodeIn = callInput(call, modelIn)
      or
      exists(int n |
        modelIn.isParameterDerefOrQualifierObject(n) and
        if n = -1
        then nodeIn = callInput(call, any(InQualifierObject inQualifier))
        else nodeIn = callInput(call, any(InParameter inParam | inParam.getIndex() = n))
      )
    ) and
    nodeOut = callOutput(call, modelOut) and
    call.getStaticCallTarget() = func and
    func.hasTaintFlow(modelIn, modelOut)
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
    CallInstruction call, ReadSideEffectInstruction read, Function func, FunctionInput modelIn,
    FunctionOutput modelOut
  |
    read.getSideEffectOperand() = callInput(call, modelIn) and
    read.getArgumentDef() = nodeIn.getDef() and
    not read.getSideEffect().isResultModeled() and
    call.getStaticCallTarget() = func and
    (
      func.(DataFlowFunction).hasDataFlow(modelIn, modelOut)
      or
      func.(TaintFunction).hasTaintFlow(modelIn, modelOut)
    ) and
    nodeOut = callOutput(call, modelOut)
  )
}
