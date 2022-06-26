/**
 * Provides an implementation of global (interprocedural) data flow. This file
 * re-exports the local (intraprocedural) data flow analysis from
 * `DataFlowImplSpecific::Public` and adds a global analysis, mainly exposed
 * through the `Configuration` class. This file exists in several identical
 * copies, allowing queries to use multiple `Configuration` classes that depend
 * on each other without introducing mutual recursion among those configurations.
 */

private import DataFlowImplCommon
private import DataFlowImplSpecific::Private
import DataFlowImplSpecific::Public
import DataFlowImplCommonPublic

/**
 * A configuration of interprocedural data flow analysis. This defines
 * sources, sinks, and any other configurable aspect of the analysis. Each
 * use of the global data flow library must define its own unique extension
 * of this abstract class. To create a configuration, extend this class with
 * a subclass whose characteristic predicate is a unique singleton string.
 * For example, write
 *
 * ```ql
 * class MyAnalysisConfiguration extends DataFlow::Configuration {
 *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
 *   // Override `isSource` and `isSink`.
 *   // Optionally override `isBarrier`.
 *   // Optionally override `isAdditionalFlowStep`.
 * }
 * ```
 * Conceptually, this defines a graph where the nodes are `DataFlow::Node`s and
 * the edges are those data-flow steps that preserve the value of the node
 * along with any additional edges defined by `isAdditionalFlowStep`.
 * Specifying nodes in `isBarrier` will remove those nodes from the graph, and
 * specifying nodes in `isBarrierIn` and/or `isBarrierOut` will remove in-going
 * and/or out-going edges from those nodes, respectively.
 *
 * Then, to query whether there is flow between some `source` and `sink`,
 * write
 *
 * ```ql
 * exists(MyAnalysisConfiguration cfg | cfg.hasFlow(source, sink))
 * ```
 *
 * Multiple configurations can coexist, but two classes extending
 * `DataFlow::Configuration` should never depend on each other. One of them
 * should instead depend on a `DataFlow2::Configuration`, a
 * `DataFlow3::Configuration`, or a `DataFlow4::Configuration`.
 */
abstract class Configuration extends string {
  bindingset[this]
  Configuration() { any() }

  /**
   * Holds if `source` is a relevant data flow source.
   */
  predicate isSource(Node source) { none() }

  /**
   * Holds if `source` is a relevant data flow source with the given initial
   * `state`.
   */
  predicate isSource(Node source, FlowState state) { none() }

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  predicate isSink(Node sink) { none() }

  /**
   * Holds if `sink` is a relevant data flow sink accepting `state`.
   */
  predicate isSink(Node source, FlowState state) { none() }

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  predicate isBarrier(Node node) { none() }

  /**
   * Holds if data flow through `node` is prohibited when the flow state is
   * `state`.
   */
  predicate isBarrier(Node node, FlowState state) { none() }

  /** Holds if data flow into `node` is prohibited. */
  predicate isBarrierIn(Node node) { none() }

  /** Holds if data flow out of `node` is prohibited. */
  predicate isBarrierOut(Node node) { none() }

  /**
   * DEPRECATED: Use `isBarrier` and `BarrierGuard` module instead.
   *
   * Holds if data flow through nodes guarded by `guard` is prohibited.
   */
  deprecated predicate isBarrierGuard(BarrierGuard guard) { none() }

  /**
   * DEPRECATED: Use `isBarrier` and `BarrierGuard` module instead.
   *
   * Holds if data flow through nodes guarded by `guard` is prohibited when
   * the flow state is `state`
   */
  deprecated predicate isBarrierGuard(BarrierGuard guard, FlowState state) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   */
  predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

  /**
   * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
   * This step is only applicable in `state1` and updates the flow state to `state2`.
   */
  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
    none()
  }

  /**
   * Holds if an arbitrary number of implicit read steps of content `c` may be
   * taken at `node`.
   */
  predicate allowImplicitRead(Node node, ContentSet c) { none() }

  /**
   * Gets the virtual dispatch branching limit when calculating field flow.
   * This can be overridden to a smaller value to improve performance (a
   * value of 0 disables field flow), or a larger value to get more results.
   */
  int fieldFlowBranchLimit() { result = 2 }

  /**
   * Gets a data flow configuration feature to add restrictions to the set of
   * valid flow paths.
   *
   * - `FeatureHasSourceCallContext`:
   *    Assume that sources have some existing call context to disallow
   *    conflicting return-flow directly following the source.
   * - `FeatureHasSinkCallContext`:
   *    Assume that sinks have some existing call context to disallow
   *    conflicting argument-to-parameter flow directly preceding the sink.
   * - `FeatureEqualSourceSinkCallContext`:
   *    Implies both of the above and additionally ensures that the entire flow
   *    path preserves the call context.
   */
  FlowFeature getAFeature() { none() }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   */
  predicate hasFlow(Node source, Node sink) { flowsTo(source, sink, this) }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   *
   * The corresponding paths are generated from the end-points and the graph
   * included in the module `PathGraph`.
   */
  predicate hasFlowPath(PathNode source, PathNode sink) { flowsTo(source, sink, _, _, this) }

  /**
   * Holds if data may flow from some source to `sink` for this configuration.
   */
  predicate hasFlowTo(Node sink) { this.hasFlow(_, sink) }

  /**
   * Holds if data may flow from some source to `sink` for this configuration.
   */
  predicate hasFlowToExpr(DataFlowExpr sink) { this.hasFlowTo(exprNode(sink)) }

  /**
   * Gets the exploration limit for `hasPartialFlow` and `hasPartialFlowRev`
   * measured in approximate number of interprocedural steps.
   */
  int explorationLimit() { none() }

  /**
   * Holds if hidden nodes should be included in the data flow graph.
   *
   * This feature should only be used for debugging or when the data flow graph
   * is not visualized (for example in a `path-problem` query).
   */
  predicate includeHiddenNodes() { none() }

  /**
   * Holds if there is a partial data flow path from `source` to `node`. The
   * approximate distance between `node` and the closest source is `dist` and
   * is restricted to be less than or equal to `explorationLimit()`. This
   * predicate completely disregards sink definitions.
   *
   * This predicate is intended for data-flow exploration and debugging and may
   * perform poorly if the number of sources is too big and/or the exploration
   * limit is set too high without using barriers.
   *
   * This predicate is disabled (has no results) by default. Override
   * `explorationLimit()` with a suitable number to enable this predicate.
   *
   * To use this in a `path-problem` query, import the module `PartialPathGraph`.
   */
  final predicate hasPartialFlow(PartialPathNode source, PartialPathNode node, int dist) {
    partialFlow(source, node, this) and
    dist = node.getSourceDistance()
  }

  /**
   * Holds if there is a partial data flow path from `node` to `sink`. The
   * approximate distance between `node` and the closest sink is `dist` and
   * is restricted to be less than or equal to `explorationLimit()`. This
   * predicate completely disregards source definitions.
   *
   * This predicate is intended for data-flow exploration and debugging and may
   * perform poorly if the number of sinks is too big and/or the exploration
   * limit is set too high without using barriers.
   *
   * This predicate is disabled (has no results) by default. Override
   * `explorationLimit()` with a suitable number to enable this predicate.
   *
   * To use this in a `path-problem` query, import the module `PartialPathGraph`.
   *
   * Note that reverse flow has slightly lower precision than the corresponding
   * forward flow, as reverse flow disregards type pruning among other features.
   */
  final predicate hasPartialFlowRev(PartialPathNode node, PartialPathNode sink, int dist) {
    revPartialFlow(node, sink, this) and
    dist = node.getSinkDistance()
  }
}

/**
 * This class exists to prevent mutual recursion between the user-overridden
 * member predicates of `Configuration` and the rest of the data-flow library.
 * Good performance cannot be guaranteed in the presence of such recursion, so
 * it should be replaced by using more than one copy of the data flow library.
 */
abstract private class ConfigurationRecursionPrevention extends Configuration {
  bindingset[this]
  ConfigurationRecursionPrevention() { any() }

  override predicate hasFlow(Node source, Node sink) {
    strictcount(Node n | this.isSource(n)) < 0
    or
    strictcount(Node n | this.isSource(n, _)) < 0
    or
    strictcount(Node n | this.isSink(n)) < 0
    or
    strictcount(Node n | this.isSink(n, _)) < 0
    or
    strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0
    or
    strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, _, n2, _)) < 0
    or
    super.hasFlow(source, sink)
  }
}

private newtype TNodeEx =
  TNodeNormal(Node n) or
  TNodeImplicitRead(Node n, boolean hasRead) {
    any(Configuration c).allowImplicitRead(n, _) and hasRead = [false, true]
  }

private class NodeEx extends TNodeEx {
  string toString() {
    result = this.asNode().toString()
    or
    exists(Node n | this.isImplicitReadNode(n, _) | result = n.toString() + " [Ext]")
  }

  Node asNode() { this = TNodeNormal(result) }

  predicate isImplicitReadNode(Node n, boolean hasRead) { this = TNodeImplicitRead(n, hasRead) }

  Node projectToNode() { this = TNodeNormal(result) or this = TNodeImplicitRead(result, _) }

  pragma[nomagic]
  private DataFlowCallable getEnclosingCallable0() {
    nodeEnclosingCallable(this.projectToNode(), result)
  }

  pragma[inline]
  DataFlowCallable getEnclosingCallable() {
    pragma[only_bind_out](this).getEnclosingCallable0() = pragma[only_bind_into](result)
  }

  pragma[nomagic]
  private DataFlowType getDataFlowType0() { nodeDataFlowType(this.asNode(), result) }

  pragma[inline]
  DataFlowType getDataFlowType() {
    pragma[only_bind_out](this).getDataFlowType0() = pragma[only_bind_into](result)
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.projectToNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class ArgNodeEx extends NodeEx {
  ArgNodeEx() { this.asNode() instanceof ArgNode }
}

private class ParamNodeEx extends NodeEx {
  ParamNodeEx() { this.asNode() instanceof ParamNode }

  predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    this.asNode().(ParamNode).isParameterOf(c, pos)
  }

  ParameterPosition getPosition() { this.isParameterOf(_, result) }

  predicate allowParameterReturnInSelf() { allowParameterReturnInSelfCached(this.asNode()) }
}

private class RetNodeEx extends NodeEx {
  RetNodeEx() { this.asNode() instanceof ReturnNodeExt }

  ReturnPosition getReturnPosition() { result = getReturnPosition(this.asNode()) }

  ReturnKindExt getKind() { result = this.asNode().(ReturnNodeExt).getKind() }
}

private predicate inBarrier(NodeEx node, Configuration config) {
  exists(Node n |
    node.asNode() = n and
    config.isBarrierIn(n)
  |
    config.isSource(n) or config.isSource(n, _)
  )
}

private predicate outBarrier(NodeEx node, Configuration config) {
  exists(Node n |
    node.asNode() = n and
    config.isBarrierOut(n)
  |
    config.isSink(n) or config.isSink(n, _)
  )
}

/** A bridge class to access the deprecated `isBarrierGuard`. */
private class BarrierGuardGuardedNodeBridge extends Unit {
  abstract predicate guardedNode(Node n, Configuration config);

  abstract predicate guardedNode(Node n, FlowState state, Configuration config);
}

private class BarrierGuardGuardedNode extends BarrierGuardGuardedNodeBridge {
  deprecated override predicate guardedNode(Node n, Configuration config) {
    exists(BarrierGuard g |
      config.isBarrierGuard(g) and
      n = g.getAGuardedNode()
    )
  }

  deprecated override predicate guardedNode(Node n, FlowState state, Configuration config) {
    exists(BarrierGuard g |
      config.isBarrierGuard(g, state) and
      n = g.getAGuardedNode()
    )
  }
}

pragma[nomagic]
private predicate fullBarrier(NodeEx node, Configuration config) {
  exists(Node n | node.asNode() = n |
    config.isBarrier(n)
    or
    config.isBarrierIn(n) and
    not config.isSource(n) and
    not config.isSource(n, _)
    or
    config.isBarrierOut(n) and
    not config.isSink(n) and
    not config.isSink(n, _)
    or
    any(BarrierGuardGuardedNodeBridge b).guardedNode(n, config)
  )
}

pragma[nomagic]
private predicate stateBarrier(NodeEx node, FlowState state, Configuration config) {
  exists(Node n | node.asNode() = n |
    config.isBarrier(n, state)
    or
    any(BarrierGuardGuardedNodeBridge b).guardedNode(n, state, config)
  )
}

pragma[nomagic]
private predicate sourceNode(NodeEx node, FlowState state, Configuration config) {
  (
    config.isSource(node.asNode()) and state instanceof FlowStateEmpty
    or
    config.isSource(node.asNode(), state)
  ) and
  not fullBarrier(node, config) and
  not stateBarrier(node, state, config)
}

pragma[nomagic]
private predicate sinkNode(NodeEx node, FlowState state, Configuration config) {
  (
    config.isSink(node.asNode()) and state instanceof FlowStateEmpty
    or
    config.isSink(node.asNode(), state)
  ) and
  not fullBarrier(node, config) and
  not stateBarrier(node, state, config)
}

/** Provides the relevant barriers for a step from `node1` to `node2`. */
pragma[inline]
private predicate stepFilter(NodeEx node1, NodeEx node2, Configuration config) {
  not outBarrier(node1, config) and
  not inBarrier(node2, config) and
  not fullBarrier(node1, config) and
  not fullBarrier(node2, config)
}

/**
 * Holds if data can flow in one local step from `node1` to `node2`.
 */
private predicate localFlowStep(NodeEx node1, NodeEx node2, Configuration config) {
  exists(Node n1, Node n2 |
    node1.asNode() = n1 and
    node2.asNode() = n2 and
    simpleLocalFlowStepExt(n1, n2) and
    stepFilter(node1, node2, config)
  )
  or
  exists(Node n |
    config.allowImplicitRead(n, _) and
    node1.asNode() = n and
    node2.isImplicitReadNode(n, false) and
    not fullBarrier(node1, config)
  )
}

/**
 * Holds if the additional step from `node1` to `node2` does not jump between callables.
 */
private predicate additionalLocalFlowStep(NodeEx node1, NodeEx node2, Configuration config) {
  exists(Node n1, Node n2 |
    node1.asNode() = n1 and
    node2.asNode() = n2 and
    config.isAdditionalFlowStep(n1, n2) and
    getNodeEnclosingCallable(n1) = getNodeEnclosingCallable(n2) and
    stepFilter(node1, node2, config)
  )
  or
  exists(Node n |
    config.allowImplicitRead(n, _) and
    node1.isImplicitReadNode(n, true) and
    node2.asNode() = n and
    not fullBarrier(node2, config)
  )
}

private predicate additionalLocalStateStep(
  NodeEx node1, FlowState s1, NodeEx node2, FlowState s2, Configuration config
) {
  exists(Node n1, Node n2 |
    node1.asNode() = n1 and
    node2.asNode() = n2 and
    config.isAdditionalFlowStep(n1, s1, n2, s2) and
    getNodeEnclosingCallable(n1) = getNodeEnclosingCallable(n2) and
    stepFilter(node1, node2, config) and
    not stateBarrier(node1, s1, config) and
    not stateBarrier(node2, s2, config)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
 */
private predicate jumpStep(NodeEx node1, NodeEx node2, Configuration config) {
  exists(Node n1, Node n2 |
    node1.asNode() = n1 and
    node2.asNode() = n2 and
    jumpStepCached(n1, n2) and
    stepFilter(node1, node2, config) and
    not config.getAFeature() instanceof FeatureEqualSourceSinkCallContext
  )
}

/**
 * Holds if the additional step from `node1` to `node2` jumps between callables.
 */
private predicate additionalJumpStep(NodeEx node1, NodeEx node2, Configuration config) {
  exists(Node n1, Node n2 |
    node1.asNode() = n1 and
    node2.asNode() = n2 and
    config.isAdditionalFlowStep(n1, n2) and
    getNodeEnclosingCallable(n1) != getNodeEnclosingCallable(n2) and
    stepFilter(node1, node2, config) and
    not config.getAFeature() instanceof FeatureEqualSourceSinkCallContext
  )
}

private predicate additionalJumpStateStep(
  NodeEx node1, FlowState s1, NodeEx node2, FlowState s2, Configuration config
) {
  exists(Node n1, Node n2 |
    node1.asNode() = n1 and
    node2.asNode() = n2 and
    config.isAdditionalFlowStep(n1, s1, n2, s2) and
    getNodeEnclosingCallable(n1) != getNodeEnclosingCallable(n2) and
    stepFilter(node1, node2, config) and
    not stateBarrier(node1, s1, config) and
    not stateBarrier(node2, s2, config) and
    not config.getAFeature() instanceof FeatureEqualSourceSinkCallContext
  )
}

pragma[nomagic]
private predicate readSet(NodeEx node1, ContentSet c, NodeEx node2, Configuration config) {
  readSet(node1.asNode(), c, node2.asNode()) and
  stepFilter(node1, node2, config)
  or
  exists(Node n |
    node2.isImplicitReadNode(n, true) and
    node1.isImplicitReadNode(n, _) and
    config.allowImplicitRead(n, c)
  )
}

// inline to reduce fan-out via `getAReadContent`
bindingset[c]
private predicate read(NodeEx node1, Content c, NodeEx node2, Configuration config) {
  exists(ContentSet cs |
    readSet(node1, cs, node2, config) and
    pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
  )
}

// inline to reduce fan-out via `getAReadContent`
bindingset[c]
private predicate clearsContentEx(NodeEx n, Content c) {
  exists(ContentSet cs |
    clearsContentCached(n.asNode(), cs) and
    pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
  )
}

// inline to reduce fan-out via `getAReadContent`
bindingset[c]
private predicate expectsContentEx(NodeEx n, Content c) {
  exists(ContentSet cs |
    expectsContentCached(n.asNode(), cs) and
    pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
  )
}

pragma[nomagic]
private predicate notExpectsContent(NodeEx n) { not expectsContentCached(n.asNode(), _) }

pragma[nomagic]
private predicate store(
  NodeEx node1, TypedContent tc, NodeEx node2, DataFlowType contentType, Configuration config
) {
  store(node1.asNode(), tc, node2.asNode(), contentType) and
  read(_, tc.getContent(), _, config) and
  stepFilter(node1, node2, config)
}

pragma[nomagic]
private predicate viableReturnPosOutEx(DataFlowCall call, ReturnPosition pos, NodeEx out) {
  viableReturnPosOut(call, pos, out.asNode())
}

pragma[nomagic]
private predicate viableParamArgEx(DataFlowCall call, ParamNodeEx p, ArgNodeEx arg) {
  viableParamArg(call, p.asNode(), arg.asNode())
}

/**
 * Holds if field flow should be used for the given configuration.
 */
private predicate useFieldFlow(Configuration config) { config.fieldFlowBranchLimit() >= 1 }

private predicate hasSourceCallCtx(Configuration config) {
  exists(FlowFeature feature | feature = config.getAFeature() |
    feature instanceof FeatureHasSourceCallContext or
    feature instanceof FeatureEqualSourceSinkCallContext
  )
}

private predicate hasSinkCallCtx(Configuration config) {
  exists(FlowFeature feature | feature = config.getAFeature() |
    feature instanceof FeatureHasSinkCallContext or
    feature instanceof FeatureEqualSourceSinkCallContext
  )
}

private module Stage1 {
  class ApApprox = Unit;

  class Ap = Unit;

  class ApOption = Unit;

  class Cc = boolean;

  /* Begin: Stage 1 logic. */
  /**
   * Holds if `node` is reachable from a source in the configuration `config`.
   *
   * The Boolean `cc` records whether the node is reached through an
   * argument in a call.
   */
  predicate fwdFlow(NodeEx node, Cc cc, Configuration config) {
    sourceNode(node, _, config) and
    if hasSourceCallCtx(config) then cc = true else cc = false
    or
    exists(NodeEx mid | fwdFlow(mid, cc, config) |
      localFlowStep(mid, node, config) or
      additionalLocalFlowStep(mid, node, config) or
      additionalLocalStateStep(mid, _, node, _, config)
    )
    or
    exists(NodeEx mid | fwdFlow(mid, _, config) and cc = false |
      jumpStep(mid, node, config) or
      additionalJumpStep(mid, node, config) or
      additionalJumpStateStep(mid, _, node, _, config)
    )
    or
    // store
    exists(NodeEx mid |
      useFieldFlow(config) and
      fwdFlow(mid, cc, config) and
      store(mid, _, node, _, config)
    )
    or
    // read
    exists(ContentSet c |
      fwdFlowReadSet(c, node, cc, config) and
      fwdFlowConsCandSet(c, _, config)
    )
    or
    // flow into a callable
    exists(NodeEx arg |
      fwdFlow(arg, _, config) and
      viableParamArgEx(_, node, arg) and
      cc = true and
      not fullBarrier(node, config)
    )
    or
    // flow out of a callable
    exists(DataFlowCall call |
      fwdFlowOut(call, node, false, config) and
      cc = false
      or
      fwdFlowOutFromArg(call, node, config) and
      fwdFlowIsEntered(call, cc, config)
    )
  }

  private predicate fwdFlow(NodeEx node, Configuration config) { fwdFlow(node, _, config) }

  pragma[nomagic]
  private predicate fwdFlowReadSet(ContentSet c, NodeEx node, Cc cc, Configuration config) {
    exists(NodeEx mid |
      fwdFlow(mid, cc, config) and
      readSet(mid, c, node, config)
    )
  }

  /**
   * Holds if `c` is the target of a store in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowConsCand(Content c, Configuration config) {
    exists(NodeEx mid, NodeEx node, TypedContent tc |
      not fullBarrier(node, config) and
      useFieldFlow(config) and
      fwdFlow(mid, _, config) and
      store(mid, tc, node, _, config) and
      c = tc.getContent()
    )
  }

  /**
   * Holds if `cs` may be interpreted in a read as the target of some store
   * into `c`, in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowConsCandSet(ContentSet cs, Content c, Configuration config) {
    fwdFlowConsCand(c, config) and
    c = cs.getAReadContent()
  }

  pragma[nomagic]
  private predicate fwdFlowReturnPosition(ReturnPosition pos, Cc cc, Configuration config) {
    exists(RetNodeEx ret |
      fwdFlow(ret, cc, config) and
      ret.getReturnPosition() = pos
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOut(DataFlowCall call, NodeEx out, Cc cc, Configuration config) {
    exists(ReturnPosition pos |
      fwdFlowReturnPosition(pos, cc, config) and
      viableReturnPosOutEx(call, pos, out) and
      not fullBarrier(out, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(DataFlowCall call, NodeEx out, Configuration config) {
    fwdFlowOut(call, out, true, config)
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(DataFlowCall call, Cc cc, Configuration config) {
    exists(ArgNodeEx arg |
      fwdFlow(arg, cc, config) and
      viableParamArgEx(call, _, arg)
    )
  }

  private predicate stateStepFwd(FlowState state1, FlowState state2, Configuration config) {
    exists(NodeEx node1 |
      additionalLocalStateStep(node1, state1, _, state2, config) or
      additionalJumpStateStep(node1, state1, _, state2, config)
    |
      fwdFlow(node1, config)
    )
  }

  private predicate fwdFlowState(FlowState state, Configuration config) {
    sourceNode(_, state, config)
    or
    exists(FlowState state0 |
      fwdFlowState(state0, config) and
      stateStepFwd(state0, state, config)
    )
  }

  /**
   * Holds if `node` is part of a path from a source to a sink in the
   * configuration `config`.
   *
   * The Boolean `toReturn` records whether the node must be returned from
   * the enclosing callable in order to reach a sink.
   */
  pragma[nomagic]
  predicate revFlow(NodeEx node, boolean toReturn, Configuration config) {
    revFlow0(node, toReturn, config) and
    fwdFlow(node, config)
  }

  pragma[nomagic]
  private predicate revFlow0(NodeEx node, boolean toReturn, Configuration config) {
    exists(FlowState state |
      fwdFlow(node, pragma[only_bind_into](config)) and
      sinkNode(node, state, config) and
      fwdFlowState(state, pragma[only_bind_into](config)) and
      if hasSinkCallCtx(config) then toReturn = true else toReturn = false
    )
    or
    exists(NodeEx mid | revFlow(mid, toReturn, config) |
      localFlowStep(node, mid, config) or
      additionalLocalFlowStep(node, mid, config) or
      additionalLocalStateStep(node, _, mid, _, config)
    )
    or
    exists(NodeEx mid | revFlow(mid, _, config) and toReturn = false |
      jumpStep(node, mid, config) or
      additionalJumpStep(node, mid, config) or
      additionalJumpStateStep(node, _, mid, _, config)
    )
    or
    // store
    exists(Content c |
      revFlowStore(c, node, toReturn, config) and
      revFlowConsCand(c, config)
    )
    or
    // read
    exists(NodeEx mid, ContentSet c |
      readSet(node, c, mid, config) and
      fwdFlowConsCandSet(c, _, pragma[only_bind_into](config)) and
      revFlow(mid, toReturn, pragma[only_bind_into](config))
    )
    or
    // flow into a callable
    exists(DataFlowCall call |
      revFlowIn(call, node, false, config) and
      toReturn = false
      or
      revFlowInToReturn(call, node, config) and
      revFlowIsReturned(call, toReturn, config)
    )
    or
    // flow out of a callable
    exists(ReturnPosition pos |
      revFlowOut(pos, config) and
      node.(RetNodeEx).getReturnPosition() = pos and
      toReturn = true
    )
  }

  /**
   * Holds if `c` is the target of a read in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowConsCand(Content c, Configuration config) {
    exists(NodeEx mid, NodeEx node, ContentSet cs |
      fwdFlow(node, pragma[only_bind_into](config)) and
      readSet(node, cs, mid, config) and
      fwdFlowConsCandSet(cs, c, pragma[only_bind_into](config)) and
      revFlow(pragma[only_bind_into](mid), _, pragma[only_bind_into](config))
    )
  }

  pragma[nomagic]
  private predicate revFlowStore(Content c, NodeEx node, boolean toReturn, Configuration config) {
    exists(NodeEx mid, TypedContent tc |
      revFlow(mid, toReturn, pragma[only_bind_into](config)) and
      fwdFlowConsCand(c, pragma[only_bind_into](config)) and
      store(node, tc, mid, _, config) and
      c = tc.getContent()
    )
  }

  /**
   * Holds if `c` is the target of both a read and a store in the flow covered
   * by `revFlow`.
   */
  pragma[nomagic]
  predicate revFlowIsReadAndStored(Content c, Configuration conf) {
    revFlowConsCand(c, conf) and
    revFlowStore(c, _, _, conf)
  }

  pragma[nomagic]
  predicate viableReturnPosOutNodeCandFwd1(
    DataFlowCall call, ReturnPosition pos, NodeEx out, Configuration config
  ) {
    fwdFlowReturnPosition(pos, _, config) and
    viableReturnPosOutEx(call, pos, out)
  }

  pragma[nomagic]
  private predicate revFlowOut(ReturnPosition pos, Configuration config) {
    exists(DataFlowCall call, NodeEx out |
      revFlow(out, _, config) and
      viableReturnPosOutNodeCandFwd1(call, pos, out, config)
    )
  }

  pragma[nomagic]
  predicate viableParamArgNodeCandFwd1(
    DataFlowCall call, ParamNodeEx p, ArgNodeEx arg, Configuration config
  ) {
    viableParamArgEx(call, p, arg) and
    fwdFlow(arg, config)
  }

  pragma[nomagic]
  private predicate revFlowIn(
    DataFlowCall call, ArgNodeEx arg, boolean toReturn, Configuration config
  ) {
    exists(ParamNodeEx p |
      revFlow(p, toReturn, config) and
      viableParamArgNodeCandFwd1(call, p, arg, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(DataFlowCall call, ArgNodeEx arg, Configuration config) {
    revFlowIn(call, arg, true, config)
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`
   * and data might flow through the target callable resulting in reverse flow
   * reaching an argument of `call`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(DataFlowCall call, boolean toReturn, Configuration config) {
    exists(NodeEx out |
      revFlow(out, toReturn, config) and
      fwdFlowOutFromArg(call, out, config)
    )
  }

  private predicate stateStepRev(FlowState state1, FlowState state2, Configuration config) {
    exists(NodeEx node1, NodeEx node2 |
      additionalLocalStateStep(node1, state1, node2, state2, config) or
      additionalJumpStateStep(node1, state1, node2, state2, config)
    |
      revFlow(node1, _, pragma[only_bind_into](config)) and
      revFlow(node2, _, pragma[only_bind_into](config)) and
      fwdFlowState(state1, pragma[only_bind_into](config)) and
      fwdFlowState(state2, pragma[only_bind_into](config))
    )
  }

  predicate revFlowState(FlowState state, Configuration config) {
    exists(NodeEx node |
      sinkNode(node, state, config) and
      revFlow(node, _, pragma[only_bind_into](config)) and
      fwdFlowState(state, pragma[only_bind_into](config))
    )
    or
    exists(FlowState state0 |
      revFlowState(state0, config) and
      stateStepRev(state, state0, config)
    )
  }

  pragma[nomagic]
  predicate storeStepCand(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, DataFlowType contentType,
    Configuration config
  ) {
    exists(Content c |
      revFlowIsReadAndStored(c, pragma[only_bind_into](config)) and
      revFlow(node2, pragma[only_bind_into](config)) and
      store(node1, tc, node2, contentType, config) and
      c = tc.getContent() and
      exists(ap1)
    )
  }

  pragma[nomagic]
  predicate readStepCand(NodeEx n1, Content c, NodeEx n2, Configuration config) {
    revFlowIsReadAndStored(c, pragma[only_bind_into](config)) and
    read(n1, c, n2, pragma[only_bind_into](config)) and
    revFlow(n2, pragma[only_bind_into](config))
  }

  pragma[nomagic]
  predicate revFlow(NodeEx node, Configuration config) { revFlow(node, _, config) }

  bindingset[node, state, config]
  predicate revFlow(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow(node, toReturn, pragma[only_bind_into](config)) and
    exists(state) and
    exists(returnAp) and
    exists(ap)
  }

  private predicate throughFlowNodeCand(NodeEx node, Configuration config) {
    revFlow(node, true, config) and
    fwdFlow(node, true, config) and
    not inBarrier(node, config) and
    not outBarrier(node, config)
  }

  /** Holds if flow may return from `callable`. */
  pragma[nomagic]
  private predicate returnFlowCallableNodeCand(
    DataFlowCallable callable, ReturnKindExt kind, Configuration config
  ) {
    exists(RetNodeEx ret |
      throughFlowNodeCand(ret, config) and
      callable = ret.getEnclosingCallable() and
      kind = ret.getKind()
    )
  }

  /**
   * Holds if flow may enter through `p` and reach a return node making `p` a
   * candidate for the origin of a summary.
   */
  pragma[nomagic]
  predicate parameterMayFlowThrough(ParamNodeEx p, DataFlowCallable c, Ap ap, Configuration config) {
    exists(ReturnKindExt kind |
      throughFlowNodeCand(p, config) and
      returnFlowCallableNodeCand(c, kind, config) and
      p.getEnclosingCallable() = c and
      exists(ap) and
      // we don't expect a parameter to return stored in itself, unless explicitly allowed
      (
        not kind.(ParamUpdateReturnKind).getPosition() = p.getPosition()
        or
        p.allowParameterReturnInSelf()
      )
    )
  }

  pragma[nomagic]
  predicate callMayFlowThroughRev(DataFlowCall call, Configuration config) {
    exists(ArgNodeEx arg, boolean toReturn |
      revFlow(arg, toReturn, config) and
      revFlowInToReturn(call, arg, config) and
      revFlowIsReturned(call, toReturn, config)
    )
  }

  predicate stats(
    boolean fwd, int nodes, int fields, int conscand, int states, int tuples, Configuration config
  ) {
    fwd = true and
    nodes = count(NodeEx node | fwdFlow(node, config)) and
    fields = count(Content f0 | fwdFlowConsCand(f0, config)) and
    conscand = -1 and
    states = count(FlowState state | fwdFlowState(state, config)) and
    tuples = count(NodeEx n, boolean b | fwdFlow(n, b, config))
    or
    fwd = false and
    nodes = count(NodeEx node | revFlow(node, _, config)) and
    fields = count(Content f0 | revFlowConsCand(f0, config)) and
    conscand = -1 and
    states = count(FlowState state | revFlowState(state, config)) and
    tuples = count(NodeEx n, boolean b | revFlow(n, b, config))
  }
  /* End: Stage 1 logic. */
}

pragma[noinline]
private predicate localFlowStepNodeCand1(NodeEx node1, NodeEx node2, Configuration config) {
  Stage1::revFlow(node2, config) and
  localFlowStep(node1, node2, config)
}

pragma[noinline]
private predicate additionalLocalFlowStepNodeCand1(NodeEx node1, NodeEx node2, Configuration config) {
  Stage1::revFlow(node2, config) and
  additionalLocalFlowStep(node1, node2, config)
}

pragma[nomagic]
private predicate viableReturnPosOutNodeCand1(
  DataFlowCall call, ReturnPosition pos, NodeEx out, Configuration config
) {
  Stage1::revFlow(out, config) and
  Stage1::viableReturnPosOutNodeCandFwd1(call, pos, out, config)
}

/**
 * Holds if data can flow out of `call` from `ret` to `out`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink.
 */
pragma[nomagic]
private predicate flowOutOfCallNodeCand1(
  DataFlowCall call, RetNodeEx ret, NodeEx out, Configuration config
) {
  viableReturnPosOutNodeCand1(call, ret.getReturnPosition(), out, config) and
  Stage1::revFlow(ret, config) and
  not outBarrier(ret, config) and
  not inBarrier(out, config)
}

pragma[nomagic]
private predicate viableParamArgNodeCand1(
  DataFlowCall call, ParamNodeEx p, ArgNodeEx arg, Configuration config
) {
  Stage1::viableParamArgNodeCandFwd1(call, p, arg, config) and
  Stage1::revFlow(arg, config)
}

/**
 * Holds if data can flow into `call` and that this step is part of a
 * path from a source to a sink.
 */
pragma[nomagic]
private predicate flowIntoCallNodeCand1(
  DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, Configuration config
) {
  viableParamArgNodeCand1(call, p, arg, config) and
  Stage1::revFlow(p, config) and
  not outBarrier(arg, config) and
  not inBarrier(p, config)
}

/**
 * Gets the amount of forward branching on the origin of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int branch(NodeEx n1, Configuration conf) {
  result =
    strictcount(NodeEx n |
      flowOutOfCallNodeCand1(_, n1, n, conf) or flowIntoCallNodeCand1(_, n1, n, conf)
    )
}

/**
 * Gets the amount of backward branching on the target of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int join(NodeEx n2, Configuration conf) {
  result =
    strictcount(NodeEx n |
      flowOutOfCallNodeCand1(_, n, n2, conf) or flowIntoCallNodeCand1(_, n, n2, conf)
    )
}

/**
 * Holds if data can flow out of `call` from `ret` to `out`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink. The
 * `allowsFieldFlow` flag indicates whether the branching is within the limit
 * specified by the configuration.
 */
pragma[nomagic]
private predicate flowOutOfCallNodeCand1(
  DataFlowCall call, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow, Configuration config
) {
  flowOutOfCallNodeCand1(call, ret, out, config) and
  exists(int b, int j |
    b = branch(ret, config) and
    j = join(out, config) and
    if b.minimum(j) <= config.fieldFlowBranchLimit()
    then allowsFieldFlow = true
    else allowsFieldFlow = false
  )
}

/**
 * Holds if data can flow into `call` and that this step is part of a
 * path from a source to a sink. The `allowsFieldFlow` flag indicates whether
 * the branching is within the limit specified by the configuration.
 */
pragma[nomagic]
private predicate flowIntoCallNodeCand1(
  DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow, Configuration config
) {
  flowIntoCallNodeCand1(call, arg, p, config) and
  exists(int b, int j |
    b = branch(arg, config) and
    j = join(p, config) and
    if b.minimum(j) <= config.fieldFlowBranchLimit()
    then allowsFieldFlow = true
    else allowsFieldFlow = false
  )
}

private module Stage2 {
  module PrevStage = Stage1;

  class ApApprox = PrevStage::Ap;

  class Ap = boolean;

  class ApNil extends Ap {
    ApNil() { this = false }
  }

  bindingset[result, ap]
  private ApApprox getApprox(Ap ap) { any() }

  private ApNil getApNil(NodeEx node) { PrevStage::revFlow(node, _) and exists(result) }

  bindingset[tc, tail]
  private Ap apCons(TypedContent tc, Ap tail) { result = true and exists(tc) and exists(tail) }

  pragma[inline]
  private Content getHeadContent(Ap ap) { exists(result) and ap = true }

  class ApOption = BooleanOption;

  ApOption apNone() { result = TBooleanNone() }

  ApOption apSome(Ap ap) { result = TBooleanSome(ap) }

  class Cc = CallContext;

  class CcCall = CallContextCall;

  class CcNoCall = CallContextNoCall;

  Cc ccNone() { result instanceof CallContextAny }

  CcCall ccSomeCall() { result instanceof CallContextSomeCall }

  private class LocalCc = Unit;

  bindingset[call, c, outercc]
  private CcCall getCallContextCall(DataFlowCall call, DataFlowCallable c, Cc outercc) {
    checkCallContextCall(outercc, call, c) and
    if recordDataFlowCallSiteDispatch(call, c)
    then result = TSpecificCall(call)
    else result = TSomeCall()
  }

  bindingset[call, c, innercc]
  private CcNoCall getCallContextReturn(DataFlowCallable c, DataFlowCall call, Cc innercc) {
    checkCallContextReturn(innercc, c, call) and
    if reducedViableImplInReturn(c, call) then result = TReturn(c, call) else result = ccNone()
  }

  bindingset[node, cc]
  private LocalCc getLocalCc(NodeEx node, Cc cc) { any() }

  bindingset[node1, state1, config]
  bindingset[node2, state2, config]
  private predicate localStep(
    NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
    ApNil ap, Configuration config, LocalCc lcc
  ) {
    (
      preservesValue = true and
      localFlowStepNodeCand1(node1, node2, config) and
      state1 = state2
      or
      preservesValue = false and
      additionalLocalFlowStepNodeCand1(node1, node2, config) and
      state1 = state2
      or
      preservesValue = false and
      additionalLocalStateStep(node1, state1, node2, state2, config)
    ) and
    exists(ap) and
    exists(lcc)
  }

  private predicate flowOutOfCall = flowOutOfCallNodeCand1/5;

  private predicate flowIntoCall = flowIntoCallNodeCand1/5;

  pragma[nomagic]
  private predicate expectsContentCand(NodeEx node, Configuration config) {
    exists(Content c |
      PrevStage::revFlow(node, pragma[only_bind_into](config)) and
      PrevStage::revFlowIsReadAndStored(c, pragma[only_bind_into](config)) and
      expectsContentEx(node, c)
    )
  }

  bindingset[node, state, ap, config]
  private predicate filter(NodeEx node, FlowState state, Ap ap, Configuration config) {
    PrevStage::revFlowState(state, pragma[only_bind_into](config)) and
    exists(ap) and
    not stateBarrier(node, state, config) and
    (
      notExpectsContent(node)
      or
      ap = true and
      expectsContentCand(node, config)
    )
  }

  bindingset[ap, contentType]
  private predicate typecheckStore(Ap ap, DataFlowType contentType) { any() }

  /* Begin: Stage 2 logic. */
  bindingset[node, state, config]
  private predicate flowCand(NodeEx node, FlowState state, ApApprox apa, Configuration config) {
    PrevStage::revFlow(node, state, _, _, apa, config)
  }

  bindingset[result, apa]
  private ApApprox unbindApa(ApApprox apa) {
    pragma[only_bind_out](apa) = pragma[only_bind_out](result)
  }

  pragma[nomagic]
  private predicate flowThroughOutOfCall(
    DataFlowCall call, CcCall ccc, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
    Configuration config
  ) {
    flowOutOfCall(call, ret, out, allowsFieldFlow, pragma[only_bind_into](config)) and
    PrevStage::callMayFlowThroughRev(call, pragma[only_bind_into](config)) and
    PrevStage::parameterMayFlowThrough(_, ret.getEnclosingCallable(), _,
      pragma[only_bind_into](config)) and
    ccc.matchesCall(call)
  }

  /**
   * Holds if `node` is reachable with access path `ap` from a source in the
   * configuration `config`.
   *
   * The call context `cc` records whether the node is reached through an
   * argument in a call, and if so, `argAp` records the access path of that
   * argument.
   */
  pragma[nomagic]
  predicate fwdFlow(NodeEx node, FlowState state, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    fwdFlow0(node, state, cc, argAp, ap, config) and
    flowCand(node, state, unbindApa(getApprox(ap)), config) and
    filter(node, state, ap, config)
  }

  pragma[nomagic]
  private predicate fwdFlow0(
    NodeEx node, FlowState state, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    sourceNode(node, state, config) and
    (if hasSourceCallCtx(config) then cc = ccSomeCall() else cc = ccNone()) and
    argAp = apNone() and
    ap = getApNil(node)
    or
    exists(NodeEx mid, FlowState state0, Ap ap0, LocalCc localCc |
      fwdFlow(mid, state0, cc, argAp, ap0, config) and
      localCc = getLocalCc(mid, cc)
    |
      localStep(mid, state0, node, state, true, _, config, localCc) and
      ap = ap0
      or
      localStep(mid, state0, node, state, false, ap, config, localCc) and
      ap0 instanceof ApNil
    )
    or
    exists(NodeEx mid |
      fwdFlow(mid, pragma[only_bind_into](state), _, _, ap, pragma[only_bind_into](config)) and
      jumpStep(mid, node, config) and
      cc = ccNone() and
      argAp = apNone()
    )
    or
    exists(NodeEx mid, ApNil nil |
      fwdFlow(mid, state, _, _, nil, pragma[only_bind_into](config)) and
      additionalJumpStep(mid, node, config) and
      cc = ccNone() and
      argAp = apNone() and
      ap = getApNil(node)
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(mid, state0, _, _, nil, pragma[only_bind_into](config)) and
      additionalJumpStateStep(mid, state0, node, state, config) and
      cc = ccNone() and
      argAp = apNone() and
      ap = getApNil(node)
    )
    or
    // store
    exists(TypedContent tc, Ap ap0 |
      fwdFlowStore(_, ap0, tc, node, state, cc, argAp, config) and
      ap = apCons(tc, ap0)
    )
    or
    // read
    exists(Ap ap0, Content c |
      fwdFlowRead(ap0, c, _, node, state, cc, argAp, config) and
      fwdFlowConsCand(ap0, c, ap, config)
    )
    or
    // flow into a callable
    exists(ApApprox apa |
      fwdFlowIn(_, node, state, _, cc, _, ap, config) and
      apa = getApprox(ap) and
      if PrevStage::parameterMayFlowThrough(node, _, apa, config)
      then argAp = apSome(ap)
      else argAp = apNone()
    )
    or
    // flow out of a callable
    fwdFlowOutNotFromArg(node, state, cc, argAp, ap, config)
    or
    exists(DataFlowCall call, Ap argAp0 |
      fwdFlowOutFromArg(call, node, state, argAp0, ap, config) and
      fwdFlowIsEntered(call, cc, argAp, argAp0, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowStore(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, FlowState state, Cc cc, ApOption argAp,
    Configuration config
  ) {
    exists(DataFlowType contentType |
      fwdFlow(node1, state, cc, argAp, ap1, config) and
      PrevStage::storeStepCand(node1, unbindApa(getApprox(ap1)), tc, node2, contentType, config) and
      typecheckStore(ap1, contentType)
    )
  }

  /**
   * Holds if forward flow with access path `tail` reaches a store of `c`
   * resulting in access path `cons`.
   */
  pragma[nomagic]
  private predicate fwdFlowConsCand(Ap cons, Content c, Ap tail, Configuration config) {
    exists(TypedContent tc |
      fwdFlowStore(_, tail, tc, _, _, _, _, config) and
      tc.getContent() = c and
      cons = apCons(tc, tail)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowRead(
    Ap ap, Content c, NodeEx node1, NodeEx node2, FlowState state, Cc cc, ApOption argAp,
    Configuration config
  ) {
    fwdFlow(node1, state, cc, argAp, ap, config) and
    PrevStage::readStepCand(node1, c, node2, config) and
    getHeadContent(ap) = c
  }

  pragma[nomagic]
  private predicate fwdFlowIn(
    DataFlowCall call, ParamNodeEx p, FlowState state, Cc outercc, Cc innercc, ApOption argAp,
    Ap ap, Configuration config
  ) {
    exists(ArgNodeEx arg, boolean allowsFieldFlow |
      fwdFlow(arg, state, outercc, argAp, ap, config) and
      flowIntoCall(call, arg, p, allowsFieldFlow, config) and
      innercc = getCallContextCall(call, p.getEnclosingCallable(), outercc) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutNotFromArg(
    NodeEx out, FlowState state, Cc ccOut, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(
      DataFlowCall call, RetNodeEx ret, boolean allowsFieldFlow, CcNoCall innercc,
      DataFlowCallable inner
    |
      fwdFlow(ret, state, innercc, argAp, ap, config) and
      flowOutOfCall(call, ret, out, allowsFieldFlow, config) and
      inner = ret.getEnclosingCallable() and
      ccOut = getCallContextReturn(inner, call, innercc) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(
    DataFlowCall call, NodeEx out, FlowState state, Ap argAp, Ap ap, Configuration config
  ) {
    exists(RetNodeEx ret, boolean allowsFieldFlow, CcCall ccc |
      fwdFlow(ret, state, ccc, apSome(argAp), ap, config) and
      flowThroughOutOfCall(call, ccc, ret, out, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`
   * and data might flow through the target callable and back out at `call`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(
    DataFlowCall call, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p |
      fwdFlowIn(call, p, _, cc, _, argAp, ap, config) and
      PrevStage::parameterMayFlowThrough(p, _, unbindApa(getApprox(ap)), config)
    )
  }

  pragma[nomagic]
  private predicate storeStepFwd(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, Ap ap2, Configuration config
  ) {
    fwdFlowStore(node1, ap1, tc, node2, _, _, _, config) and
    ap2 = apCons(tc, ap1) and
    fwdFlowRead(ap2, tc.getContent(), _, _, _, _, _, config)
  }

  private predicate readStepFwd(
    NodeEx n1, Ap ap1, Content c, NodeEx n2, Ap ap2, Configuration config
  ) {
    fwdFlowRead(ap1, c, n1, n2, _, _, _, config) and
    fwdFlowConsCand(ap1, c, ap2, config)
  }

  pragma[nomagic]
  private predicate callMayFlowThroughFwd(DataFlowCall call, Configuration config) {
    exists(Ap argAp0, NodeEx out, FlowState state, Cc cc, ApOption argAp, Ap ap |
      fwdFlow(out, state, pragma[only_bind_into](cc), pragma[only_bind_into](argAp), ap,
        pragma[only_bind_into](config)) and
      fwdFlowOutFromArg(call, out, state, argAp0, ap, config) and
      fwdFlowIsEntered(pragma[only_bind_into](call), pragma[only_bind_into](cc),
        pragma[only_bind_into](argAp), pragma[only_bind_into](argAp0),
        pragma[only_bind_into](config))
    )
  }

  pragma[nomagic]
  private predicate flowThroughIntoCall(
    DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow, Configuration config
  ) {
    flowIntoCall(call, arg, p, allowsFieldFlow, config) and
    fwdFlow(arg, _, _, _, _, pragma[only_bind_into](config)) and
    PrevStage::parameterMayFlowThrough(p, _, _, pragma[only_bind_into](config)) and
    callMayFlowThroughFwd(call, pragma[only_bind_into](config))
  }

  pragma[nomagic]
  private predicate returnNodeMayFlowThrough(
    RetNodeEx ret, FlowState state, Ap ap, Configuration config
  ) {
    fwdFlow(ret, state, any(CcCall ccc), apSome(_), ap, config)
  }

  /**
   * Holds if `node` with access path `ap` is part of a path from a source to a
   * sink in the configuration `config`.
   *
   * The Boolean `toReturn` records whether the node must be returned from the
   * enclosing callable in order to reach a sink, and if so, `returnAp` records
   * the access path of the returned value.
   */
  pragma[nomagic]
  predicate revFlow(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow0(node, state, toReturn, returnAp, ap, config) and
    fwdFlow(node, state, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlow0(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    fwdFlow(node, state, _, _, ap, config) and
    sinkNode(node, state, config) and
    (if hasSinkCallCtx(config) then toReturn = true else toReturn = false) and
    returnAp = apNone() and
    ap instanceof ApNil
    or
    exists(NodeEx mid, FlowState state0 |
      localStep(node, state, mid, state0, true, _, config, _) and
      revFlow(mid, state0, toReturn, returnAp, ap, config)
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(node, pragma[only_bind_into](state), _, _, ap, pragma[only_bind_into](config)) and
      localStep(node, pragma[only_bind_into](state), mid, state0, false, _, config, _) and
      revFlow(mid, state0, toReturn, returnAp, nil, pragma[only_bind_into](config)) and
      ap instanceof ApNil
    )
    or
    exists(NodeEx mid |
      jumpStep(node, mid, config) and
      revFlow(mid, state, _, _, ap, config) and
      toReturn = false and
      returnAp = apNone()
    )
    or
    exists(NodeEx mid, ApNil nil |
      fwdFlow(node, _, _, _, ap, pragma[only_bind_into](config)) and
      additionalJumpStep(node, mid, config) and
      revFlow(pragma[only_bind_into](mid), state, _, _, nil, pragma[only_bind_into](config)) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(node, _, _, _, ap, pragma[only_bind_into](config)) and
      additionalJumpStateStep(node, state, mid, state0, config) and
      revFlow(pragma[only_bind_into](mid), pragma[only_bind_into](state0), _, _, nil,
        pragma[only_bind_into](config)) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    // store
    exists(Ap ap0, Content c |
      revFlowStore(ap0, c, ap, node, state, _, _, toReturn, returnAp, config) and
      revFlowConsCand(ap0, c, ap, config)
    )
    or
    // read
    exists(NodeEx mid, Ap ap0 |
      revFlow(mid, state, toReturn, returnAp, ap0, config) and
      readStepFwd(node, ap, _, mid, ap0, config)
    )
    or
    // flow into a callable
    revFlowInNotToReturn(node, state, returnAp, ap, config) and
    toReturn = false
    or
    exists(DataFlowCall call, Ap returnAp0 |
      revFlowInToReturn(call, node, state, returnAp0, ap, config) and
      revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
    or
    // flow out of a callable
    revFlowOut(_, node, state, _, _, ap, config) and
    toReturn = true and
    if returnNodeMayFlowThrough(node, state, ap, config)
    then returnAp = apSome(ap)
    else returnAp = apNone()
  }

  pragma[nomagic]
  private predicate revFlowStore(
    Ap ap0, Content c, Ap ap, NodeEx node, FlowState state, TypedContent tc, NodeEx mid,
    boolean toReturn, ApOption returnAp, Configuration config
  ) {
    revFlow(mid, state, toReturn, returnAp, ap0, config) and
    storeStepFwd(node, ap, tc, mid, ap0, config) and
    tc.getContent() = c
  }

  /**
   * Holds if reverse flow with access path `tail` reaches a read of `c`
   * resulting in access path `cons`.
   */
  pragma[nomagic]
  private predicate revFlowConsCand(Ap cons, Content c, Ap tail, Configuration config) {
    exists(NodeEx mid, Ap tail0 |
      revFlow(mid, _, _, _, tail, config) and
      tail = pragma[only_bind_into](tail0) and
      readStepFwd(_, cons, c, mid, tail0, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowOut(
    DataFlowCall call, RetNodeEx ret, FlowState state, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(NodeEx out, boolean allowsFieldFlow |
      revFlow(out, state, toReturn, returnAp, ap, config) and
      flowOutOfCall(call, ret, out, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate revFlowInNotToReturn(
    ArgNodeEx arg, FlowState state, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p, boolean allowsFieldFlow |
      revFlow(p, state, false, returnAp, ap, config) and
      flowIntoCall(_, arg, p, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(
    DataFlowCall call, ArgNodeEx arg, FlowState state, Ap returnAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p, boolean allowsFieldFlow |
      revFlow(p, state, true, apSome(returnAp), ap, config) and
      flowThroughIntoCall(call, arg, p, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`
   * and data might flow through the target callable resulting in reverse flow
   * reaching an argument of `call`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(
    DataFlowCall call, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(RetNodeEx ret, FlowState state, CcCall ccc |
      revFlowOut(call, ret, state, toReturn, returnAp, ap, config) and
      fwdFlow(ret, state, ccc, apSome(_), ap, config) and
      ccc.matchesCall(call)
    )
  }

  pragma[nomagic]
  predicate storeStepCand(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, DataFlowType contentType,
    Configuration config
  ) {
    exists(Ap ap2, Content c |
      PrevStage::storeStepCand(node1, _, tc, node2, contentType, config) and
      revFlowStore(ap2, c, ap1, node1, _, tc, node2, _, _, config) and
      revFlowConsCand(ap2, c, ap1, config)
    )
  }

  predicate readStepCand(NodeEx node1, Content c, NodeEx node2, Configuration config) {
    exists(Ap ap1, Ap ap2 |
      revFlow(node2, _, _, _, pragma[only_bind_into](ap2), pragma[only_bind_into](config)) and
      readStepFwd(node1, ap1, c, node2, ap2, config) and
      revFlowStore(ap1, c, pragma[only_bind_into](ap2), _, _, _, _, _, _,
        pragma[only_bind_into](config))
    )
  }

  predicate revFlow(NodeEx node, FlowState state, Configuration config) {
    revFlow(node, state, _, _, _, config)
  }

  pragma[nomagic]
  predicate revFlow(NodeEx node, Configuration config) { revFlow(node, _, _, _, _, config) }

  // use an alias as a workaround for bad functionality-induced joins
  pragma[nomagic]
  predicate revFlowAlias(NodeEx node, Configuration config) { revFlow(node, _, _, _, _, config) }

  // use an alias as a workaround for bad functionality-induced joins
  pragma[nomagic]
  predicate revFlowAlias(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow(node, state, toReturn, returnAp, ap, config)
  }

  private predicate fwdConsCand(TypedContent tc, Ap ap, Configuration config) {
    storeStepFwd(_, ap, tc, _, _, config)
  }

  private predicate revConsCand(TypedContent tc, Ap ap, Configuration config) {
    storeStepCand(_, ap, tc, _, _, config)
  }

  private predicate validAp(Ap ap, Configuration config) {
    revFlow(_, _, _, _, ap, config) and ap instanceof ApNil
    or
    exists(TypedContent head, Ap tail |
      consCand(head, tail, config) and
      ap = apCons(head, tail)
    )
  }

  predicate consCand(TypedContent tc, Ap ap, Configuration config) {
    revConsCand(tc, ap, config) and
    validAp(ap, config)
  }

  pragma[noinline]
  private predicate parameterFlow(
    ParamNodeEx p, Ap ap, Ap ap0, DataFlowCallable c, Configuration config
  ) {
    revFlow(p, _, true, apSome(ap0), ap, config) and
    c = p.getEnclosingCallable()
  }

  predicate parameterMayFlowThrough(ParamNodeEx p, DataFlowCallable c, Ap ap, Configuration config) {
    exists(RetNodeEx ret, FlowState state, Ap ap0, ReturnKindExt kind, ParameterPosition pos |
      parameterFlow(p, ap, ap0, c, config) and
      c = ret.getEnclosingCallable() and
      revFlow(pragma[only_bind_into](ret), pragma[only_bind_into](state), true, apSome(_),
        pragma[only_bind_into](ap0), pragma[only_bind_into](config)) and
      fwdFlow(ret, state, any(CcCall ccc), apSome(ap), ap0, config) and
      kind = ret.getKind() and
      p.getPosition() = pos and
      // we don't expect a parameter to return stored in itself, unless explicitly allowed
      (
        not kind.(ParamUpdateReturnKind).getPosition() = pos
        or
        p.allowParameterReturnInSelf()
      )
    )
  }

  pragma[nomagic]
  predicate callMayFlowThroughRev(DataFlowCall call, Configuration config) {
    exists(
      Ap returnAp0, ArgNodeEx arg, FlowState state, boolean toReturn, ApOption returnAp, Ap ap
    |
      revFlow(arg, state, toReturn, returnAp, ap, config) and
      revFlowInToReturn(call, arg, state, returnAp0, ap, config) and
      revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
  }

  predicate stats(
    boolean fwd, int nodes, int fields, int conscand, int states, int tuples, Configuration config
  ) {
    fwd = true and
    nodes = count(NodeEx node | fwdFlow(node, _, _, _, _, config)) and
    fields = count(TypedContent f0 | fwdConsCand(f0, _, config)) and
    conscand = count(TypedContent f0, Ap ap | fwdConsCand(f0, ap, config)) and
    states = count(FlowState state | fwdFlow(_, state, _, _, _, config)) and
    tuples =
      count(NodeEx n, FlowState state, Cc cc, ApOption argAp, Ap ap |
        fwdFlow(n, state, cc, argAp, ap, config)
      )
    or
    fwd = false and
    nodes = count(NodeEx node | revFlow(node, _, _, _, _, config)) and
    fields = count(TypedContent f0 | consCand(f0, _, config)) and
    conscand = count(TypedContent f0, Ap ap | consCand(f0, ap, config)) and
    states = count(FlowState state | revFlow(_, state, _, _, _, config)) and
    tuples =
      count(NodeEx n, FlowState state, boolean b, ApOption retAp, Ap ap |
        revFlow(n, state, b, retAp, ap, config)
      )
  }
  /* End: Stage 2 logic. */
}

pragma[nomagic]
private predicate flowOutOfCallNodeCand2(
  DataFlowCall call, RetNodeEx node1, NodeEx node2, boolean allowsFieldFlow, Configuration config
) {
  flowOutOfCallNodeCand1(call, node1, node2, allowsFieldFlow, config) and
  Stage2::revFlow(node2, pragma[only_bind_into](config)) and
  Stage2::revFlowAlias(node1, pragma[only_bind_into](config))
}

pragma[nomagic]
private predicate flowIntoCallNodeCand2(
  DataFlowCall call, ArgNodeEx node1, ParamNodeEx node2, boolean allowsFieldFlow,
  Configuration config
) {
  flowIntoCallNodeCand1(call, node1, node2, allowsFieldFlow, config) and
  Stage2::revFlow(node2, pragma[only_bind_into](config)) and
  Stage2::revFlowAlias(node1, pragma[only_bind_into](config))
}

private module LocalFlowBigStep {
  /**
   * A node where some checking is required, and hence the big-step relation
   * is not allowed to step over.
   */
  private class FlowCheckNode extends NodeEx {
    FlowCheckNode() {
      castNode(this.asNode()) or
      clearsContentCached(this.asNode(), _) or
      expectsContentCached(this.asNode(), _)
    }
  }

  /**
   * Holds if `node` can be the first node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  private predicate localFlowEntry(NodeEx node, FlowState state, Configuration config) {
    Stage2::revFlow(node, state, config) and
    (
      sourceNode(node, state, config)
      or
      jumpStep(_, node, config)
      or
      additionalJumpStep(_, node, config)
      or
      additionalJumpStateStep(_, _, node, state, config)
      or
      node instanceof ParamNodeEx
      or
      node.asNode() instanceof OutNodeExt
      or
      Stage2::storeStepCand(_, _, _, node, _, config)
      or
      Stage2::readStepCand(_, _, node, config)
      or
      node instanceof FlowCheckNode
      or
      exists(FlowState s |
        additionalLocalStateStep(_, s, node, state, config) and
        s != state
      )
    )
  }

  /**
   * Holds if `node` can be the last node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  private predicate localFlowExit(NodeEx node, FlowState state, Configuration config) {
    exists(NodeEx next | Stage2::revFlow(next, state, config) |
      jumpStep(node, next, config) or
      additionalJumpStep(node, next, config) or
      flowIntoCallNodeCand1(_, node, next, config) or
      flowOutOfCallNodeCand1(_, node, next, config) or
      Stage2::storeStepCand(node, _, _, next, _, config) or
      Stage2::readStepCand(node, _, next, config)
    )
    or
    exists(NodeEx next, FlowState s | Stage2::revFlow(next, s, config) |
      additionalJumpStateStep(node, state, next, s, config)
      or
      additionalLocalStateStep(node, state, next, s, config) and
      s != state
    )
    or
    Stage2::revFlow(node, state, config) and
    node instanceof FlowCheckNode
    or
    sinkNode(node, state, config)
  }

  pragma[noinline]
  private predicate additionalLocalFlowStepNodeCand2(
    NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, Configuration config
  ) {
    additionalLocalFlowStepNodeCand1(node1, node2, config) and
    state1 = state2 and
    Stage2::revFlow(node1, pragma[only_bind_into](state1), _, _, false,
      pragma[only_bind_into](config)) and
    Stage2::revFlowAlias(node2, pragma[only_bind_into](state2), _, _, false,
      pragma[only_bind_into](config))
    or
    additionalLocalStateStep(node1, state1, node2, state2, config) and
    Stage2::revFlow(node1, state1, _, _, false, pragma[only_bind_into](config)) and
    Stage2::revFlowAlias(node2, state2, _, _, false, pragma[only_bind_into](config))
  }

  /**
   * Holds if the local path from `node1` to `node2` is a prefix of a maximal
   * subsequence of local flow steps in a dataflow path.
   *
   * This is the transitive closure of `[additional]localFlowStep` beginning
   * at `localFlowEntry`.
   */
  pragma[nomagic]
  private predicate localFlowStepPlus(
    NodeEx node1, FlowState state, NodeEx node2, boolean preservesValue, DataFlowType t,
    Configuration config, LocalCallContext cc
  ) {
    not isUnreachableInCallCached(node2.asNode(), cc.(LocalCallContextSpecificCall).getCall()) and
    (
      localFlowEntry(node1, pragma[only_bind_into](state), pragma[only_bind_into](config)) and
      (
        localFlowStepNodeCand1(node1, node2, config) and
        preservesValue = true and
        t = node1.getDataFlowType() and // irrelevant dummy value
        Stage2::revFlow(node2, pragma[only_bind_into](state), pragma[only_bind_into](config))
        or
        additionalLocalFlowStepNodeCand2(node1, state, node2, state, config) and
        preservesValue = false and
        t = node2.getDataFlowType()
      ) and
      node1 != node2 and
      cc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCallCached(node1.asNode(), cc.(LocalCallContextSpecificCall).getCall())
      or
      exists(NodeEx mid |
        localFlowStepPlus(node1, pragma[only_bind_into](state), mid, preservesValue, t,
          pragma[only_bind_into](config), cc) and
        localFlowStepNodeCand1(mid, node2, config) and
        not mid instanceof FlowCheckNode and
        Stage2::revFlow(node2, pragma[only_bind_into](state), pragma[only_bind_into](config))
      )
      or
      exists(NodeEx mid |
        localFlowStepPlus(node1, state, mid, _, _, pragma[only_bind_into](config), cc) and
        additionalLocalFlowStepNodeCand2(mid, state, node2, state, config) and
        not mid instanceof FlowCheckNode and
        preservesValue = false and
        t = node2.getDataFlowType()
      )
    )
  }

  /**
   * Holds if `node1` can step to `node2` in one or more local steps and this
   * path can occur as a maximal subsequence of local steps in a dataflow path.
   */
  pragma[nomagic]
  predicate localFlowBigStep(
    NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
    AccessPathFrontNil apf, Configuration config, LocalCallContext callContext
  ) {
    localFlowStepPlus(node1, state1, node2, preservesValue, apf.getType(), config, callContext) and
    localFlowExit(node2, state1, config) and
    state1 = state2
    or
    additionalLocalFlowStepNodeCand2(node1, state1, node2, state2, config) and
    state1 != state2 and
    preservesValue = false and
    apf = TFrontNil(node2.getDataFlowType()) and
    callContext.relevantFor(node1.getEnclosingCallable()) and
    not exists(DataFlowCall call | call = callContext.(LocalCallContextSpecificCall).getCall() |
      isUnreachableInCallCached(node1.asNode(), call) or
      isUnreachableInCallCached(node2.asNode(), call)
    )
  }
}

private import LocalFlowBigStep

private module Stage3 {
  module PrevStage = Stage2;

  class ApApprox = PrevStage::Ap;

  class Ap = AccessPathFront;

  class ApNil = AccessPathFrontNil;

  private ApApprox getApprox(Ap ap) { result = ap.toBoolNonEmpty() }

  private ApNil getApNil(NodeEx node) {
    PrevStage::revFlow(node, _) and result = TFrontNil(node.getDataFlowType())
  }

  bindingset[tc, tail]
  private Ap apCons(TypedContent tc, Ap tail) { result.getHead() = tc and exists(tail) }

  pragma[noinline]
  private Content getHeadContent(Ap ap) { result = ap.getHead().getContent() }

  class ApOption = AccessPathFrontOption;

  ApOption apNone() { result = TAccessPathFrontNone() }

  ApOption apSome(Ap ap) { result = TAccessPathFrontSome(ap) }

  class Cc = boolean;

  class CcCall extends Cc {
    CcCall() { this = true }

    /** Holds if this call context may be `call`. */
    predicate matchesCall(DataFlowCall call) { any() }
  }

  class CcNoCall extends Cc {
    CcNoCall() { this = false }
  }

  Cc ccNone() { result = false }

  CcCall ccSomeCall() { result = true }

  private class LocalCc = Unit;

  bindingset[call, c, outercc]
  private CcCall getCallContextCall(DataFlowCall call, DataFlowCallable c, Cc outercc) { any() }

  bindingset[call, c, innercc]
  private CcNoCall getCallContextReturn(DataFlowCallable c, DataFlowCall call, Cc innercc) { any() }

  bindingset[node, cc]
  private LocalCc getLocalCc(NodeEx node, Cc cc) { any() }

  private predicate localStep(
    NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
    ApNil ap, Configuration config, LocalCc lcc
  ) {
    localFlowBigStep(node1, state1, node2, state2, preservesValue, ap, config, _) and exists(lcc)
  }

  private predicate flowOutOfCall = flowOutOfCallNodeCand2/5;

  private predicate flowIntoCall = flowIntoCallNodeCand2/5;

  pragma[nomagic]
  private predicate clearSet(NodeEx node, ContentSet c, Configuration config) {
    PrevStage::revFlow(node, config) and
    clearsContentCached(node.asNode(), c)
  }

  pragma[nomagic]
  private predicate clearContent(NodeEx node, Content c, Configuration config) {
    exists(ContentSet cs |
      PrevStage::readStepCand(_, pragma[only_bind_into](c), _, pragma[only_bind_into](config)) and
      c = cs.getAReadContent() and
      clearSet(node, cs, pragma[only_bind_into](config))
    )
  }

  pragma[nomagic]
  private predicate clear(NodeEx node, Ap ap, Configuration config) {
    clearContent(node, ap.getHead().getContent(), config)
  }

  pragma[nomagic]
  private predicate expectsContentCand(NodeEx node, Ap ap, Configuration config) {
    exists(Content c |
      PrevStage::revFlow(node, pragma[only_bind_into](config)) and
      PrevStage::readStepCand(_, c, _, pragma[only_bind_into](config)) and
      expectsContentEx(node, c) and
      c = ap.getHead().getContent()
    )
  }

  pragma[nomagic]
  private predicate castingNodeEx(NodeEx node) { node.asNode() instanceof CastingNode }

  bindingset[node, state, ap, config]
  private predicate filter(NodeEx node, FlowState state, Ap ap, Configuration config) {
    exists(state) and
    exists(config) and
    not clear(node, ap, config) and
    (if castingNodeEx(node) then compatibleTypes(node.getDataFlowType(), ap.getType()) else any()) and
    (
      notExpectsContent(node)
      or
      expectsContentCand(node, ap, config)
    )
  }

  bindingset[ap, contentType]
  private predicate typecheckStore(Ap ap, DataFlowType contentType) {
    // We need to typecheck stores here, since reverse flow through a getter
    // might have a different type here compared to inside the getter.
    compatibleTypes(ap.getType(), contentType)
  }

  /* Begin: Stage 3 logic. */
  bindingset[node, state, config]
  private predicate flowCand(NodeEx node, FlowState state, ApApprox apa, Configuration config) {
    PrevStage::revFlow(node, state, _, _, apa, config)
  }

  bindingset[result, apa]
  private ApApprox unbindApa(ApApprox apa) {
    pragma[only_bind_out](apa) = pragma[only_bind_out](result)
  }

  pragma[nomagic]
  private predicate flowThroughOutOfCall(
    DataFlowCall call, CcCall ccc, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
    Configuration config
  ) {
    flowOutOfCall(call, ret, out, allowsFieldFlow, pragma[only_bind_into](config)) and
    PrevStage::callMayFlowThroughRev(call, pragma[only_bind_into](config)) and
    PrevStage::parameterMayFlowThrough(_, ret.getEnclosingCallable(), _,
      pragma[only_bind_into](config)) and
    ccc.matchesCall(call)
  }

  /**
   * Holds if `node` is reachable with access path `ap` from a source in the
   * configuration `config`.
   *
   * The call context `cc` records whether the node is reached through an
   * argument in a call, and if so, `argAp` records the access path of that
   * argument.
   */
  pragma[nomagic]
  predicate fwdFlow(NodeEx node, FlowState state, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    fwdFlow0(node, state, cc, argAp, ap, config) and
    flowCand(node, state, unbindApa(getApprox(ap)), config) and
    filter(node, state, ap, config)
  }

  pragma[nomagic]
  private predicate fwdFlow0(
    NodeEx node, FlowState state, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    sourceNode(node, state, config) and
    (if hasSourceCallCtx(config) then cc = ccSomeCall() else cc = ccNone()) and
    argAp = apNone() and
    ap = getApNil(node)
    or
    exists(NodeEx mid, FlowState state0, Ap ap0, LocalCc localCc |
      fwdFlow(mid, state0, cc, argAp, ap0, config) and
      localCc = getLocalCc(mid, cc)
    |
      localStep(mid, state0, node, state, true, _, config, localCc) and
      ap = ap0
      or
      localStep(mid, state0, node, state, false, ap, config, localCc) and
      ap0 instanceof ApNil
    )
    or
    exists(NodeEx mid |
      fwdFlow(mid, pragma[only_bind_into](state), _, _, ap, pragma[only_bind_into](config)) and
      jumpStep(mid, node, config) and
      cc = ccNone() and
      argAp = apNone()
    )
    or
    exists(NodeEx mid, ApNil nil |
      fwdFlow(mid, state, _, _, nil, pragma[only_bind_into](config)) and
      additionalJumpStep(mid, node, config) and
      cc = ccNone() and
      argAp = apNone() and
      ap = getApNil(node)
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(mid, state0, _, _, nil, pragma[only_bind_into](config)) and
      additionalJumpStateStep(mid, state0, node, state, config) and
      cc = ccNone() and
      argAp = apNone() and
      ap = getApNil(node)
    )
    or
    // store
    exists(TypedContent tc, Ap ap0 |
      fwdFlowStore(_, ap0, tc, node, state, cc, argAp, config) and
      ap = apCons(tc, ap0)
    )
    or
    // read
    exists(Ap ap0, Content c |
      fwdFlowRead(ap0, c, _, node, state, cc, argAp, config) and
      fwdFlowConsCand(ap0, c, ap, config)
    )
    or
    // flow into a callable
    exists(ApApprox apa |
      fwdFlowIn(_, node, state, _, cc, _, ap, config) and
      apa = getApprox(ap) and
      if PrevStage::parameterMayFlowThrough(node, _, apa, config)
      then argAp = apSome(ap)
      else argAp = apNone()
    )
    or
    // flow out of a callable
    fwdFlowOutNotFromArg(node, state, cc, argAp, ap, config)
    or
    exists(DataFlowCall call, Ap argAp0 |
      fwdFlowOutFromArg(call, node, state, argAp0, ap, config) and
      fwdFlowIsEntered(call, cc, argAp, argAp0, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowStore(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, FlowState state, Cc cc, ApOption argAp,
    Configuration config
  ) {
    exists(DataFlowType contentType |
      fwdFlow(node1, state, cc, argAp, ap1, config) and
      PrevStage::storeStepCand(node1, unbindApa(getApprox(ap1)), tc, node2, contentType, config) and
      typecheckStore(ap1, contentType)
    )
  }

  /**
   * Holds if forward flow with access path `tail` reaches a store of `c`
   * resulting in access path `cons`.
   */
  pragma[nomagic]
  private predicate fwdFlowConsCand(Ap cons, Content c, Ap tail, Configuration config) {
    exists(TypedContent tc |
      fwdFlowStore(_, tail, tc, _, _, _, _, config) and
      tc.getContent() = c and
      cons = apCons(tc, tail)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowRead(
    Ap ap, Content c, NodeEx node1, NodeEx node2, FlowState state, Cc cc, ApOption argAp,
    Configuration config
  ) {
    fwdFlow(node1, state, cc, argAp, ap, config) and
    PrevStage::readStepCand(node1, c, node2, config) and
    getHeadContent(ap) = c
  }

  pragma[nomagic]
  private predicate fwdFlowIn(
    DataFlowCall call, ParamNodeEx p, FlowState state, Cc outercc, Cc innercc, ApOption argAp,
    Ap ap, Configuration config
  ) {
    exists(ArgNodeEx arg, boolean allowsFieldFlow |
      fwdFlow(arg, state, outercc, argAp, ap, config) and
      flowIntoCall(call, arg, p, allowsFieldFlow, config) and
      innercc = getCallContextCall(call, p.getEnclosingCallable(), outercc) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutNotFromArg(
    NodeEx out, FlowState state, Cc ccOut, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(
      DataFlowCall call, RetNodeEx ret, boolean allowsFieldFlow, CcNoCall innercc,
      DataFlowCallable inner
    |
      fwdFlow(ret, state, innercc, argAp, ap, config) and
      flowOutOfCall(call, ret, out, allowsFieldFlow, config) and
      inner = ret.getEnclosingCallable() and
      ccOut = getCallContextReturn(inner, call, innercc) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(
    DataFlowCall call, NodeEx out, FlowState state, Ap argAp, Ap ap, Configuration config
  ) {
    exists(RetNodeEx ret, boolean allowsFieldFlow, CcCall ccc |
      fwdFlow(ret, state, ccc, apSome(argAp), ap, config) and
      flowThroughOutOfCall(call, ccc, ret, out, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`
   * and data might flow through the target callable and back out at `call`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(
    DataFlowCall call, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p |
      fwdFlowIn(call, p, _, cc, _, argAp, ap, config) and
      PrevStage::parameterMayFlowThrough(p, _, unbindApa(getApprox(ap)), config)
    )
  }

  pragma[nomagic]
  private predicate storeStepFwd(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, Ap ap2, Configuration config
  ) {
    fwdFlowStore(node1, ap1, tc, node2, _, _, _, config) and
    ap2 = apCons(tc, ap1) and
    fwdFlowRead(ap2, tc.getContent(), _, _, _, _, _, config)
  }

  private predicate readStepFwd(
    NodeEx n1, Ap ap1, Content c, NodeEx n2, Ap ap2, Configuration config
  ) {
    fwdFlowRead(ap1, c, n1, n2, _, _, _, config) and
    fwdFlowConsCand(ap1, c, ap2, config)
  }

  pragma[nomagic]
  private predicate callMayFlowThroughFwd(DataFlowCall call, Configuration config) {
    exists(Ap argAp0, NodeEx out, FlowState state, Cc cc, ApOption argAp, Ap ap |
      fwdFlow(out, state, pragma[only_bind_into](cc), pragma[only_bind_into](argAp), ap,
        pragma[only_bind_into](config)) and
      fwdFlowOutFromArg(call, out, state, argAp0, ap, config) and
      fwdFlowIsEntered(pragma[only_bind_into](call), pragma[only_bind_into](cc),
        pragma[only_bind_into](argAp), pragma[only_bind_into](argAp0),
        pragma[only_bind_into](config))
    )
  }

  pragma[nomagic]
  private predicate flowThroughIntoCall(
    DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow, Configuration config
  ) {
    flowIntoCall(call, arg, p, allowsFieldFlow, config) and
    fwdFlow(arg, _, _, _, _, pragma[only_bind_into](config)) and
    PrevStage::parameterMayFlowThrough(p, _, _, pragma[only_bind_into](config)) and
    callMayFlowThroughFwd(call, pragma[only_bind_into](config))
  }

  pragma[nomagic]
  private predicate returnNodeMayFlowThrough(
    RetNodeEx ret, FlowState state, Ap ap, Configuration config
  ) {
    fwdFlow(ret, state, any(CcCall ccc), apSome(_), ap, config)
  }

  /**
   * Holds if `node` with access path `ap` is part of a path from a source to a
   * sink in the configuration `config`.
   *
   * The Boolean `toReturn` records whether the node must be returned from the
   * enclosing callable in order to reach a sink, and if so, `returnAp` records
   * the access path of the returned value.
   */
  pragma[nomagic]
  predicate revFlow(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow0(node, state, toReturn, returnAp, ap, config) and
    fwdFlow(node, state, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlow0(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    fwdFlow(node, state, _, _, ap, config) and
    sinkNode(node, state, config) and
    (if hasSinkCallCtx(config) then toReturn = true else toReturn = false) and
    returnAp = apNone() and
    ap instanceof ApNil
    or
    exists(NodeEx mid, FlowState state0 |
      localStep(node, state, mid, state0, true, _, config, _) and
      revFlow(mid, state0, toReturn, returnAp, ap, config)
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(node, pragma[only_bind_into](state), _, _, ap, pragma[only_bind_into](config)) and
      localStep(node, pragma[only_bind_into](state), mid, state0, false, _, config, _) and
      revFlow(mid, state0, toReturn, returnAp, nil, pragma[only_bind_into](config)) and
      ap instanceof ApNil
    )
    or
    exists(NodeEx mid |
      jumpStep(node, mid, config) and
      revFlow(mid, state, _, _, ap, config) and
      toReturn = false and
      returnAp = apNone()
    )
    or
    exists(NodeEx mid, ApNil nil |
      fwdFlow(node, _, _, _, ap, pragma[only_bind_into](config)) and
      additionalJumpStep(node, mid, config) and
      revFlow(pragma[only_bind_into](mid), state, _, _, nil, pragma[only_bind_into](config)) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(node, _, _, _, ap, pragma[only_bind_into](config)) and
      additionalJumpStateStep(node, state, mid, state0, config) and
      revFlow(pragma[only_bind_into](mid), pragma[only_bind_into](state0), _, _, nil,
        pragma[only_bind_into](config)) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    // store
    exists(Ap ap0, Content c |
      revFlowStore(ap0, c, ap, node, state, _, _, toReturn, returnAp, config) and
      revFlowConsCand(ap0, c, ap, config)
    )
    or
    // read
    exists(NodeEx mid, Ap ap0 |
      revFlow(mid, state, toReturn, returnAp, ap0, config) and
      readStepFwd(node, ap, _, mid, ap0, config)
    )
    or
    // flow into a callable
    revFlowInNotToReturn(node, state, returnAp, ap, config) and
    toReturn = false
    or
    exists(DataFlowCall call, Ap returnAp0 |
      revFlowInToReturn(call, node, state, returnAp0, ap, config) and
      revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
    or
    // flow out of a callable
    revFlowOut(_, node, state, _, _, ap, config) and
    toReturn = true and
    if returnNodeMayFlowThrough(node, state, ap, config)
    then returnAp = apSome(ap)
    else returnAp = apNone()
  }

  pragma[nomagic]
  private predicate revFlowStore(
    Ap ap0, Content c, Ap ap, NodeEx node, FlowState state, TypedContent tc, NodeEx mid,
    boolean toReturn, ApOption returnAp, Configuration config
  ) {
    revFlow(mid, state, toReturn, returnAp, ap0, config) and
    storeStepFwd(node, ap, tc, mid, ap0, config) and
    tc.getContent() = c
  }

  /**
   * Holds if reverse flow with access path `tail` reaches a read of `c`
   * resulting in access path `cons`.
   */
  pragma[nomagic]
  private predicate revFlowConsCand(Ap cons, Content c, Ap tail, Configuration config) {
    exists(NodeEx mid, Ap tail0 |
      revFlow(mid, _, _, _, tail, config) and
      tail = pragma[only_bind_into](tail0) and
      readStepFwd(_, cons, c, mid, tail0, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowOut(
    DataFlowCall call, RetNodeEx ret, FlowState state, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(NodeEx out, boolean allowsFieldFlow |
      revFlow(out, state, toReturn, returnAp, ap, config) and
      flowOutOfCall(call, ret, out, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate revFlowInNotToReturn(
    ArgNodeEx arg, FlowState state, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p, boolean allowsFieldFlow |
      revFlow(p, state, false, returnAp, ap, config) and
      flowIntoCall(_, arg, p, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(
    DataFlowCall call, ArgNodeEx arg, FlowState state, Ap returnAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p, boolean allowsFieldFlow |
      revFlow(p, state, true, apSome(returnAp), ap, config) and
      flowThroughIntoCall(call, arg, p, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`
   * and data might flow through the target callable resulting in reverse flow
   * reaching an argument of `call`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(
    DataFlowCall call, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(RetNodeEx ret, FlowState state, CcCall ccc |
      revFlowOut(call, ret, state, toReturn, returnAp, ap, config) and
      fwdFlow(ret, state, ccc, apSome(_), ap, config) and
      ccc.matchesCall(call)
    )
  }

  pragma[nomagic]
  predicate storeStepCand(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, DataFlowType contentType,
    Configuration config
  ) {
    exists(Ap ap2, Content c |
      PrevStage::storeStepCand(node1, _, tc, node2, contentType, config) and
      revFlowStore(ap2, c, ap1, node1, _, tc, node2, _, _, config) and
      revFlowConsCand(ap2, c, ap1, config)
    )
  }

  predicate readStepCand(NodeEx node1, Content c, NodeEx node2, Configuration config) {
    exists(Ap ap1, Ap ap2 |
      revFlow(node2, _, _, _, pragma[only_bind_into](ap2), pragma[only_bind_into](config)) and
      readStepFwd(node1, ap1, c, node2, ap2, config) and
      revFlowStore(ap1, c, pragma[only_bind_into](ap2), _, _, _, _, _, _,
        pragma[only_bind_into](config))
    )
  }

  predicate revFlow(NodeEx node, FlowState state, Configuration config) {
    revFlow(node, state, _, _, _, config)
  }

  pragma[nomagic]
  predicate revFlow(NodeEx node, Configuration config) { revFlow(node, _, _, _, _, config) }

  // use an alias as a workaround for bad functionality-induced joins
  pragma[nomagic]
  predicate revFlowAlias(NodeEx node, Configuration config) { revFlow(node, _, _, _, _, config) }

  // use an alias as a workaround for bad functionality-induced joins
  pragma[nomagic]
  predicate revFlowAlias(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow(node, state, toReturn, returnAp, ap, config)
  }

  private predicate fwdConsCand(TypedContent tc, Ap ap, Configuration config) {
    storeStepFwd(_, ap, tc, _, _, config)
  }

  private predicate revConsCand(TypedContent tc, Ap ap, Configuration config) {
    storeStepCand(_, ap, tc, _, _, config)
  }

  private predicate validAp(Ap ap, Configuration config) {
    revFlow(_, _, _, _, ap, config) and ap instanceof ApNil
    or
    exists(TypedContent head, Ap tail |
      consCand(head, tail, config) and
      ap = apCons(head, tail)
    )
  }

  predicate consCand(TypedContent tc, Ap ap, Configuration config) {
    revConsCand(tc, ap, config) and
    validAp(ap, config)
  }

  pragma[noinline]
  private predicate parameterFlow(
    ParamNodeEx p, Ap ap, Ap ap0, DataFlowCallable c, Configuration config
  ) {
    revFlow(p, _, true, apSome(ap0), ap, config) and
    c = p.getEnclosingCallable()
  }

  predicate parameterMayFlowThrough(ParamNodeEx p, DataFlowCallable c, Ap ap, Configuration config) {
    exists(RetNodeEx ret, FlowState state, Ap ap0, ReturnKindExt kind, ParameterPosition pos |
      parameterFlow(p, ap, ap0, c, config) and
      c = ret.getEnclosingCallable() and
      revFlow(pragma[only_bind_into](ret), pragma[only_bind_into](state), true, apSome(_),
        pragma[only_bind_into](ap0), pragma[only_bind_into](config)) and
      fwdFlow(ret, state, any(CcCall ccc), apSome(ap), ap0, config) and
      kind = ret.getKind() and
      p.getPosition() = pos and
      // we don't expect a parameter to return stored in itself, unless explicitly allowed
      (
        not kind.(ParamUpdateReturnKind).getPosition() = pos
        or
        p.allowParameterReturnInSelf()
      )
    )
  }

  pragma[nomagic]
  predicate callMayFlowThroughRev(DataFlowCall call, Configuration config) {
    exists(
      Ap returnAp0, ArgNodeEx arg, FlowState state, boolean toReturn, ApOption returnAp, Ap ap
    |
      revFlow(arg, state, toReturn, returnAp, ap, config) and
      revFlowInToReturn(call, arg, state, returnAp0, ap, config) and
      revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
  }

  predicate stats(
    boolean fwd, int nodes, int fields, int conscand, int states, int tuples, Configuration config
  ) {
    fwd = true and
    nodes = count(NodeEx node | fwdFlow(node, _, _, _, _, config)) and
    fields = count(TypedContent f0 | fwdConsCand(f0, _, config)) and
    conscand = count(TypedContent f0, Ap ap | fwdConsCand(f0, ap, config)) and
    states = count(FlowState state | fwdFlow(_, state, _, _, _, config)) and
    tuples =
      count(NodeEx n, FlowState state, Cc cc, ApOption argAp, Ap ap |
        fwdFlow(n, state, cc, argAp, ap, config)
      )
    or
    fwd = false and
    nodes = count(NodeEx node | revFlow(node, _, _, _, _, config)) and
    fields = count(TypedContent f0 | consCand(f0, _, config)) and
    conscand = count(TypedContent f0, Ap ap | consCand(f0, ap, config)) and
    states = count(FlowState state | revFlow(_, state, _, _, _, config)) and
    tuples =
      count(NodeEx n, FlowState state, boolean b, ApOption retAp, Ap ap |
        revFlow(n, state, b, retAp, ap, config)
      )
  }
  /* End: Stage 3 logic. */
}

/**
 * Holds if `argApf` is recorded as the summary context for flow reaching `node`
 * and remains relevant for the following pruning stage.
 */
private predicate flowCandSummaryCtx(
  NodeEx node, FlowState state, AccessPathFront argApf, Configuration config
) {
  exists(AccessPathFront apf |
    Stage3::revFlow(node, state, true, _, apf, config) and
    Stage3::fwdFlow(node, state, any(Stage3::CcCall ccc), TAccessPathFrontSome(argApf), apf, config)
  )
}

/**
 * Holds if a length 2 access path approximation with the head `tc` is expected
 * to be expensive.
 */
private predicate expensiveLen2unfolding(TypedContent tc, Configuration config) {
  exists(int tails, int nodes, int apLimit, int tupleLimit |
    tails = strictcount(AccessPathFront apf | Stage3::consCand(tc, apf, config)) and
    nodes =
      strictcount(NodeEx n, FlowState state |
        Stage3::revFlow(n, state, _, _, any(AccessPathFrontHead apf | apf.getHead() = tc), config)
        or
        flowCandSummaryCtx(n, state, any(AccessPathFrontHead apf | apf.getHead() = tc), config)
      ) and
    accessPathApproxCostLimits(apLimit, tupleLimit) and
    apLimit < tails and
    tupleLimit < (tails - 1) * nodes and
    not tc.forceHighPrecision()
  )
}

private newtype TAccessPathApprox =
  TNil(DataFlowType t) or
  TConsNil(TypedContent tc, DataFlowType t) {
    Stage3::consCand(tc, TFrontNil(t), _) and
    not expensiveLen2unfolding(tc, _)
  } or
  TConsCons(TypedContent tc1, TypedContent tc2, int len) {
    Stage3::consCand(tc1, TFrontHead(tc2), _) and
    len in [2 .. accessPathLimit()] and
    not expensiveLen2unfolding(tc1, _)
  } or
  TCons1(TypedContent tc, int len) {
    len in [1 .. accessPathLimit()] and
    expensiveLen2unfolding(tc, _)
  }

/**
 * Conceptually a list of `TypedContent`s followed by a `DataFlowType`, but only
 * the first two elements of the list and its length are tracked. If data flows
 * from a source to a given node with a given `AccessPathApprox`, this indicates
 * the sequence of dereference operations needed to get from the value in the node
 * to the tracked object. The final type indicates the type of the tracked object.
 */
abstract private class AccessPathApprox extends TAccessPathApprox {
  abstract string toString();

  abstract TypedContent getHead();

  abstract int len();

  abstract DataFlowType getType();

  abstract AccessPathFront getFront();

  /** Gets the access path obtained by popping `head` from this path, if any. */
  abstract AccessPathApprox pop(TypedContent head);
}

private class AccessPathApproxNil extends AccessPathApprox, TNil {
  private DataFlowType t;

  AccessPathApproxNil() { this = TNil(t) }

  override string toString() { result = concat(": " + ppReprType(t)) }

  override TypedContent getHead() { none() }

  override int len() { result = 0 }

  override DataFlowType getType() { result = t }

  override AccessPathFront getFront() { result = TFrontNil(t) }

  override AccessPathApprox pop(TypedContent head) { none() }
}

abstract private class AccessPathApproxCons extends AccessPathApprox { }

private class AccessPathApproxConsNil extends AccessPathApproxCons, TConsNil {
  private TypedContent tc;
  private DataFlowType t;

  AccessPathApproxConsNil() { this = TConsNil(tc, t) }

  override string toString() {
    // The `concat` becomes "" if `ppReprType` has no result.
    result = "[" + tc.toString() + "]" + concat(" : " + ppReprType(t))
  }

  override TypedContent getHead() { result = tc }

  override int len() { result = 1 }

  override DataFlowType getType() { result = tc.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(tc) }

  override AccessPathApprox pop(TypedContent head) { head = tc and result = TNil(t) }
}

private class AccessPathApproxConsCons extends AccessPathApproxCons, TConsCons {
  private TypedContent tc1;
  private TypedContent tc2;
  private int len;

  AccessPathApproxConsCons() { this = TConsCons(tc1, tc2, len) }

  override string toString() {
    if len = 2
    then result = "[" + tc1.toString() + ", " + tc2.toString() + "]"
    else result = "[" + tc1.toString() + ", " + tc2.toString() + ", ... (" + len.toString() + ")]"
  }

  override TypedContent getHead() { result = tc1 }

  override int len() { result = len }

  override DataFlowType getType() { result = tc1.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(tc1) }

  override AccessPathApprox pop(TypedContent head) {
    head = tc1 and
    (
      result = TConsCons(tc2, _, len - 1)
      or
      len = 2 and
      result = TConsNil(tc2, _)
      or
      result = TCons1(tc2, len - 1)
    )
  }
}

private class AccessPathApproxCons1 extends AccessPathApproxCons, TCons1 {
  private TypedContent tc;
  private int len;

  AccessPathApproxCons1() { this = TCons1(tc, len) }

  override string toString() {
    if len = 1
    then result = "[" + tc.toString() + "]"
    else result = "[" + tc.toString() + ", ... (" + len.toString() + ")]"
  }

  override TypedContent getHead() { result = tc }

  override int len() { result = len }

  override DataFlowType getType() { result = tc.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(tc) }

  override AccessPathApprox pop(TypedContent head) {
    head = tc and
    (
      exists(TypedContent tc2 | Stage3::consCand(tc, TFrontHead(tc2), _) |
        result = TConsCons(tc2, _, len - 1)
        or
        len = 2 and
        result = TConsNil(tc2, _)
        or
        result = TCons1(tc2, len - 1)
      )
      or
      exists(DataFlowType t |
        len = 1 and
        Stage3::consCand(tc, TFrontNil(t), _) and
        result = TNil(t)
      )
    )
  }
}

/** Gets the access path obtained by popping `tc` from `ap`, if any. */
private AccessPathApprox pop(TypedContent tc, AccessPathApprox apa) { result = apa.pop(tc) }

/** Gets the access path obtained by pushing `tc` onto `ap`. */
private AccessPathApprox push(TypedContent tc, AccessPathApprox apa) { apa = pop(tc, result) }

private newtype TAccessPathApproxOption =
  TAccessPathApproxNone() or
  TAccessPathApproxSome(AccessPathApprox apa)

private class AccessPathApproxOption extends TAccessPathApproxOption {
  string toString() {
    this = TAccessPathApproxNone() and result = "<none>"
    or
    this = TAccessPathApproxSome(any(AccessPathApprox apa | result = apa.toString()))
  }
}

private module Stage4 {
  module PrevStage = Stage3;

  class ApApprox = PrevStage::Ap;

  class Ap = AccessPathApprox;

  class ApNil = AccessPathApproxNil;

  private ApApprox getApprox(Ap ap) { result = ap.getFront() }

  private ApNil getApNil(NodeEx node) {
    PrevStage::revFlow(node, _) and result = TNil(node.getDataFlowType())
  }

  bindingset[tc, tail]
  private Ap apCons(TypedContent tc, Ap tail) { result = push(tc, tail) }

  pragma[noinline]
  private Content getHeadContent(Ap ap) { result = ap.getHead().getContent() }

  class ApOption = AccessPathApproxOption;

  ApOption apNone() { result = TAccessPathApproxNone() }

  ApOption apSome(Ap ap) { result = TAccessPathApproxSome(ap) }

  class Cc = CallContext;

  class CcCall = CallContextCall;

  class CcNoCall = CallContextNoCall;

  Cc ccNone() { result instanceof CallContextAny }

  CcCall ccSomeCall() { result instanceof CallContextSomeCall }

  private class LocalCc = LocalCallContext;

  bindingset[call, c, outercc]
  private CcCall getCallContextCall(DataFlowCall call, DataFlowCallable c, Cc outercc) {
    checkCallContextCall(outercc, call, c) and
    if recordDataFlowCallSite(call, c) then result = TSpecificCall(call) else result = TSomeCall()
  }

  bindingset[call, c, innercc]
  private CcNoCall getCallContextReturn(DataFlowCallable c, DataFlowCall call, Cc innercc) {
    checkCallContextReturn(innercc, c, call) and
    if reducedViableImplInReturn(c, call) then result = TReturn(c, call) else result = ccNone()
  }

  bindingset[node, cc]
  private LocalCc getLocalCc(NodeEx node, Cc cc) {
    result =
      getLocalCallContext(pragma[only_bind_into](pragma[only_bind_out](cc)),
        node.getEnclosingCallable())
  }

  private predicate localStep(
    NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
    ApNil ap, Configuration config, LocalCc lcc
  ) {
    localFlowBigStep(node1, state1, node2, state2, preservesValue, ap.getFront(), config, lcc)
  }

  pragma[nomagic]
  private predicate flowOutOfCall(
    DataFlowCall call, RetNodeEx node1, NodeEx node2, boolean allowsFieldFlow, Configuration config
  ) {
    exists(FlowState state |
      flowOutOfCallNodeCand2(call, node1, node2, allowsFieldFlow, config) and
      PrevStage::revFlow(node2, pragma[only_bind_into](state), _, _, _,
        pragma[only_bind_into](config)) and
      PrevStage::revFlowAlias(node1, pragma[only_bind_into](state), _, _, _,
        pragma[only_bind_into](config))
    )
  }

  pragma[nomagic]
  private predicate flowIntoCall(
    DataFlowCall call, ArgNodeEx node1, ParamNodeEx node2, boolean allowsFieldFlow,
    Configuration config
  ) {
    exists(FlowState state |
      flowIntoCallNodeCand2(call, node1, node2, allowsFieldFlow, config) and
      PrevStage::revFlow(node2, pragma[only_bind_into](state), _, _, _,
        pragma[only_bind_into](config)) and
      PrevStage::revFlowAlias(node1, pragma[only_bind_into](state), _, _, _,
        pragma[only_bind_into](config))
    )
  }

  bindingset[node, state, ap, config]
  private predicate filter(NodeEx node, FlowState state, Ap ap, Configuration config) { any() }

  // Type checking is not necessary here as it has already been done in stage 3.
  bindingset[ap, contentType]
  private predicate typecheckStore(Ap ap, DataFlowType contentType) { any() }

  /* Begin: Stage 4 logic. */
  bindingset[node, state, config]
  private predicate flowCand(NodeEx node, FlowState state, ApApprox apa, Configuration config) {
    PrevStage::revFlow(node, state, _, _, apa, config)
  }

  bindingset[result, apa]
  private ApApprox unbindApa(ApApprox apa) {
    pragma[only_bind_out](apa) = pragma[only_bind_out](result)
  }

  pragma[nomagic]
  private predicate flowThroughOutOfCall(
    DataFlowCall call, CcCall ccc, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
    Configuration config
  ) {
    flowOutOfCall(call, ret, out, allowsFieldFlow, pragma[only_bind_into](config)) and
    PrevStage::callMayFlowThroughRev(call, pragma[only_bind_into](config)) and
    PrevStage::parameterMayFlowThrough(_, ret.getEnclosingCallable(), _,
      pragma[only_bind_into](config)) and
    ccc.matchesCall(call)
  }

  /**
   * Holds if `node` is reachable with access path `ap` from a source in the
   * configuration `config`.
   *
   * The call context `cc` records whether the node is reached through an
   * argument in a call, and if so, `argAp` records the access path of that
   * argument.
   */
  pragma[nomagic]
  predicate fwdFlow(NodeEx node, FlowState state, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    fwdFlow0(node, state, cc, argAp, ap, config) and
    flowCand(node, state, unbindApa(getApprox(ap)), config) and
    filter(node, state, ap, config)
  }

  pragma[nomagic]
  private predicate fwdFlow0(
    NodeEx node, FlowState state, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    sourceNode(node, state, config) and
    (if hasSourceCallCtx(config) then cc = ccSomeCall() else cc = ccNone()) and
    argAp = apNone() and
    ap = getApNil(node)
    or
    exists(NodeEx mid, FlowState state0, Ap ap0, LocalCc localCc |
      fwdFlow(mid, state0, cc, argAp, ap0, config) and
      localCc = getLocalCc(mid, cc)
    |
      localStep(mid, state0, node, state, true, _, config, localCc) and
      ap = ap0
      or
      localStep(mid, state0, node, state, false, ap, config, localCc) and
      ap0 instanceof ApNil
    )
    or
    exists(NodeEx mid |
      fwdFlow(mid, pragma[only_bind_into](state), _, _, ap, pragma[only_bind_into](config)) and
      jumpStep(mid, node, config) and
      cc = ccNone() and
      argAp = apNone()
    )
    or
    exists(NodeEx mid, ApNil nil |
      fwdFlow(mid, state, _, _, nil, pragma[only_bind_into](config)) and
      additionalJumpStep(mid, node, config) and
      cc = ccNone() and
      argAp = apNone() and
      ap = getApNil(node)
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(mid, state0, _, _, nil, pragma[only_bind_into](config)) and
      additionalJumpStateStep(mid, state0, node, state, config) and
      cc = ccNone() and
      argAp = apNone() and
      ap = getApNil(node)
    )
    or
    // store
    exists(TypedContent tc, Ap ap0 |
      fwdFlowStore(_, ap0, tc, node, state, cc, argAp, config) and
      ap = apCons(tc, ap0)
    )
    or
    // read
    exists(Ap ap0, Content c |
      fwdFlowRead(ap0, c, _, node, state, cc, argAp, config) and
      fwdFlowConsCand(ap0, c, ap, config)
    )
    or
    // flow into a callable
    exists(ApApprox apa |
      fwdFlowIn(_, node, state, _, cc, _, ap, config) and
      apa = getApprox(ap) and
      if PrevStage::parameterMayFlowThrough(node, _, apa, config)
      then argAp = apSome(ap)
      else argAp = apNone()
    )
    or
    // flow out of a callable
    fwdFlowOutNotFromArg(node, state, cc, argAp, ap, config)
    or
    exists(DataFlowCall call, Ap argAp0 |
      fwdFlowOutFromArg(call, node, state, argAp0, ap, config) and
      fwdFlowIsEntered(call, cc, argAp, argAp0, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowStore(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, FlowState state, Cc cc, ApOption argAp,
    Configuration config
  ) {
    exists(DataFlowType contentType |
      fwdFlow(node1, state, cc, argAp, ap1, config) and
      PrevStage::storeStepCand(node1, unbindApa(getApprox(ap1)), tc, node2, contentType, config) and
      typecheckStore(ap1, contentType)
    )
  }

  /**
   * Holds if forward flow with access path `tail` reaches a store of `c`
   * resulting in access path `cons`.
   */
  pragma[nomagic]
  private predicate fwdFlowConsCand(Ap cons, Content c, Ap tail, Configuration config) {
    exists(TypedContent tc |
      fwdFlowStore(_, tail, tc, _, _, _, _, config) and
      tc.getContent() = c and
      cons = apCons(tc, tail)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowRead(
    Ap ap, Content c, NodeEx node1, NodeEx node2, FlowState state, Cc cc, ApOption argAp,
    Configuration config
  ) {
    fwdFlow(node1, state, cc, argAp, ap, config) and
    PrevStage::readStepCand(node1, c, node2, config) and
    getHeadContent(ap) = c
  }

  pragma[nomagic]
  private predicate fwdFlowIn(
    DataFlowCall call, ParamNodeEx p, FlowState state, Cc outercc, Cc innercc, ApOption argAp,
    Ap ap, Configuration config
  ) {
    exists(ArgNodeEx arg, boolean allowsFieldFlow |
      fwdFlow(arg, state, outercc, argAp, ap, config) and
      flowIntoCall(call, arg, p, allowsFieldFlow, config) and
      innercc = getCallContextCall(call, p.getEnclosingCallable(), outercc) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutNotFromArg(
    NodeEx out, FlowState state, Cc ccOut, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(
      DataFlowCall call, RetNodeEx ret, boolean allowsFieldFlow, CcNoCall innercc,
      DataFlowCallable inner
    |
      fwdFlow(ret, state, innercc, argAp, ap, config) and
      flowOutOfCall(call, ret, out, allowsFieldFlow, config) and
      inner = ret.getEnclosingCallable() and
      ccOut = getCallContextReturn(inner, call, innercc) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(
    DataFlowCall call, NodeEx out, FlowState state, Ap argAp, Ap ap, Configuration config
  ) {
    exists(RetNodeEx ret, boolean allowsFieldFlow, CcCall ccc |
      fwdFlow(ret, state, ccc, apSome(argAp), ap, config) and
      flowThroughOutOfCall(call, ccc, ret, out, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`
   * and data might flow through the target callable and back out at `call`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(
    DataFlowCall call, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p |
      fwdFlowIn(call, p, _, cc, _, argAp, ap, config) and
      PrevStage::parameterMayFlowThrough(p, _, unbindApa(getApprox(ap)), config)
    )
  }

  pragma[nomagic]
  private predicate storeStepFwd(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, Ap ap2, Configuration config
  ) {
    fwdFlowStore(node1, ap1, tc, node2, _, _, _, config) and
    ap2 = apCons(tc, ap1) and
    fwdFlowRead(ap2, tc.getContent(), _, _, _, _, _, config)
  }

  private predicate readStepFwd(
    NodeEx n1, Ap ap1, Content c, NodeEx n2, Ap ap2, Configuration config
  ) {
    fwdFlowRead(ap1, c, n1, n2, _, _, _, config) and
    fwdFlowConsCand(ap1, c, ap2, config)
  }

  pragma[nomagic]
  private predicate callMayFlowThroughFwd(DataFlowCall call, Configuration config) {
    exists(Ap argAp0, NodeEx out, FlowState state, Cc cc, ApOption argAp, Ap ap |
      fwdFlow(out, state, pragma[only_bind_into](cc), pragma[only_bind_into](argAp), ap,
        pragma[only_bind_into](config)) and
      fwdFlowOutFromArg(call, out, state, argAp0, ap, config) and
      fwdFlowIsEntered(pragma[only_bind_into](call), pragma[only_bind_into](cc),
        pragma[only_bind_into](argAp), pragma[only_bind_into](argAp0),
        pragma[only_bind_into](config))
    )
  }

  pragma[nomagic]
  private predicate flowThroughIntoCall(
    DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow, Configuration config
  ) {
    flowIntoCall(call, arg, p, allowsFieldFlow, config) and
    fwdFlow(arg, _, _, _, _, pragma[only_bind_into](config)) and
    PrevStage::parameterMayFlowThrough(p, _, _, pragma[only_bind_into](config)) and
    callMayFlowThroughFwd(call, pragma[only_bind_into](config))
  }

  pragma[nomagic]
  private predicate returnNodeMayFlowThrough(
    RetNodeEx ret, FlowState state, Ap ap, Configuration config
  ) {
    fwdFlow(ret, state, any(CcCall ccc), apSome(_), ap, config)
  }

  /**
   * Holds if `node` with access path `ap` is part of a path from a source to a
   * sink in the configuration `config`.
   *
   * The Boolean `toReturn` records whether the node must be returned from the
   * enclosing callable in order to reach a sink, and if so, `returnAp` records
   * the access path of the returned value.
   */
  pragma[nomagic]
  predicate revFlow(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow0(node, state, toReturn, returnAp, ap, config) and
    fwdFlow(node, state, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlow0(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    fwdFlow(node, state, _, _, ap, config) and
    sinkNode(node, state, config) and
    (if hasSinkCallCtx(config) then toReturn = true else toReturn = false) and
    returnAp = apNone() and
    ap instanceof ApNil
    or
    exists(NodeEx mid, FlowState state0 |
      localStep(node, state, mid, state0, true, _, config, _) and
      revFlow(mid, state0, toReturn, returnAp, ap, config)
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(node, pragma[only_bind_into](state), _, _, ap, pragma[only_bind_into](config)) and
      localStep(node, pragma[only_bind_into](state), mid, state0, false, _, config, _) and
      revFlow(mid, state0, toReturn, returnAp, nil, pragma[only_bind_into](config)) and
      ap instanceof ApNil
    )
    or
    exists(NodeEx mid |
      jumpStep(node, mid, config) and
      revFlow(mid, state, _, _, ap, config) and
      toReturn = false and
      returnAp = apNone()
    )
    or
    exists(NodeEx mid, ApNil nil |
      fwdFlow(node, _, _, _, ap, pragma[only_bind_into](config)) and
      additionalJumpStep(node, mid, config) and
      revFlow(pragma[only_bind_into](mid), state, _, _, nil, pragma[only_bind_into](config)) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    exists(NodeEx mid, FlowState state0, ApNil nil |
      fwdFlow(node, _, _, _, ap, pragma[only_bind_into](config)) and
      additionalJumpStateStep(node, state, mid, state0, config) and
      revFlow(pragma[only_bind_into](mid), pragma[only_bind_into](state0), _, _, nil,
        pragma[only_bind_into](config)) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    // store
    exists(Ap ap0, Content c |
      revFlowStore(ap0, c, ap, node, state, _, _, toReturn, returnAp, config) and
      revFlowConsCand(ap0, c, ap, config)
    )
    or
    // read
    exists(NodeEx mid, Ap ap0 |
      revFlow(mid, state, toReturn, returnAp, ap0, config) and
      readStepFwd(node, ap, _, mid, ap0, config)
    )
    or
    // flow into a callable
    revFlowInNotToReturn(node, state, returnAp, ap, config) and
    toReturn = false
    or
    exists(DataFlowCall call, Ap returnAp0 |
      revFlowInToReturn(call, node, state, returnAp0, ap, config) and
      revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
    or
    // flow out of a callable
    revFlowOut(_, node, state, _, _, ap, config) and
    toReturn = true and
    if returnNodeMayFlowThrough(node, state, ap, config)
    then returnAp = apSome(ap)
    else returnAp = apNone()
  }

  pragma[nomagic]
  private predicate revFlowStore(
    Ap ap0, Content c, Ap ap, NodeEx node, FlowState state, TypedContent tc, NodeEx mid,
    boolean toReturn, ApOption returnAp, Configuration config
  ) {
    revFlow(mid, state, toReturn, returnAp, ap0, config) and
    storeStepFwd(node, ap, tc, mid, ap0, config) and
    tc.getContent() = c
  }

  /**
   * Holds if reverse flow with access path `tail` reaches a read of `c`
   * resulting in access path `cons`.
   */
  pragma[nomagic]
  private predicate revFlowConsCand(Ap cons, Content c, Ap tail, Configuration config) {
    exists(NodeEx mid, Ap tail0 |
      revFlow(mid, _, _, _, tail, config) and
      tail = pragma[only_bind_into](tail0) and
      readStepFwd(_, cons, c, mid, tail0, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowOut(
    DataFlowCall call, RetNodeEx ret, FlowState state, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(NodeEx out, boolean allowsFieldFlow |
      revFlow(out, state, toReturn, returnAp, ap, config) and
      flowOutOfCall(call, ret, out, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate revFlowInNotToReturn(
    ArgNodeEx arg, FlowState state, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p, boolean allowsFieldFlow |
      revFlow(p, state, false, returnAp, ap, config) and
      flowIntoCall(_, arg, p, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(
    DataFlowCall call, ArgNodeEx arg, FlowState state, Ap returnAp, Ap ap, Configuration config
  ) {
    exists(ParamNodeEx p, boolean allowsFieldFlow |
      revFlow(p, state, true, apSome(returnAp), ap, config) and
      flowThroughIntoCall(call, arg, p, allowsFieldFlow, config) and
      if allowsFieldFlow = false then ap instanceof ApNil else any()
    )
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`
   * and data might flow through the target callable resulting in reverse flow
   * reaching an argument of `call`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(
    DataFlowCall call, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(RetNodeEx ret, FlowState state, CcCall ccc |
      revFlowOut(call, ret, state, toReturn, returnAp, ap, config) and
      fwdFlow(ret, state, ccc, apSome(_), ap, config) and
      ccc.matchesCall(call)
    )
  }

  pragma[nomagic]
  predicate storeStepCand(
    NodeEx node1, Ap ap1, TypedContent tc, NodeEx node2, DataFlowType contentType,
    Configuration config
  ) {
    exists(Ap ap2, Content c |
      PrevStage::storeStepCand(node1, _, tc, node2, contentType, config) and
      revFlowStore(ap2, c, ap1, node1, _, tc, node2, _, _, config) and
      revFlowConsCand(ap2, c, ap1, config)
    )
  }

  predicate readStepCand(NodeEx node1, Content c, NodeEx node2, Configuration config) {
    exists(Ap ap1, Ap ap2 |
      revFlow(node2, _, _, _, pragma[only_bind_into](ap2), pragma[only_bind_into](config)) and
      readStepFwd(node1, ap1, c, node2, ap2, config) and
      revFlowStore(ap1, c, pragma[only_bind_into](ap2), _, _, _, _, _, _,
        pragma[only_bind_into](config))
    )
  }

  predicate revFlow(NodeEx node, FlowState state, Configuration config) {
    revFlow(node, state, _, _, _, config)
  }

  pragma[nomagic]
  predicate revFlow(NodeEx node, Configuration config) { revFlow(node, _, _, _, _, config) }

  // use an alias as a workaround for bad functionality-induced joins
  pragma[nomagic]
  predicate revFlowAlias(NodeEx node, Configuration config) { revFlow(node, _, _, _, _, config) }

  // use an alias as a workaround for bad functionality-induced joins
  pragma[nomagic]
  predicate revFlowAlias(
    NodeEx node, FlowState state, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    revFlow(node, state, toReturn, returnAp, ap, config)
  }

  private predicate fwdConsCand(TypedContent tc, Ap ap, Configuration config) {
    storeStepFwd(_, ap, tc, _, _, config)
  }

  private predicate revConsCand(TypedContent tc, Ap ap, Configuration config) {
    storeStepCand(_, ap, tc, _, _, config)
  }

  private predicate validAp(Ap ap, Configuration config) {
    revFlow(_, _, _, _, ap, config) and ap instanceof ApNil
    or
    exists(TypedContent head, Ap tail |
      consCand(head, tail, config) and
      ap = apCons(head, tail)
    )
  }

  predicate consCand(TypedContent tc, Ap ap, Configuration config) {
    revConsCand(tc, ap, config) and
    validAp(ap, config)
  }

  pragma[noinline]
  private predicate parameterFlow(
    ParamNodeEx p, Ap ap, Ap ap0, DataFlowCallable c, Configuration config
  ) {
    revFlow(p, _, true, apSome(ap0), ap, config) and
    c = p.getEnclosingCallable()
  }

  predicate parameterMayFlowThrough(ParamNodeEx p, DataFlowCallable c, Ap ap, Configuration config) {
    exists(RetNodeEx ret, FlowState state, Ap ap0, ReturnKindExt kind, ParameterPosition pos |
      parameterFlow(p, ap, ap0, c, config) and
      c = ret.getEnclosingCallable() and
      revFlow(pragma[only_bind_into](ret), pragma[only_bind_into](state), true, apSome(_),
        pragma[only_bind_into](ap0), pragma[only_bind_into](config)) and
      fwdFlow(ret, state, any(CcCall ccc), apSome(ap), ap0, config) and
      kind = ret.getKind() and
      p.getPosition() = pos and
      // we don't expect a parameter to return stored in itself, unless explicitly allowed
      (
        not kind.(ParamUpdateReturnKind).getPosition() = pos
        or
        p.allowParameterReturnInSelf()
      )
    )
  }

  pragma[nomagic]
  predicate callMayFlowThroughRev(DataFlowCall call, Configuration config) {
    exists(
      Ap returnAp0, ArgNodeEx arg, FlowState state, boolean toReturn, ApOption returnAp, Ap ap
    |
      revFlow(arg, state, toReturn, returnAp, ap, config) and
      revFlowInToReturn(call, arg, state, returnAp0, ap, config) and
      revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
  }

  predicate stats(
    boolean fwd, int nodes, int fields, int conscand, int states, int tuples, Configuration config
  ) {
    fwd = true and
    nodes = count(NodeEx node | fwdFlow(node, _, _, _, _, config)) and
    fields = count(TypedContent f0 | fwdConsCand(f0, _, config)) and
    conscand = count(TypedContent f0, Ap ap | fwdConsCand(f0, ap, config)) and
    states = count(FlowState state | fwdFlow(_, state, _, _, _, config)) and
    tuples =
      count(NodeEx n, FlowState state, Cc cc, ApOption argAp, Ap ap |
        fwdFlow(n, state, cc, argAp, ap, config)
      )
    or
    fwd = false and
    nodes = count(NodeEx node | revFlow(node, _, _, _, _, config)) and
    fields = count(TypedContent f0 | consCand(f0, _, config)) and
    conscand = count(TypedContent f0, Ap ap | consCand(f0, ap, config)) and
    states = count(FlowState state | revFlow(_, state, _, _, _, config)) and
    tuples =
      count(NodeEx n, FlowState state, boolean b, ApOption retAp, Ap ap |
        revFlow(n, state, b, retAp, ap, config)
      )
  }
  /* End: Stage 4 logic. */
}

bindingset[conf, result]
private Configuration unbindConf(Configuration conf) {
  exists(Configuration c | result = pragma[only_bind_into](c) and conf = pragma[only_bind_into](c))
}

pragma[nomagic]
private predicate nodeMayUseSummary0(
  NodeEx n, DataFlowCallable c, FlowState state, AccessPathApprox apa, Configuration config
) {
  exists(AccessPathApprox apa0 |
    Stage4::parameterMayFlowThrough(_, c, _, _) and
    Stage4::revFlow(n, state, true, _, apa0, config) and
    Stage4::fwdFlow(n, state, any(CallContextCall ccc), TAccessPathApproxSome(apa), apa0, config) and
    n.getEnclosingCallable() = c
  )
}

pragma[nomagic]
private predicate nodeMayUseSummary(
  NodeEx n, FlowState state, AccessPathApprox apa, Configuration config
) {
  exists(DataFlowCallable c |
    Stage4::parameterMayFlowThrough(_, c, apa, config) and
    nodeMayUseSummary0(n, c, state, apa, config)
  )
}

private newtype TSummaryCtx =
  TSummaryCtxNone() or
  TSummaryCtxSome(ParamNodeEx p, FlowState state, AccessPath ap) {
    exists(Configuration config |
      Stage4::parameterMayFlowThrough(p, _, ap.getApprox(), config) and
      Stage4::revFlow(p, state, _, _, _, config)
    )
  }

/**
 * A context for generating flow summaries. This represents flow entry through
 * a specific parameter with an access path of a specific shape.
 *
 * Summaries are only created for parameters that may flow through.
 */
abstract private class SummaryCtx extends TSummaryCtx {
  abstract string toString();
}

/** A summary context from which no flow summary can be generated. */
private class SummaryCtxNone extends SummaryCtx, TSummaryCtxNone {
  override string toString() { result = "<none>" }
}

/** A summary context from which a flow summary can be generated. */
private class SummaryCtxSome extends SummaryCtx, TSummaryCtxSome {
  private ParamNodeEx p;
  private FlowState s;
  private AccessPath ap;

  SummaryCtxSome() { this = TSummaryCtxSome(p, s, ap) }

  ParameterPosition getParameterPos() { p.isParameterOf(_, result) }

  ParamNodeEx getParamNode() { result = p }

  override string toString() { result = p + ": " + ap }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    p.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * Gets the number of length 2 access path approximations that correspond to `apa`.
 */
private int count1to2unfold(AccessPathApproxCons1 apa, Configuration config) {
  exists(TypedContent tc, int len |
    tc = apa.getHead() and
    len = apa.len() and
    result =
      strictcount(AccessPathFront apf |
        Stage4::consCand(tc, any(AccessPathApprox ap | ap.getFront() = apf and ap.len() = len - 1),
          config)
      )
  )
}

private int countNodesUsingAccessPath(AccessPathApprox apa, Configuration config) {
  result =
    strictcount(NodeEx n, FlowState state |
      Stage4::revFlow(n, state, _, _, apa, config) or nodeMayUseSummary(n, state, apa, config)
    )
}

/**
 * Holds if a length 2 access path approximation matching `apa` is expected
 * to be expensive.
 */
private predicate expensiveLen1to2unfolding(AccessPathApproxCons1 apa, Configuration config) {
  exists(int aps, int nodes, int apLimit, int tupleLimit |
    aps = count1to2unfold(apa, config) and
    nodes = countNodesUsingAccessPath(apa, config) and
    accessPathCostLimits(apLimit, tupleLimit) and
    apLimit < aps and
    tupleLimit < (aps - 1) * nodes
  )
}

private AccessPathApprox getATail(AccessPathApprox apa, Configuration config) {
  exists(TypedContent head |
    apa.pop(head) = result and
    Stage4::consCand(head, result, config)
  )
}

/**
 * Holds with `unfold = false` if a precise head-tail representation of `apa` is
 * expected to be expensive. Holds with `unfold = true` otherwise.
 */
private predicate evalUnfold(AccessPathApprox apa, boolean unfold, Configuration config) {
  if apa.getHead().forceHighPrecision()
  then unfold = true
  else
    exists(int aps, int nodes, int apLimit, int tupleLimit |
      aps = countPotentialAps(apa, config) and
      nodes = countNodesUsingAccessPath(apa, config) and
      accessPathCostLimits(apLimit, tupleLimit) and
      if apLimit < aps and tupleLimit < (aps - 1) * nodes then unfold = false else unfold = true
    )
}

/**
 * Gets the number of `AccessPath`s that correspond to `apa`.
 */
private int countAps(AccessPathApprox apa, Configuration config) {
  evalUnfold(apa, false, config) and
  result = 1 and
  (not apa instanceof AccessPathApproxCons1 or expensiveLen1to2unfolding(apa, config))
  or
  evalUnfold(apa, false, config) and
  result = count1to2unfold(apa, config) and
  not expensiveLen1to2unfolding(apa, config)
  or
  evalUnfold(apa, true, config) and
  result = countPotentialAps(apa, config)
}

/**
 * Gets the number of `AccessPath`s that would correspond to `apa` assuming
 * that it is expanded to a precise head-tail representation.
 */
language[monotonicAggregates]
private int countPotentialAps(AccessPathApprox apa, Configuration config) {
  apa instanceof AccessPathApproxNil and result = 1
  or
  result = strictsum(AccessPathApprox tail | tail = getATail(apa, config) | countAps(tail, config))
}

private newtype TAccessPath =
  TAccessPathNil(DataFlowType t) or
  TAccessPathCons(TypedContent head, AccessPath tail) {
    exists(AccessPathApproxCons apa |
      not evalUnfold(apa, false, _) and
      head = apa.getHead() and
      tail.getApprox() = getATail(apa, _)
    )
  } or
  TAccessPathCons2(TypedContent head1, TypedContent head2, int len) {
    exists(AccessPathApproxCons apa |
      evalUnfold(apa, false, _) and
      not expensiveLen1to2unfolding(apa, _) and
      apa.len() = len and
      head1 = apa.getHead() and
      head2 = getATail(apa, _).getHead()
    )
  } or
  TAccessPathCons1(TypedContent head, int len) {
    exists(AccessPathApproxCons apa |
      evalUnfold(apa, false, _) and
      expensiveLen1to2unfolding(apa, _) and
      apa.len() = len and
      head = apa.getHead()
    )
  }

private newtype TPathNode =
  TPathNodeMid(
    NodeEx node, FlowState state, CallContext cc, SummaryCtx sc, AccessPath ap, Configuration config
  ) {
    // A PathNode is introduced by a source ...
    Stage4::revFlow(node, state, config) and
    sourceNode(node, state, config) and
    (
      if hasSourceCallCtx(config)
      then cc instanceof CallContextSomeCall
      else cc instanceof CallContextAny
    ) and
    sc instanceof SummaryCtxNone and
    ap = TAccessPathNil(node.getDataFlowType())
    or
    // ... or a step from an existing PathNode to another node.
    exists(PathNodeMid mid |
      pathStep(mid, node, state, cc, sc, ap) and
      pragma[only_bind_into](config) = mid.getConfiguration() and
      Stage4::revFlow(node, state, _, _, ap.getApprox(), pragma[only_bind_into](config))
    )
  } or
  TPathNodeSink(NodeEx node, FlowState state, Configuration config) {
    exists(PathNodeMid sink |
      sink.isAtSink() and
      node = sink.getNodeEx() and
      state = sink.getState() and
      config = sink.getConfiguration()
    )
  }

/**
 * A list of `TypedContent`s followed by a `DataFlowType`. If data flows from a
 * source to a given node with a given `AccessPath`, this indicates the sequence
 * of dereference operations needed to get from the value in the node to the
 * tracked object. The final type indicates the type of the tracked object.
 */
private class AccessPath extends TAccessPath {
  /** Gets the head of this access path, if any. */
  abstract TypedContent getHead();

  /** Gets the tail of this access path, if any. */
  abstract AccessPath getTail();

  /** Gets the front of this access path. */
  abstract AccessPathFront getFront();

  /** Gets the approximation of this access path. */
  abstract AccessPathApprox getApprox();

  /** Gets the length of this access path. */
  abstract int length();

  /** Gets a textual representation of this access path. */
  abstract string toString();

  /** Gets the access path obtained by popping `tc` from this access path, if any. */
  final AccessPath pop(TypedContent tc) {
    result = this.getTail() and
    tc = this.getHead()
  }

  /** Gets the access path obtained by pushing `tc` onto this access path. */
  final AccessPath push(TypedContent tc) { this = result.pop(tc) }
}

private class AccessPathNil extends AccessPath, TAccessPathNil {
  private DataFlowType t;

  AccessPathNil() { this = TAccessPathNil(t) }

  DataFlowType getType() { result = t }

  override TypedContent getHead() { none() }

  override AccessPath getTail() { none() }

  override AccessPathFrontNil getFront() { result = TFrontNil(t) }

  override AccessPathApproxNil getApprox() { result = TNil(t) }

  override int length() { result = 0 }

  override string toString() { result = concat(": " + ppReprType(t)) }
}

private class AccessPathCons extends AccessPath, TAccessPathCons {
  private TypedContent head;
  private AccessPath tail;

  AccessPathCons() { this = TAccessPathCons(head, tail) }

  override TypedContent getHead() { result = head }

  override AccessPath getTail() { result = tail }

  override AccessPathFrontHead getFront() { result = TFrontHead(head) }

  override AccessPathApproxCons getApprox() {
    result = TConsNil(head, tail.(AccessPathNil).getType())
    or
    result = TConsCons(head, tail.getHead(), this.length())
    or
    result = TCons1(head, this.length())
  }

  override int length() { result = 1 + tail.length() }

  private string toStringImpl(boolean needsSuffix) {
    exists(DataFlowType t |
      tail = TAccessPathNil(t) and
      needsSuffix = false and
      result = head.toString() + "]" + concat(" : " + ppReprType(t))
    )
    or
    result = head + ", " + tail.(AccessPathCons).toStringImpl(needsSuffix)
    or
    exists(TypedContent tc2, TypedContent tc3, int len | tail = TAccessPathCons2(tc2, tc3, len) |
      result = head + ", " + tc2 + ", " + tc3 + ", ... (" and len > 2 and needsSuffix = true
      or
      result = head + ", " + tc2 + ", " + tc3 + "]" and len = 2 and needsSuffix = false
    )
    or
    exists(TypedContent tc2, int len | tail = TAccessPathCons1(tc2, len) |
      result = head + ", " + tc2 + ", ... (" and len > 1 and needsSuffix = true
      or
      result = head + ", " + tc2 + "]" and len = 1 and needsSuffix = false
    )
  }

  override string toString() {
    result = "[" + this.toStringImpl(true) + this.length().toString() + ")]"
    or
    result = "[" + this.toStringImpl(false)
  }
}

private class AccessPathCons2 extends AccessPath, TAccessPathCons2 {
  private TypedContent head1;
  private TypedContent head2;
  private int len;

  AccessPathCons2() { this = TAccessPathCons2(head1, head2, len) }

  override TypedContent getHead() { result = head1 }

  override AccessPath getTail() {
    Stage4::consCand(head1, result.getApprox(), _) and
    result.getHead() = head2 and
    result.length() = len - 1
  }

  override AccessPathFrontHead getFront() { result = TFrontHead(head1) }

  override AccessPathApproxCons getApprox() {
    result = TConsCons(head1, head2, len) or
    result = TCons1(head1, len)
  }

  override int length() { result = len }

  override string toString() {
    if len = 2
    then result = "[" + head1.toString() + ", " + head2.toString() + "]"
    else
      result = "[" + head1.toString() + ", " + head2.toString() + ", ... (" + len.toString() + ")]"
  }
}

private class AccessPathCons1 extends AccessPath, TAccessPathCons1 {
  private TypedContent head;
  private int len;

  AccessPathCons1() { this = TAccessPathCons1(head, len) }

  override TypedContent getHead() { result = head }

  override AccessPath getTail() {
    Stage4::consCand(head, result.getApprox(), _) and result.length() = len - 1
  }

  override AccessPathFrontHead getFront() { result = TFrontHead(head) }

  override AccessPathApproxCons getApprox() { result = TCons1(head, len) }

  override int length() { result = len }

  override string toString() {
    if len = 1
    then result = "[" + head.toString() + "]"
    else result = "[" + head.toString() + ", ... (" + len.toString() + ")]"
  }
}

/**
 * A `Node` augmented with a call context (except for sinks), an access path, and a configuration.
 * Only those `PathNode`s that are reachable from a source are generated.
 */
class PathNode extends TPathNode {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  /**
   * Gets a textual representation of this element, including a textual
   * representation of the call context.
   */
  string toStringWithContext() { none() }

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

  /** Gets the underlying `Node`. */
  final Node getNode() { this.(PathNodeImpl).getNodeEx().projectToNode() = result }

  /** Gets the `FlowState` of this node. */
  FlowState getState() { none() }

  /** Gets the associated configuration. */
  Configuration getConfiguration() { none() }

  /** Gets a successor of this node, if any. */
  final PathNode getASuccessor() {
    result = this.(PathNodeImpl).getANonHiddenSuccessor() and
    reach(this) and
    reach(result)
  }

  /** Holds if this node is a source. */
  predicate isSource() { none() }
}

abstract private class PathNodeImpl extends PathNode {
  abstract PathNodeImpl getASuccessorImpl();

  private PathNodeImpl getASuccessorIfHidden() {
    this.isHidden() and
    result = this.getASuccessorImpl()
  }

  final PathNodeImpl getANonHiddenSuccessor() {
    result = this.getASuccessorImpl().getASuccessorIfHidden*() and
    not this.isHidden() and
    not result.isHidden()
  }

  abstract NodeEx getNodeEx();

  predicate isHidden() {
    not this.getConfiguration().includeHiddenNodes() and
    (
      hiddenNode(this.getNodeEx().asNode()) and
      not this.isSource() and
      not this instanceof PathNodeSink
      or
      this.getNodeEx() instanceof TNodeImplicitRead
    )
  }

  private string ppAp() {
    this instanceof PathNodeSink and result = ""
    or
    exists(string s | s = this.(PathNodeMid).getAp().toString() |
      if s = "" then result = "" else result = " " + s
    )
  }

  private string ppCtx() {
    this instanceof PathNodeSink and result = ""
    or
    result = " <" + this.(PathNodeMid).getCallContext().toString() + ">"
  }

  override string toString() { result = this.getNodeEx().toString() + this.ppAp() }

  override string toStringWithContext() {
    result = this.getNodeEx().toString() + this.ppAp() + this.ppCtx()
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getNodeEx().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** Holds if `n` can reach a sink. */
private predicate directReach(PathNodeImpl n) {
  n instanceof PathNodeSink or directReach(n.getANonHiddenSuccessor())
}

/** Holds if `n` can reach a sink or is used in a subpath that can reach a sink. */
private predicate reach(PathNode n) { directReach(n) or Subpaths::retReach(n) }

/** Holds if `n1.getASuccessor() = n2` and `n2` can reach a sink. */
private predicate pathSucc(PathNodeImpl n1, PathNode n2) {
  n1.getANonHiddenSuccessor() = n2 and directReach(n2)
}

private predicate pathSuccPlus(PathNode n1, PathNode n2) = fastTC(pathSucc/2)(n1, n2)

/**
 * Provides the query predicates needed to include a graph in a path-problem query.
 */
module PathGraph {
  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode a, PathNode b) { a.getASuccessor() = b }

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  query predicate nodes(PathNode n, string key, string val) {
    reach(n) and key = "semmle.label" and val = n.toString()
  }

  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
   * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
   * `ret -> out` is summarized as the edge `arg -> out`.
   */
  query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
    Subpaths::subpaths(arg, par, ret, out) and
    reach(arg) and
    reach(par) and
    reach(ret) and
    reach(out)
  }
}

/**
 * An intermediate flow graph node. This is a triple consisting of a `Node`,
 * a `CallContext`, and a `Configuration`.
 */
private class PathNodeMid extends PathNodeImpl, TPathNodeMid {
  NodeEx node;
  FlowState state;
  CallContext cc;
  SummaryCtx sc;
  AccessPath ap;
  Configuration config;

  PathNodeMid() { this = TPathNodeMid(node, state, cc, sc, ap, config) }

  override NodeEx getNodeEx() { result = node }

  override FlowState getState() { result = state }

  CallContext getCallContext() { result = cc }

  SummaryCtx getSummaryCtx() { result = sc }

  AccessPath getAp() { result = ap }

  override Configuration getConfiguration() { result = config }

  private PathNodeMid getSuccMid() {
    pathStep(this, result.getNodeEx(), result.getState(), result.getCallContext(),
      result.getSummaryCtx(), result.getAp()) and
    result.getConfiguration() = unbindConf(this.getConfiguration())
  }

  override PathNodeImpl getASuccessorImpl() {
    // an intermediate step to another intermediate node
    result = this.getSuccMid()
    or
    // a final step to a sink
    result = this.getSuccMid().projectToSink()
  }

  override predicate isSource() {
    sourceNode(node, state, config) and
    (
      if hasSourceCallCtx(config)
      then cc instanceof CallContextSomeCall
      else cc instanceof CallContextAny
    ) and
    sc instanceof SummaryCtxNone and
    ap instanceof AccessPathNil
  }

  predicate isAtSink() {
    sinkNode(node, state, config) and
    ap instanceof AccessPathNil and
    if hasSinkCallCtx(config)
    then
      // For `FeatureHasSinkCallContext` the condition `cc instanceof CallContextNoCall`
      // is exactly what we need to check. This also implies
      // `sc instanceof SummaryCtxNone`.
      // For `FeatureEqualSourceSinkCallContext` the initial call context was
      // set to `CallContextSomeCall` and jumps are disallowed, so
      // `cc instanceof CallContextNoCall` never holds. On the other hand,
      // in this case there's never any need to enter a call except to identify
      // a summary, so the condition in `pathIntoCallable` enforces this, which
      // means that `sc instanceof SummaryCtxNone` holds if and only if we are
      // in the call context of the source.
      sc instanceof SummaryCtxNone or
      cc instanceof CallContextNoCall
    else any()
  }

  PathNodeSink projectToSink() {
    this.isAtSink() and
    result.getNodeEx() = node and
    result.getState() = state and
    result.getConfiguration() = unbindConf(config)
  }
}

/**
 * A flow graph node corresponding to a sink. This is disjoint from the
 * intermediate nodes in order to uniquely correspond to a given sink by
 * excluding the `CallContext`.
 */
private class PathNodeSink extends PathNodeImpl, TPathNodeSink {
  NodeEx node;
  FlowState state;
  Configuration config;

  PathNodeSink() { this = TPathNodeSink(node, state, config) }

  override NodeEx getNodeEx() { result = node }

  override FlowState getState() { result = state }

  override Configuration getConfiguration() { result = config }

  override PathNodeImpl getASuccessorImpl() { none() }

  override predicate isSource() { sourceNode(node, state, config) }
}

private predicate pathNode(
  PathNodeMid mid, NodeEx midnode, FlowState state, CallContext cc, SummaryCtx sc, AccessPath ap,
  Configuration conf, LocalCallContext localCC
) {
  midnode = mid.getNodeEx() and
  state = mid.getState() and
  conf = mid.getConfiguration() and
  cc = mid.getCallContext() and
  sc = mid.getSummaryCtx() and
  localCC =
    getLocalCallContext(pragma[only_bind_into](pragma[only_bind_out](cc)),
      midnode.getEnclosingCallable()) and
  ap = mid.getAp()
}

/**
 * Holds if data may flow from `mid` to `node`. The last step in or out of
 * a callable is recorded by `cc`.
 */
pragma[nomagic]
private predicate pathStep(
  PathNodeMid mid, NodeEx node, FlowState state, CallContext cc, SummaryCtx sc, AccessPath ap
) {
  exists(NodeEx midnode, FlowState state0, Configuration conf, LocalCallContext localCC |
    pathNode(mid, midnode, state0, cc, sc, ap, conf, localCC) and
    localFlowBigStep(midnode, state0, node, state, true, _, conf, localCC)
  )
  or
  exists(
    AccessPath ap0, NodeEx midnode, FlowState state0, Configuration conf, LocalCallContext localCC
  |
    pathNode(mid, midnode, state0, cc, sc, ap0, conf, localCC) and
    localFlowBigStep(midnode, state0, node, state, false, ap.getFront(), conf, localCC) and
    ap0 instanceof AccessPathNil
  )
  or
  jumpStep(mid.getNodeEx(), node, mid.getConfiguration()) and
  state = mid.getState() and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  ap = mid.getAp()
  or
  additionalJumpStep(mid.getNodeEx(), node, mid.getConfiguration()) and
  state = mid.getState() and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  mid.getAp() instanceof AccessPathNil and
  ap = TAccessPathNil(node.getDataFlowType())
  or
  additionalJumpStateStep(mid.getNodeEx(), mid.getState(), node, state, mid.getConfiguration()) and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  mid.getAp() instanceof AccessPathNil and
  ap = TAccessPathNil(node.getDataFlowType())
  or
  exists(TypedContent tc | pathStoreStep(mid, node, state, ap.pop(tc), tc, cc)) and
  sc = mid.getSummaryCtx()
  or
  exists(TypedContent tc | pathReadStep(mid, node, state, ap.push(tc), tc, cc)) and
  sc = mid.getSummaryCtx()
  or
  pathIntoCallable(mid, node, state, _, cc, sc, _, _) and ap = mid.getAp()
  or
  pathOutOfCallable(mid, node, state, cc) and ap = mid.getAp() and sc instanceof SummaryCtxNone
  or
  pathThroughCallable(mid, node, state, cc, ap) and sc = mid.getSummaryCtx()
}

pragma[nomagic]
private predicate pathReadStep(
  PathNodeMid mid, NodeEx node, FlowState state, AccessPath ap0, TypedContent tc, CallContext cc
) {
  ap0 = mid.getAp() and
  tc = ap0.getHead() and
  Stage4::readStepCand(mid.getNodeEx(), tc.getContent(), node, mid.getConfiguration()) and
  state = mid.getState() and
  cc = mid.getCallContext()
}

pragma[nomagic]
private predicate pathStoreStep(
  PathNodeMid mid, NodeEx node, FlowState state, AccessPath ap0, TypedContent tc, CallContext cc
) {
  ap0 = mid.getAp() and
  Stage4::storeStepCand(mid.getNodeEx(), _, tc, node, _, mid.getConfiguration()) and
  state = mid.getState() and
  cc = mid.getCallContext()
}

private predicate pathOutOfCallable0(
  PathNodeMid mid, ReturnPosition pos, FlowState state, CallContext innercc, AccessPathApprox apa,
  Configuration config
) {
  pos = mid.getNodeEx().(RetNodeEx).getReturnPosition() and
  state = mid.getState() and
  innercc = mid.getCallContext() and
  innercc instanceof CallContextNoCall and
  apa = mid.getAp().getApprox() and
  config = mid.getConfiguration()
}

pragma[nomagic]
private predicate pathOutOfCallable1(
  PathNodeMid mid, DataFlowCall call, ReturnKindExt kind, FlowState state, CallContext cc,
  AccessPathApprox apa, Configuration config
) {
  exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
    pathOutOfCallable0(mid, pos, state, innercc, apa, config) and
    c = pos.getCallable() and
    kind = pos.getKind() and
    resolveReturn(innercc, c, call)
  |
    if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
  )
}

pragma[noinline]
private NodeEx getAnOutNodeFlow(
  ReturnKindExt kind, DataFlowCall call, AccessPathApprox apa, Configuration config
) {
  result.asNode() = kind.getAnOutNode(call) and
  Stage4::revFlow(result, _, _, _, apa, config)
}

/**
 * Holds if data may flow from `mid` to `out`. The last step of this path
 * is a return from a callable and is recorded by `cc`, if needed.
 */
pragma[noinline]
private predicate pathOutOfCallable(PathNodeMid mid, NodeEx out, FlowState state, CallContext cc) {
  exists(ReturnKindExt kind, DataFlowCall call, AccessPathApprox apa, Configuration config |
    pathOutOfCallable1(mid, call, kind, state, cc, apa, config) and
    out = getAnOutNodeFlow(kind, call, apa, config)
  )
}

/**
 * Holds if data may flow from `mid` to the `i`th argument of `call` in `cc`.
 */
pragma[noinline]
private predicate pathIntoArg(
  PathNodeMid mid, ParameterPosition ppos, FlowState state, CallContext cc, DataFlowCall call,
  AccessPath ap, AccessPathApprox apa, Configuration config
) {
  exists(ArgNodeEx arg, ArgumentPosition apos |
    pathNode(mid, arg, state, cc, _, ap, config, _) and
    arg.asNode().(ArgNode).argumentOf(call, apos) and
    apa = ap.getApprox() and
    parameterMatch(ppos, apos)
  )
}

pragma[nomagic]
private predicate parameterCand(
  DataFlowCallable callable, ParameterPosition pos, AccessPathApprox apa, Configuration config
) {
  exists(ParamNodeEx p |
    Stage4::revFlow(p, _, _, _, apa, config) and
    p.isParameterOf(callable, pos)
  )
}

pragma[nomagic]
private predicate pathIntoCallable0(
  PathNodeMid mid, DataFlowCallable callable, ParameterPosition pos, FlowState state,
  CallContext outercc, DataFlowCall call, AccessPath ap, Configuration config
) {
  exists(AccessPathApprox apa |
    pathIntoArg(mid, pragma[only_bind_into](pos), state, outercc, call, ap,
      pragma[only_bind_into](apa), pragma[only_bind_into](config)) and
    callable = resolveCall(call, outercc) and
    parameterCand(callable, pragma[only_bind_into](pos), pragma[only_bind_into](apa),
      pragma[only_bind_into](config))
  )
}

/**
 * Holds if data may flow from `mid` to `p` through `call`. The contexts
 * before and after entering the callable are `outercc` and `innercc`,
 * respectively.
 */
pragma[nomagic]
private predicate pathIntoCallable(
  PathNodeMid mid, ParamNodeEx p, FlowState state, CallContext outercc, CallContextCall innercc,
  SummaryCtx sc, DataFlowCall call, Configuration config
) {
  exists(ParameterPosition pos, DataFlowCallable callable, AccessPath ap |
    pathIntoCallable0(mid, callable, pos, state, outercc, call, ap, config) and
    p.isParameterOf(callable, pos) and
    (
      sc = TSummaryCtxSome(p, state, ap)
      or
      not exists(TSummaryCtxSome(p, state, ap)) and
      sc = TSummaryCtxNone() and
      // When the call contexts of source and sink needs to match then there's
      // never any reason to enter a callable except to find a summary. See also
      // the comment in `PathNodeMid::isAtSink`.
      not config.getAFeature() instanceof FeatureEqualSourceSinkCallContext
    )
  |
    if recordDataFlowCallSite(call, callable)
    then innercc = TSpecificCall(call)
    else innercc = TSomeCall()
  )
}

/** Holds if data may flow from a parameter given by `sc` to a return of kind `kind`. */
pragma[nomagic]
private predicate paramFlowsThrough(
  ReturnKindExt kind, FlowState state, CallContextCall cc, SummaryCtxSome sc, AccessPath ap,
  AccessPathApprox apa, Configuration config
) {
  exists(PathNodeMid mid, RetNodeEx ret, ParameterPosition pos |
    pathNode(mid, ret, state, cc, sc, ap, config, _) and
    kind = ret.getKind() and
    apa = ap.getApprox() and
    pos = sc.getParameterPos() and
    // we don't expect a parameter to return stored in itself, unless explicitly allowed
    (
      not kind.(ParamUpdateReturnKind).getPosition() = pos
      or
      sc.getParamNode().allowParameterReturnInSelf()
    )
  )
}

pragma[nomagic]
private predicate pathThroughCallable0(
  DataFlowCall call, PathNodeMid mid, ReturnKindExt kind, FlowState state, CallContext cc,
  AccessPath ap, AccessPathApprox apa, Configuration config
) {
  exists(CallContext innercc, SummaryCtx sc |
    pathIntoCallable(mid, _, _, cc, innercc, sc, call, config) and
    paramFlowsThrough(kind, state, innercc, sc, ap, apa, config)
  )
}

/**
 * Holds if data may flow from `mid` through a callable to the node `out`.
 * The context `cc` is restored to its value prior to entering the callable.
 */
pragma[noinline]
private predicate pathThroughCallable(
  PathNodeMid mid, NodeEx out, FlowState state, CallContext cc, AccessPath ap
) {
  exists(DataFlowCall call, ReturnKindExt kind, AccessPathApprox apa, Configuration config |
    pathThroughCallable0(call, mid, kind, state, cc, ap, apa, config) and
    out = getAnOutNodeFlow(kind, call, apa, config)
  )
}

private module Subpaths {
  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple and `ret` is determined by
   * `kind`, `sc`, `apout`, and `innercc`.
   */
  pragma[nomagic]
  private predicate subpaths01(
    PathNodeImpl arg, ParamNodeEx par, SummaryCtxSome sc, CallContext innercc, ReturnKindExt kind,
    NodeEx out, FlowState sout, AccessPath apout
  ) {
    exists(Configuration config |
      pathThroughCallable(arg, out, pragma[only_bind_into](sout), _, pragma[only_bind_into](apout)) and
      pathIntoCallable(arg, par, _, _, innercc, sc, _, config) and
      paramFlowsThrough(kind, pragma[only_bind_into](sout), innercc, sc,
        pragma[only_bind_into](apout), _, unbindConf(config)) and
      not arg.isHidden()
    )
  }

  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple and `ret` is determined by
   * `kind`, `sc`, `sout`, `apout`, and `innercc`.
   */
  pragma[nomagic]
  private predicate subpaths02(
    PathNode arg, ParamNodeEx par, SummaryCtxSome sc, CallContext innercc, ReturnKindExt kind,
    NodeEx out, FlowState sout, AccessPath apout
  ) {
    subpaths01(arg, par, sc, innercc, kind, out, sout, apout) and
    out.asNode() = kind.getAnOutNode(_)
  }

  pragma[nomagic]
  private Configuration getPathNodeConf(PathNode n) { result = n.getConfiguration() }

  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
   */
  pragma[nomagic]
  private predicate subpaths03(
    PathNode arg, ParamNodeEx par, PathNodeMid ret, NodeEx out, FlowState sout, AccessPath apout
  ) {
    exists(SummaryCtxSome sc, CallContext innercc, ReturnKindExt kind, RetNodeEx retnode |
      subpaths02(arg, par, sc, innercc, kind, out, sout, apout) and
      pathNode(ret, retnode, sout, innercc, sc, apout, unbindConf(getPathNodeConf(arg)), _) and
      kind = retnode.getKind()
    )
  }

  private PathNodeImpl localStepToHidden(PathNodeImpl n) {
    n.getASuccessorImpl() = result and
    result.isHidden() and
    exists(NodeEx n1, NodeEx n2 | n1 = n.getNodeEx() and n2 = result.getNodeEx() |
      localFlowBigStep(n1, _, n2, _, _, _, _, _) or
      store(n1, _, n2, _, _) or
      readSet(n1, _, n2, _)
    )
  }

  pragma[nomagic]
  private predicate hasSuccessor(PathNodeImpl pred, PathNodeMid succ, NodeEx succNode) {
    succ = pred.getANonHiddenSuccessor() and
    succNode = succ.getNodeEx()
  }

  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
   * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
   * `ret -> out` is summarized as the edge `arg -> out`.
   */
  predicate subpaths(PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNode out) {
    exists(ParamNodeEx p, NodeEx o, FlowState sout, AccessPath apout, PathNodeMid out0 |
      pragma[only_bind_into](arg).getANonHiddenSuccessor() = pragma[only_bind_into](out0) and
      subpaths03(pragma[only_bind_into](arg), p, localStepToHidden*(ret), o, sout, apout) and
      hasSuccessor(pragma[only_bind_into](arg), par, p) and
      not ret.isHidden() and
      pathNode(out0, o, sout, _, _, apout, _, _)
    |
      out = out0 or out = out0.projectToSink()
    )
  }

  /**
   * Holds if `n` can reach a return node in a summarized subpath that can reach a sink.
   */
  predicate retReach(PathNodeImpl n) {
    exists(PathNode out | subpaths(_, _, n, out) | directReach(out) or retReach(out))
    or
    exists(PathNodeImpl mid |
      retReach(mid) and
      n.getANonHiddenSuccessor() = mid and
      not subpaths(_, mid, _, _)
    )
  }
}

/**
 * Holds if data can flow (inter-procedurally) from `source` to `sink`.
 *
 * Will only have results if `configuration` has non-empty sources and
 * sinks.
 */
private predicate flowsTo(
  PathNode flowsource, PathNodeSink flowsink, Node source, Node sink, Configuration configuration
) {
  flowsource.isSource() and
  flowsource.getConfiguration() = configuration and
  flowsource.(PathNodeImpl).getNodeEx().asNode() = source and
  (flowsource = flowsink or pathSuccPlus(flowsource, flowsink)) and
  flowsink.getNodeEx().asNode() = sink
}

/**
 * Holds if data can flow (inter-procedurally) from `source` to `sink`.
 *
 * Will only have results if `configuration` has non-empty sources and
 * sinks.
 */
predicate flowsTo(Node source, Node sink, Configuration configuration) {
  flowsTo(_, _, source, sink, configuration)
}

private predicate finalStats(
  boolean fwd, int nodes, int fields, int conscand, int states, int tuples
) {
  fwd = true and
  nodes = count(NodeEx n0 | exists(PathNodeImpl pn | pn.getNodeEx() = n0)) and
  fields = count(TypedContent f0 | exists(PathNodeMid pn | pn.getAp().getHead() = f0)) and
  conscand = count(AccessPath ap | exists(PathNodeMid pn | pn.getAp() = ap)) and
  states = count(FlowState state | exists(PathNodeMid pn | pn.getState() = state)) and
  tuples = count(PathNode pn)
  or
  fwd = false and
  nodes = count(NodeEx n0 | exists(PathNodeImpl pn | pn.getNodeEx() = n0 and reach(pn))) and
  fields = count(TypedContent f0 | exists(PathNodeMid pn | pn.getAp().getHead() = f0 and reach(pn))) and
  conscand = count(AccessPath ap | exists(PathNodeMid pn | pn.getAp() = ap and reach(pn))) and
  states = count(FlowState state | exists(PathNodeMid pn | pn.getState() = state and reach(pn))) and
  tuples = count(PathNode pn | reach(pn))
}

/**
 * INTERNAL: Only for debugging.
 *
 * Calculates per-stage metrics for data flow.
 */
predicate stageStats(
  int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
  Configuration config
) {
  stage = "1 Fwd" and
  n = 10 and
  Stage1::stats(true, nodes, fields, conscand, states, tuples, config)
  or
  stage = "1 Rev" and
  n = 15 and
  Stage1::stats(false, nodes, fields, conscand, states, tuples, config)
  or
  stage = "2 Fwd" and
  n = 20 and
  Stage2::stats(true, nodes, fields, conscand, states, tuples, config)
  or
  stage = "2 Rev" and
  n = 25 and
  Stage2::stats(false, nodes, fields, conscand, states, tuples, config)
  or
  stage = "3 Fwd" and
  n = 30 and
  Stage3::stats(true, nodes, fields, conscand, states, tuples, config)
  or
  stage = "3 Rev" and
  n = 35 and
  Stage3::stats(false, nodes, fields, conscand, states, tuples, config)
  or
  stage = "4 Fwd" and
  n = 40 and
  Stage4::stats(true, nodes, fields, conscand, states, tuples, config)
  or
  stage = "4 Rev" and
  n = 45 and
  Stage4::stats(false, nodes, fields, conscand, states, tuples, config)
  or
  stage = "5 Fwd" and n = 50 and finalStats(true, nodes, fields, conscand, states, tuples)
  or
  stage = "5 Rev" and n = 55 and finalStats(false, nodes, fields, conscand, states, tuples)
}

private module FlowExploration {
  private predicate callableStep(DataFlowCallable c1, DataFlowCallable c2, Configuration config) {
    exists(NodeEx node1, NodeEx node2 |
      jumpStep(node1, node2, config)
      or
      additionalJumpStep(node1, node2, config)
      or
      additionalJumpStateStep(node1, _, node2, _, config)
      or
      // flow into callable
      viableParamArgEx(_, node2, node1)
      or
      // flow out of a callable
      viableReturnPosOutEx(_, node1.(RetNodeEx).getReturnPosition(), node2)
    |
      c1 = node1.getEnclosingCallable() and
      c2 = node2.getEnclosingCallable() and
      c1 != c2
    )
  }

  private predicate interestingCallableSrc(DataFlowCallable c, Configuration config) {
    exists(Node n | config.isSource(n) or config.isSource(n, _) | c = getNodeEnclosingCallable(n))
    or
    exists(DataFlowCallable mid |
      interestingCallableSrc(mid, config) and callableStep(mid, c, config)
    )
  }

  private predicate interestingCallableSink(DataFlowCallable c, Configuration config) {
    exists(Node n | config.isSink(n) or config.isSink(n, _) | c = getNodeEnclosingCallable(n))
    or
    exists(DataFlowCallable mid |
      interestingCallableSink(mid, config) and callableStep(c, mid, config)
    )
  }

  private newtype TCallableExt =
    TCallable(DataFlowCallable c, Configuration config) {
      interestingCallableSrc(c, config) or
      interestingCallableSink(c, config)
    } or
    TCallableSrc() or
    TCallableSink()

  private predicate callableExtSrc(TCallableSrc src) { any() }

  private predicate callableExtSink(TCallableSink sink) { any() }

  private predicate callableExtStepFwd(TCallableExt ce1, TCallableExt ce2) {
    exists(DataFlowCallable c1, DataFlowCallable c2, Configuration config |
      callableStep(c1, c2, config) and
      ce1 = TCallable(c1, pragma[only_bind_into](config)) and
      ce2 = TCallable(c2, pragma[only_bind_into](config))
    )
    or
    exists(Node n, Configuration config |
      ce1 = TCallableSrc() and
      (config.isSource(n) or config.isSource(n, _)) and
      ce2 = TCallable(getNodeEnclosingCallable(n), config)
    )
    or
    exists(Node n, Configuration config |
      ce2 = TCallableSink() and
      (config.isSink(n) or config.isSink(n, _)) and
      ce1 = TCallable(getNodeEnclosingCallable(n), config)
    )
  }

  private predicate callableExtStepRev(TCallableExt ce1, TCallableExt ce2) {
    callableExtStepFwd(ce2, ce1)
  }

  private int distSrcExt(TCallableExt c) =
    shortestDistances(callableExtSrc/1, callableExtStepFwd/2)(_, c, result)

  private int distSinkExt(TCallableExt c) =
    shortestDistances(callableExtSink/1, callableExtStepRev/2)(_, c, result)

  private int distSrc(DataFlowCallable c, Configuration config) {
    result = distSrcExt(TCallable(c, config)) - 1
  }

  private int distSink(DataFlowCallable c, Configuration config) {
    result = distSinkExt(TCallable(c, config)) - 1
  }

  private newtype TPartialAccessPath =
    TPartialNil(DataFlowType t) or
    TPartialCons(TypedContent tc, int len) { len in [1 .. accessPathLimit()] }

  /**
   * Conceptually a list of `TypedContent`s followed by a `Type`, but only the first
   * element of the list and its length are tracked. If data flows from a source to
   * a given node with a given `AccessPath`, this indicates the sequence of
   * dereference operations needed to get from the value in the node to the
   * tracked object. The final type indicates the type of the tracked object.
   */
  private class PartialAccessPath extends TPartialAccessPath {
    abstract string toString();

    TypedContent getHead() { this = TPartialCons(result, _) }

    int len() {
      this = TPartialNil(_) and result = 0
      or
      this = TPartialCons(_, result)
    }

    DataFlowType getType() {
      this = TPartialNil(result)
      or
      exists(TypedContent head | this = TPartialCons(head, _) | result = head.getContainerType())
    }
  }

  private class PartialAccessPathNil extends PartialAccessPath, TPartialNil {
    override string toString() {
      exists(DataFlowType t | this = TPartialNil(t) | result = concat(": " + ppReprType(t)))
    }
  }

  private class PartialAccessPathCons extends PartialAccessPath, TPartialCons {
    override string toString() {
      exists(TypedContent tc, int len | this = TPartialCons(tc, len) |
        if len = 1
        then result = "[" + tc.toString() + "]"
        else result = "[" + tc.toString() + ", ... (" + len.toString() + ")]"
      )
    }
  }

  private newtype TRevPartialAccessPath =
    TRevPartialNil() or
    TRevPartialCons(Content c, int len) { len in [1 .. accessPathLimit()] }

  /**
   * Conceptually a list of `Content`s, but only the first
   * element of the list and its length are tracked.
   */
  private class RevPartialAccessPath extends TRevPartialAccessPath {
    abstract string toString();

    Content getHead() { this = TRevPartialCons(result, _) }

    int len() {
      this = TRevPartialNil() and result = 0
      or
      this = TRevPartialCons(_, result)
    }
  }

  private class RevPartialAccessPathNil extends RevPartialAccessPath, TRevPartialNil {
    override string toString() { result = "" }
  }

  private class RevPartialAccessPathCons extends RevPartialAccessPath, TRevPartialCons {
    override string toString() {
      exists(Content c, int len | this = TRevPartialCons(c, len) |
        if len = 1
        then result = "[" + c.toString() + "]"
        else result = "[" + c.toString() + ", ... (" + len.toString() + ")]"
      )
    }
  }

  private predicate relevantState(FlowState state) {
    sourceNode(_, state, _) or
    sinkNode(_, state, _) or
    additionalLocalStateStep(_, state, _, _, _) or
    additionalLocalStateStep(_, _, _, state, _) or
    additionalJumpStateStep(_, state, _, _, _) or
    additionalJumpStateStep(_, _, _, state, _)
  }

  private newtype TSummaryCtx1 =
    TSummaryCtx1None() or
    TSummaryCtx1Param(ParamNodeEx p)

  private newtype TSummaryCtx2 =
    TSummaryCtx2None() or
    TSummaryCtx2Some(FlowState s) { relevantState(s) }

  private newtype TSummaryCtx3 =
    TSummaryCtx3None() or
    TSummaryCtx3Some(PartialAccessPath ap)

  private newtype TRevSummaryCtx1 =
    TRevSummaryCtx1None() or
    TRevSummaryCtx1Some(ReturnPosition pos)

  private newtype TRevSummaryCtx2 =
    TRevSummaryCtx2None() or
    TRevSummaryCtx2Some(FlowState s) { relevantState(s) }

  private newtype TRevSummaryCtx3 =
    TRevSummaryCtx3None() or
    TRevSummaryCtx3Some(RevPartialAccessPath ap)

  private newtype TPartialPathNode =
    TPartialPathNodeFwd(
      NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
      TSummaryCtx3 sc3, PartialAccessPath ap, Configuration config
    ) {
      sourceNode(node, state, config) and
      cc instanceof CallContextAny and
      sc1 = TSummaryCtx1None() and
      sc2 = TSummaryCtx2None() and
      sc3 = TSummaryCtx3None() and
      ap = TPartialNil(node.getDataFlowType()) and
      exists(config.explorationLimit())
      or
      partialPathNodeMk0(node, state, cc, sc1, sc2, sc3, ap, config) and
      distSrc(node.getEnclosingCallable(), config) <= config.explorationLimit()
    } or
    TPartialPathNodeRev(
      NodeEx node, FlowState state, TRevSummaryCtx1 sc1, TRevSummaryCtx2 sc2, TRevSummaryCtx3 sc3,
      RevPartialAccessPath ap, Configuration config
    ) {
      sinkNode(node, state, config) and
      sc1 = TRevSummaryCtx1None() and
      sc2 = TRevSummaryCtx2None() and
      sc3 = TRevSummaryCtx3None() and
      ap = TRevPartialNil() and
      exists(config.explorationLimit())
      or
      exists(PartialPathNodeRev mid |
        revPartialPathStep(mid, node, state, sc1, sc2, sc3, ap, config) and
        not clearsContentEx(node, ap.getHead()) and
        (
          notExpectsContent(node) or
          expectsContentEx(node, ap.getHead())
        ) and
        not fullBarrier(node, config) and
        not stateBarrier(node, state, config) and
        distSink(node.getEnclosingCallable(), config) <= config.explorationLimit()
      )
    }

  pragma[nomagic]
  private predicate partialPathNodeMk0(
    NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
    TSummaryCtx3 sc3, PartialAccessPath ap, Configuration config
  ) {
    exists(PartialPathNodeFwd mid |
      partialPathStep(mid, node, state, cc, sc1, sc2, sc3, ap, config) and
      not fullBarrier(node, config) and
      not stateBarrier(node, state, config) and
      not clearsContentEx(node, ap.getHead().getContent()) and
      (
        notExpectsContent(node) or
        expectsContentEx(node, ap.getHead().getContent())
      ) and
      if node.asNode() instanceof CastingNode
      then compatibleTypes(node.getDataFlowType(), ap.getType())
      else any()
    )
  }

  /**
   * A `Node` augmented with a call context, an access path, and a configuration.
   */
  class PartialPathNode extends TPartialPathNode {
    /** Gets a textual representation of this element. */
    string toString() { result = this.getNodeEx().toString() + this.ppAp() }

    /**
     * Gets a textual representation of this element, including a textual
     * representation of the call context.
     */
    string toStringWithContext() {
      result = this.getNodeEx().toString() + this.ppAp() + this.ppCtx()
    }

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
      this.getNodeEx().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /** Gets the underlying `Node`. */
    final Node getNode() { this.getNodeEx().projectToNode() = result }

    FlowState getState() { none() }

    private NodeEx getNodeEx() {
      result = this.(PartialPathNodeFwd).getNodeEx() or
      result = this.(PartialPathNodeRev).getNodeEx()
    }

    /** Gets the associated configuration. */
    Configuration getConfiguration() { none() }

    /** Gets a successor of this node, if any. */
    PartialPathNode getASuccessor() { none() }

    /**
     * Gets the approximate distance to the nearest source measured in number
     * of interprocedural steps.
     */
    int getSourceDistance() {
      result = distSrc(this.getNodeEx().getEnclosingCallable(), this.getConfiguration())
    }

    /**
     * Gets the approximate distance to the nearest sink measured in number
     * of interprocedural steps.
     */
    int getSinkDistance() {
      result = distSink(this.getNodeEx().getEnclosingCallable(), this.getConfiguration())
    }

    private string ppAp() {
      exists(string s |
        s = this.(PartialPathNodeFwd).getAp().toString() or
        s = this.(PartialPathNodeRev).getAp().toString()
      |
        if s = "" then result = "" else result = " " + s
      )
    }

    private string ppCtx() {
      result = " <" + this.(PartialPathNodeFwd).getCallContext().toString() + ">"
    }

    /** Holds if this is a source in a forward-flow path. */
    predicate isFwdSource() { this.(PartialPathNodeFwd).isSource() }

    /** Holds if this is a sink in a reverse-flow path. */
    predicate isRevSink() { this.(PartialPathNodeRev).isSink() }
  }

  /**
   * Provides the query predicates needed to include a graph in a path-problem query.
   */
  module PartialPathGraph {
    /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
    query predicate edges(PartialPathNode a, PartialPathNode b) { a.getASuccessor() = b }
  }

  private class PartialPathNodeFwd extends PartialPathNode, TPartialPathNodeFwd {
    NodeEx node;
    FlowState state;
    CallContext cc;
    TSummaryCtx1 sc1;
    TSummaryCtx2 sc2;
    TSummaryCtx3 sc3;
    PartialAccessPath ap;
    Configuration config;

    PartialPathNodeFwd() { this = TPartialPathNodeFwd(node, state, cc, sc1, sc2, sc3, ap, config) }

    NodeEx getNodeEx() { result = node }

    override FlowState getState() { result = state }

    CallContext getCallContext() { result = cc }

    TSummaryCtx1 getSummaryCtx1() { result = sc1 }

    TSummaryCtx2 getSummaryCtx2() { result = sc2 }

    TSummaryCtx3 getSummaryCtx3() { result = sc3 }

    PartialAccessPath getAp() { result = ap }

    override Configuration getConfiguration() { result = config }

    override PartialPathNodeFwd getASuccessor() {
      partialPathStep(this, result.getNodeEx(), result.getState(), result.getCallContext(),
        result.getSummaryCtx1(), result.getSummaryCtx2(), result.getSummaryCtx3(), result.getAp(),
        result.getConfiguration())
    }

    predicate isSource() {
      sourceNode(node, state, config) and
      cc instanceof CallContextAny and
      sc1 = TSummaryCtx1None() and
      sc2 = TSummaryCtx2None() and
      sc3 = TSummaryCtx3None() and
      ap instanceof TPartialNil
    }
  }

  private class PartialPathNodeRev extends PartialPathNode, TPartialPathNodeRev {
    NodeEx node;
    FlowState state;
    TRevSummaryCtx1 sc1;
    TRevSummaryCtx2 sc2;
    TRevSummaryCtx3 sc3;
    RevPartialAccessPath ap;
    Configuration config;

    PartialPathNodeRev() { this = TPartialPathNodeRev(node, state, sc1, sc2, sc3, ap, config) }

    NodeEx getNodeEx() { result = node }

    override FlowState getState() { result = state }

    TRevSummaryCtx1 getSummaryCtx1() { result = sc1 }

    TRevSummaryCtx2 getSummaryCtx2() { result = sc2 }

    TRevSummaryCtx3 getSummaryCtx3() { result = sc3 }

    RevPartialAccessPath getAp() { result = ap }

    override Configuration getConfiguration() { result = config }

    override PartialPathNodeRev getASuccessor() {
      revPartialPathStep(result, this.getNodeEx(), this.getState(), this.getSummaryCtx1(),
        this.getSummaryCtx2(), this.getSummaryCtx3(), this.getAp(), this.getConfiguration())
    }

    predicate isSink() {
      sinkNode(node, state, config) and
      sc1 = TRevSummaryCtx1None() and
      sc2 = TRevSummaryCtx2None() and
      sc3 = TRevSummaryCtx3None() and
      ap = TRevPartialNil()
    }
  }

  private predicate partialPathStep(
    PartialPathNodeFwd mid, NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1,
    TSummaryCtx2 sc2, TSummaryCtx3 sc3, PartialAccessPath ap, Configuration config
  ) {
    not isUnreachableInCallCached(node.asNode(), cc.(CallContextSpecificCall).getCall()) and
    (
      localFlowStep(mid.getNodeEx(), node, config) and
      state = mid.getState() and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      ap = mid.getAp() and
      config = mid.getConfiguration()
      or
      additionalLocalFlowStep(mid.getNodeEx(), node, config) and
      state = mid.getState() and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      mid.getAp() instanceof PartialAccessPathNil and
      ap = TPartialNil(node.getDataFlowType()) and
      config = mid.getConfiguration()
      or
      additionalLocalStateStep(mid.getNodeEx(), mid.getState(), node, state, config) and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      mid.getAp() instanceof PartialAccessPathNil and
      ap = TPartialNil(node.getDataFlowType()) and
      config = mid.getConfiguration()
    )
    or
    jumpStep(mid.getNodeEx(), node, config) and
    state = mid.getState() and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    sc3 = TSummaryCtx3None() and
    ap = mid.getAp() and
    config = mid.getConfiguration()
    or
    additionalJumpStep(mid.getNodeEx(), node, config) and
    state = mid.getState() and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    sc3 = TSummaryCtx3None() and
    mid.getAp() instanceof PartialAccessPathNil and
    ap = TPartialNil(node.getDataFlowType()) and
    config = mid.getConfiguration()
    or
    additionalJumpStateStep(mid.getNodeEx(), mid.getState(), node, state, config) and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    sc3 = TSummaryCtx3None() and
    mid.getAp() instanceof PartialAccessPathNil and
    ap = TPartialNil(node.getDataFlowType()) and
    config = mid.getConfiguration()
    or
    partialPathStoreStep(mid, _, _, node, ap) and
    state = mid.getState() and
    cc = mid.getCallContext() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3() and
    config = mid.getConfiguration()
    or
    exists(PartialAccessPath ap0, TypedContent tc |
      partialPathReadStep(mid, ap0, tc, node, cc, config) and
      state = mid.getState() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      apConsFwd(ap, tc, ap0, config)
    )
    or
    partialPathIntoCallable(mid, node, state, _, cc, sc1, sc2, sc3, _, ap, config)
    or
    partialPathOutOfCallable(mid, node, state, cc, ap, config) and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    sc3 = TSummaryCtx3None()
    or
    partialPathThroughCallable(mid, node, state, cc, ap, config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3()
  }

  bindingset[result, i]
  private int unbindInt(int i) { pragma[only_bind_out](i) = pragma[only_bind_out](result) }

  pragma[inline]
  private predicate partialPathStoreStep(
    PartialPathNodeFwd mid, PartialAccessPath ap1, TypedContent tc, NodeEx node,
    PartialAccessPath ap2
  ) {
    exists(NodeEx midNode, DataFlowType contentType |
      midNode = mid.getNodeEx() and
      ap1 = mid.getAp() and
      store(midNode, tc, node, contentType, mid.getConfiguration()) and
      ap2.getHead() = tc and
      ap2.len() = unbindInt(ap1.len() + 1) and
      compatibleTypes(ap1.getType(), contentType)
    )
  }

  pragma[nomagic]
  private predicate apConsFwd(
    PartialAccessPath ap1, TypedContent tc, PartialAccessPath ap2, Configuration config
  ) {
    exists(PartialPathNodeFwd mid |
      partialPathStoreStep(mid, ap1, tc, _, ap2) and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate partialPathReadStep(
    PartialPathNodeFwd mid, PartialAccessPath ap, TypedContent tc, NodeEx node, CallContext cc,
    Configuration config
  ) {
    exists(NodeEx midNode |
      midNode = mid.getNodeEx() and
      ap = mid.getAp() and
      read(midNode, tc.getContent(), node, pragma[only_bind_into](config)) and
      ap.getHead() = tc and
      pragma[only_bind_into](config) = mid.getConfiguration() and
      cc = mid.getCallContext()
    )
  }

  private predicate partialPathOutOfCallable0(
    PartialPathNodeFwd mid, ReturnPosition pos, FlowState state, CallContext innercc,
    PartialAccessPath ap, Configuration config
  ) {
    pos = mid.getNodeEx().(RetNodeEx).getReturnPosition() and
    state = mid.getState() and
    innercc = mid.getCallContext() and
    innercc instanceof CallContextNoCall and
    ap = mid.getAp() and
    config = mid.getConfiguration()
  }

  pragma[nomagic]
  private predicate partialPathOutOfCallable1(
    PartialPathNodeFwd mid, DataFlowCall call, ReturnKindExt kind, FlowState state, CallContext cc,
    PartialAccessPath ap, Configuration config
  ) {
    exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
      partialPathOutOfCallable0(mid, pos, state, innercc, ap, config) and
      c = pos.getCallable() and
      kind = pos.getKind() and
      resolveReturn(innercc, c, call)
    |
      if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
    )
  }

  private predicate partialPathOutOfCallable(
    PartialPathNodeFwd mid, NodeEx out, FlowState state, CallContext cc, PartialAccessPath ap,
    Configuration config
  ) {
    exists(ReturnKindExt kind, DataFlowCall call |
      partialPathOutOfCallable1(mid, call, kind, state, cc, ap, config)
    |
      out.asNode() = kind.getAnOutNode(call)
    )
  }

  pragma[noinline]
  private predicate partialPathIntoArg(
    PartialPathNodeFwd mid, ParameterPosition ppos, FlowState state, CallContext cc,
    DataFlowCall call, PartialAccessPath ap, Configuration config
  ) {
    exists(ArgNode arg, ArgumentPosition apos |
      arg = mid.getNodeEx().asNode() and
      state = mid.getState() and
      cc = mid.getCallContext() and
      arg.argumentOf(call, apos) and
      ap = mid.getAp() and
      config = mid.getConfiguration() and
      parameterMatch(ppos, apos)
    )
  }

  pragma[nomagic]
  private predicate partialPathIntoCallable0(
    PartialPathNodeFwd mid, DataFlowCallable callable, ParameterPosition pos, FlowState state,
    CallContext outercc, DataFlowCall call, PartialAccessPath ap, Configuration config
  ) {
    partialPathIntoArg(mid, pos, state, outercc, call, ap, config) and
    callable = resolveCall(call, outercc)
  }

  private predicate partialPathIntoCallable(
    PartialPathNodeFwd mid, ParamNodeEx p, FlowState state, CallContext outercc,
    CallContextCall innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, TSummaryCtx3 sc3,
    DataFlowCall call, PartialAccessPath ap, Configuration config
  ) {
    exists(ParameterPosition pos, DataFlowCallable callable |
      partialPathIntoCallable0(mid, callable, pos, state, outercc, call, ap, config) and
      p.isParameterOf(callable, pos) and
      sc1 = TSummaryCtx1Param(p) and
      sc2 = TSummaryCtx2Some(state) and
      sc3 = TSummaryCtx3Some(ap)
    |
      if recordDataFlowCallSite(call, callable)
      then innercc = TSpecificCall(call)
      else innercc = TSomeCall()
    )
  }

  pragma[nomagic]
  private predicate paramFlowsThroughInPartialPath(
    ReturnKindExt kind, FlowState state, CallContextCall cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
    TSummaryCtx3 sc3, PartialAccessPath ap, Configuration config
  ) {
    exists(PartialPathNodeFwd mid, RetNodeEx ret |
      mid.getNodeEx() = ret and
      kind = ret.getKind() and
      state = mid.getState() and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      config = mid.getConfiguration() and
      ap = mid.getAp()
    )
  }

  pragma[noinline]
  private predicate partialPathThroughCallable0(
    DataFlowCall call, PartialPathNodeFwd mid, ReturnKindExt kind, FlowState state, CallContext cc,
    PartialAccessPath ap, Configuration config
  ) {
    exists(CallContext innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, TSummaryCtx3 sc3 |
      partialPathIntoCallable(mid, _, _, cc, innercc, sc1, sc2, sc3, call, _, config) and
      paramFlowsThroughInPartialPath(kind, state, innercc, sc1, sc2, sc3, ap, config)
    )
  }

  private predicate partialPathThroughCallable(
    PartialPathNodeFwd mid, NodeEx out, FlowState state, CallContext cc, PartialAccessPath ap,
    Configuration config
  ) {
    exists(DataFlowCall call, ReturnKindExt kind |
      partialPathThroughCallable0(call, mid, kind, state, cc, ap, config) and
      out.asNode() = kind.getAnOutNode(call)
    )
  }

  pragma[nomagic]
  private predicate revPartialPathStep(
    PartialPathNodeRev mid, NodeEx node, FlowState state, TRevSummaryCtx1 sc1, TRevSummaryCtx2 sc2,
    TRevSummaryCtx3 sc3, RevPartialAccessPath ap, Configuration config
  ) {
    localFlowStep(node, mid.getNodeEx(), config) and
    state = mid.getState() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3() and
    ap = mid.getAp() and
    config = mid.getConfiguration()
    or
    additionalLocalFlowStep(node, mid.getNodeEx(), config) and
    state = mid.getState() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3() and
    mid.getAp() instanceof RevPartialAccessPathNil and
    ap = TRevPartialNil() and
    config = mid.getConfiguration()
    or
    additionalLocalStateStep(node, state, mid.getNodeEx(), mid.getState(), config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3() and
    mid.getAp() instanceof RevPartialAccessPathNil and
    ap = TRevPartialNil() and
    config = mid.getConfiguration()
    or
    jumpStep(node, mid.getNodeEx(), config) and
    state = mid.getState() and
    sc1 = TRevSummaryCtx1None() and
    sc2 = TRevSummaryCtx2None() and
    sc3 = TRevSummaryCtx3None() and
    ap = mid.getAp() and
    config = mid.getConfiguration()
    or
    additionalJumpStep(node, mid.getNodeEx(), config) and
    state = mid.getState() and
    sc1 = TRevSummaryCtx1None() and
    sc2 = TRevSummaryCtx2None() and
    sc3 = TRevSummaryCtx3None() and
    mid.getAp() instanceof RevPartialAccessPathNil and
    ap = TRevPartialNil() and
    config = mid.getConfiguration()
    or
    additionalJumpStateStep(node, state, mid.getNodeEx(), mid.getState(), config) and
    sc1 = TRevSummaryCtx1None() and
    sc2 = TRevSummaryCtx2None() and
    sc3 = TRevSummaryCtx3None() and
    mid.getAp() instanceof RevPartialAccessPathNil and
    ap = TRevPartialNil() and
    config = mid.getConfiguration()
    or
    revPartialPathReadStep(mid, _, _, node, ap) and
    state = mid.getState() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3() and
    config = mid.getConfiguration()
    or
    exists(RevPartialAccessPath ap0, Content c |
      revPartialPathStoreStep(mid, ap0, c, node, config) and
      state = mid.getState() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      apConsRev(ap, c, ap0, config)
    )
    or
    exists(ParamNodeEx p |
      mid.getNodeEx() = p and
      viableParamArgEx(_, p, node) and
      state = mid.getState() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      sc1 = TRevSummaryCtx1None() and
      sc2 = TRevSummaryCtx2None() and
      sc3 = TRevSummaryCtx3None() and
      ap = mid.getAp() and
      config = mid.getConfiguration()
    )
    or
    exists(ReturnPosition pos |
      revPartialPathIntoReturn(mid, pos, state, sc1, sc2, sc3, _, ap, config) and
      pos = getReturnPosition(node.asNode())
    )
    or
    revPartialPathThroughCallable(mid, node, state, ap, config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    sc3 = mid.getSummaryCtx3()
  }

  pragma[inline]
  private predicate revPartialPathReadStep(
    PartialPathNodeRev mid, RevPartialAccessPath ap1, Content c, NodeEx node,
    RevPartialAccessPath ap2
  ) {
    exists(NodeEx midNode |
      midNode = mid.getNodeEx() and
      ap1 = mid.getAp() and
      read(node, c, midNode, mid.getConfiguration()) and
      ap2.getHead() = c and
      ap2.len() = unbindInt(ap1.len() + 1)
    )
  }

  pragma[nomagic]
  private predicate apConsRev(
    RevPartialAccessPath ap1, Content c, RevPartialAccessPath ap2, Configuration config
  ) {
    exists(PartialPathNodeRev mid |
      revPartialPathReadStep(mid, ap1, c, _, ap2) and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate revPartialPathStoreStep(
    PartialPathNodeRev mid, RevPartialAccessPath ap, Content c, NodeEx node, Configuration config
  ) {
    exists(NodeEx midNode, TypedContent tc |
      midNode = mid.getNodeEx() and
      ap = mid.getAp() and
      store(node, tc, midNode, _, config) and
      ap.getHead() = c and
      config = mid.getConfiguration() and
      tc.getContent() = c
    )
  }

  pragma[nomagic]
  private predicate revPartialPathIntoReturn(
    PartialPathNodeRev mid, ReturnPosition pos, FlowState state, TRevSummaryCtx1Some sc1,
    TRevSummaryCtx2Some sc2, TRevSummaryCtx3Some sc3, DataFlowCall call, RevPartialAccessPath ap,
    Configuration config
  ) {
    exists(NodeEx out |
      mid.getNodeEx() = out and
      mid.getState() = state and
      viableReturnPosOutEx(call, pos, out) and
      sc1 = TRevSummaryCtx1Some(pos) and
      sc2 = TRevSummaryCtx2Some(state) and
      sc3 = TRevSummaryCtx3Some(ap) and
      ap = mid.getAp() and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate revPartialPathFlowsThrough(
    ArgumentPosition apos, FlowState state, TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2,
    TRevSummaryCtx3Some sc3, RevPartialAccessPath ap, Configuration config
  ) {
    exists(PartialPathNodeRev mid, ParamNodeEx p, ParameterPosition ppos |
      mid.getNodeEx() = p and
      mid.getState() = state and
      p.getPosition() = ppos and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc3 = mid.getSummaryCtx3() and
      ap = mid.getAp() and
      config = mid.getConfiguration() and
      parameterMatch(ppos, apos)
    )
  }

  pragma[nomagic]
  private predicate revPartialPathThroughCallable0(
    DataFlowCall call, PartialPathNodeRev mid, ArgumentPosition pos, FlowState state,
    RevPartialAccessPath ap, Configuration config
  ) {
    exists(TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2, TRevSummaryCtx3Some sc3 |
      revPartialPathIntoReturn(mid, _, _, sc1, sc2, sc3, call, _, config) and
      revPartialPathFlowsThrough(pos, state, sc1, sc2, sc3, ap, config)
    )
  }

  pragma[nomagic]
  private predicate revPartialPathThroughCallable(
    PartialPathNodeRev mid, ArgNodeEx node, FlowState state, RevPartialAccessPath ap,
    Configuration config
  ) {
    exists(DataFlowCall call, ArgumentPosition pos |
      revPartialPathThroughCallable0(call, mid, pos, state, ap, config) and
      node.asNode().(ArgNode).argumentOf(call, pos)
    )
  }
}

import FlowExploration

private predicate partialFlow(
  PartialPathNode source, PartialPathNode node, Configuration configuration
) {
  source.getConfiguration() = configuration and
  source.isFwdSource() and
  node = source.getASuccessor+()
}

private predicate revPartialFlow(
  PartialPathNode node, PartialPathNode sink, Configuration configuration
) {
  sink.getConfiguration() = configuration and
  sink.isRevSink() and
  node.getASuccessor+() = sink
}
