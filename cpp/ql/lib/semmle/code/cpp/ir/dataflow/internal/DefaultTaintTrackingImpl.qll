/**
 * INTERNAL: Do not use.
 *
 * An IR taint tracking library that uses an IR DataFlow configuration to track
 * taint from user inputs as defined by `semmle.code.cpp.security.Security`.
 */

import cpp
import semmle.code.cpp.security.Security
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.ResolveCall
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.models.interfaces.Taint
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.ir.dataflow.TaintTracking
private import semmle.code.cpp.ir.dataflow.TaintTracking2
private import semmle.code.cpp.ir.dataflow.TaintTracking3
private import semmle.code.cpp.ir.dataflow.internal.ModelUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

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
  name =
    [
      "strcasestr", "strchnul", "strchr", "strchrnul", "strcmp", "strcspn", "strncmp", "strndup",
      "strnlen", "strrchr", "strspn", "strstr", "strtod", "strtof", "strtol", "strtoll", "strtoq",
      "strtoul"
    ]
}

private DataFlow::Node getNodeForSource(Expr source) {
  isUserInput(source, _) and
  result = getNodeForExpr(source)
}

private DataFlow::Node getNodeForExpr(Expr node) {
  node = DataFlow::ExprFlowCached::asExprInternal(result)
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
  result = DataFlow::definitionByReferenceNodeFromArgument(node) and
  not argv(node.(VariableAccess).getTarget())
}

private predicate conflatePointerAndPointee(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // Flow from `op` to `*op`.
  exists(Operand operand, int indirectionIndex |
    nodeHasOperand(nodeFrom, operand, indirectionIndex) and
    nodeHasOperand(nodeTo, operand, indirectionIndex - 1)
  )
  or
  // Flow from `instr` to `*instr`.
  exists(Instruction instr, int indirectionIndex |
    nodeHasInstruction(nodeFrom, instr, indirectionIndex) and
    nodeHasInstruction(nodeTo, instr, indirectionIndex - 1)
  )
}

private module DefaultTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

  predicate isSink(DataFlow::Node sink) { exists(adjustedSink(sink)) }

  predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

  predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    conflatePointerAndPointee(nodeFrom, nodeTo)
  }
}

private module DefaultTaintTrackingFlow = TaintTracking::Global<DefaultTaintTrackingConfig>;

private module ToGlobalVarTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = getNodeForSource(_) }

  predicate isSink(DataFlow::Node sink) { sink.asVariable() instanceof GlobalOrNamespaceVariable }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    writesVariable(n1.asInstruction(), n2.asVariable().(GlobalOrNamespaceVariable))
    or
    readsVariable(n2.asInstruction(), n1.asVariable().(GlobalOrNamespaceVariable))
  }

  predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

  predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }
}

private module ToGlobalVarTaintTrackingFlow = TaintTracking::Global<ToGlobalVarTaintTrackingConfig>;

private module FromGlobalVarTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // This set of sources should be reasonably small, which is good for
    // performance since the set of sinks is very large.
    ToGlobalVarTaintTrackingFlow::flowTo(source)
  }

  predicate isSink(DataFlow::Node sink) { exists(adjustedSink(sink)) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    // Additional step for flow out of variables. There is no flow _into_
    // variables in this configuration, so this step only serves to take flow
    // out of a variable that's a source.
    readsVariable(n2.asInstruction(), n1.asVariable())
  }

  predicate isBarrier(DataFlow::Node node) { nodeIsBarrier(node) }

  predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }
}

private module FromGlobalVarTaintTrackingFlow =
  TaintTracking::Global<FromGlobalVarTaintTrackingConfig>;

private predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getAstVariable() = var
}

private predicate writesVariable(StoreInstruction store, Variable var) {
  store.getDestinationAddress().(VariableAddressInstruction).getAstVariable() = var
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
  exists(Instruction instr | instr = node.asOperand().getDef() |
    readsVariable(instr, checkedVar) and
    any(IRGuardCondition guard).ensuresEq(access, _, _, instr.getBlock(), true)
  )
}

cached
private module Cached {
  cached
  predicate nodeIsBarrier(DataFlow::Node node) {
    exists(Variable checkedVar, Instruction instr | instr = node.asOperand().getDef() |
      readsVariable(instr, checkedVar) and
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

  cached
  predicate nodeIsBarrierIn(DataFlow::Node node) {
    // don't use dataflow into taint sources, as this leads to duplicate results.
    exists(Expr source | isUserInput(source, _) |
      source = DataFlow::ExprFlowCached::asExprInternal(node)
      or
      // This case goes together with the similar (but not identical) rule in
      // `getNodeForSource`.
      node = DataFlow::definitionByReferenceNodeFromArgument(source)
    )
    or
    // don't use dataflow into binary instructions if both operands are unpredictable
    exists(BinaryInstruction iTo |
      iTo = node.asInstruction() and
      not predictableInstruction(iTo.getLeft()) and
      not predictableInstruction(iTo.getRight()) and
      // propagate taint from either the pointer or the offset, regardless of predictability
      not iTo instanceof PointerArithmeticInstruction
    )
    or
    // don't use dataflow through calls to pure functions if two or more operands
    // are unpredictable
    exists(Instruction iFrom1, Instruction iFrom2, CallInstruction iTo |
      iTo = node.asInstruction() and
      isPureFunction(iTo.getStaticCallTarget().getName()) and
      iFrom1 = iTo.getAnArgument() and
      iFrom2 = iTo.getAnArgument() and
      not predictableInstruction(iFrom1) and
      not predictableInstruction(iFrom2) and
      iFrom1 != iFrom2
    )
  }

  cached
  Element adjustedSink(DataFlow::Node sink) {
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
      sink.asExpr() = call.getArgument(pragma[only_bind_into](i)) and
      result = resolveCall(call).getParameter(pragma[only_bind_into](i))
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
    or
    result =
      sink.asOperand()
          .(SideEffectOperand)
          .getUse()
          .(ReadSideEffectInstruction)
          .getArgumentDef()
          .getUnconvertedResultExpression()
  }

  /**
   * Step to return value of a modeled function when an input taints the
   * dereference of the return value.
   */
  cached
  predicate additionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(CallInstruction call, Function func, FunctionInput modelIn, FunctionOutput modelOut |
      n1 = callInput(call, modelIn) and
      (
        func.(TaintFunction).hasTaintFlow(modelIn, modelOut)
        or
        func.(DataFlowFunction).hasDataFlow(modelIn, modelOut)
      ) and
      call.getStaticCallTarget() = func and
      modelOut.isReturnValueDeref() and
      call = n2.asInstruction()
    )
  }
}

private import Cached

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
  exists(DataFlow::Node sink |
    DefaultTaintTrackingFlow::flow(getNodeForSource(source), sink) and
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
    DataFlow::VariableNode variableNode, GlobalOrNamespaceVariable global, DataFlow::Node sink
  |
    global = variableNode.getVariable() and
    ToGlobalVarTaintTrackingFlow::flow(getNodeForSource(source), variableNode) and
    FromGlobalVarTaintTrackingFlow::flow(variableNode, sink) and
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
    /** Override this to specify which elements are sources in this configuration. */
    predicate isSource(Expr source) { exists(getNodeForSource(source)) }

    /** Override this to specify which elements are sinks in this configuration. */
    abstract predicate isSink(Element e);

    /** Override this to specify which expressions are barriers in this configuration. */
    predicate isBarrier(Expr e) { nodeIsBarrier(getNodeForExpr(e)) }

    /**
     * Override this predicate to `any()` to allow taint to flow through global
     * variables.
     */
    predicate taintThroughGlobals() { none() }

    /** Gets a textual representation of this element. */
    string toString() { result = "TaintTrackingConfiguration" }
  }

  private module AdjustedConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists(TaintTrackingConfiguration cfg, Expr e |
        cfg.isSource(e) and source = getNodeForExpr(e)
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(TaintTrackingConfiguration cfg | cfg.isSink(adjustedSink(sink)))
    }

    predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
      conflatePointerAndPointee(n1, n2)
      or
      // Steps into and out of global variables
      exists(TaintTrackingConfiguration cfg | cfg.taintThroughGlobals() |
        writesVariable(n1.asInstruction(), n2.asVariable().(GlobalOrNamespaceVariable))
        or
        readsVariable(n2.asInstruction(), n1.asVariable().(GlobalOrNamespaceVariable))
      )
      or
      additionalTaintStep(n1, n2)
    }

    predicate isBarrier(DataFlow::Node node) {
      exists(TaintTrackingConfiguration cfg, Expr e | cfg.isBarrier(e) and node = getNodeForExpr(e))
    }

    predicate isBarrierIn(DataFlow::Node node) { nodeIsBarrierIn(node) }

    predicate neverSkip(Node node) { none() }
  }

  private module AdjustedFlow = TaintTracking::Global<AdjustedConfig>;

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
    TWrapPathNode(AdjustedFlow::PathNode n) or
    // There's a single newtype constructor for both sources and sinks since
    // that makes it easiest to deal with the case where source = sink.
    TEndpointPathNode(Element e) {
      exists(DataFlow::Node sourceNode, DataFlow::Node sinkNode |
        AdjustedFlow::flow(sourceNode, sinkNode)
      |
        sourceNode = getNodeForExpr(e) and
        exists(TaintTrackingConfiguration ttCfg | ttCfg.isSource(e))
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
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      none()
    }
  }

  /**
   * INTERNAL: Do not use.
   */
  module Private {
    /** Gets a predecessor `PathNode` of `pathNode`, if any. */
    PathNode getAPredecessor(PathNode pathNode) { edges(result, pathNode) }

    /** Gets the element that `pathNode` wraps, if any. */
    Element getElementFromPathNode(PathNode pathNode) {
      exists(DataFlow::Node node | node = pathNode.(WrapPathNode).inner().getNode() |
        result = node.asInstruction().getAst()
        or
        result = node.asOperand().getDef().getAst()
      )
      or
      result = pathNode.(EndpointPathNode).inner()
    }
  }

  private class WrapPathNode extends PathNode, TWrapPathNode {
    AdjustedFlow::PathNode inner() { this = TWrapPathNode(result) }

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
      this.inner()
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  /** A PathNode whose `Element` is a source. It may also be a sink. */
  private class InitialPathNode extends EndpointPathNode {
    InitialPathNode() { exists(TaintTrackingConfiguration cfg | cfg.isSource(this.inner())) }
  }

  /** A PathNode whose `Element` is a sink. It may also be a source. */
  private class FinalPathNode extends EndpointPathNode {
    FinalPathNode() { exists(TaintTrackingConfiguration cfg | cfg.isSink(this.inner())) }
  }

  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode a, PathNode b) {
    AdjustedFlow::PathGraph::edges(a.(WrapPathNode).inner(), b.(WrapPathNode).inner())
    or
    // To avoid showing trivial-looking steps, we _replace_ the last node instead
    // of adding an edge out of it.
    exists(WrapPathNode sinkNode |
      AdjustedFlow::PathGraph::edges(a.(WrapPathNode).inner(), sinkNode.inner()) and
      b.(FinalPathNode).inner() = adjustedSink(sinkNode.inner().getNode())
    )
    or
    // Same for the first node
    exists(WrapPathNode sourceNode |
      AdjustedFlow::PathGraph::edges(sourceNode.inner(), b.(WrapPathNode).inner()) and
      sourceNode.inner().getNode() = getNodeForExpr(a.(InitialPathNode).inner())
    )
    or
    // Finally, handle the case where the path goes directly from a source to a
    // sink, meaning that they both need to be translated.
    exists(WrapPathNode sinkNode, WrapPathNode sourceNode |
      AdjustedFlow::PathGraph::edges(sourceNode.inner(), sinkNode.inner()) and
      sourceNode.inner().getNode() = getNodeForExpr(a.(InitialPathNode).inner()) and
      b.(FinalPathNode).inner() = adjustedSink(sinkNode.inner().getNode())
    )
  }

  /**
   * Holds if there is flow from `arg` to `out` across a call that can by summarized by the flow
   * from `par` to `ret` within it, in the graph of data flow path explanations.
   */
  query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
    AdjustedFlow::PathGraph::subpaths(arg.(WrapPathNode).inner(), par.(WrapPathNode).inner(),
      ret.(WrapPathNode).inner(), out.(WrapPathNode).inner())
    or
    // To avoid showing trivial-looking steps, we _replace_ the last node instead
    // of adding an edge out of it.
    exists(WrapPathNode sinkNode |
      AdjustedFlow::PathGraph::subpaths(arg.(WrapPathNode).inner(), par.(WrapPathNode).inner(),
        ret.(WrapPathNode).inner(), sinkNode.inner()) and
      out.(FinalPathNode).inner() = adjustedSink(sinkNode.inner().getNode())
    )
    or
    // Same for the first node
    exists(WrapPathNode sourceNode |
      AdjustedFlow::PathGraph::subpaths(sourceNode.inner(), par.(WrapPathNode).inner(),
        ret.(WrapPathNode).inner(), out.(WrapPathNode).inner()) and
      sourceNode.inner().getNode() = getNodeForExpr(arg.(InitialPathNode).inner())
    )
    or
    // Finally, handle the case where the path goes directly from a source to a
    // sink, meaning that they both need to be translated.
    exists(WrapPathNode sinkNode, WrapPathNode sourceNode |
      AdjustedFlow::PathGraph::subpaths(sourceNode.inner(), par.(WrapPathNode).inner(),
        ret.(WrapPathNode).inner(), sinkNode.inner()) and
      sourceNode.inner().getNode() = getNodeForExpr(arg.(InitialPathNode).inner()) and
      out.(FinalPathNode).inner() = adjustedSink(sinkNode.inner().getNode())
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
    exists(DataFlow::Node flowSource, DataFlow::Node flowSink |
      source = sourceNode.(InitialPathNode).inner() and
      flowSource = getNodeForExpr(source) and
      AdjustedFlow::flow(flowSource, flowSink) and
      tainted = adjustedSink(flowSink) and
      tainted = sinkNode.(FinalPathNode).inner()
    )
  }

  private predicate isGlobalVariablePathNode(WrapPathNode n) {
    n.inner().getNode().asVariable() instanceof GlobalOrNamespaceVariable
    or
    n.inner().getNode().asIndirectVariable() instanceof GlobalOrNamespaceVariable
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
      AdjustedConfig::isSource(sourceNode.(WrapPathNode).inner().getNode()) and
      edgesWithoutGlobals+(sourceNode, sinkNode) and
      tainted = sinkNode.inner()
    )
  }
}
