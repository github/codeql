import cpp
import semmle.code.cpp.security.Security
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.DataFlow2
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.internal.DataFlowDispatch as Dispatch
private import semmle.code.cpp.models.interfaces.Taint
private import semmle.code.cpp.models.interfaces.DataFlow

/**
 * A predictable instruction is one where an external user can predict
 * the value. For example, a literal in the source code is considered
 * predictable.
 */
private predicate predictableInstruction(Instruction instr) {
  instr instanceof ConstantInstruction
  or
  instr instanceof StringConstantInstruction
  or
  // This could be a conversion on a string literal
  predictableInstruction(instr.(UnaryInstruction).getUnary())
}

private DataFlow::Node getNodeForSource(Expr source) {
  isUserInput(source, _) and
  (
    result = DataFlow::exprNode(source)
    or
    result = DataFlow::definitionByReferenceNode(source)
  )
}

private class DefaultTaintTrackingCfg extends DataFlow::Configuration {
  DefaultTaintTrackingCfg() { this = "DefaultTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

  override predicate isSink(DataFlow::Node sink) { any() }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
  }

  override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }
}

private class ToGlobalVarTaintTrackingCfg extends DataFlow::Configuration {
  ToGlobalVarTaintTrackingCfg() { this = "GlobalVarTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

  override predicate isSink(DataFlow::Node sink) {
    exists(GlobalOrNamespaceVariable gv | writesVariable(sink.asInstruction(), gv))
  }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
    or
    exists(StoreInstruction i1, LoadInstruction i2, GlobalOrNamespaceVariable gv |
      writesVariable(i1, gv) and
      readsVariable(i2, gv) and
      i1 = n1.asInstruction() and
      i2 = n2.asInstruction()
    )
  }

  override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }
}

private class FromGlobalVarTaintTrackingCfg extends DataFlow2::Configuration {
  FromGlobalVarTaintTrackingCfg() { this = "FromGlobalVarTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) {
    exists(
      ToGlobalVarTaintTrackingCfg other, DataFlow::Node prevSink, GlobalOrNamespaceVariable gv
    |
      other.hasFlowTo(prevSink) and
      writesVariable(prevSink.asInstruction(), gv) and
      readsVariable(source.asInstruction(), gv)
    )
  }

  override predicate isSink(DataFlow::Node sink) { any() }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
  }

  override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }
}

private predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getASTVariable() = var
}

private predicate writesVariable(StoreInstruction store, Variable var) {
  store.getDestinationAddress().(VariableAddressInstruction).getASTVariable() = var
}

/**
 * A variable that has any kind of upper-bound check anywhere in the program
 */
// TODO: This coarse overapproximation, ported from the old taint tracking
// library, could be replaced with an actual semantic check that a particular
// variable _access_ is guarded by an upper-bound check. We probably don't want
// to do this right away since it could expose a lot of FPs that were
// previously suppressed by this predicate by coincidence.
private predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getLeftOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getRightOperand().getValue() = "0"
  )
}

private predicate nodeIsBarrier(DataFlow::Node node) {
  exists(Variable checkedVar |
    readsVariable(node.asInstruction(), checkedVar) and
    hasUpperBoundsCheck(checkedVar)
  )
}

private predicate instructionTaintStep(Instruction i1, Instruction i2) {
  // Expressions computed from tainted data are also tainted
  i2 =
    any(CallInstruction call |
      isPureFunction(call.getStaticCallTarget().getName()) and
      call.getAnArgument() = i1 and
      forall(Instruction arg | arg = call.getAnArgument() | arg = i1 or predictableInstruction(arg)) and
      // flow through `strlen` tends to cause dubious results, if the length is
      // bounded.
      not call.getStaticCallTarget().getName() = "strlen"
    )
  or
  // Flow through pointer dereference
  i2.(LoadInstruction).getSourceAddress() = i1
  or
  i2.(UnaryInstruction).getUnary() = i1
  or
  i2.(ChiInstruction).getPartial() = i1 and
  not isChiForAllAliasedMemory(i2)
  or
  exists(BinaryInstruction bin |
    bin = i2 and
    predictableInstruction(i2.getAnOperand().getDef()) and
    i1 = i2.getAnOperand().getDef()
  )
  or
  // This is part of the translation of `a[i]`, where we want taint to flow
  // from `a`.
  i2.(PointerAddInstruction).getLeft() = i1
  or
  // Until we have from through indirections across calls, we'll take flow out
  // of the parameter and into its indirection.
  exists(IRFunction f, Parameter parameter |
    i1 = getInitializeParameter(f, parameter) and
    i2 = getInitializeIndirection(f, parameter)
  )
  or
  // Until we have flow through indirections across calls, we'll take flow out
  // of the indirection and into the argument.
  // When we get proper flow through indirections across calls, this code can be
  // moved to `adjusedSink` or possibly into the `DataFlow::ExprNode` class.
  exists(ReadSideEffectInstruction read |
    read.getAnOperand().(SideEffectOperand).getAnyDef() = i1 and
    read.getArgumentDef() = i2
  )
  or
  // Flow from argument to return value
  i2 =
    any(CallInstruction call |
      exists(int indexIn |
        modelTaintToReturnValue(call.getStaticCallTarget(), indexIn) and
        i1 = getACallArgumentOrIndirection(call, indexIn)
      )
    )
  or
  // Flow from input argument to output argument
  // TODO: This won't work in practice as long as all aliased memory is tracked
  // together in a single virtual variable.
  // TODO: Will this work on the test for `TaintedPath.ql`, where the output arg
  // is a pointer addition expression?
  i2 =
    any(WriteSideEffectInstruction outNode |
      exists(CallInstruction call, int indexIn, int indexOut |
        modelTaintToParameter(call.getStaticCallTarget(), indexIn, indexOut) and
        i1 = getACallArgumentOrIndirection(call, indexIn) and
        outNode.getIndex() = indexOut and
        outNode.getPrimaryInstruction() = call
      )
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

/**
 * Get an instruction that goes into argument `argumentIndex` of `call`. This
 * can be either directly or through one pointer indirection.
 */
private Instruction getACallArgumentOrIndirection(CallInstruction call, int argumentIndex) {
  result = call.getPositionalArgument(argumentIndex)
  or
  exists(ReadSideEffectInstruction readSE |
    // TODO: why are read side effect operands imprecise?
    result = readSE.getSideEffectOperand().getAnyDef() and
    readSE.getPrimaryInstruction() = call and
    readSE.getIndex() = argumentIndex
  )
}

private predicate modelTaintToParameter(Function f, int parameterIn, int parameterOut) {
  exists(FunctionInput modelIn, FunctionOutput modelOut |
    (
      f.(DataFlowFunction).hasDataFlow(modelIn, modelOut)
      or
      f.(TaintFunction).hasTaintFlow(modelIn, modelOut)
    ) and
    (modelIn.isParameter(parameterIn) or modelIn.isParameterDeref(parameterIn)) and
    modelOut.isParameterDeref(parameterOut)
  )
}

/**
 * Holds if `chi` is on the chain of chi-instructions for all aliased memory.
 * Taint shoud not pass through these instructions since they tend to mix up
 * unrelated objects.
 */
private predicate isChiForAllAliasedMemory(Instruction instr) {
  instr.(ChiInstruction).getTotal() instanceof AliasedDefinitionInstruction
  or
  isChiForAllAliasedMemory(instr.(ChiInstruction).getTotal())
  or
  isChiForAllAliasedMemory(instr.(PhiInstruction).getAnInput())
}

private predicate modelTaintToReturnValue(Function f, int parameterIn) {
  // Taint flow from parameter to return value
  exists(FunctionInput modelIn, FunctionOutput modelOut |
    f.(TaintFunction).hasTaintFlow(modelIn, modelOut) and
    (modelIn.isParameter(parameterIn) or modelIn.isParameterDeref(parameterIn)) and
    (modelOut.isReturnValue() or modelOut.isReturnValueDeref())
  )
  or
  // Data flow (not taint flow) to where the return value points. For the time
  // being we will conflate pointers and objects in taint tracking.
  exists(FunctionInput modelIn, FunctionOutput modelOut |
    f.(DataFlowFunction).hasDataFlow(modelIn, modelOut) and
    (modelIn.isParameter(parameterIn) or modelIn.isParameterDeref(parameterIn)) and
    modelOut.isReturnValueDeref()
  )
  or
  // Taint flow from one argument to another and data flow from an argument to a
  // return value. This happens in functions like `strcat` and `memcpy`. We
  // could model this flow in two separate steps, but that would add reverse
  // flow from the write side-effect to the call instruction, which may not be
  // desirable.
  exists(int parameterMid, InParameter modelMid, OutReturnValue returnOut |
    modelTaintToParameter(f, parameterIn, parameterMid) and
    modelMid.isParameter(parameterMid) and
    f.(DataFlowFunction).hasDataFlow(modelMid, returnOut)
  )
}

private Element adjustedSink(DataFlow::Node sink) {
  // TODO: is it more appropriate to use asConvertedExpr here and avoid
  // `getConversion*`? Or will that cause us to miss some cases where there's
  // flow to a conversion (like a `ReferenceDereferenceExpr`) and we want to
  // pretend there was flow to the converted `Expr` for the sake of
  // compatibility.
  sink.asExpr().getConversion*() = result
  or
  // For compatibility, send flow from arguments to parameters, even for
  // functions with no body.
  exists(FunctionCall call, int i |
    sink.asExpr() = call.getArgument(i) and
    result = resolveCall(call).getParameter(i)
  )
  or
  // For compatibility, send flow into a `Variable` if there is flow to any
  // Load or Store of that variable.
  exists(CopyInstruction copy |
    copy.getSourceValue() = sink.asInstruction() and
    (
      readsVariable(copy, result) or
      writesVariable(copy, result)
    ) and
    not hasUpperBoundsCheck(result)
  )
  or
  // For compatibility, send flow into a `NotExpr` even if it's part of a
  // short-circuiting condition and thus might get skipped.
  result.(NotExpr).getOperand() = sink.asExpr()
}

predicate tainted(Expr source, Element tainted) {
  exists(DefaultTaintTrackingCfg cfg, DataFlow::Node sink |
    cfg.hasFlow(getNodeForSource(source), sink) and
    tainted = adjustedSink(sink)
  )
}

predicate taintedIncludingGlobalVars(Expr source, Element tainted, string globalVar) {
  tainted(source, tainted) and
  globalVar = ""
  or
  exists(
    ToGlobalVarTaintTrackingCfg toCfg, FromGlobalVarTaintTrackingCfg fromCfg, DataFlow::Node store,
    GlobalOrNamespaceVariable global, DataFlow::Node load, DataFlow::Node sink
  |
    toCfg.hasFlow(getNodeForSource(source), store) and
    store
        .asInstruction()
        .(StoreInstruction)
        .getDestinationAddress()
        .(VariableAddressInstruction)
        .getASTVariable() = global and
    load
        .asInstruction()
        .(LoadInstruction)
        .getSourceAddress()
        .(VariableAddressInstruction)
        .getASTVariable() = global and
    fromCfg.hasFlow(load, sink) and
    tainted = adjustedSink(sink) and
    global = globalVarFromId(globalVar)
  )
}

GlobalOrNamespaceVariable globalVarFromId(string id) { id = result.getQualifiedName() }

Function resolveCall(Call call) {
  exists(CallInstruction callInstruction |
    callInstruction.getAST() = call and
    result = Dispatch::viableCallable(callInstruction)
  )
}
