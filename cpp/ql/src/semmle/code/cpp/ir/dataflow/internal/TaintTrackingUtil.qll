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
predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  localInstructionTaintStep(nodeFrom.asInstruction(), nodeTo.asInstruction())
}

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
private predicate localInstructionTaintStep(Instruction nodeFrom, Instruction nodeTo) {
  // Taint can flow through expressions that alter the value but preserve
  // more than one bit of it _or_ expressions that follow data through
  // pointer indirections.
  nodeTo.getAnOperand().getAnyDef() = nodeFrom and
  (
    nodeTo instanceof ArithmeticInstruction
    or
    nodeTo instanceof BitwiseInstruction
    or
    nodeTo instanceof PointerArithmeticInstruction
    or
    nodeTo instanceof FieldAddressInstruction
    or
    // The `CopyInstruction` case is also present in non-taint data flow, but
    // that uses `getDef` rather than `getAnyDef`. For taint, we want flow
    // from a definition of `myStruct` to a `myStruct.myField` expression.
    nodeTo instanceof CopyInstruction
  )
  or
  nodeTo.(LoadInstruction).getSourceAddress() = nodeFrom
  or
  modeledInstructionTaintStep(nodeFrom, nodeTo)
  or
  // Flow through partial reads of arrays and unions
  nodeTo.(LoadInstruction).getSourceValueOperand().getAnyDef() = nodeFrom and
  not nodeFrom.isResultConflated() and
  (
    nodeFrom.getResultType() instanceof ArrayType or
    nodeFrom.getResultType() instanceof Union
  )
  or
  // Flow from an element to an array or union that contains it.
  nodeTo.(ChiInstruction).getPartial() = nodeFrom and
  not nodeTo.isResultConflated() and
  exists(Type t | nodeTo.getResultLanguageType().hasType(t, false) |
    t instanceof Union
    or
    t instanceof ArrayType
  )
  or
  // Until we have from through indirections across calls, we'll take flow out
  // of the parameter and into its indirection.
  exists(IRFunction f, Parameter parameter |
    nodeFrom = getInitializeParameter(f, parameter) and
    nodeTo = getInitializeIndirection(f, parameter)
  )
  or
  // Until we have flow through indirections across calls, we'll take flow out
  // of the indirection and into the argument.
  // When we get proper flow through indirections across calls, this code can be
  // moved to `adjusedSink` or possibly into the `DataFlow::ExprNode` class.
  exists(ReadSideEffectInstruction read |
    read.getAnOperand().(SideEffectOperand).getAnyDef() = nodeFrom and
    read.getArgumentDef() = nodeTo
  )
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
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }

/**
 * Holds if taint can flow from `instrIn` to `instrOut` through a call to a
 * modeled function.
 */
predicate modeledInstructionTaintStep(Instruction instrIn, Instruction instrOut) {
  exists(CallInstruction call, TaintFunction func, FunctionInput modelIn, FunctionOutput modelOut |
    instrIn = callInput(call, modelIn) and
    instrOut = callOutput(call, modelOut) and
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
    instrIn = callInput(call, modelIn) and
    instrOut = callOutput(call, modelOut) and
    call.getStaticCallTarget() = func and
    func.(TaintFunction).hasTaintFlow(modelIn, modelMidOut) and
    func.(DataFlowFunction).hasDataFlow(modelMidIn, modelOut) and
    modelMidOut.isParameterDeref(indexMid) and
    modelMidIn.isParameter(indexMid)
  )
}

pragma[noinline]
private InitializeIndirectionInstruction getInitializeIndirection(IRFunction f, Parameter p) {
  result.getParameter() = p and
  result.getEnclosingIRFunction() = f
}

pragma[noinline]
private InitializeParameterInstruction getInitializeParameter(IRFunction f, Parameter p) {
  result.getParameter() = p and
  result.getEnclosingIRFunction() = f
}