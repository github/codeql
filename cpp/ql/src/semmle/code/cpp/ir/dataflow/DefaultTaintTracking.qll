import cpp
import semmle.code.cpp.security.Security
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.DataFlow2
private import semmle.code.cpp.ir.dataflow.DataFlow3
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.internal.DataFlowDispatch as Dispatch
private import semmle.code.cpp.controlflow.IRGuards
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

/**
 * Functions that we should only allow taint to flow through (to the return
 * value) if all but the source argument are 'predictable'.  This is done to
 * emulate the old security library's implementation rather than due to any
 * strong belief that this is the right approach.
 *
 * Note that the list itself is not very principled; it consists of all the
 * functions listed in the old security library's [default] `isPureFunction`
 * that have more than one argument, but are not in the old taint tracking
 * library's `returnArgument` predicate.
 */
predicate predictableOnlyFlow(string name) {
  name = "strcasestr" or
  name = "strchnul" or
  name = "strchr" or
  name = "strchrnul" or
  name = "strcmp" or
  name = "strcspn" or
  name = "strncmp" or
  name = "strndup" or
  name = "strnlen" or
  name = "strrchr" or
  name = "strspn" or
  name = "strstr" or
  name = "strtod" or
  name = "strtof" or
  name = "strtol" or
  name = "strtoll" or
  name = "strtoq" or
  name = "strtoul"
}

private DataFlow::Node getNodeForSource(Expr source) {
  isUserInput(source, _) and
  (
    result = DataFlow::exprNode(source)
    or
    // Some of the sources in `isUserInput` are intended to match the value of
    // an expression, while others (those modeled below) are intended to match
    // the taint that propagates out of an argument, like the `char *` argument
    // to `gets`. It's impossible here to tell which is which, but the "access
    // to argv" source is definitely not intended to match an output argument,
    // and it causes false positives if we let it.
    //
    // This case goes together with the similar (but not identical) rule in
    // `nodeIsBarrierIn`.
    result = DataFlow::definitionByReferenceNodeFromArgument(source) and
    not argv(source.(VariableAccess).getTarget())
  )
}

private class DefaultTaintTrackingCfg extends DataFlow::Configuration {
  DefaultTaintTrackingCfg() { this = "DefaultTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

  override predicate isSink(DataFlow::Node sink) { exists(adjustedSink(sink)) }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
  }

  override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

  override predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }
}

private class ToGlobalVarTaintTrackingCfg extends DataFlow::Configuration {
  ToGlobalVarTaintTrackingCfg() { this = "GlobalVarTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

  override predicate isSink(DataFlow::Node sink) {
    sink.asVariable() instanceof GlobalOrNamespaceVariable
  }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
    or
    writesVariable(n1.asInstruction(), n2.asVariable().(GlobalOrNamespaceVariable))
    or
    readsVariable(n2.asInstruction(), n1.asVariable().(GlobalOrNamespaceVariable))
  }

  override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

  override predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }
}

private class FromGlobalVarTaintTrackingCfg extends DataFlow2::Configuration {
  FromGlobalVarTaintTrackingCfg() { this = "FromGlobalVarTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) {
    // This set of sources should be reasonably small, which is good for
    // performance since the set of sinks is very large.
    exists(ToGlobalVarTaintTrackingCfg otherCfg | otherCfg.hasFlowTo(source))
  }

  override predicate isSink(DataFlow::Node sink) { exists(adjustedSink(sink)) }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
    or
    // Additional step for flow out of variables. There is no flow _into_
    // variables in this configuration, so this step only serves to take flow
    // out of a variable that's a source.
    readsVariable(n2.asInstruction(), n1.asVariable())
  }

  override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

  override predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }
}

private predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getASTVariable() = var
}

private predicate writesVariable(StoreInstruction store, Variable var) {
  store.getDestinationAddress().(VariableAddressInstruction).getASTVariable() = var
}

/**
 * A variable that has any kind of upper-bound check anywhere in the program.  This is
 * biased towards being inclusive because there are a lot of valid ways of doing an
 * upper bounds checks if we don't consider where it occurs, for example:
 * ```
 *   if (x < 10) { sink(x); }
 *
 *   if (10 > y) { sink(y); }
 *
 *   if (z > 10) { z = 10; }
 *   sink(z);
 * ```
 */
// TODO: This coarse overapproximation, ported from the old taint tracking
// library, could be replaced with an actual semantic check that a particular
// variable _access_ is guarded by an upper-bound check. We probably don't want
// to do this right away since it could expose a lot of FPs that were
// previously suppressed by this predicate by coincidence.
private predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getAnOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getAnOperand().getValue() = "0"
  )
}

private predicate nodeIsBarrierEqualityCandidate(
  DataFlow::Node node, Operand access, Variable checkedVar
) {
  readsVariable(node.asInstruction(), checkedVar) and
  any(IRGuardCondition guard).ensuresEq(access, _, _, node.asInstruction().getBlock(), true)
}

private predicate nodeIsBarrier(DataFlow::Node node) {
  exists(Variable checkedVar |
    readsVariable(node.asInstruction(), checkedVar) and
    hasUpperBoundsCheck(checkedVar)
  )
  or
  exists(Variable checkedVar, Operand access |
    /*
     * This node is guarded by a condition that forces the accessed variable
     * to equal something else.  For example:
     * ```
     * x = taintsource()
     * if (x == 10) {
     *   taintsink(x); // not considered tainted
     * }
     * ```
     */

    nodeIsBarrierEqualityCandidate(node, access, checkedVar) and
    readsVariable(access.getDef(), checkedVar)
  )
}

private predicate nodeIsBarrierIn(DataFlow::Node node) {
  // don't use dataflow into taint sources, as this leads to duplicate results.
  exists(Expr source | isUserInput(source, _) |
    node = DataFlow::exprNode(source)
    or
    // This case goes together with the similar (but not identical) rule in
    // `getNodeForSource`.
    node = DataFlow::definitionByReferenceNodeFromArgument(source)
  )
}

cached
private predicate instructionTaintStep(Instruction i1, Instruction i2) {
  // Expressions computed from tainted data are also tainted
  exists(CallInstruction call, int argIndex | call = i2 |
    isPureFunction(call.getStaticCallTarget().getName()) and
    i1 = getACallArgumentOrIndirection(call, argIndex) and
    forall(Instruction arg | arg = call.getAnArgument() |
      arg = getACallArgumentOrIndirection(call, argIndex) or predictableInstruction(arg)
    ) and
    // flow through `strlen` tends to cause dubious results, if the length is
    // bounded.
    not call.getStaticCallTarget().getName() = "strlen"
  )
  or
  // Flow through pointer dereference
  i2.(LoadInstruction).getSourceAddress() = i1
  or
  // Flow through partial reads of arrays and unions
  i2.(LoadInstruction).getSourceValueOperand().getAnyDef() = i1 and
  not i1.isResultConflated() and
  (
    i1.getResultType() instanceof ArrayType or
    i1.getResultType() instanceof Union
  )
  or
  // Unary instructions tend to preserve enough information in practice that we
  // want taint to flow through.
  // The exception is `FieldAddressInstruction`. Together with the rule for
  // `LoadInstruction` above and for `ChiInstruction` below, flow through
  // `FieldAddressInstruction` could cause flow into one field to come out an
  // unrelated field. This would happen across function boundaries, where the IR
  // would not be able to match loads to stores.
  i2.(UnaryInstruction).getUnary() = i1 and
  (
    not i2 instanceof FieldAddressInstruction
    or
    i2.(FieldAddressInstruction).getField().getDeclaringType() instanceof Union
  )
  or
  // Flow out of definition-by-reference
  i2.(ChiInstruction).getPartial() = i1.(WriteSideEffectInstruction) and
  not i2.isResultConflated()
  or
  // Flow from an element to an array or union that contains it.
  i2.(ChiInstruction).getPartial() = i1 and
  not i2.isResultConflated() and
  exists(Type t | i2.getResultLanguageType().hasType(t, false) |
    t instanceof Union
    or
    t instanceof ArrayType
  )
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
        i1 = getACallArgumentOrIndirection(call, indexIn) and
        not predictableOnlyFlow(call.getStaticCallTarget().getName())
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
  or
  // Taint postfix and prefix crement operations when their operand is tainted.
  result.(CrementOperation).getAnOperand() = sink.asExpr()
  or
  // Taint `e1 += e2`, `e &= e2` and friends when `e1` or `e2` is tainted.
  result.(AssignOperation).getAnOperand() = sink.asExpr()
}

/**
 * Holds if `tainted` may contain taint from `source`.
 *
 * A tainted expression is either directly user input, or is
 * computed from user input in a way that users can probably
 * control the exact output of the computation.
 *
 * This doesn't include data flow through global variables.
 * If you need that you must call `taintedIncludingGlobalVars`.
 */
cached
predicate tainted(Expr source, Element tainted) {
  exists(DefaultTaintTrackingCfg cfg, DataFlow::Node sink |
    cfg.hasFlow(getNodeForSource(source), sink) and
    tainted = adjustedSink(sink)
  )
}

/**
 * Holds if `tainted` may contain taint from `source`, where the taint passed
 * through a global variable named `globalVar`.
 *
 * A tainted expression is either directly user input, or is
 * computed from user input in a way that users can probably
 * control the exact output of the computation.
 *
 * This version gives the same results as tainted but also includes
 * data flow through global variables.
 *
 * The parameter `globalVar` is the qualified name of the last global variable
 * used to move the value from source to tainted. If the taint did not pass
 * through a global variable, then `globalVar = ""`.
 */
cached
predicate taintedIncludingGlobalVars(Expr source, Element tainted, string globalVar) {
  tainted(source, tainted) and
  globalVar = ""
  or
  exists(
    ToGlobalVarTaintTrackingCfg toCfg, FromGlobalVarTaintTrackingCfg fromCfg,
    DataFlow::VariableNode variableNode, GlobalOrNamespaceVariable global, DataFlow::Node sink
  |
    global = variableNode.getVariable() and
    toCfg.hasFlow(getNodeForSource(source), variableNode) and
    fromCfg.hasFlow(variableNode, sink) and
    tainted = adjustedSink(sink) and
    global = globalVarFromId(globalVar)
  )
}

/**
 * Gets the global variable whose qualified name is `id`. Use this predicate
 * together with `taintedIncludingGlobalVars`. Example:
 *
 * ```
 * exists(string varName |
 *   taintedIncludingGlobalVars(source, tainted, varName) and
 *   var = globalVarFromId(varName)
 * )
 * ```
 */
GlobalOrNamespaceVariable globalVarFromId(string id) { id = result.getQualifiedName() }

/**
 * Resolve potential target function(s) for `call`.
 *
 * If `call` is a call through a function pointer (`ExprCall`) or
 * targets a virtual method, simple data flow analysis is performed
 * in order to identify target(s).
 */
Function resolveCall(Call call) {
  exists(CallInstruction callInstruction |
    callInstruction.getAST() = call and
    result = Dispatch::viableCallable(callInstruction)
  )
}

/**
 * Provides definitions for augmenting source/sink pairs with data-flow paths
 * between them. From a `@kind path-problem` query, import this module in the
 * global scope, extend `TaintTrackingConfiguration`, and use `taintedWithPath`
 * in place of `tainted`.
 *
 * Importing this module will also import the query predicates that contain the
 * taint paths.
 */
module TaintedWithPath {
  private newtype TSingleton = MkSingleton()

  /**
   * A taint-tracking configuration that matches sources and sinks in the same
   * way as the `tainted` predicate.
   *
   * Override `isSink` and `taintThroughGlobals` as needed, but do not provide
   * a characteristic predicate.
   */
  class TaintTrackingConfiguration extends TSingleton {
    /** Override this to specify which elements are sinks in this configuration. */
    abstract predicate isSink(Element e);

    /**
     * Override this predicate to `any()` to allow taint to flow through global
     * variables.
     */
    predicate taintThroughGlobals() { none() }

    /** Gets a textual representation of this element. */
    string toString() { result = "TaintTrackingConfiguration" }
  }

  private class AdjustedConfiguration extends DataFlow3::Configuration {
    AdjustedConfiguration() { this = "AdjustedConfiguration" }

    override predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

    override predicate isSink(DataFlow::Node sink) {
      exists(TaintTrackingConfiguration cfg | cfg.isSink(adjustedSink(sink)))
    }

    override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
      instructionTaintStep(n1.asInstruction(), n2.asInstruction())
      or
      exists(TaintTrackingConfiguration cfg | cfg.taintThroughGlobals() |
        writesVariable(n1.asInstruction(), n2.asVariable().(GlobalOrNamespaceVariable))
        or
        readsVariable(n2.asInstruction(), n1.asVariable().(GlobalOrNamespaceVariable))
      )
    }

    override predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

    override predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }
  }

  /*
   * A sink `Element` may map to multiple `DataFlowX::PathNode`s via (the
   * inverse of) `adjustedSink`. For example, an `Expr` maps to all its
   * conversions, and a `Variable` maps to all loads and stores from it. Because
   * the path node is part of the tuple that constitutes the alert, this leads
   * to duplicate alerts.
   *
   * To avoid showing duplicates, we edit the graph to replace the final node
   * coming from the data-flow library with a node that matches exactly the
   * `Element` sink that's requested.
   *
   * The same is done for sources.
   */

  private newtype TPathNode =
    TWrapPathNode(DataFlow3::PathNode n) or
    // There's a single newtype constructor for both sources and sinks since
    // that makes it easiest to deal with the case where source = sink.
    TEndpointPathNode(Element e) {
      exists(AdjustedConfiguration cfg, DataFlow3::Node sourceNode, DataFlow3::Node sinkNode |
        cfg.hasFlow(sourceNode, sinkNode)
      |
        sourceNode = getNodeForSource(e)
        or
        e = adjustedSink(sinkNode) and
        exists(TaintTrackingConfiguration ttCfg | ttCfg.isSink(e))
      )
    }

  /** An opaque type used for the nodes of a data-flow path. */
  class PathNode extends TPathNode {
    /** Gets a textual representation of this element. */
    string toString() { none() }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      none()
    }
  }

  private class WrapPathNode extends PathNode, TWrapPathNode {
    DataFlow3::PathNode inner() { this = TWrapPathNode(result) }

    override string toString() { result = this.inner().toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.inner().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  private class EndpointPathNode extends PathNode, TEndpointPathNode {
    Expr inner() { this = TEndpointPathNode(result) }

    override string toString() { result = this.inner().toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this
          .inner()
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  /** A PathNode whose `Element` is a source. It may also be a sink. */
  private class InitialPathNode extends EndpointPathNode {
    InitialPathNode() { exists(getNodeForSource(this.inner())) }
  }

  /** A PathNode whose `Element` is a sink. It may also be a source. */
  private class FinalPathNode extends EndpointPathNode {
    FinalPathNode() { exists(TaintTrackingConfiguration cfg | cfg.isSink(this.inner())) }
  }

  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode a, PathNode b) {
    DataFlow3::PathGraph::edges(a.(WrapPathNode).inner(), b.(WrapPathNode).inner())
    or
    // To avoid showing trivial-looking steps, we _replace_ the last node instead
    // of adding an edge out of it.
    exists(WrapPathNode sinkNode |
      DataFlow3::PathGraph::edges(a.(WrapPathNode).inner(), sinkNode.inner()) and
      b.(FinalPathNode).inner() = adjustedSink(sinkNode.inner().getNode())
    )
    or
    // Same for the first node
    exists(WrapPathNode sourceNode |
      DataFlow3::PathGraph::edges(sourceNode.inner(), b.(WrapPathNode).inner()) and
      sourceNode.inner().getNode() = getNodeForSource(a.(InitialPathNode).inner())
    )
    or
    // Finally, handle the case where the path goes directly from a source to a
    // sink, meaning that they both need to be translated.
    exists(WrapPathNode sinkNode, WrapPathNode sourceNode |
      DataFlow3::PathGraph::edges(sourceNode.inner(), sinkNode.inner()) and
      sourceNode.inner().getNode() = getNodeForSource(a.(InitialPathNode).inner()) and
      b.(FinalPathNode).inner() = adjustedSink(sinkNode.inner().getNode())
    )
  }

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  query predicate nodes(PathNode n, string key, string val) {
    key = "semmle.label" and val = n.toString()
  }

  /**
   * Holds if `tainted` may contain taint from `source`, where `sourceNode` and
   * `sinkNode` are the corresponding `PathNode`s that can be used in a query
   * to provide path explanations. Extend `TaintTrackingConfiguration` to use
   * this predicate.
   *
   * A tainted expression is either directly user input, or is computed from
   * user input in a way that users can probably control the exact output of
   * the computation.
   */
  predicate taintedWithPath(Expr source, Element tainted, PathNode sourceNode, PathNode sinkNode) {
    exists(AdjustedConfiguration cfg, DataFlow3::Node flowSource, DataFlow3::Node flowSink |
      source = sourceNode.(InitialPathNode).inner() and
      flowSource = getNodeForSource(source) and
      cfg.hasFlow(flowSource, flowSink) and
      tainted = adjustedSink(flowSink) and
      tainted = sinkNode.(FinalPathNode).inner()
    )
  }

  private predicate isGlobalVariablePathNode(WrapPathNode n) {
    n.inner().getNode().asVariable() instanceof GlobalOrNamespaceVariable
  }

  private predicate edgesWithoutGlobals(PathNode a, PathNode b) {
    edges(a, b) and
    not isGlobalVariablePathNode(a) and
    not isGlobalVariablePathNode(b)
  }

  /**
   * Holds if `tainted` can be reached from a taint source without passing
   * through a global variable.
   */
  predicate taintedWithoutGlobals(Element tainted) {
    exists(PathNode sourceNode, FinalPathNode sinkNode |
      sourceNode.(WrapPathNode).inner().getNode() = getNodeForSource(_) and
      edgesWithoutGlobals+(sourceNode, sinkNode) and
      tainted = sinkNode.inner()
    )
  }
}
