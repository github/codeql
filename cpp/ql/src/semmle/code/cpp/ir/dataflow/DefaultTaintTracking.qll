import cpp
import semmle.code.cpp.security.Security
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.DataFlow2
private import semmle.code.cpp.ir.dataflow.DataFlow3
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

/**
 * Functions that we should only allow taint to flow through (to the return
 * value) if all but the source argument are 'predictable'.  This is done to
 * emulate the old security library's implementation rather than due to any
 * strong belief that this is the right approach.
 *
 * Note that the list itself is not very principled; it consists of all the
 * functions listed in the old security library's [default] `isPureFunction`
 * that have more than one argument, but are not in the old taint tracking
 * library's `returnArgument` predicate.  In addition, `strlen` is included
 * because it's also a special case in flow to return values.
 */
predicate predictableOnlyFlow(string name) {
  name = "strcasestr" or
  name = "strchnul" or
  name = "strchr" or
  name = "strchrnul" or
  name = "strcmp" or
  name = "strcspn" or
  name = "strlen" or // special case
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
    result = DataFlow::definitionByReferenceNode(source) and
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

private predicate nodeIsBarrierIn(DataFlow::Node node) {
  // don't use dataflow into taint sources, as this leads to duplicate results.
  node = getNodeForSource(any(Expr e))
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
  i2.(UnaryInstruction).getUnary() = i1
  or
  i2.(ChiInstruction).getPartial() = i1 and
  not i2.isResultConflated()
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

cached
predicate tainted(Expr source, Element tainted) {
  exists(DefaultTaintTrackingCfg cfg, DataFlow::Node sink |
    cfg.hasFlow(getNodeForSource(source), sink) and
    tainted = adjustedSink(sink)
  )
}

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

GlobalOrNamespaceVariable globalVarFromId(string id) { id = result.getQualifiedName() }

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
   * The same should ideally be done with the source, but we haven't seen a
   * need for it yet.
   */

  private newtype TPathNode =
    TWrapPathNode(DataFlow3::PathNode n) or
    TFinalPathNode(Element e) { exists(TaintTrackingConfiguration cfg | cfg.isSink(e)) }

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

  private class WrapPathNode extends PathNode, TPathNode {
    DataFlow3::PathNode inner() { this = TWrapPathNode(result) }

    override string toString() { result = this.inner().toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.inner().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  private class FinalPathNode extends PathNode, TFinalPathNode {
    Element inner() { this = TFinalPathNode(result) }

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

  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode a, PathNode b) {
    DataFlow3::PathGraph::edges(a.(WrapPathNode).inner(), b.(WrapPathNode).inner())
    or
    // To avoid showing trivial-looking steps, we replace the last node instead
    // of adding an edge out of it.
    exists(WrapPathNode replaced |
      DataFlow3::PathGraph::edges(a.(WrapPathNode).inner(), replaced.inner()) and
      b.(FinalPathNode).inner() = adjustedSink(replaced.inner().getNode())
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
    exists(AdjustedConfiguration cfg, DataFlow3::PathNode sinkInner |
      sourceNode.(WrapPathNode).inner().getNode() = getNodeForSource(source) and
      cfg.hasFlowPath(sourceNode.(WrapPathNode).inner(), sinkInner) and
      tainted = adjustedSink(sinkInner.getNode()) and
      tainted = sinkNode.(FinalPathNode).inner()
    )
  }
}
