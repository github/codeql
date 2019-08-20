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

/**
 * A configuration of interprocedural data flow analysis. This defines
 * sources, sinks, and any other configurable aspect of the analysis. Each
 * use of the global data flow library must define its own unique extension
 * of this abstract class. To create a configuration, extend this class with
 * a subclass whose characteristic predicate is a unique singleton string.
 * For example, write
 *
 * ```
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
 * ```
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
  abstract predicate isSource(Node source);

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  abstract predicate isSink(Node sink);

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  predicate isBarrier(Node node) { none() }

  /** DEPRECATED: override `isBarrierIn` and `isBarrierOut` instead. */
  deprecated predicate isBarrierEdge(Node node1, Node node2) { none() }

  /** Holds if data flow into `node` is prohibited. */
  predicate isBarrierIn(Node node) { none() }

  /** Holds if data flow out of `node` is prohibited. */
  predicate isBarrierOut(Node node) { none() }

  /** Holds if data flow through nodes guarded by `guard` is prohibited. */
  predicate isBarrierGuard(BarrierGuard guard) { none() }

  /**
   * Holds if the additional flow step from `node1` to `node2` must be taken
   * into account in the analysis.
   */
  predicate isAdditionalFlowStep(Node node1, Node node2) { none() }

  /**
   * Gets the virtual dispatch branching limit when calculating field flow.
   * This can be overridden to a smaller value to improve performance (a
   * value of 0 disables field flow), or a larger value to get more results.
   */
  int fieldFlowBranchLimit() { result = 2 }

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
  predicate hasFlowTo(Node sink) { hasFlow(_, sink) }

  /**
   * Holds if data may flow from some source to `sink` for this configuration.
   */
  predicate hasFlowToExpr(DataFlowExpr sink) { hasFlowTo(exprNode(sink)) }

  /** DEPRECATED: use `hasFlow` instead. */
  deprecated predicate hasFlowForward(Node source, Node sink) { hasFlow(source, sink) }

  /** DEPRECATED: use `hasFlow` instead. */
  deprecated predicate hasFlowBackward(Node source, Node sink) { hasFlow(source, sink) }
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
    strictcount(Node n | this.isSink(n)) < 0
    or
    strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0
    or
    super.hasFlow(source, sink)
  }
}

private predicate inBarrier(Node node, Configuration config) {
  config.isBarrierIn(node) and
  config.isSource(node)
}

private predicate outBarrier(Node node, Configuration config) {
  config.isBarrierOut(node) and
  config.isSink(node)
}

private predicate fullBarrier(Node node, Configuration config) {
  config.isBarrier(node)
  or
  config.isBarrierIn(node) and
  not config.isSource(node)
  or
  config.isBarrierOut(node) and
  not config.isSink(node)
  or
  exists(BarrierGuard g |
    config.isBarrierGuard(g) and
    node = g.getAGuardedNode()
  )
}

private class AdditionalFlowStepSource extends Node {
  AdditionalFlowStepSource() { any(Configuration c).isAdditionalFlowStep(this, _) }
}

pragma[noinline]
private predicate isAdditionalFlowStep(
  AdditionalFlowStepSource node1, Node node2, DataFlowCallable callable1, Configuration config
) {
  config.isAdditionalFlowStep(node1, node2) and
  callable1 = node1.getEnclosingCallable()
}

/**
 * Holds if data can flow in one local step from `node1` to `node2`.
 */
private predicate localFlowStep(Node node1, Node node2, Configuration config) {
  simpleLocalFlowStep(node1, node2) and
  not outBarrier(node1, config) and
  not inBarrier(node2, config) and
  not fullBarrier(node1, config) and
  not fullBarrier(node2, config)
}

/**
 * Holds if the additional step from `node1` to `node2` does not jump between callables.
 */
private predicate additionalLocalFlowStep(Node node1, Node node2, Configuration config) {
  isAdditionalFlowStep(node1, node2, node2.getEnclosingCallable(), config) and
  not outBarrier(node1, config) and
  not inBarrier(node2, config) and
  not fullBarrier(node1, config) and
  not fullBarrier(node2, config)
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
 */
private predicate jumpStep(Node node1, Node node2, Configuration config) {
  jumpStep(node1, node2) and
  not outBarrier(node1, config) and
  not inBarrier(node2, config) and
  not fullBarrier(node1, config) and
  not fullBarrier(node2, config)
}

/**
 * Holds if the additional step from `node1` to `node2` jumps between callables.
 */
private predicate additionalJumpStep(Node node1, Node node2, Configuration config) {
  exists(DataFlowCallable callable1 |
    isAdditionalFlowStep(node1, node2, callable1, config) and
    node2.getEnclosingCallable() != callable1 and
    not outBarrier(node1, config) and
    not inBarrier(node2, config) and
    not fullBarrier(node1, config) and
    not fullBarrier(node2, config)
  )
}

/**
 * Holds if field flow should be used for the given configuration.
 */
private predicate useFieldFlow(Configuration config) { config.fieldFlowBranchLimit() >= 1 }

pragma[noinline]
private ReturnPosition viableReturnPos(DataFlowCall call, ReturnKind kind) {
  viableImpl(call) = result.getCallable() and
  kind = result.getKind()
}

/**
 * Holds if `node` is reachable from a source in the given configuration
 * ignoring call contexts.
 */
private predicate nodeCandFwd1(Node node, boolean stored, Configuration config) {
  not fullBarrier(node, config) and
  (
    config.isSource(node) and stored = false
    or
    exists(Node mid |
      nodeCandFwd1(mid, stored, config) and
      localFlowStep(mid, node, config)
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, stored, config) and
      additionalLocalFlowStep(mid, node, config) and
      stored = false
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, stored, config) and
      jumpStep(mid, node, config)
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, stored, config) and
      additionalJumpStep(mid, node, config) and
      stored = false
    )
    or
    // store
    exists(Node mid |
      useFieldFlow(config) and
      nodeCandFwd1(mid, _, config) and
      store(mid, _, node) and
      stored = true and
      not outBarrier(mid, config)
    )
    or
    // read
    exists(Content f |
      nodeCandFwd1Read(f, node, config) and
      storeCandFwd1(f, unbind(config)) and
      (stored = false or stored = true) and
      not inBarrier(node, config)
    )
    or
    // flow into a callable
    exists(Node arg |
      nodeCandFwd1(arg, stored, config) and
      viableParamArg(_, node, arg)
    )
    or
    // flow out of an argument
    exists(PostUpdateNode mid, ParameterNode p |
      nodeCandFwd1(mid, stored, config) and
      parameterValueFlowsToUpdate(p, mid) and
      viableParamArg(_, p, node.(PostUpdateNode).getPreUpdateNode())
    )
    or
    // flow out of a callable
    exists(DataFlowCall call, ReturnNode ret, ReturnKind kind |
      nodeCandFwd1(ret, stored, config) and
      getReturnPosition(ret) = viableReturnPos(call, kind) and
      node = getAnOutNode(call, kind)
    )
  )
}

pragma[noinline]
private predicate nodeCandFwd1Read(Content f, Node node, Configuration config) {
  exists(Node mid |
    nodeCandFwd1(mid, true, config) and
    read(mid, f, node)
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCandFwd1`.
 */
pragma[noinline]
private predicate storeCandFwd1(Content f, Configuration config) {
  exists(Node mid, Node node |
    not fullBarrier(node, config) and
    useFieldFlow(config) and
    nodeCandFwd1(mid, _, config) and
    store(mid, f, node)
  )
}

bindingset[result, b]
private boolean unbindBool(boolean b) { result != b.booleanNot() }

/**
 * Holds if `node` is part of a path from a source to a sink in the given
 * configuration ignoring call contexts.
 */
pragma[nomagic]
private predicate nodeCand1(Node node, boolean stored, Configuration config) {
  nodeCandFwd1(node, false, config) and
  config.isSink(node) and
  stored = false
  or
  nodeCandFwd1(node, unbindBool(stored), unbind(config)) and
  (
    exists(Node mid |
      localFlowStep(node, mid, config) and
      nodeCand1(mid, stored, config)
    )
    or
    exists(Node mid |
      additionalLocalFlowStep(node, mid, config) and
      nodeCand1(mid, stored, config) and
      stored = false
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      nodeCand1(mid, stored, config)
    )
    or
    exists(Node mid |
      additionalJumpStep(node, mid, config) and
      nodeCand1(mid, stored, config) and
      stored = false
    )
    or
    // store
    exists(Content f |
      nodeCand1Store(f, node, config) and
      readCand1(f, unbind(config)) and
      (stored = false or stored = true)
    )
    or
    // read
    exists(Node mid, Content f |
      read(node, f, mid) and
      storeCandFwd1(f, unbind(config)) and
      nodeCand1(mid, _, config) and
      stored = true
    )
    or
    // flow into a callable
    exists(Node param |
      viableParamArg(_, param, node) and
      nodeCand1(param, stored, config)
    )
    or
    // flow out of an argument
    exists(PostUpdateNode mid, ParameterNode p |
      parameterValueFlowsToUpdate(p, node) and
      viableParamArg(_, p, mid.getPreUpdateNode()) and
      nodeCand1(mid, stored, config)
    )
    or
    // flow out of a callable
    exists(DataFlowCall call, ReturnKind kind, OutNode out |
      nodeCand1(out, stored, config) and
      getReturnPosition(node) = viableReturnPos(call, kind) and
      out = getAnOutNode(call, kind)
    )
  )
}

/**
 * Holds if `f` is the target of a read in the flow covered by `nodeCand1`.
 */
pragma[noinline]
private predicate readCand1(Content f, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd1(node, true, unbind(config)) and
    read(node, f, mid) and
    storeCandFwd1(f, unbind(config)) and
    nodeCand1(mid, _, config)
  )
}

pragma[noinline]
private predicate nodeCand1Store(Content f, Node node, Configuration config) {
  exists(Node mid |
    nodeCand1(mid, true, config) and
    storeCandFwd1(f, unbind(config)) and
    store(node, f, mid)
  )
}

private predicate throughFlowNodeCand(Node node, Configuration config) {
  nodeCand1(node, false, config) and
  not fullBarrier(node, config) and
  not inBarrier(node, config) and
  not outBarrier(node, config)
}

/**
 * Holds if there is a path from `p` to `node` in the same callable that is
 * part of a path from a source to a sink taking simple call contexts into
 * consideration. This is restricted to paths that do not necessarily
 * preserve the value of `p` by making use of at least one additional step
 * from the configuration.
 */
pragma[nomagic]
private predicate simpleParameterFlow(
  ParameterNode p, Node node, DataFlowType t, Configuration config
) {
  throughFlowNodeCand(node, config) and
  p = node and
  t = getErasedRepr(node.getType()) and
  exists(ReturnNode ret, ReturnKind kind |
    returnNodeGetEnclosingCallable(ret) = p.getEnclosingCallable() and
    kind = ret.getKind() and
    not parameterValueFlowsThrough(p, kind, _)
  )
  or
  throughFlowNodeCand(node, unbind(config)) and
  exists(Node mid |
    simpleParameterFlow(p, mid, t, config) and
    localFlowStep(mid, node, config) and
    compatibleTypes(t, node.getType())
  )
  or
  throughFlowNodeCand(node, unbind(config)) and
  exists(Node mid |
    simpleParameterFlow(p, mid, _, config) and
    additionalLocalFlowStep(mid, node, config) and
    t = getErasedRepr(node.getType())
  )
  or
  throughFlowNodeCand(node, unbind(config)) and
  exists(Node mid |
    simpleParameterFlow(p, mid, t, config) and
    localStoreReadStep(mid, node) and
    compatibleTypes(t, node.getType())
  )
  or
  // value flow through a callable
  throughFlowNodeCand(node, unbind(config)) and
  exists(Node arg |
    simpleParameterFlow(p, arg, t, config) and
    argumentValueFlowsThrough(arg, node, _) and
    compatibleTypes(t, node.getType())
  )
  or
  // flow through a callable
  throughFlowNodeCand(node, unbind(config)) and
  exists(Node arg |
    simpleParameterFlow(p, arg, _, config) and
    simpleArgumentFlowsThrough(arg, node, t, config)
  )
}

pragma[noinline]
private predicate simpleArgumentFlowsThrough0(
  DataFlowCall call, ArgumentNode arg, ReturnKind kind, DataFlowType t, Configuration config
) {
  nodeCand1(arg, false, unbind(config)) and
  not outBarrier(arg, config) and
  exists(ParameterNode p, ReturnNode ret |
    simpleParameterFlow(p, ret, t, config) and
    kind = ret.getKind() and
    viableParamArg(call, p, arg)
  )
}

/**
 * Holds if data can flow from `arg` to `out` through a call, taking simple
 * call contexts into consideration, and that this is part of a path from a
 * source to a sink. This is restricted to paths through calls that do not
 * necessarily preserve the value of `arg` by making use of at least one
 * additional step from the configuration.
 */
private predicate simpleArgumentFlowsThrough(
  ArgumentNode arg, Node out, DataFlowType t, Configuration config
) {
  exists(DataFlowCall call, ReturnKind kind |
    nodeCand1(out, false, unbind(config)) and
    not inBarrier(out, config) and
    simpleArgumentFlowsThrough0(call, arg, kind, t, config) and
    out = getAnOutNode(call, kind)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` in one local step or a step
 * through a callable.
 */
pragma[noinline]
private predicate localFlowStepOrFlowThroughCallable(Node node1, Node node2, Configuration config) {
  nodeCand1(node1, _, config) and
  localFlowStep(node1, node2, config)
  or
  nodeCand1(node1, _, config) and
  argumentValueFlowsThrough(node1, node2, _)
}

/**
 * Holds if data can flow from `node1` to `node2` in one local step or a step
 * through a callable, in both cases using an additional flow step from the
 * configuration.
 */
pragma[noinline]
private predicate additionalLocalFlowStepOrFlowThroughCallable(
  Node node1, Node node2, Configuration config
) {
  nodeCand1(node1, _, config) and
  additionalLocalFlowStep(node1, node2, config)
  or
  simpleArgumentFlowsThrough(node1, node2, _, config)
}

/**
 * Holds if data can flow out of a callable from `node1` to `node2`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink.
 */
private predicate flowOutOfCallable(Node node1, Node node2, Configuration config) {
  nodeCand1(node1, _, unbind(config)) and
  nodeCand1(node2, _, config) and
  not outBarrier(node1, config) and
  not inBarrier(node2, config) and
  (
    // flow out of an argument
    exists(ParameterNode p |
      parameterValueFlowsToUpdate(p, node1) and
      viableParamArg(_, p, node2.(PostUpdateNode).getPreUpdateNode())
    )
    or
    // flow out of a callable
    exists(DataFlowCall call, ReturnKind kind |
      getReturnPosition(node1) = viableReturnPos(call, kind) and
      node2 = getAnOutNode(call, kind)
    )
  )
}

/**
 * Holds if data can flow into a callable and that this step is part of a
 * path from a source to a sink.
 */
private predicate flowIntoCallable(Node node1, Node node2, Configuration config) {
  viableParamArg(_, node2, node1) and
  nodeCand1(node1, _, unbind(config)) and
  nodeCand1(node2, _, config) and
  not outBarrier(node1, config) and
  not inBarrier(node2, config)
}

/**
 * Gets the amount of forward branching on the origin of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int branch(Node n1, Configuration conf) {
  result = strictcount(Node n | flowOutOfCallable(n1, n, conf) or flowIntoCallable(n1, n, conf))
}

/**
 * Gets the amount of backward branching on the target of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int join(Node n2, Configuration conf) {
  result = strictcount(Node n | flowOutOfCallable(n, n2, conf) or flowIntoCallable(n, n2, conf))
}

/**
 * Holds if data can flow out of a callable from `node1` to `node2`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink. The
 * `allowsFieldFlow` flag indicates whether the branching is within the limit
 * specified by the configuration.
 */
private predicate flowOutOfCallable(
  Node node1, Node node2, boolean allowsFieldFlow, Configuration config
) {
  flowOutOfCallable(node1, node2, config) and
  exists(int b, int j |
    b = branch(node1, config) and
    j = join(node2, config) and
    if b.minimum(j) <= config.fieldFlowBranchLimit()
    then allowsFieldFlow = true
    else allowsFieldFlow = false
  )
}

/**
 * Holds if data can flow into a callable and that this step is part of a
 * path from a source to a sink. The `allowsFieldFlow` flag indicates whether
 * the branching is within the limit specified by the configuration.
 */
private predicate flowIntoCallable(
  Node node1, Node node2, boolean allowsFieldFlow, Configuration config
) {
  flowIntoCallable(node1, node2, config) and
  exists(int b, int j |
    b = branch(node1, config) and
    j = join(node2, config) and
    if b.minimum(j) <= config.fieldFlowBranchLimit()
    then allowsFieldFlow = true
    else allowsFieldFlow = false
  )
}

/**
 * Holds if `node` is part of a path from a source to a sink in the given
 * configuration taking simple call contexts into consideration.
 */
private predicate nodeCandFwd2(Node node, boolean fromArg, boolean stored, Configuration config) {
  nodeCand1(node, false, config) and
  config.isSource(node) and
  fromArg = false and
  stored = false
  or
  nodeCand1(node, unbindBool(stored), unbind(config)) and
  (
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, stored, config) and
      localFlowStepOrFlowThroughCallable(mid, node, config)
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, stored, config) and
      additionalLocalFlowStepOrFlowThroughCallable(mid, node, config) and
      stored = false
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, _, stored, config) and
      jumpStep(mid, node, config) and
      fromArg = false
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, _, stored, config) and
      additionalJumpStep(mid, node, config) and
      fromArg = false and
      stored = false
    )
    or
    // store
    exists(Node mid, Content f |
      nodeCandFwd2(mid, fromArg, _, config) and
      store(mid, f, node) and
      readCand1(f, unbind(config)) and
      stored = true
    )
    or
    // read
    exists(Content f |
      nodeCandFwd2Read(f, node, fromArg, config) and
      storeCandFwd2(f, unbind(config)) and
      (stored = false or stored = true)
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      nodeCandFwd2(mid, _, stored, config) and
      flowIntoCallable(mid, node, allowsFieldFlow, config) and
      fromArg = true and
      (stored = false or allowsFieldFlow = true)
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      nodeCandFwd2(mid, false, stored, config) and
      flowOutOfCallable(mid, node, allowsFieldFlow, config) and
      fromArg = false and
      (stored = false or allowsFieldFlow = true)
    )
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCandFwd2`.
 */
pragma[noinline]
private predicate storeCandFwd2(Content f, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCand1(node, true, unbind(config)) and
    nodeCandFwd2(mid, _, _, config) and
    store(mid, f, node) and
    readCand1(f, unbind(config))
  )
}

pragma[noinline]
private predicate nodeCandFwd2Read(Content f, Node node, boolean fromArg, Configuration config) {
  exists(Node mid |
    nodeCandFwd2(mid, fromArg, true, config) and
    read(mid, f, node) and
    readCand1(f, unbind(config))
  )
}

/**
 * Holds if `node` is part of a path from a source to a sink in the given
 * configuration taking simple call contexts into consideration.
 */
private predicate nodeCand2(Node node, boolean toReturn, boolean stored, Configuration config) {
  nodeCandFwd2(node, _, false, config) and
  config.isSink(node) and
  toReturn = false and
  stored = false
  or
  nodeCandFwd2(node, _, unbindBool(stored), unbind(config)) and
  (
    exists(Node mid |
      localFlowStepOrFlowThroughCallable(node, mid, config) and
      nodeCand2(mid, toReturn, stored, config)
    )
    or
    exists(Node mid |
      additionalLocalFlowStepOrFlowThroughCallable(node, mid, config) and
      nodeCand2(mid, toReturn, stored, config) and
      stored = false
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      nodeCand2(mid, _, stored, config) and
      toReturn = false
    )
    or
    exists(Node mid |
      additionalJumpStep(node, mid, config) and
      nodeCand2(mid, _, stored, config) and
      toReturn = false and
      stored = false
    )
    or
    // store
    exists(Content f |
      nodeCand2Store(f, node, toReturn, config) and
      readCand2(f, unbind(config)) and
      (stored = false or stored = true)
    )
    or
    // read
    exists(Node mid, Content f |
      read(node, f, mid) and
      storeCandFwd2(f, unbind(config)) and
      nodeCand2(mid, toReturn, _, config) and
      stored = true
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      flowIntoCallable(node, mid, allowsFieldFlow, config) and
      nodeCand2(mid, false, stored, config) and
      toReturn = false and
      (stored = false or allowsFieldFlow = true)
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      flowOutOfCallable(node, mid, allowsFieldFlow, config) and
      nodeCand2(mid, _, stored, config) and
      toReturn = true and
      (stored = false or allowsFieldFlow = true)
    )
  )
}

/**
 * Holds if `f` is the target of a read in the flow covered by `nodeCand2`.
 */
pragma[noinline]
private predicate readCand2(Content f, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd2(node, _, true, unbind(config)) and
    read(node, f, mid) and
    storeCandFwd2(f, unbind(config)) and
    nodeCand2(mid, _, _, config)
  )
}

pragma[noinline]
private predicate nodeCand2Store(Content f, Node node, boolean toReturn, Configuration config) {
  exists(Node mid |
    store(node, f, mid) and
    nodeCand2(mid, toReturn, true, config)
  )
}

pragma[nomagic]
private predicate storeCand(Content f, Configuration conf) {
  exists(Node node |
    nodeCand2Store(f, node, _, conf) and
    nodeCand2(node, _, _, unbind(conf))
  )
}

/**
 * Holds if `f` is the target of both a store and a read in the path graph
 * covered by `nodeCand2`.
 */
pragma[noinline]
private predicate readStoreCand(Content f, Configuration conf) {
  storeCand(f, conf) and
  readCand2(f, conf)
}

private predicate nodeCand(Node node, Configuration config) { nodeCand2(node, _, _, config) }

/**
 * Holds if `node` can be the first node in a maximal subsequence of local
 * flow steps in a dataflow path.
 */
private predicate localFlowEntry(Node node, Configuration config) {
  nodeCand(node, config) and
  (
    config.isSource(node) or
    jumpStep(_, node, config) or
    additionalJumpStep(_, node, config) or
    node instanceof ParameterNode or
    node instanceof OutNode or
    node instanceof PostUpdateNode or
    read(_, _, node) or
    node instanceof CastNode
  )
}

/**
 * Holds if `node` can be the last node in a maximal subsequence of local
 * flow steps in a dataflow path.
 */
private predicate localFlowExit(Node node, Configuration config) {
  exists(Node next | nodeCand(next, config) |
    jumpStep(node, next, config) or
    additionalJumpStep(node, next, config) or
    flowIntoCallable(node, next, config) or
    flowOutOfCallable(node, next, config) or
    simpleArgumentFlowsThrough(node, next, _, config) or
    argumentValueFlowsThrough(node, next, _) or
    store(node, _, next) or
    read(node, _, next)
  )
  or
  node instanceof CastNode
  or
  config.isSink(node)
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
  Node node1, Node node2, boolean preservesValue, Configuration config
) {
  localFlowEntry(node1, config) and
  (
    localFlowStep(node1, node2, config) and preservesValue = true
    or
    additionalLocalFlowStep(node1, node2, config) and preservesValue = false
  ) and
  node1 != node2 and
  nodeCand(node2, unbind(config))
  or
  exists(Node mid |
    localFlowStepPlus(node1, mid, preservesValue, config) and
    localFlowStep(mid, node2, config) and
    not mid instanceof CastNode and
    nodeCand(node2, unbind(config))
  )
  or
  exists(Node mid |
    localFlowStepPlus(node1, mid, _, config) and
    additionalLocalFlowStep(mid, node2, config) and
    not mid instanceof CastNode and
    preservesValue = false and
    nodeCand(node2, unbind(config))
  )
}

/**
 * Holds if `node1` can step to `node2` in one or more local steps and this
 * path can occur as a maximal subsequence of local steps in a dataflow path.
 */
pragma[noinline]
private predicate localFlowBigStep(
  Node node1, Node node2, boolean preservesValue, Configuration config
) {
  localFlowStepPlus(node1, node2, preservesValue, config) and
  localFlowExit(node2, config)
}

private newtype TAccessPathFront =
  TFrontNil(DataFlowType t) or
  TFrontHead(Content f)

/**
 * The front of an `AccessPath`. This is either a head or a nil.
 */
private class AccessPathFront extends TAccessPathFront {
  string toString() {
    exists(DataFlowType t | this = TFrontNil(t) | result = ppReprType(t))
    or
    exists(Content f | this = TFrontHead(f) | result = f.toString())
  }

  DataFlowType getType() {
    this = TFrontNil(result)
    or
    exists(Content head | this = TFrontHead(head) | result = head.getContainerType())
  }

  predicate headUsesContent(Content f) { this = TFrontHead(f) }
}

private class AccessPathFrontNil extends AccessPathFront, TFrontNil { }

/**
 * A `Node` at which a cast can occur such that the type should be checked.
 */
private class CastingNode extends Node {
  CastingNode() {
    this instanceof ParameterNode or
    this instanceof CastNode or
    this instanceof OutNode or
    this.(PostUpdateNode).getPreUpdateNode() instanceof ArgumentNode
  }
}

/**
 * Holds if data can flow from a source to `node` with the given `apf`.
 */
private predicate flowCandFwd(Node node, boolean fromArg, AccessPathFront apf, Configuration config) {
  flowCandFwd0(node, fromArg, apf, config) and
  if node instanceof CastingNode then compatibleTypes(node.getType(), apf.getType()) else any()
}

/**
 * A node that requires an empty access path and should have its tracked type
 * (re-)computed. This is either a source or a node reached through an
 * additional step.
 */
private class AccessPathFrontNilNode extends Node {
  AccessPathFrontNilNode() {
    nodeCand(this, _) and
    (
      any(Configuration c).isSource(this)
      or
      localFlowBigStep(_, this, false, _)
      or
      additionalJumpStep(_, this, _)
    )
  }

  pragma[noinline]
  private DataFlowType getErasedReprType() { result = getErasedRepr(this.getType()) }

  /** Gets the `nil` path front for this node. */
  AccessPathFrontNil getApf() { result = TFrontNil(this.getErasedReprType()) }
}

private predicate flowCandFwd0(Node node, boolean fromArg, AccessPathFront apf, Configuration config) {
  nodeCand2(node, _, false, config) and
  config.isSource(node) and
  fromArg = false and
  apf = node.(AccessPathFrontNilNode).getApf()
  or
  nodeCand(node, unbind(config)) and
  (
    exists(Node mid |
      flowCandFwd(mid, fromArg, apf, config) and
      localFlowBigStep(mid, node, true, config)
    )
    or
    exists(Node mid, AccessPathFrontNil nil |
      flowCandFwd(mid, fromArg, nil, config) and
      localFlowBigStep(mid, node, false, config) and
      apf = node.(AccessPathFrontNilNode).getApf()
    )
    or
    exists(Node mid |
      flowCandFwd(mid, _, apf, config) and
      jumpStep(mid, node, config) and
      fromArg = false
    )
    or
    exists(Node mid, AccessPathFrontNil nil |
      flowCandFwd(mid, _, nil, config) and
      additionalJumpStep(mid, node, config) and
      fromArg = false and
      apf = node.(AccessPathFrontNilNode).getApf()
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      flowCandFwd(mid, _, apf, config) and
      flowIntoCallable(mid, node, allowsFieldFlow, config) and
      fromArg = true and
      (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      flowCandFwd(mid, false, apf, config) and
      flowOutOfCallable(mid, node, allowsFieldFlow, config) and
      fromArg = false and
      (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
    )
    or
    exists(Node mid |
      flowCandFwd(mid, fromArg, apf, config) and
      argumentValueFlowsThrough(mid, node, _)
    )
    or
    exists(Node mid, AccessPathFrontNil nil, DataFlowType t |
      flowCandFwd(mid, fromArg, nil, config) and
      simpleArgumentFlowsThrough(mid, node, t, config) and
      apf = TFrontNil(t)
    )
  )
  or
  exists(Node mid, Content f |
    flowCandFwd(mid, fromArg, _, config) and
    store(mid, f, node) and
    nodeCand(node, unbind(config)) and
    apf.headUsesContent(f)
  )
  or
  exists(Content f, AccessPathFront apf0 |
    flowCandFwdRead(f, node, apf0, fromArg, config) and
    apf0.headUsesContent(f) and
    consCandFwd(f, apf, unbind(config))
  )
}

pragma[noinline]
private predicate consCandFwd(Content f, AccessPathFront apf, Configuration config) {
  exists(Node mid, Node n |
    flowCandFwd(mid, _, apf, config) and
    store(mid, f, n) and
    nodeCand(n, unbind(config)) and
    readStoreCand(f, unbind(config)) and
    compatibleTypes(apf.getType(), f.getType())
  )
}

pragma[noinline]
private predicate flowCandFwdRead(
  Content f, Node node, AccessPathFront apf, boolean fromArg, Configuration config
) {
  exists(Node mid |
    flowCandFwd(mid, fromArg, apf, config) and
    read(mid, f, node) and
    nodeCand(node, unbind(config))
  )
}

/**
 * Holds if data can flow from a source to `node` with the given `apf` and
 * from there flow to a sink.
 */
private predicate flowCand(Node node, boolean toReturn, AccessPathFront apf, Configuration config) {
  flowCand0(node, toReturn, apf, config) and
  flowCandFwd(node, _, apf, config)
}

private predicate flowCand0(Node node, boolean toReturn, AccessPathFront apf, Configuration config) {
  flowCandFwd(node, _, apf, config) and
  config.isSink(node) and
  toReturn = false and
  apf instanceof AccessPathFrontNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, config) and
    flowCand(mid, toReturn, apf, config)
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, apf, config) and
    localFlowBigStep(node, mid, false, config) and
    flowCand(mid, toReturn, nil, config) and
    apf instanceof AccessPathFrontNil
  )
  or
  exists(Node mid |
    jumpStep(node, mid, config) and
    flowCand(mid, _, apf, config) and
    toReturn = false
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, apf, config) and
    additionalJumpStep(node, mid, config) and
    flowCand(mid, _, nil, config) and
    toReturn = false and
    apf instanceof AccessPathFrontNil
  )
  or
  exists(Node mid, boolean allowsFieldFlow |
    flowIntoCallable(node, mid, allowsFieldFlow, config) and
    flowCand(mid, false, apf, config) and
    toReturn = false and
    (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
  )
  or
  exists(Node mid, boolean allowsFieldFlow |
    flowOutOfCallable(node, mid, allowsFieldFlow, config) and
    flowCand(mid, _, apf, config) and
    toReturn = true and
    (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
  )
  or
  exists(Node mid |
    argumentValueFlowsThrough(node, mid, _) and
    flowCand(mid, toReturn, apf, config)
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    simpleArgumentFlowsThrough(node, mid, _, config) and
    flowCand(mid, toReturn, nil, config) and
    apf instanceof AccessPathFrontNil and
    flowCandFwd(node, _, apf, config)
  )
  or
  exists(Content f, AccessPathFront apf0 |
    flowCandStore(node, f, toReturn, apf0, config) and
    apf0.headUsesContent(f) and
    consCand(f, apf, unbind(config))
  )
  or
  exists(Content f, AccessPathFront apf0 |
    flowCandRead(node, f, toReturn, apf0, config) and
    consCandFwd(f, apf0, unbind(config)) and
    apf.headUsesContent(f)
  )
}

pragma[nomagic]
private predicate flowCandRead(
  Node node, Content f, boolean toReturn, AccessPathFront apf0, Configuration config
) {
  exists(Node mid |
    read(node, f, mid) and
    flowCand(mid, toReturn, apf0, config)
  )
}

pragma[noinline]
private predicate flowCandStore(
  Node node, Content f, boolean toReturn, AccessPathFront apf0, Configuration config
) {
  exists(Node mid |
    store(node, f, mid) and
    flowCand(mid, toReturn, apf0, config)
  )
}

pragma[noinline]
private predicate consCand(Content f, AccessPathFront apf, Configuration config) {
  consCandFwd(f, apf, config) and
  exists(Node n, AccessPathFront apf0 |
    flowCandFwd(n, _, apf0, config) and
    apf0.headUsesContent(f) and
    flowCandRead(n, f, _, apf, config)
  )
}

private newtype TAccessPath =
  TNil(DataFlowType t) or
  TCons(Content f, int len) { len in [1 .. 5] }

/**
 * Conceptually a list of `Content`s followed by a `Type`, but only the first
 * element of the list and its length are tracked. If data flows from a source to
 * a given node with a given `AccessPath`, this indicates the sequence of
 * dereference operations needed to get from the value in the node to the
 * tracked object. The final type indicates the type of the tracked object.
 */
private class AccessPath extends TAccessPath {
  abstract string toString();

  Content getHead() { this = TCons(result, _) }

  int len() {
    this = TNil(_) and result = 0
    or
    this = TCons(_, result)
  }

  DataFlowType getType() {
    this = TNil(result)
    or
    exists(Content head | this = TCons(head, _) | result = head.getContainerType())
  }

  abstract AccessPathFront getFront();
}

private class AccessPathNil extends AccessPath, TNil {
  override string toString() { exists(DataFlowType t | this = TNil(t) | result = ppReprType(t)) }

  override AccessPathFront getFront() {
    exists(DataFlowType t | this = TNil(t) | result = TFrontNil(t))
  }
}

private class AccessPathCons extends AccessPath, TCons {
  override string toString() {
    exists(Content f, int len | this = TCons(f, len) |
      result = f.toString() + ", ... (" + len.toString() + ")"
    )
  }

  override AccessPathFront getFront() {
    exists(Content f | this = TCons(f, _) | result = TFrontHead(f))
  }
}

/** Holds if `ap0` corresponds to the cons of `f` and `ap`. */
private predicate pop(AccessPath ap0, Content f, AccessPath ap) {
  ap0.getFront().headUsesContent(f) and
  consCand(f, ap.getFront(), _) and
  ap0.len() = 1 + ap.len()
}

/** Holds if `ap0` corresponds to the cons of `f` and `ap` and `apf` is the front of `ap`. */
pragma[noinline]
private predicate popWithFront(AccessPath ap0, Content f, AccessPathFront apf, AccessPath ap) {
  pop(ap0, f, ap) and apf = ap.getFront()
}

/** Holds if `ap` corresponds to the cons of `f` and `ap0`. */
private predicate push(AccessPath ap0, Content f, AccessPath ap) { pop(ap, f, ap0) }

/**
 * A node that requires an empty access path and should have its tracked type
 * (re-)computed. This is either a source or a node reached through an
 * additional step.
 */
private class AccessPathNilNode extends Node {
  AccessPathNilNode() { flowCand(this.(AccessPathFrontNilNode), _, _, _) }

  pragma[noinline]
  private DataFlowType getErasedReprType() { result = getErasedRepr(this.getType()) }

  /** Gets the `nil` path for this node. */
  AccessPathNil getAp() { result = TNil(this.getErasedReprType()) }
}

/**
 * Holds if data can flow from a source to `node` with the given `ap`.
 */
private predicate flowFwd(
  Node node, boolean fromArg, AccessPathFront apf, AccessPath ap, Configuration config
) {
  flowFwd0(node, fromArg, apf, ap, config) and
  flowCand(node, _, apf, config)
}

private predicate flowFwd0(
  Node node, boolean fromArg, AccessPathFront apf, AccessPath ap, Configuration config
) {
  flowCand(node, _, _, config) and
  config.isSource(node) and
  fromArg = false and
  ap = node.(AccessPathNilNode).getAp() and
  apf = ap.(AccessPathNil).getFront()
  or
  flowCand(node, _, _, unbind(config)) and
  (
    exists(Node mid |
      flowFwd(mid, fromArg, apf, ap, config) and
      localFlowBigStep(mid, node, true, config)
    )
    or
    exists(Node mid, AccessPathNil nil |
      flowFwd(mid, fromArg, _, nil, config) and
      localFlowBigStep(mid, node, false, config) and
      ap = node.(AccessPathNilNode).getAp() and
      apf = ap.(AccessPathNil).getFront()
    )
    or
    exists(Node mid |
      flowFwd(mid, _, apf, ap, config) and
      jumpStep(mid, node, config) and
      fromArg = false
    )
    or
    exists(Node mid, AccessPathNil nil |
      flowFwd(mid, _, _, nil, config) and
      additionalJumpStep(mid, node, config) and
      fromArg = false and
      ap = node.(AccessPathNilNode).getAp() and
      apf = ap.(AccessPathNil).getFront()
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      flowFwd(mid, _, apf, ap, config) and
      flowIntoCallable(mid, node, allowsFieldFlow, config) and
      fromArg = true and
      (ap instanceof AccessPathNil or allowsFieldFlow = true)
    )
    or
    exists(Node mid, boolean allowsFieldFlow |
      flowFwd(mid, false, apf, ap, config) and
      flowOutOfCallable(mid, node, allowsFieldFlow, config) and
      fromArg = false and
      (ap instanceof AccessPathNil or allowsFieldFlow = true)
    )
    or
    exists(Node mid |
      flowFwd(mid, fromArg, apf, ap, config) and
      argumentValueFlowsThrough(mid, node, _)
    )
    or
    exists(Node mid, AccessPathNil nil, DataFlowType t |
      flowFwd(mid, fromArg, _, nil, config) and
      simpleArgumentFlowsThrough(mid, node, t, config) and
      ap = TNil(t) and
      apf = ap.(AccessPathNil).getFront()
    )
  )
  or
  exists(Content f, AccessPath ap0 |
    flowFwdStore(node, f, ap0, apf, fromArg, config) and
    push(ap0, f, ap)
  )
  or
  exists(Content f, AccessPath ap0 |
    flowFwdRead(node, f, ap0, fromArg, config) and
    popWithFront(ap0, f, apf, ap)
  )
}

pragma[nomagic]
private predicate flowFwdStore(
  Node node, Content f, AccessPath ap0, AccessPathFront apf, boolean fromArg, Configuration config
) {
  exists(Node mid, AccessPathFront apf0 |
    flowFwd(mid, fromArg, apf0, ap0, config) and
    flowFwdStoreAux(mid, f, node, apf0, apf, config)
  )
}

private predicate flowFwdStoreAux(
  Node mid, Content f, Node node, AccessPathFront apf0, AccessPathFront apf, Configuration config
) {
  store(mid, f, node) and
  consCand(f, apf0, config) and
  apf.headUsesContent(f) and
  flowCand(node, _, apf, unbind(config))
}

pragma[nomagic]
private predicate flowFwdRead(
  Node node, Content f, AccessPath ap0, boolean fromArg, Configuration config
) {
  exists(Node mid, AccessPathFront apf0 |
    flowFwd(mid, fromArg, apf0, ap0, config) and
    read(mid, f, node) and
    apf0.headUsesContent(f) and
    flowCand(node, _, _, unbind(config))
  )
}

/**
 * Holds if data can flow from a source to `node` with the given `ap` and
 * from there flow to a sink.
 */
private predicate flow(Node node, boolean toReturn, AccessPath ap, Configuration config) {
  flow0(node, toReturn, ap, config) and
  flowFwd(node, _, _, ap, config)
}

private predicate flow0(Node node, boolean toReturn, AccessPath ap, Configuration config) {
  flowFwd(node, _, _, ap, config) and
  config.isSink(node) and
  toReturn = false and
  ap instanceof AccessPathNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, config) and
    flow(mid, toReturn, ap, config)
  )
  or
  exists(Node mid, AccessPathNil nil |
    flowFwd(node, _, _, ap, config) and
    localFlowBigStep(node, mid, false, config) and
    flow(mid, toReturn, nil, config) and
    ap instanceof AccessPathNil
  )
  or
  exists(Node mid |
    jumpStep(node, mid, config) and
    flow(mid, _, ap, config) and
    toReturn = false
  )
  or
  exists(Node mid, AccessPathNil nil |
    flowFwd(node, _, _, ap, config) and
    additionalJumpStep(node, mid, config) and
    flow(mid, _, nil, config) and
    toReturn = false and
    ap instanceof AccessPathNil
  )
  or
  exists(Node mid, boolean allowsFieldFlow |
    flowIntoCallable(node, mid, allowsFieldFlow, config) and
    flow(mid, false, ap, config) and
    toReturn = false and
    (ap instanceof AccessPathNil or allowsFieldFlow = true)
  )
  or
  exists(Node mid, boolean allowsFieldFlow |
    flowOutOfCallable(node, mid, allowsFieldFlow, config) and
    flow(mid, _, ap, config) and
    toReturn = true and
    (ap instanceof AccessPathNil or allowsFieldFlow = true)
  )
  or
  exists(Node mid |
    argumentValueFlowsThrough(node, mid, _) and
    flow(mid, toReturn, ap, config)
  )
  or
  exists(Node mid, AccessPathNil ap0 |
    simpleArgumentFlowsThrough(node, mid, _, config) and
    flow(mid, toReturn, ap0, config) and
    ap instanceof AccessPathNil and
    flowFwd(node, _, _, ap, config)
  )
  or
  exists(Content f, AccessPath ap0 |
    flowStore(node, f, toReturn, ap0, config) and
    pop(ap0, f, ap)
  )
  or
  exists(Content f, AccessPath ap0 |
    flowRead(node, f, toReturn, ap0, config) and
    push(ap0, f, ap)
  )
}

pragma[nomagic]
private predicate flowStore(
  Node node, Content f, boolean toReturn, AccessPath ap0, Configuration config
) {
  exists(Node mid |
    store(node, f, mid) and
    flow(mid, toReturn, ap0, config)
  )
}

pragma[nomagic]
private predicate flowRead(
  Node node, Content f, boolean toReturn, AccessPath ap0, Configuration config
) {
  exists(Node mid |
    read(node, f, mid) and
    flow(mid, toReturn, ap0, config)
  )
}

bindingset[conf, result]
private Configuration unbind(Configuration conf) { result >= conf and result <= conf }

private predicate flow(Node n, Configuration config) { flow(n, _, _, config) }

private newtype TPathNode =
  TPathNodeMid(Node node, CallContext cc, AccessPath ap, Configuration config) {
    // A PathNode is introduced by a source ...
    flow(node, config) and
    config.isSource(node) and
    cc instanceof CallContextAny and
    ap = node.(AccessPathNilNode).getAp()
    or
    // ... or a step from an existing PathNode to another node.
    exists(PathNodeMid mid |
      pathStep(mid, node, cc, ap) and
      config = mid.getConfiguration() and
      flow(node, _, ap, unbind(config))
    )
  } or
  TPathNodeSink(Node node, Configuration config) {
    // The AccessPath on a sink is empty.
    config.isSink(node) and
    flow(node, config)
  }

/**
 * A `Node` augmented with a call context (except for sinks), an access path, and a configuration.
 * Only those `PathNode`s that are reachable from a source are generated.
 */
abstract class PathNode extends TPathNode {
  /** Gets a textual representation of this element. */
  string toString() { result = getNode().toString() + ppAp() }

  /**
   * Gets a textual representation of this element, including a textual
   * representation of the call context.
   */
  string toStringWithContext() { result = getNode().toString() + ppAp() + ppCtx() }

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
    getNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the underlying `Node`. */
  abstract Node getNode();

  /** Gets the associated configuration. */
  abstract Configuration getConfiguration();

  /** Gets a successor. */
  deprecated final PathNode getSucc() { result = this.getASuccessor() }

  /** Gets a successor of this node, if any. */
  abstract PathNode getASuccessor();

  private string ppAp() {
    this instanceof PathNodeSink and result = ""
    or
    exists(string s | s = this.(PathNodeMid).getAp().toString() |
      if s = "" then result = "" else result = " [" + s + "]"
    )
  }

  private string ppCtx() {
    this instanceof PathNodeSink and result = ""
    or
    result = " <" + this.(PathNodeMid).getCallContext().toString() + ">"
  }
}

/** Holds if `n` can reach a sink. */
private predicate reach(PathNode n) { n instanceof PathNodeSink or reach(n.getASuccessor()) }

/** Holds if `n1.getSucc() = n2` and `n2` can reach a sink. */
private predicate pathSucc(PathNode n1, PathNode n2) { n1.getASuccessor() = n2 and reach(n2) }

private predicate pathSuccPlus(PathNode n1, PathNode n2) = fastTC(pathSucc/2)(n1, n2)

/**
 * Provides the query predicates needed to include a graph in a path-problem query.
 */
module PathGraph {
  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode a, PathNode b) { pathSucc(a, b) }
}

/**
 * An intermediate flow graph node. This is a triple consisting of a `Node`,
 * a `CallContext`, and a `Configuration`.
 */
private class PathNodeMid extends PathNode, TPathNodeMid {
  Node node;

  CallContext cc;

  AccessPath ap;

  Configuration config;

  PathNodeMid() { this = TPathNodeMid(node, cc, ap, config) }

  override Node getNode() { result = node }

  CallContext getCallContext() { result = cc }

  AccessPath getAp() { result = ap }

  override Configuration getConfiguration() { result = config }

  private PathNodeMid getSuccMid() {
    pathStep(this, result.getNode(), result.getCallContext(), result.getAp()) and
    result.getConfiguration() = unbind(this.getConfiguration())
  }

  override PathNode getASuccessor() {
    // an intermediate step to another intermediate node
    result = getSuccMid()
    or
    // a final step to a sink via one or more local steps
    localFlowStepPlus(node, result.getNode(), _, config) and
    ap instanceof AccessPathNil and
    result instanceof PathNodeSink and
    result.getConfiguration() = unbind(this.getConfiguration())
    or
    // a final step to a sink via zero steps means we merge the last two steps to prevent trivial-looking edges
    exists(PathNodeMid mid |
      mid = getSuccMid() and
      mid.getNode() = result.getNode() and
      mid.getAp() instanceof AccessPathNil and
      result instanceof PathNodeSink and
      result.getConfiguration() = unbind(mid.getConfiguration())
    )
    or
    // a direct step from a source to a sink if a node is both
    this instanceof PathNodeSource and
    result instanceof PathNodeSink and
    this.getNode() = result.getNode() and
    result.getConfiguration() = unbind(this.getConfiguration())
  }
}

/**
 * A flow graph node corresponding to a source.
 */
private class PathNodeSource extends PathNodeMid {
  PathNodeSource() {
    getConfiguration().isSource(getNode()) and
    getCallContext() instanceof CallContextAny and
    getAp() instanceof AccessPathNil
  }
}

/**
 * A flow graph node corresponding to a sink. This is disjoint from the
 * intermediate nodes in order to uniquely correspond to a given sink by
 * excluding the `CallContext`.
 */
private class PathNodeSink extends PathNode, TPathNodeSink {
  Node node;

  Configuration config;

  PathNodeSink() { this = TPathNodeSink(node, config) }

  override Node getNode() { result = node }

  override Configuration getConfiguration() { result = config }

  override PathNode getASuccessor() { none() }
}

/**
 * Holds if data may flow from `mid` to `node`. The last step in or out of
 * a callable is recorded by `cc`.
 */
private predicate pathStep(PathNodeMid mid, Node node, CallContext cc, AccessPath ap) {
  localFlowBigStep(mid.getNode(), node, true, mid.getConfiguration()) and
  cc = mid.getCallContext() and
  ap = mid.getAp()
  or
  localFlowBigStep(mid.getNode(), node, false, mid.getConfiguration()) and
  cc = mid.getCallContext() and
  mid.getAp() instanceof AccessPathNil and
  ap = node.(AccessPathNilNode).getAp()
  or
  jumpStep(mid.getNode(), node, mid.getConfiguration()) and
  cc instanceof CallContextAny and
  ap = mid.getAp()
  or
  additionalJumpStep(mid.getNode(), node, mid.getConfiguration()) and
  cc instanceof CallContextAny and
  mid.getAp() instanceof AccessPathNil and
  ap = node.(AccessPathNilNode).getAp()
  or
  contentReadStep(mid, node, ap) and cc = mid.getCallContext()
  or
  exists(Content f, AccessPath ap0 | contentStoreStep(mid, node, ap0, f, cc) and push(ap0, f, ap))
  or
  pathOutOfArgument(mid, node, cc) and ap = mid.getAp()
  or
  pathIntoCallable(mid, node, _, cc, _) and ap = mid.getAp()
  or
  pathOutOfCallable(mid, node, cc) and ap = mid.getAp()
  or
  pathThroughCallable(mid, node, cc, ap)
  or
  valuePathThroughCallable(mid, node, cc) and ap = mid.getAp()
}

private predicate contentReadStep(PathNodeMid mid, Node node, AccessPath ap) {
  exists(Content f, AccessPath ap0 |
    ap0 = mid.getAp() and
    read(mid.getNode(), f, node) and
    pop(ap0, f, ap)
  )
}

pragma[noinline]
private predicate contentStoreStep(
  PathNodeMid mid, Node node, AccessPath ap0, Content f, CallContext cc
) {
  ap0 = mid.getAp() and
  store(mid.getNode(), f, node) and
  cc = mid.getCallContext()
}

private predicate pathOutOfCallable0(PathNodeMid mid, ReturnPosition pos, CallContext innercc) {
  pos = getReturnPosition(mid.getNode()) and
  innercc = mid.getCallContext() and
  not innercc instanceof CallContextCall
}

pragma[noinline]
private predicate pathOutOfCallable1(
  PathNodeMid mid, DataFlowCall call, ReturnKind kind, CallContext cc
) {
  exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
    pathOutOfCallable0(mid, pos, innercc) and
    c = pos.getCallable() and
    kind = pos.getKind() and
    resolveReturn(innercc, c, call)
  |
    if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
  )
}

/**
 * Holds if data may flow from `mid` to `out`. The last step of this path
 * is a return from a callable and is recorded by `cc`, if needed.
 */
pragma[noinline]
private predicate pathOutOfCallable(PathNodeMid mid, OutNode out, CallContext cc) {
  exists(ReturnKind kind, DataFlowCall call | pathOutOfCallable1(mid, call, kind, cc) |
    out = getAnOutNode(call, kind)
  )
}

private predicate pathOutOfArgument(PathNodeMid mid, PostUpdateNode node, CallContext cc) {
  exists(
    PostUpdateNode n, ParameterNode p, DataFlowCallable callable, CallContext innercc, int i,
    DataFlowCall call, ArgumentNode arg
  |
    mid.getNode() = n and
    parameterValueFlowsToUpdate(p, n) and
    innercc = mid.getCallContext() and
    p.isParameterOf(callable, i) and
    resolveReturn(innercc, callable, call) and
    node.getPreUpdateNode() = arg and
    arg.argumentOf(call, i) and
    flow(node, unbind(mid.getConfiguration()))
  |
    if reducedViableImplInReturn(callable, call)
    then cc = TReturn(callable, call)
    else cc = TAnyCallContext()
  )
}

/**
 * Holds if data may flow from `mid` to the `i`th argument of `call` in `cc`.
 */
pragma[noinline]
private predicate pathIntoArg(
  PathNodeMid mid, int i, CallContext cc, DataFlowCall call, boolean emptyAp
) {
  exists(ArgumentNode arg, AccessPath ap |
    arg = mid.getNode() and
    cc = mid.getCallContext() and
    arg.argumentOf(call, i) and
    ap = mid.getAp()
  |
    ap instanceof AccessPathNil and emptyAp = true
    or
    ap instanceof AccessPathCons and emptyAp = false
  )
}

pragma[noinline]
private predicate parameterCand(DataFlowCallable callable, int i, Configuration config) {
  exists(ParameterNode p |
    flow(p, config) and
    p.isParameterOf(callable, i)
  )
}

pragma[nomagic]
private predicate pathIntoCallable0(
  PathNodeMid mid, DataFlowCallable callable, int i, CallContext outercc, DataFlowCall call,
  boolean emptyAp
) {
  pathIntoArg(mid, i, outercc, call, emptyAp) and
  callable = resolveCall(call, outercc) and
  parameterCand(callable, any(int j | j <= i and j >= i), mid.getConfiguration())
}

/**
 * Holds if data may flow from `mid` to `p` through `call`. The contexts
 * before and after entering the callable are `outercc` and `innercc`,
 * respectively.
 */
private predicate pathIntoCallable(
  PathNodeMid mid, ParameterNode p, CallContext outercc, CallContextCall innercc, DataFlowCall call
) {
  exists(int i, DataFlowCallable callable, boolean emptyAp |
    pathIntoCallable0(mid, callable, i, outercc, call, emptyAp) and
    p.isParameterOf(callable, i)
  |
    if reducedViableImplInCallContext(_, callable, call)
    then innercc = TSpecificCall(call, i, emptyAp)
    else innercc = TSomeCall(p, emptyAp)
  )
}

/** Holds if data may flow from `p` to a return of kind `kind`. */
pragma[nomagic]
private predicate paramFlowsThrough(
  ParameterNode p, ReturnKind kind, CallContextCall cc, AccessPathNil apnil, Configuration config
) {
  exists(PathNodeMid mid, ReturnNode ret |
    mid.getNode() = ret and
    kind = ret.getKind() and
    cc = mid.getCallContext() and
    config = mid.getConfiguration() and
    apnil = mid.getAp()
  |
    cc = TSomeCall(p, true)
    or
    exists(int i | cc = TSpecificCall(_, i, true) |
      p.isParameterOf(returnNodeGetEnclosingCallable(ret), i)
    )
  )
}

pragma[noinline]
private predicate pathThroughCallable0(
  DataFlowCall call, PathNodeMid mid, ReturnKind kind, CallContext cc, AccessPathNil apnil
) {
  exists(ParameterNode p, CallContext innercc |
    pathIntoCallable(mid, p, cc, innercc, call) and
    paramFlowsThrough(p, kind, innercc, apnil, unbind(mid.getConfiguration())) and
    not parameterValueFlowsThrough(p, kind, innercc) and
    mid.getAp() instanceof AccessPathNil
  )
}

/**
 * Holds if data may flow from `mid` through a callable to the node `out`.
 * The context `cc` is restored to its value prior to entering the callable.
 */
pragma[noinline]
private predicate pathThroughCallable(
  PathNodeMid mid, OutNode out, CallContext cc, AccessPathNil apnil
) {
  exists(DataFlowCall call, ReturnKind kind |
    pathThroughCallable0(call, mid, kind, cc, apnil) and
    out = getAnOutNode(call, kind)
  )
}

pragma[noinline]
private predicate valuePathThroughCallable0(
  DataFlowCall call, PathNodeMid mid, ReturnKind kind, CallContext cc
) {
  exists(ParameterNode p, CallContext innercc |
    pathIntoCallable(mid, p, cc, innercc, call) and
    parameterValueFlowsThrough(p, kind, innercc)
  )
}

private predicate valuePathThroughCallable(PathNodeMid mid, OutNode out, CallContext cc) {
  exists(DataFlowCall call, ReturnKind kind |
    valuePathThroughCallable0(call, mid, kind, cc) and
    out = getAnOutNode(call, kind)
  )
}

/**
 * Holds if data can flow (inter-procedurally) from `source` to `sink`.
 *
 * Will only have results if `configuration` has non-empty sources and
 * sinks.
 */
private predicate flowsTo(
  PathNodeSource flowsource, PathNodeSink flowsink, Node source, Node sink,
  Configuration configuration
) {
  flowsource.getConfiguration() = configuration and
  flowsource.getNode() = source and
  pathSuccPlus(flowsource, flowsink) and
  flowsink.getNode() = sink
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
