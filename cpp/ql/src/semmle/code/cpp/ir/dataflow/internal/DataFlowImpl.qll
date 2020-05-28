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

  /**
   * Gets the exploration limit for `hasPartialFlow` measured in approximate
   * number of interprocedural steps.
   */
  int explorationLimit() { none() }

  /**
   * Holds if there is a partial data flow path from `source` to `node`. The
   * approximate distance between `node` and the closest source is `dist` and
   * is restricted to be less than or equal to `explorationLimit()`. This
   * predicate completely disregards sink definitions.
   *
   * This predicate is intended for dataflow exploration and debugging and may
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

/**
 * Holds if `node` is reachable from a source in the configuration `config`.
 *
 * The Boolean `fromArg` records whether the node is reached through an
 * argument in a call.
 */
private predicate nodeCandFwd1(Node node, boolean fromArg, Configuration config) {
  not fullBarrier(node, config) and
  (
    config.isSource(node) and
    fromArg = false
    or
    exists(Node mid |
      nodeCandFwd1(mid, fromArg, config) and
      localFlowStep(mid, node, config)
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, fromArg, config) and
      additionalLocalFlowStep(mid, node, config)
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, config) and
      jumpStep(mid, node, config) and
      fromArg = false
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, config) and
      additionalJumpStep(mid, node, config) and
      fromArg = false
    )
    or
    // store
    exists(Node mid |
      useFieldFlow(config) and
      nodeCandFwd1(mid, fromArg, config) and
      store(mid, _, node) and
      not outBarrier(mid, config)
    )
    or
    // read
    exists(Content f |
      nodeCandFwd1Read(f, node, fromArg, config) and
      nodeCandFwd1IsStored(f, config) and
      not inBarrier(node, config)
    )
    or
    // flow into a callable
    exists(Node arg |
      nodeCandFwd1(arg, config) and
      viableParamArg(_, node, arg) and
      fromArg = true
    )
    or
    // flow out of a callable
    exists(DataFlowCall call |
      nodeCandFwd1Out(call, node, false, config) and
      fromArg = false
      or
      nodeCandFwd1OutFromArg(call, node, config) and
      nodeCandFwd1IsEntered(call, fromArg, config)
    )
  )
}

private predicate nodeCandFwd1(Node node, Configuration config) { nodeCandFwd1(node, _, config) }

pragma[nomagic]
private predicate nodeCandFwd1Read(Content f, Node node, boolean fromArg, Configuration config) {
  exists(Node mid |
    nodeCandFwd1(mid, fromArg, config) and
    read(mid, f, node)
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCandFwd1`.
 */
pragma[nomagic]
private predicate nodeCandFwd1IsStored(Content f, Configuration config) {
  exists(Node mid, Node node |
    not fullBarrier(node, config) and
    useFieldFlow(config) and
    nodeCandFwd1(mid, config) and
    store(mid, f, node)
  )
}

pragma[nomagic]
private predicate nodeCandFwd1ReturnPosition(
  ReturnPosition pos, boolean fromArg, Configuration config
) {
  exists(ReturnNodeExt ret |
    nodeCandFwd1(ret, fromArg, config) and
    getReturnPosition(ret) = pos
  )
}

pragma[nomagic]
private predicate nodeCandFwd1Out(DataFlowCall call, Node out, boolean fromArg, Configuration config) {
  exists(ReturnPosition pos |
    nodeCandFwd1ReturnPosition(pos, fromArg, config) and
    viableReturnPosOut(call, pos, out)
  )
}

pragma[nomagic]
private predicate nodeCandFwd1OutFromArg(DataFlowCall call, Node node, Configuration config) {
  nodeCandFwd1Out(call, node, true, config)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `nodeCandFwd1`.
 */
pragma[nomagic]
private predicate nodeCandFwd1IsEntered(DataFlowCall call, boolean fromArg, Configuration config) {
  exists(ArgumentNode arg |
    nodeCandFwd1(arg, fromArg, config) and
    viableParamArg(call, _, arg)
  )
}

bindingset[result, b]
private boolean unbindBool(boolean b) { result != b.booleanNot() }

/**
 * Holds if `node` is part of a path from a source to a sink in the
 * configuration `config`.
 *
 * The Boolean `toReturn` records whether the node must be returned from
 * the enclosing callable in order to reach a sink.
 */
pragma[nomagic]
private predicate nodeCand1(Node node, boolean toReturn, Configuration config) {
  nodeCand1_0(node, toReturn, config) and
  nodeCandFwd1(node, config)
}

pragma[nomagic]
private predicate nodeCand1_0(Node node, boolean toReturn, Configuration config) {
  nodeCandFwd1(node, config) and
  config.isSink(node) and
  toReturn = false
  or
  exists(Node mid |
    localFlowStep(node, mid, config) and
    nodeCand1(mid, toReturn, config)
  )
  or
  exists(Node mid |
    additionalLocalFlowStep(node, mid, config) and
    nodeCand1(mid, toReturn, config)
  )
  or
  exists(Node mid |
    jumpStep(node, mid, config) and
    nodeCand1(mid, _, config) and
    toReturn = false
  )
  or
  exists(Node mid |
    additionalJumpStep(node, mid, config) and
    nodeCand1(mid, _, config) and
    toReturn = false
  )
  or
  // store
  exists(Content f |
    nodeCand1Store(f, node, toReturn, config) and
    nodeCand1IsRead(f, config)
  )
  or
  // read
  exists(Node mid, Content f |
    read(node, f, mid) and
    nodeCandFwd1IsStored(f, unbind(config)) and
    nodeCand1(mid, toReturn, config)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    nodeCand1In(call, node, false, config) and
    toReturn = false
    or
    nodeCand1InToReturn(call, node, config) and
    nodeCand1IsReturned(call, toReturn, config)
  )
  or
  // flow out of a callable
  exists(ReturnPosition pos |
    nodeCand1Out(pos, config) and
    getReturnPosition(node) = pos and
    toReturn = true
  )
}

/**
 * Holds if `f` is the target of a read in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate nodeCand1IsRead(Content f, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd1(node, unbind(config)) and
    read(node, f, mid) and
    nodeCandFwd1IsStored(f, unbind(config)) and
    nodeCand1(mid, _, config)
  )
}

pragma[nomagic]
private predicate nodeCand1Store(Content f, Node node, boolean toReturn, Configuration config) {
  exists(Node mid |
    nodeCand1(mid, toReturn, config) and
    nodeCandFwd1IsStored(f, unbind(config)) and
    store(node, f, mid)
  )
}

/**
 * Holds if `f` is the target of both a read and a store in the flow covered
 * by `nodeCand1`.
 */
private predicate nodeCand1IsReadAndStored(Content f, Configuration conf) {
  nodeCand1IsRead(f, conf) and
  nodeCand1Store(f, _, _, conf)
}

pragma[nomagic]
private predicate viableReturnPosOutNodeCandFwd1(
  DataFlowCall call, ReturnPosition pos, Node out, Configuration config
) {
  nodeCandFwd1ReturnPosition(pos, _, config) and
  viableReturnPosOut(call, pos, out)
}

pragma[nomagic]
private predicate nodeCand1Out(ReturnPosition pos, Configuration config) {
  exists(DataFlowCall call, Node out |
    nodeCand1(out, _, config) and
    viableReturnPosOutNodeCandFwd1(call, pos, out, config)
  )
}

pragma[nomagic]
private predicate viableParamArgNodeCandFwd1(
  DataFlowCall call, ParameterNode p, ArgumentNode arg, Configuration config
) {
  viableParamArg(call, p, arg) and
  nodeCandFwd1(arg, config)
}

pragma[nomagic]
private predicate nodeCand1In(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, Configuration config
) {
  exists(ParameterNode p |
    nodeCand1(p, toReturn, config) and
    viableParamArgNodeCandFwd1(call, p, arg, config)
  )
}

pragma[nomagic]
private predicate nodeCand1InToReturn(DataFlowCall call, ArgumentNode arg, Configuration config) {
  nodeCand1In(call, arg, true, config)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate nodeCand1IsReturned(DataFlowCall call, boolean toReturn, Configuration config) {
  exists(Node out |
    nodeCand1(out, toReturn, config) and
    nodeCandFwd1OutFromArg(call, out, config)
  )
}

pragma[nomagic]
private predicate nodeCand1(Node node, Configuration config) { nodeCand1(node, _, config) }

private predicate throughFlowNodeCand1(Node node, Configuration config) {
  nodeCand1(node, true, config) and
  not fullBarrier(node, config) and
  not inBarrier(node, config) and
  not outBarrier(node, config)
}

/** Holds if flow may return from `callable`. */
pragma[nomagic]
private predicate returnFlowCallableNodeCand1(
  DataFlowCallable callable, ReturnKindExt kind, Configuration config
) {
  exists(ReturnNodeExt ret |
    throughFlowNodeCand1(ret, config) and
    callable = ret.getEnclosingCallable() and
    kind = ret.getKind()
  )
}

/**
 * Holds if flow may enter through `p` and reach a return node making `p` a
 * candidate for the origin of a summary.
 */
private predicate parameterThroughFlowNodeCand1(ParameterNode p, Configuration config) {
  exists(ReturnKindExt kind |
    throughFlowNodeCand1(p, config) and
    returnFlowCallableNodeCand1(p.getEnclosingCallable(), kind, config) and
    // we don't expect a parameter to return stored in itself
    not exists(int pos |
      kind.(ParamUpdateReturnKind).getPosition() = pos and p.isParameterOf(_, pos)
    )
  )
}

pragma[nomagic]
private predicate store(Node n1, Content f, Node n2, Configuration config) {
  nodeCand1IsReadAndStored(f, config) and
  nodeCand1(n2, unbind(config)) and
  store(n1, f, n2)
}

pragma[nomagic]
private predicate read(Node n1, Content f, Node n2, Configuration config) {
  nodeCand1IsReadAndStored(f, config) and
  nodeCand1(n2, unbind(config)) and
  read(n1, f, n2)
}

pragma[noinline]
private predicate localFlowStepNodeCand1(Node node1, Node node2, Configuration config) {
  nodeCand1(node1, config) and
  localFlowStep(node1, node2, config)
}

pragma[noinline]
private predicate additionalLocalFlowStepNodeCand1(Node node1, Node node2, Configuration config) {
  nodeCand1(node1, config) and
  additionalLocalFlowStep(node1, node2, config)
}

pragma[nomagic]
private predicate viableReturnPosOutNodeCand1(
  DataFlowCall call, ReturnPosition pos, Node out, Configuration config
) {
  nodeCand1(out, _, config) and
  viableReturnPosOutNodeCandFwd1(call, pos, out, config)
}

/**
 * Holds if data can flow out of `call` from `ret` to `out`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink.
 */
pragma[nomagic]
private predicate flowOutOfCallNodeCand1(
  DataFlowCall call, ReturnNodeExt ret, Node out, Configuration config
) {
  viableReturnPosOutNodeCand1(call, getReturnPosition(ret), out, config) and
  nodeCand1(ret, config) and
  not outBarrier(ret, config) and
  not inBarrier(out, config)
}

pragma[nomagic]
private predicate viableParamArgNodeCand1(
  DataFlowCall call, ParameterNode p, ArgumentNode arg, Configuration config
) {
  viableParamArgNodeCandFwd1(call, p, arg, config) and
  nodeCand1(arg, config)
}

/**
 * Holds if data can flow into `call` and that this step is part of a
 * path from a source to a sink.
 */
pragma[nomagic]
private predicate flowIntoCallNodeCand1(
  DataFlowCall call, ArgumentNode arg, ParameterNode p, Configuration config
) {
  viableParamArgNodeCand1(call, p, arg, config) and
  nodeCand1(p, config) and
  not outBarrier(arg, config) and
  not inBarrier(p, config)
}

/**
 * Gets the amount of forward branching on the origin of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int branch(Node n1, Configuration conf) {
  result =
    strictcount(Node n |
      flowOutOfCallNodeCand1(_, n1, n, conf) or flowIntoCallNodeCand1(_, n1, n, conf)
    )
}

/**
 * Gets the amount of backward branching on the target of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int join(Node n2, Configuration conf) {
  result =
    strictcount(Node n |
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
  DataFlowCall call, ReturnNodeExt ret, Node out, boolean allowsFieldFlow, Configuration config
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
  DataFlowCall call, ArgumentNode arg, ParameterNode p, boolean allowsFieldFlow,
  Configuration config
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

/**
 * Holds if `node` is reachable from a source in the configuration `config`.
 * The Boolean `stored` records whether the tracked value is stored into a
 * field of `node`.
 *
 * The Boolean `fromArg` records whether the node is reached through an
 * argument in a call, and if so, `argStored` records whether the tracked
 * value was stored into a field of the argument.
 */
private predicate nodeCandFwd2(
  Node node, boolean fromArg, BooleanOption argStored, boolean stored, Configuration config
) {
  nodeCand1(node, config) and
  config.isSource(node) and
  fromArg = false and
  argStored = TBooleanNone() and
  stored = false
  or
  nodeCand1(node, unbind(config)) and
  (
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, argStored, stored, config) and
      localFlowStepNodeCand1(mid, node, config)
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, argStored, stored, config) and
      additionalLocalFlowStepNodeCand1(mid, node, config) and
      stored = false
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, _, _, stored, config) and
      jumpStep(mid, node, config) and
      fromArg = false and
      argStored = TBooleanNone()
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, _, _, stored, config) and
      additionalJumpStep(mid, node, config) and
      fromArg = false and
      argStored = TBooleanNone() and
      stored = false
    )
    or
    // store
    exists(Node mid, Content f |
      nodeCandFwd2(mid, fromArg, argStored, _, config) and
      store(mid, f, node, config) and
      stored = true
    )
    or
    // read
    exists(Content f |
      nodeCandFwd2Read(f, node, fromArg, argStored, config) and
      nodeCandFwd2IsStored(f, stored, config)
    )
    or
    // flow into a callable
    nodeCandFwd2In(_, node, _, _, stored, config) and
    fromArg = true and
    if parameterThroughFlowNodeCand1(node, config)
    then argStored = TBooleanSome(stored)
    else argStored = TBooleanNone()
    or
    // flow out of a callable
    exists(DataFlowCall call |
      nodeCandFwd2Out(call, node, fromArg, argStored, stored, config) and
      fromArg = false
      or
      exists(boolean argStored0 |
        nodeCandFwd2OutFromArg(call, node, argStored0, stored, config) and
        nodeCandFwd2IsEntered(call, fromArg, argStored, argStored0, config)
      )
    )
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCandFwd2`.
 */
pragma[noinline]
private predicate nodeCandFwd2IsStored(Content f, boolean stored, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCand1(node, unbind(config)) and
    nodeCandFwd2(mid, _, _, stored, config) and
    store(mid, f, node, config)
  )
}

pragma[nomagic]
private predicate nodeCandFwd2Read(
  Content f, Node node, boolean fromArg, BooleanOption argStored, Configuration config
) {
  exists(Node mid |
    nodeCandFwd2(mid, fromArg, argStored, true, config) and
    read(mid, f, node, config)
  )
}

pragma[nomagic]
private predicate nodeCandFwd2In(
  DataFlowCall call, ParameterNode p, boolean fromArg, BooleanOption argStored, boolean stored,
  Configuration config
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow |
    nodeCandFwd2(arg, fromArg, argStored, stored, config) and
    flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow, config)
  |
    stored = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCandFwd2Out(
  DataFlowCall call, Node out, boolean fromArg, BooleanOption argStored, boolean stored,
  Configuration config
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    nodeCandFwd2(ret, fromArg, argStored, stored, config) and
    flowOutOfCallNodeCand1(call, ret, out, allowsFieldFlow, config)
  |
    stored = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCandFwd2OutFromArg(
  DataFlowCall call, Node out, boolean argStored, boolean stored, Configuration config
) {
  nodeCandFwd2Out(call, out, true, TBooleanSome(argStored), stored, config)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `nodeCandFwd2`.
 */
pragma[nomagic]
private predicate nodeCandFwd2IsEntered(
  DataFlowCall call, boolean fromArg, BooleanOption argStored, boolean stored, Configuration config
) {
  exists(ParameterNode p |
    nodeCandFwd2In(call, p, fromArg, argStored, stored, config) and
    parameterThroughFlowNodeCand1(p, config)
  )
}

/**
 * Holds if `node` is part of a path from a source to a sink in the
 * configuration `config`. The Boolean `read` records whether the tracked
 * value must be read from a field of `node` in order to reach a sink.
 *
 * The Boolean `toReturn` records whether the node must be returned from
 * the enclosing callable in order to reach a sink, and if so, `returnRead`
 * records whether a field must be read from the returned value.
 */
private predicate nodeCand2(
  Node node, boolean toReturn, BooleanOption returnRead, boolean read, Configuration config
) {
  nodeCandFwd2(node, _, _, false, config) and
  config.isSink(node) and
  toReturn = false and
  returnRead = TBooleanNone() and
  read = false
  or
  nodeCandFwd2(node, _, _, unbindBool(read), unbind(config)) and
  (
    exists(Node mid |
      localFlowStepNodeCand1(node, mid, config) and
      nodeCand2(mid, toReturn, returnRead, read, config)
    )
    or
    exists(Node mid |
      additionalLocalFlowStepNodeCand1(node, mid, config) and
      nodeCand2(mid, toReturn, returnRead, read, config) and
      read = false
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      nodeCand2(mid, _, _, read, config) and
      toReturn = false and
      returnRead = TBooleanNone()
    )
    or
    exists(Node mid |
      additionalJumpStep(node, mid, config) and
      nodeCand2(mid, _, _, read, config) and
      toReturn = false and
      returnRead = TBooleanNone() and
      read = false
    )
    or
    // store
    exists(Content f |
      nodeCand2Store(f, node, toReturn, returnRead, read, config) and
      nodeCand2IsRead(f, read, config)
    )
    or
    // read
    exists(Node mid, Content f, boolean read0 |
      read(node, f, mid, config) and
      nodeCandFwd2IsStored(f, unbindBool(read0), unbind(config)) and
      nodeCand2(mid, toReturn, returnRead, read0, config) and
      read = true
    )
    or
    // flow into a callable
    exists(DataFlowCall call |
      nodeCand2In(call, node, toReturn, returnRead, read, config) and
      toReturn = false
      or
      exists(boolean returnRead0 |
        nodeCand2InToReturn(call, node, returnRead0, read, config) and
        nodeCand2IsReturned(call, toReturn, returnRead, returnRead0, config)
      )
    )
    or
    // flow out of a callable
    nodeCand2Out(_, node, _, _, read, config) and
    toReturn = true and
    if nodeCandFwd2(node, true, TBooleanSome(_), unbindBool(read), config)
    then returnRead = TBooleanSome(read)
    else returnRead = TBooleanNone()
  )
}

/**
 * Holds if `f` is the target of a read in the flow covered by `nodeCand2`.
 */
pragma[noinline]
private predicate nodeCand2IsRead(Content f, boolean read, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd2(node, _, _, true, unbind(config)) and
    read(node, f, mid, config) and
    nodeCandFwd2IsStored(f, unbindBool(read), unbind(config)) and
    nodeCand2(mid, _, _, read, config)
  )
}

pragma[nomagic]
private predicate nodeCand2Store(
  Content f, Node node, boolean toReturn, BooleanOption returnRead, boolean stored,
  Configuration config
) {
  exists(Node mid |
    store(node, f, mid, config) and
    nodeCand2(mid, toReturn, returnRead, true, config) and
    nodeCandFwd2(node, _, _, stored, unbind(config))
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCand2`.
 */
pragma[nomagic]
private predicate nodeCand2IsStored(Content f, boolean stored, Configuration conf) {
  exists(Node node |
    nodeCand2Store(f, node, _, _, stored, conf) and
    nodeCand2(node, _, _, stored, conf)
  )
}

/**
 * Holds if `f` is the target of both a store and a read in the path graph
 * covered by `nodeCand2`.
 */
pragma[noinline]
private predicate nodeCand2IsReadAndStored(Content f, Configuration conf) {
  exists(boolean apNonEmpty |
    nodeCand2IsStored(f, apNonEmpty, conf) and
    nodeCand2IsRead(f, apNonEmpty, conf)
  )
}

pragma[nomagic]
private predicate nodeCand2Out(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, BooleanOption returnRead, boolean read,
  Configuration config
) {
  exists(Node out, boolean allowsFieldFlow |
    nodeCand2(out, toReturn, returnRead, read, config) and
    flowOutOfCallNodeCand1(call, ret, out, allowsFieldFlow, config)
  |
    read = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCand2In(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, BooleanOption returnRead, boolean read,
  Configuration config
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    nodeCand2(p, toReturn, returnRead, read, config) and
    flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow, config)
  |
    read = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCand2InToReturn(
  DataFlowCall call, ArgumentNode arg, boolean returnRead, boolean read, Configuration config
) {
  nodeCand2In(call, arg, true, TBooleanSome(returnRead), read, config)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `nodeCand2`.
 */
pragma[nomagic]
private predicate nodeCand2IsReturned(
  DataFlowCall call, boolean toReturn, BooleanOption returnRead, boolean read, Configuration config
) {
  exists(ReturnNodeExt ret |
    nodeCand2Out(call, ret, toReturn, returnRead, read, config) and
    nodeCandFwd2(ret, true, TBooleanSome(_), read, config)
  )
}

private predicate nodeCand2(Node node, Configuration config) { nodeCand2(node, _, _, _, config) }

pragma[nomagic]
private predicate flowOutOfCallNodeCand2(
  DataFlowCall call, ReturnNodeExt node1, Node node2, boolean allowsFieldFlow, Configuration config
) {
  flowOutOfCallNodeCand1(call, node1, node2, allowsFieldFlow, config) and
  nodeCand2(node2, config) and
  nodeCand2(node1, unbind(config))
}

pragma[nomagic]
private predicate flowIntoCallNodeCand2(
  DataFlowCall call, ArgumentNode node1, ParameterNode node2, boolean allowsFieldFlow,
  Configuration config
) {
  flowIntoCallNodeCand1(call, node1, node2, allowsFieldFlow, config) and
  nodeCand2(node2, config) and
  nodeCand2(node1, unbind(config))
}

private module LocalFlowBigStep {
  /**
   * Holds if `node` can be the first node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  private predicate localFlowEntry(Node node, Configuration config) {
    nodeCand2(node, config) and
    (
      config.isSource(node) or
      jumpStep(_, node, config) or
      additionalJumpStep(_, node, config) or
      node instanceof ParameterNode or
      node instanceof OutNodeExt or
      store(_, _, node) or
      read(_, _, node) or
      node instanceof CastNode
    )
  }

  /**
   * Holds if `node` can be the last node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  private predicate localFlowExit(Node node, Configuration config) {
    exists(Node next | nodeCand2(next, config) |
      jumpStep(node, next, config) or
      additionalJumpStep(node, next, config) or
      flowIntoCallNodeCand1(_, node, next, config) or
      flowOutOfCallNodeCand1(_, node, next, config) or
      store(node, _, next) or
      read(node, _, next)
    )
    or
    node instanceof CastNode
    or
    config.isSink(node)
  }

  pragma[noinline]
  private predicate additionalLocalFlowStepNodeCand2(Node node1, Node node2, Configuration config) {
    additionalLocalFlowStepNodeCand1(node1, node2, config) and
    nodeCand2(node1, _, _, false, config) and
    nodeCand2(node2, _, _, false, unbind(config))
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
    Node node1, Node node2, boolean preservesValue, DataFlowType t, Configuration config,
    LocalCallContext cc
  ) {
    not isUnreachableInCall(node2, cc.(LocalCallContextSpecificCall).getCall()) and
    (
      localFlowEntry(node1, config) and
      (
        localFlowStepNodeCand1(node1, node2, config) and
        preservesValue = true and
        t = getErasedNodeTypeBound(node1)
        or
        additionalLocalFlowStepNodeCand2(node1, node2, config) and
        preservesValue = false and
        t = getErasedNodeTypeBound(node2)
      ) and
      node1 != node2 and
      cc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall(node1, cc.(LocalCallContextSpecificCall).getCall()) and
      nodeCand2(node2, unbind(config))
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, preservesValue, t, config, cc) and
        localFlowStepNodeCand1(mid, node2, config) and
        not mid instanceof CastNode and
        nodeCand2(node2, unbind(config))
      )
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, _, _, config, cc) and
        additionalLocalFlowStepNodeCand2(mid, node2, config) and
        not mid instanceof CastNode and
        preservesValue = false and
        t = getErasedNodeTypeBound(node2) and
        nodeCand2(node2, unbind(config))
      )
    )
  }

  /**
   * Holds if `node1` can step to `node2` in one or more local steps and this
   * path can occur as a maximal subsequence of local steps in a dataflow path.
   */
  pragma[nomagic]
  predicate localFlowBigStep(
    Node node1, Node node2, boolean preservesValue, AccessPathFrontNil apf, Configuration config,
    LocalCallContext callContext
  ) {
    localFlowStepPlus(node1, node2, preservesValue, apf.getType(), config, callContext) and
    localFlowExit(node2, config)
  }
}

private import LocalFlowBigStep

pragma[nomagic]
private predicate readCand2(Node node1, Content f, Node node2, Configuration config) {
  read(node1, f, node2, config) and
  nodeCand2(node1, _, _, true, unbind(config)) and
  nodeCand2(node2, config) and
  nodeCand2IsReadAndStored(f, unbind(config))
}

pragma[nomagic]
private predicate storeCand2(Node node1, Content f, Node node2, Configuration config) {
  store(node1, f, node2, config) and
  nodeCand2(node1, config) and
  nodeCand2(node2, _, _, true, unbind(config)) and
  nodeCand2IsReadAndStored(f, unbind(config))
}

/**
 * Holds if `node` is reachable with access path front `apf` from a
 * source in the configuration `config`.
 *
 * The Boolean `fromArg` records whether the node is reached through an
 * argument in a call, and if so, `argApf` records the front of the
 * access path of that argument.
 */
pragma[nomagic]
private predicate flowCandFwd(
  Node node, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf,
  Configuration config
) {
  flowCandFwd0(node, fromArg, argApf, apf, config) and
  if node instanceof CastingNode
  then compatibleTypes(getErasedNodeTypeBound(node), apf.getType())
  else any()
}

pragma[nomagic]
private predicate flowCandFwd0(
  Node node, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf,
  Configuration config
) {
  nodeCand2(node, _, _, false, config) and
  config.isSource(node) and
  fromArg = false and
  argApf = TAccessPathFrontNone() and
  apf = TFrontNil(getErasedNodeTypeBound(node))
  or
  exists(Node mid |
    flowCandFwd(mid, fromArg, argApf, apf, config) and
    localFlowBigStep(mid, node, true, _, config, _)
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(mid, fromArg, argApf, nil, config) and
    localFlowBigStep(mid, node, false, apf, config, _)
  )
  or
  exists(Node mid |
    flowCandFwd(mid, _, _, apf, config) and
    nodeCand2(node, unbind(config)) and
    jumpStep(mid, node, config) and
    fromArg = false and
    argApf = TAccessPathFrontNone()
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(mid, _, _, nil, config) and
    nodeCand2(node, unbind(config)) and
    additionalJumpStep(mid, node, config) and
    fromArg = false and
    argApf = TAccessPathFrontNone() and
    apf = TFrontNil(getErasedNodeTypeBound(node))
  )
  or
  // store
  exists(Node mid, Content f |
    flowCandFwd(mid, fromArg, argApf, _, config) and
    storeCand2(mid, f, node, config) and
    nodeCand2(node, _, _, true, unbind(config)) and
    apf.headUsesContent(f)
  )
  or
  // read
  exists(Content f |
    flowCandFwdRead(f, node, fromArg, argApf, config) and
    flowCandFwdConsCand(f, apf, config) and
    nodeCand2(node, _, _, unbindBool(apf.toBoolNonEmpty()), unbind(config))
  )
  or
  // flow into a callable
  flowCandFwdIn(_, node, _, _, apf, config) and
  fromArg = true and
  if nodeCand2(node, true, _, unbindBool(apf.toBoolNonEmpty()), config)
  then argApf = TAccessPathFrontSome(apf)
  else argApf = TAccessPathFrontNone()
  or
  // flow out of a callable
  exists(DataFlowCall call |
    flowCandFwdOut(call, node, fromArg, argApf, apf, config) and
    fromArg = false
    or
    exists(AccessPathFront argApf0 |
      flowCandFwdOutFromArg(call, node, argApf0, apf, config) and
      flowCandFwdIsEntered(call, fromArg, argApf, argApf0, config)
    )
  )
}

pragma[nomagic]
private predicate flowCandFwdConsCand(Content f, AccessPathFront apf, Configuration config) {
  exists(Node mid, Node n |
    flowCandFwd(mid, _, _, apf, config) and
    storeCand2(mid, f, n, config) and
    nodeCand2(n, _, _, true, unbind(config)) and
    compatibleTypes(apf.getType(), f.getType())
  )
}

pragma[nomagic]
private predicate flowCandFwdRead(
  Content f, Node node, boolean fromArg, AccessPathFrontOption argApf, Configuration config
) {
  exists(Node mid, AccessPathFrontHead apf0 |
    flowCandFwd(mid, fromArg, argApf, apf0, config) and
    readCand2(mid, f, node, config) and
    apf0.headUsesContent(f)
  )
}

pragma[nomagic]
private predicate flowCandFwdIn(
  DataFlowCall call, ParameterNode p, boolean fromArg, AccessPathFrontOption argApf,
  AccessPathFront apf, Configuration config
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow |
    flowCandFwd(arg, fromArg, argApf, apf, config) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandFwdOut(
  DataFlowCall call, Node node, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf,
  Configuration config
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    flowCandFwd(ret, fromArg, argApf, apf, config) and
    flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow, config)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandFwdOutFromArg(
  DataFlowCall call, Node node, AccessPathFront argApf, AccessPathFront apf, Configuration config
) {
  flowCandFwdOut(call, node, true, TAccessPathFrontSome(argApf), apf, config)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `flowCandFwd`.
 */
pragma[nomagic]
private predicate flowCandFwdIsEntered(
  DataFlowCall call, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf,
  Configuration config
) {
  exists(ParameterNode p |
    flowCandFwdIn(call, p, fromArg, argApf, apf, config) and
    nodeCand2(p, true, TBooleanSome(_), unbindBool(apf.toBoolNonEmpty()), config)
  )
}

/**
 * Holds if `node` with access path front `apf` is part of a path from a
 * source to a sink in the configuration `config`.
 *
 * The Boolean `toReturn` records whether the node must be returned from
 * the enclosing callable in order to reach a sink, and if so, `returnApf`
 * records the front of the access path of the returned value.
 */
pragma[nomagic]
private predicate flowCand(
  Node node, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf,
  Configuration config
) {
  flowCand0(node, toReturn, returnApf, apf, config) and
  flowCandFwd(node, _, _, apf, config)
}

pragma[nomagic]
private predicate flowCand0(
  Node node, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf,
  Configuration config
) {
  flowCandFwd(node, _, _, apf, config) and
  config.isSink(node) and
  toReturn = false and
  returnApf = TAccessPathFrontNone() and
  apf instanceof AccessPathFrontNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, _, config, _) and
    flowCand(mid, toReturn, returnApf, apf, config)
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, _, apf, config) and
    localFlowBigStep(node, mid, false, _, config, _) and
    flowCand(mid, toReturn, returnApf, nil, config) and
    apf instanceof AccessPathFrontNil
  )
  or
  exists(Node mid |
    jumpStep(node, mid, config) and
    flowCand(mid, _, _, apf, config) and
    toReturn = false and
    returnApf = TAccessPathFrontNone()
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, _, apf, config) and
    additionalJumpStep(node, mid, config) and
    flowCand(mid, _, _, nil, config) and
    toReturn = false and
    returnApf = TAccessPathFrontNone() and
    apf instanceof AccessPathFrontNil
  )
  or
  // store
  exists(Content f, AccessPathFrontHead apf0 |
    flowCandStore(node, f, toReturn, returnApf, apf0, config) and
    apf0.headUsesContent(f) and
    flowCandConsCand(f, apf, config)
  )
  or
  // read
  exists(Content f, AccessPathFront apf0 |
    flowCandRead(node, f, toReturn, returnApf, apf0, config) and
    flowCandFwdConsCand(f, apf0, config) and
    apf.headUsesContent(f)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    flowCandIn(call, node, toReturn, returnApf, apf, config) and
    toReturn = false
    or
    exists(AccessPathFront returnApf0 |
      flowCandInToReturn(call, node, returnApf0, apf, config) and
      flowCandIsReturned(call, toReturn, returnApf, returnApf0, config)
    )
  )
  or
  // flow out of a callable
  flowCandOut(_, node, _, _, apf, config) and
  toReturn = true and
  if flowCandFwd(node, true, _, apf, config)
  then returnApf = TAccessPathFrontSome(apf)
  else returnApf = TAccessPathFrontNone()
}

pragma[nomagic]
private predicate flowCandRead(
  Node node, Content f, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf0,
  Configuration config
) {
  exists(Node mid |
    readCand2(node, f, mid, config) and
    flowCand(mid, toReturn, returnApf, apf0, config)
  )
}

pragma[nomagic]
private predicate flowCandStore(
  Node node, Content f, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFrontHead apf0,
  Configuration config
) {
  exists(Node mid |
    storeCand2(node, f, mid, config) and
    flowCand(mid, toReturn, returnApf, apf0, config)
  )
}

pragma[nomagic]
private predicate flowCandConsCand(Content f, AccessPathFront apf, Configuration config) {
  flowCandFwdConsCand(f, apf, config) and
  exists(Node n, AccessPathFrontHead apf0 |
    flowCandFwd(n, _, _, apf0, config) and
    apf0.headUsesContent(f) and
    flowCandRead(n, f, _, _, apf, config)
  )
}

pragma[nomagic]
private predicate flowCandOut(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, AccessPathFrontOption returnApf,
  AccessPathFront apf, Configuration config
) {
  exists(Node out, boolean allowsFieldFlow |
    flowCand(out, toReturn, returnApf, apf, config) and
    flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow, config)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandIn(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, AccessPathFrontOption returnApf,
  AccessPathFront apf, Configuration config
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    flowCand(p, toReturn, returnApf, apf, config) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandInToReturn(
  DataFlowCall call, ArgumentNode arg, AccessPathFront returnApf, AccessPathFront apf,
  Configuration config
) {
  flowCandIn(call, arg, true, TAccessPathFrontSome(returnApf), apf, config)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `flowCand`.
 */
pragma[nomagic]
private predicate flowCandIsReturned(
  DataFlowCall call, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf,
  Configuration config
) {
  exists(ReturnNodeExt ret |
    flowCandOut(call, ret, toReturn, returnApf, apf, config) and
    flowCandFwd(ret, true, TAccessPathFrontSome(_), apf, config)
  )
}

private newtype TAccessPath =
  TNil(DataFlowType t) or
  TConsNil(Content f, DataFlowType t) { flowCandConsCand(f, TFrontNil(t), _) } or
  TConsCons(Content f1, Content f2, int len) {
    flowCandConsCand(f1, TFrontHead(f2), _) and len in [2 .. accessPathLimit()]
  }

/**
 * Conceptually a list of `Content`s followed by a `Type`, but only the first two
 * elements of the list and its length are tracked. If data flows from a source to
 * a given node with a given `AccessPath`, this indicates the sequence of
 * dereference operations needed to get from the value in the node to the
 * tracked object. The final type indicates the type of the tracked object.
 */
abstract private class AccessPath extends TAccessPath {
  abstract string toString();

  abstract Content getHead();

  abstract int len();

  abstract DataFlowType getType();

  abstract AccessPathFront getFront();

  /**
   * Holds if this access path has `head` at the front and may be followed by `tail`.
   */
  abstract predicate pop(Content head, AccessPath tail);
}

private class AccessPathNil extends AccessPath, TNil {
  private DataFlowType t;

  AccessPathNil() { this = TNil(t) }

  override string toString() { result = concat(": " + ppReprType(t)) }

  override Content getHead() { none() }

  override int len() { result = 0 }

  override DataFlowType getType() { result = t }

  override AccessPathFront getFront() { result = TFrontNil(t) }

  override predicate pop(Content head, AccessPath tail) { none() }
}

abstract private class AccessPathCons extends AccessPath { }

private class AccessPathConsNil extends AccessPathCons, TConsNil {
  private Content f;
  private DataFlowType t;

  AccessPathConsNil() { this = TConsNil(f, t) }

  override string toString() {
    // The `concat` becomes "" if `ppReprType` has no result.
    result = "[" + f.toString() + "]" + concat(" : " + ppReprType(t))
  }

  override Content getHead() { result = f }

  override int len() { result = 1 }

  override DataFlowType getType() { result = f.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(f) }

  override predicate pop(Content head, AccessPath tail) { head = f and tail = TNil(t) }
}

private class AccessPathConsCons extends AccessPathCons, TConsCons {
  private Content f1;
  private Content f2;
  private int len;

  AccessPathConsCons() { this = TConsCons(f1, f2, len) }

  override string toString() {
    if len = 2
    then result = "[" + f1.toString() + ", " + f2.toString() + "]"
    else result = "[" + f1.toString() + ", " + f2.toString() + ", ... (" + len.toString() + ")]"
  }

  override Content getHead() { result = f1 }

  override int len() { result = len }

  override DataFlowType getType() { result = f1.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(f1) }

  override predicate pop(Content head, AccessPath tail) {
    head = f1 and
    (
      tail = TConsCons(f2, _, len - 1)
      or
      len = 2 and
      tail = TConsNil(f2, _)
    )
  }
}

/** Gets the access path obtained by popping `f` from `ap`, if any. */
private AccessPath pop(Content f, AccessPath ap) { ap.pop(f, result) }

/** Gets the access path obtained by pushing `f` onto `ap`. */
private AccessPath push(Content f, AccessPath ap) { ap = pop(f, result) }

private newtype TAccessPathOption =
  TAccessPathNone() or
  TAccessPathSome(AccessPath ap)

private class AccessPathOption extends TAccessPathOption {
  string toString() {
    this = TAccessPathNone() and result = "<none>"
    or
    this = TAccessPathSome(any(AccessPath ap | result = ap.toString()))
  }
}

/**
 * Holds if `node` is reachable with access path `ap` from a source in
 * the configuration `config`.
 *
 * The Boolean `fromArg` records whether the node is reached through an
 * argument in a call, and if so, `argAp` records the access path of that
 * argument.
 */
private predicate flowFwd(
  Node node, boolean fromArg, AccessPathOption argAp, AccessPathFront apf, AccessPath ap,
  Configuration config
) {
  flowFwd0(node, fromArg, argAp, apf, ap, config) and
  flowCand(node, _, _, apf, config)
}

private predicate flowFwd0(
  Node node, boolean fromArg, AccessPathOption argAp, AccessPathFront apf, AccessPath ap,
  Configuration config
) {
  flowCand(node, _, _, _, config) and
  config.isSource(node) and
  fromArg = false and
  argAp = TAccessPathNone() and
  ap = TNil(getErasedNodeTypeBound(node)) and
  apf = ap.(AccessPathNil).getFront()
  or
  flowCand(node, _, _, _, unbind(config)) and
  (
    exists(Node mid |
      flowFwd(mid, fromArg, argAp, apf, ap, config) and
      localFlowBigStep(mid, node, true, _, config, _)
    )
    or
    exists(Node mid, AccessPathNil nil |
      flowFwd(mid, fromArg, argAp, _, nil, config) and
      localFlowBigStep(mid, node, false, apf, config, _) and
      apf = ap.(AccessPathNil).getFront()
    )
    or
    exists(Node mid |
      flowFwd(mid, _, _, apf, ap, config) and
      jumpStep(mid, node, config) and
      fromArg = false and
      argAp = TAccessPathNone()
    )
    or
    exists(Node mid, AccessPathNil nil |
      flowFwd(mid, _, _, _, nil, config) and
      additionalJumpStep(mid, node, config) and
      fromArg = false and
      argAp = TAccessPathNone() and
      ap = TNil(getErasedNodeTypeBound(node)) and
      apf = ap.(AccessPathNil).getFront()
    )
  )
  or
  // store
  exists(Content f, AccessPath ap0 |
    flowFwdStore(node, f, ap0, apf, fromArg, argAp, config) and
    ap = push(f, ap0)
  )
  or
  // read
  exists(Content f |
    flowFwdRead(node, f, push(f, ap), fromArg, argAp, config) and
    flowFwdConsCand(f, apf, ap, config)
  )
  or
  // flow into a callable
  flowFwdIn(_, node, _, _, apf, ap, config) and
  fromArg = true and
  if flowCand(node, true, _, apf, config)
  then argAp = TAccessPathSome(ap)
  else argAp = TAccessPathNone()
  or
  // flow out of a callable
  exists(DataFlowCall call |
    flowFwdOut(call, node, fromArg, argAp, apf, ap, config) and
    fromArg = false
    or
    exists(AccessPath argAp0 |
      flowFwdOutFromArg(call, node, argAp0, apf, ap, config) and
      flowFwdIsEntered(call, fromArg, argAp, argAp0, config)
    )
  )
}

pragma[nomagic]
private predicate flowFwdStore(
  Node node, Content f, AccessPath ap0, AccessPathFront apf, boolean fromArg,
  AccessPathOption argAp, Configuration config
) {
  exists(Node mid, AccessPathFront apf0 |
    flowFwd(mid, fromArg, argAp, apf0, ap0, config) and
    flowFwdStore1(mid, f, node, apf0, apf, config)
  )
}

pragma[nomagic]
private predicate flowFwdStore0(
  Node mid, Content f, Node node, AccessPathFront apf0, Configuration config
) {
  storeCand2(mid, f, node, config) and
  flowCand(mid, _, _, apf0, config)
}

pragma[noinline]
private predicate flowFwdStore1(
  Node mid, Content f, Node node, AccessPathFront apf0, AccessPathFrontHead apf,
  Configuration config
) {
  flowFwdStore0(mid, f, node, apf0, config) and
  flowCandConsCand(f, apf0, config) and
  apf.headUsesContent(f) and
  flowCand(node, _, _, apf, unbind(config))
}

pragma[nomagic]
private predicate flowFwdRead(
  Node node, Content f, AccessPath ap0, boolean fromArg, AccessPathOption argAp,
  Configuration config
) {
  exists(Node mid, AccessPathFrontHead apf0 |
    flowFwd(mid, fromArg, argAp, apf0, ap0, config) and
    readCand2(mid, f, node, config) and
    apf0.headUsesContent(f) and
    flowCand(node, _, _, _, unbind(config))
  )
}

pragma[nomagic]
private predicate flowFwdConsCand(
  Content f, AccessPathFront apf, AccessPath ap, Configuration config
) {
  exists(Node n |
    flowFwd(n, _, _, apf, ap, config) and
    flowFwdStore1(n, f, _, apf, _, config)
  )
}

pragma[nomagic]
private predicate flowFwdIn(
  DataFlowCall call, ParameterNode p, boolean fromArg, AccessPathOption argAp, AccessPathFront apf,
  AccessPath ap, Configuration config
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow |
    flowFwd(arg, fromArg, argAp, apf, ap, config) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config) and
    flowCand(p, _, _, _, unbind(config))
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowFwdOut(
  DataFlowCall call, Node node, boolean fromArg, AccessPathOption argAp, AccessPathFront apf,
  AccessPath ap, Configuration config
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    flowFwd(ret, fromArg, argAp, apf, ap, config) and
    flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow, config) and
    flowCand(node, _, _, _, unbind(config))
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowFwdOutFromArg(
  DataFlowCall call, Node node, AccessPath argAp, AccessPathFront apf, AccessPath ap,
  Configuration config
) {
  flowFwdOut(call, node, true, TAccessPathSome(argAp), apf, ap, config)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `flowFwd`.
 */
pragma[nomagic]
private predicate flowFwdIsEntered(
  DataFlowCall call, boolean fromArg, AccessPathOption argAp, AccessPath ap, Configuration config
) {
  exists(ParameterNode p, AccessPathFront apf |
    flowFwdIn(call, p, fromArg, argAp, apf, ap, config) and
    flowCand(p, true, TAccessPathFrontSome(_), apf, config)
  )
}

/**
 * Holds if `node` with access path `ap` is part of a path from a source to
 * a sink in the configuration `config`.
 *
 * The Boolean `toReturn` records whether the node must be returned from
 * the enclosing callable in order to reach a sink, and if so, `returnAp`
 * records the access path of the returned value.
 */
private predicate flow(
  Node node, boolean toReturn, AccessPathOption returnAp, AccessPath ap, Configuration config
) {
  flow0(node, toReturn, returnAp, ap, config) and
  flowFwd(node, _, _, _, ap, config)
}

private predicate flow0(
  Node node, boolean toReturn, AccessPathOption returnAp, AccessPath ap, Configuration config
) {
  flowFwd(node, _, _, _, ap, config) and
  config.isSink(node) and
  toReturn = false and
  returnAp = TAccessPathNone() and
  ap instanceof AccessPathNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, _, config, _) and
    flow(mid, toReturn, returnAp, ap, config)
  )
  or
  exists(Node mid, AccessPathNil nil |
    flowFwd(node, _, _, _, ap, config) and
    localFlowBigStep(node, mid, false, _, config, _) and
    flow(mid, toReturn, returnAp, nil, config) and
    ap instanceof AccessPathNil
  )
  or
  exists(Node mid |
    jumpStep(node, mid, config) and
    flow(mid, _, _, ap, config) and
    toReturn = false and
    returnAp = TAccessPathNone()
  )
  or
  exists(Node mid, AccessPathNil nil |
    flowFwd(node, _, _, _, ap, config) and
    additionalJumpStep(node, mid, config) and
    flow(mid, _, _, nil, config) and
    toReturn = false and
    returnAp = TAccessPathNone() and
    ap instanceof AccessPathNil
  )
  or
  // store
  exists(Content f |
    flowStore(f, node, toReturn, returnAp, ap, config) and
    flowConsCand(f, ap, config)
  )
  or
  // read
  exists(Node mid, AccessPath ap0 |
    readFlowFwd(node, _, mid, ap, ap0, config) and
    flow(mid, toReturn, returnAp, ap0, config)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    flowIn(call, node, toReturn, returnAp, ap, config) and
    toReturn = false
    or
    exists(AccessPath returnAp0 |
      flowInToReturn(call, node, returnAp0, ap, config) and
      flowIsReturned(call, toReturn, returnAp, returnAp0, config)
    )
  )
  or
  // flow out of a callable
  flowOut(_, node, _, _, ap, config) and
  toReturn = true and
  if flowFwd(node, true, TAccessPathSome(_), _, ap, config)
  then returnAp = TAccessPathSome(ap)
  else returnAp = TAccessPathNone()
}

pragma[nomagic]
private predicate storeFlowFwd(
  Node node1, Content f, Node node2, AccessPath ap, AccessPath ap0, Configuration config
) {
  storeCand2(node1, f, node2, config) and
  flowFwdStore(node2, f, ap, _, _, _, config) and
  ap0 = push(f, ap)
}

pragma[nomagic]
private predicate flowStore(
  Content f, Node node, boolean toReturn, AccessPathOption returnAp, AccessPath ap,
  Configuration config
) {
  exists(Node mid, AccessPath ap0 |
    storeFlowFwd(node, f, mid, ap, ap0, config) and
    flow(mid, toReturn, returnAp, ap0, config)
  )
}

pragma[nomagic]
private predicate readFlowFwd(
  Node node1, Content f, Node node2, AccessPath ap, AccessPath ap0, Configuration config
) {
  readCand2(node1, f, node2, config) and
  flowFwdRead(node2, f, ap, _, _, config) and
  ap0 = pop(f, ap) and
  flowFwdConsCand(f, _, ap0, unbind(config))
}

pragma[nomagic]
private predicate flowConsCand(Content f, AccessPath ap, Configuration config) {
  exists(Node n, Node mid |
    flow(mid, _, _, ap, config) and
    readFlowFwd(n, f, mid, _, ap, config)
  )
}

pragma[nomagic]
private predicate flowOut(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, AccessPathOption returnAp, AccessPath ap,
  Configuration config
) {
  exists(Node out, boolean allowsFieldFlow |
    flow(out, toReturn, returnAp, ap, config) and
    flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow, config)
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowIn(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, AccessPathOption returnAp, AccessPath ap,
  Configuration config
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    flow(p, toReturn, returnAp, ap, config) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowInToReturn(
  DataFlowCall call, ArgumentNode arg, AccessPath returnAp, AccessPath ap, Configuration config
) {
  flowIn(call, arg, true, TAccessPathSome(returnAp), ap, config)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `flow`.
 */
pragma[nomagic]
private predicate flowIsReturned(
  DataFlowCall call, boolean toReturn, AccessPathOption returnAp, AccessPath ap,
  Configuration config
) {
  exists(ReturnNodeExt ret |
    flowOut(call, ret, toReturn, returnAp, ap, config) and
    flowFwd(ret, true, TAccessPathSome(_), _, ap, config)
  )
}

bindingset[conf, result]
private Configuration unbind(Configuration conf) { result >= conf and result <= conf }

private predicate flow(Node n, Configuration config) { flow(n, _, _, _, config) }

pragma[noinline]
private predicate parameterFlow(
  ParameterNode p, AccessPath ap, DataFlowCallable c, Configuration config
) {
  flow(p, true, _, ap, config) and
  c = p.getEnclosingCallable()
}

private newtype TSummaryCtx =
  TSummaryCtxNone() or
  TSummaryCtxSome(ParameterNode p, AccessPath ap) {
    exists(ReturnNodeExt ret, Configuration config, AccessPath ap0 |
      parameterFlow(p, ap, ret.getEnclosingCallable(), config) and
      flow(ret, true, TAccessPathSome(_), ap0, config) and
      flowFwd(ret, true, TAccessPathSome(ap), _, ap0, config)
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
  private ParameterNode p;
  private AccessPath ap;

  SummaryCtxSome() { this = TSummaryCtxSome(p, ap) }

  int getParameterPos() { p.isParameterOf(_, result) }

  override string toString() { result = p + ": " + ap }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    p.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private newtype TPathNode =
  TPathNodeMid(Node node, CallContext cc, SummaryCtx sc, AccessPath ap, Configuration config) {
    // A PathNode is introduced by a source ...
    flow(node, config) and
    config.isSource(node) and
    cc instanceof CallContextAny and
    sc instanceof SummaryCtxNone and
    ap = TNil(getErasedNodeTypeBound(node))
    or
    // ... or a step from an existing PathNode to another node.
    exists(PathNodeMid mid |
      pathStep(mid, node, cc, sc, ap) and
      config = mid.getConfiguration() and
      flow(node, _, _, ap, unbind(config))
    )
  } or
  TPathNodeSink(Node node, Configuration config) {
    config.isSink(node) and
    flow(node, unbind(config)) and
    (
      // A sink that is also a source ...
      config.isSource(node)
      or
      // ... or a sink that can be reached from a source
      exists(PathNodeMid mid |
        pathStep(mid, node, _, _, any(AccessPathNil nil)) and
        config = unbind(mid.getConfiguration())
      )
    )
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
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }

  /** Gets the underlying `Node`. */
  Node getNode() { none() }

  /** Gets the associated configuration. */
  Configuration getConfiguration() { none() }

  /** Gets a successor of this node, if any. */
  PathNode getASuccessor() { none() }

  /** Holds if this node is a source. */
  predicate isSource() { none() }
}

abstract private class PathNodeImpl extends PathNode {
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

  override string toString() { result = this.getNode().toString() + ppAp() }

  override string toStringWithContext() { result = this.getNode().toString() + ppAp() + ppCtx() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
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

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  query predicate nodes(PathNode n, string key, string val) {
    reach(n) and key = "semmle.label" and val = n.toString()
  }
}

/**
 * An intermediate flow graph node. This is a triple consisting of a `Node`,
 * a `CallContext`, and a `Configuration`.
 */
private class PathNodeMid extends PathNodeImpl, TPathNodeMid {
  Node node;
  CallContext cc;
  SummaryCtx sc;
  AccessPath ap;
  Configuration config;

  PathNodeMid() { this = TPathNodeMid(node, cc, sc, ap, config) }

  override Node getNode() { result = node }

  CallContext getCallContext() { result = cc }

  SummaryCtx getSummaryCtx() { result = sc }

  AccessPath getAp() { result = ap }

  override Configuration getConfiguration() { result = config }

  private PathNodeMid getSuccMid() {
    pathStep(this, result.getNode(), result.getCallContext(), result.getSummaryCtx(), result.getAp()) and
    result.getConfiguration() = unbind(this.getConfiguration())
  }

  override PathNodeImpl getASuccessor() {
    // an intermediate step to another intermediate node
    result = getSuccMid()
    or
    // a final step to a sink via zero steps means we merge the last two steps to prevent trivial-looking edges
    exists(PathNodeMid mid, PathNodeSink sink |
      mid = getSuccMid() and
      mid.getNode() = sink.getNode() and
      mid.getAp() instanceof AccessPathNil and
      sink.getConfiguration() = unbind(mid.getConfiguration()) and
      result = sink
    )
  }

  override predicate isSource() {
    config.isSource(node) and
    cc instanceof CallContextAny and
    sc instanceof SummaryCtxNone and
    ap instanceof AccessPathNil
  }
}

/**
 * A flow graph node corresponding to a sink. This is disjoint from the
 * intermediate nodes in order to uniquely correspond to a given sink by
 * excluding the `CallContext`.
 */
private class PathNodeSink extends PathNodeImpl, TPathNodeSink {
  Node node;
  Configuration config;

  PathNodeSink() { this = TPathNodeSink(node, config) }

  override Node getNode() { result = node }

  override Configuration getConfiguration() { result = config }

  override PathNode getASuccessor() { none() }

  override predicate isSource() { config.isSource(node) }
}

/**
 * Holds if data may flow from `mid` to `node`. The last step in or out of
 * a callable is recorded by `cc`.
 */
private predicate pathStep(PathNodeMid mid, Node node, CallContext cc, SummaryCtx sc, AccessPath ap) {
  exists(AccessPath ap0, Node midnode, Configuration conf, LocalCallContext localCC |
    midnode = mid.getNode() and
    conf = mid.getConfiguration() and
    cc = mid.getCallContext() and
    sc = mid.getSummaryCtx() and
    localCC = getLocalCallContext(cc, midnode.getEnclosingCallable()) and
    ap0 = mid.getAp()
  |
    localFlowBigStep(midnode, node, true, _, conf, localCC) and
    ap = ap0
    or
    localFlowBigStep(midnode, node, false, ap.getFront(), conf, localCC) and
    ap0 instanceof AccessPathNil
  )
  or
  jumpStep(mid.getNode(), node, mid.getConfiguration()) and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  ap = mid.getAp()
  or
  additionalJumpStep(mid.getNode(), node, mid.getConfiguration()) and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  mid.getAp() instanceof AccessPathNil and
  ap = TNil(getErasedNodeTypeBound(node))
  or
  exists(Content f | pathStoreStep(mid, node, pop(f, ap), f, cc)) and
  sc = mid.getSummaryCtx()
  or
  exists(Content f | pathReadStep(mid, node, push(f, ap), f, cc)) and
  sc = mid.getSummaryCtx()
  or
  pathIntoCallable(mid, node, _, cc, sc, _) and ap = mid.getAp()
  or
  pathOutOfCallable(mid, node, cc) and ap = mid.getAp() and sc instanceof SummaryCtxNone
  or
  pathThroughCallable(mid, node, cc, ap) and sc = mid.getSummaryCtx()
}

pragma[nomagic]
private predicate readCand(Node node1, Content f, Node node2, Configuration config) {
  read(node1, f, node2) and
  flow(node2, config)
}

pragma[nomagic]
private predicate pathReadStep(PathNodeMid mid, Node node, AccessPath ap0, Content f, CallContext cc) {
  ap0 = mid.getAp() and
  readCand(mid.getNode(), f, node, mid.getConfiguration()) and
  cc = mid.getCallContext()
}

pragma[nomagic]
private predicate storeCand(Node node1, Content f, Node node2, Configuration config) {
  store(node1, f, node2) and
  flow(node2, config)
}

pragma[nomagic]
private predicate pathStoreStep(
  PathNodeMid mid, Node node, AccessPath ap0, Content f, CallContext cc
) {
  ap0 = mid.getAp() and
  storeCand(mid.getNode(), f, node, mid.getConfiguration()) and
  cc = mid.getCallContext()
}

private predicate pathOutOfCallable0(
  PathNodeMid mid, ReturnPosition pos, CallContext innercc, AccessPath ap, Configuration config
) {
  pos = getReturnPosition(mid.getNode()) and
  innercc = mid.getCallContext() and
  not innercc instanceof CallContextCall and
  ap = mid.getAp() and
  config = mid.getConfiguration()
}

pragma[nomagic]
private predicate pathOutOfCallable1(
  PathNodeMid mid, DataFlowCall call, ReturnKindExt kind, CallContext cc, AccessPath ap,
  Configuration config
) {
  exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
    pathOutOfCallable0(mid, pos, innercc, ap, config) and
    c = pos.getCallable() and
    kind = pos.getKind() and
    resolveReturn(innercc, c, call)
  |
    if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
  )
}

pragma[noinline]
private Node getAnOutNodeFlow(
  ReturnKindExt kind, DataFlowCall call, AccessPath ap, Configuration config
) {
  result = kind.getAnOutNode(call) and
  flow(result, _, _, ap, config)
}

/**
 * Holds if data may flow from `mid` to `out`. The last step of this path
 * is a return from a callable and is recorded by `cc`, if needed.
 */
pragma[noinline]
private predicate pathOutOfCallable(PathNodeMid mid, Node out, CallContext cc) {
  exists(ReturnKindExt kind, DataFlowCall call, AccessPath ap, Configuration config |
    pathOutOfCallable1(mid, call, kind, cc, ap, config)
  |
    out = getAnOutNodeFlow(kind, call, ap, config)
  )
}

/**
 * Holds if data may flow from `mid` to the `i`th argument of `call` in `cc`.
 */
pragma[noinline]
private predicate pathIntoArg(
  PathNodeMid mid, int i, CallContext cc, DataFlowCall call, AccessPath ap
) {
  exists(ArgumentNode arg |
    arg = mid.getNode() and
    cc = mid.getCallContext() and
    arg.argumentOf(call, i) and
    ap = mid.getAp()
  )
}

pragma[noinline]
private predicate parameterCand(
  DataFlowCallable callable, int i, AccessPath ap, Configuration config
) {
  exists(ParameterNode p |
    flow(p, _, _, ap, config) and
    p.isParameterOf(callable, i)
  )
}

pragma[nomagic]
private predicate pathIntoCallable0(
  PathNodeMid mid, DataFlowCallable callable, int i, CallContext outercc, DataFlowCall call,
  AccessPath ap
) {
  pathIntoArg(mid, i, outercc, call, ap) and
  callable = resolveCall(call, outercc) and
  parameterCand(callable, any(int j | j <= i and j >= i), ap, mid.getConfiguration())
}

/**
 * Holds if data may flow from `mid` to `p` through `call`. The contexts
 * before and after entering the callable are `outercc` and `innercc`,
 * respectively.
 */
private predicate pathIntoCallable(
  PathNodeMid mid, ParameterNode p, CallContext outercc, CallContextCall innercc, SummaryCtx sc,
  DataFlowCall call
) {
  exists(int i, DataFlowCallable callable, AccessPath ap |
    pathIntoCallable0(mid, callable, i, outercc, call, ap) and
    p.isParameterOf(callable, i) and
    (
      sc = TSummaryCtxSome(p, ap)
      or
      not exists(TSummaryCtxSome(p, ap)) and
      sc = TSummaryCtxNone()
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
  ReturnKindExt kind, CallContextCall cc, SummaryCtxSome sc, AccessPath ap, Configuration config
) {
  exists(PathNodeMid mid, ReturnNodeExt ret, int pos |
    mid.getNode() = ret and
    kind = ret.getKind() and
    cc = mid.getCallContext() and
    sc = mid.getSummaryCtx() and
    config = mid.getConfiguration() and
    ap = mid.getAp() and
    pos = sc.getParameterPos() and
    not kind.(ParamUpdateReturnKind).getPosition() = pos
  )
}

pragma[nomagic]
private predicate pathThroughCallable0(
  DataFlowCall call, PathNodeMid mid, ReturnKindExt kind, CallContext cc, AccessPath ap
) {
  exists(CallContext innercc, SummaryCtx sc |
    pathIntoCallable(mid, _, cc, innercc, sc, call) and
    paramFlowsThrough(kind, innercc, sc, ap, unbind(mid.getConfiguration()))
  )
}

/**
 * Holds if data may flow from `mid` through a callable to the node `out`.
 * The context `cc` is restored to its value prior to entering the callable.
 */
pragma[noinline]
private predicate pathThroughCallable(PathNodeMid mid, Node out, CallContext cc, AccessPath ap) {
  exists(DataFlowCall call, ReturnKindExt kind |
    pathThroughCallable0(call, mid, kind, cc, ap) and
    out = getAnOutNodeFlow(kind, call, ap, mid.getConfiguration())
  )
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
  flowsource.getNode() = source and
  (flowsource = flowsink or pathSuccPlus(flowsource, flowsink)) and
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

private module FlowExploration {
  private predicate callableStep(DataFlowCallable c1, DataFlowCallable c2, Configuration config) {
    exists(Node node1, Node node2 |
      jumpStep(node1, node2, config)
      or
      additionalJumpStep(node1, node2, config)
      or
      // flow into callable
      viableParamArg(_, node2, node1)
      or
      // flow out of a callable
      viableReturnPosOut(_, getReturnPosition(node1), node2)
    |
      c1 = node1.getEnclosingCallable() and
      c2 = node2.getEnclosingCallable() and
      c1 != c2
    )
  }

  private predicate interestingCallableSrc(DataFlowCallable c, Configuration config) {
    exists(Node n | config.isSource(n) and c = n.getEnclosingCallable())
    or
    exists(DataFlowCallable mid |
      interestingCallableSrc(mid, config) and callableStep(mid, c, config)
    )
  }

  private newtype TCallableExt =
    TCallable(DataFlowCallable c, Configuration config) { interestingCallableSrc(c, config) } or
    TCallableSrc()

  private predicate callableExtSrc(TCallableSrc src) { any() }

  private predicate callableExtStepFwd(TCallableExt ce1, TCallableExt ce2) {
    exists(DataFlowCallable c1, DataFlowCallable c2, Configuration config |
      callableStep(c1, c2, config) and
      ce1 = TCallable(c1, config) and
      ce2 = TCallable(c2, unbind(config))
    )
    or
    exists(Node n, Configuration config |
      ce1 = TCallableSrc() and
      config.isSource(n) and
      ce2 = TCallable(n.getEnclosingCallable(), config)
    )
  }

  private int distSrcExt(TCallableExt c) =
    shortestDistances(callableExtSrc/1, callableExtStepFwd/2)(_, c, result)

  private int distSrc(DataFlowCallable c, Configuration config) {
    result = distSrcExt(TCallable(c, config)) - 1
  }

  private newtype TPartialAccessPath =
    TPartialNil(DataFlowType t) or
    TPartialCons(Content f, int len) { len in [1 .. 5] }

  /**
   * Conceptually a list of `Content`s followed by a `Type`, but only the first
   * element of the list and its length are tracked. If data flows from a source to
   * a given node with a given `AccessPath`, this indicates the sequence of
   * dereference operations needed to get from the value in the node to the
   * tracked object. The final type indicates the type of the tracked object.
   */
  private class PartialAccessPath extends TPartialAccessPath {
    abstract string toString();

    Content getHead() { this = TPartialCons(result, _) }

    int len() {
      this = TPartialNil(_) and result = 0
      or
      this = TPartialCons(_, result)
    }

    DataFlowType getType() {
      this = TPartialNil(result)
      or
      exists(Content head | this = TPartialCons(head, _) | result = head.getContainerType())
    }

    abstract AccessPathFront getFront();
  }

  private class PartialAccessPathNil extends PartialAccessPath, TPartialNil {
    override string toString() {
      exists(DataFlowType t | this = TPartialNil(t) | result = concat(": " + ppReprType(t)))
    }

    override AccessPathFront getFront() {
      exists(DataFlowType t | this = TPartialNil(t) | result = TFrontNil(t))
    }
  }

  private class PartialAccessPathCons extends PartialAccessPath, TPartialCons {
    override string toString() {
      exists(Content f, int len | this = TPartialCons(f, len) |
        if len = 1
        then result = "[" + f.toString() + "]"
        else result = "[" + f.toString() + ", ... (" + len.toString() + ")]"
      )
    }

    override AccessPathFront getFront() {
      exists(Content f | this = TPartialCons(f, _) | result = TFrontHead(f))
    }
  }

  private newtype TSummaryCtx1 =
    TSummaryCtx1None() or
    TSummaryCtx1Param(ParameterNode p)

  private newtype TSummaryCtx2 =
    TSummaryCtx2None() or
    TSummaryCtx2Some(PartialAccessPath ap)

  private newtype TPartialPathNode =
    TPartialPathNodeMk(
      Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, PartialAccessPath ap,
      Configuration config
    ) {
      config.isSource(node) and
      cc instanceof CallContextAny and
      sc1 = TSummaryCtx1None() and
      sc2 = TSummaryCtx2None() and
      ap = TPartialNil(getErasedNodeTypeBound(node)) and
      not fullBarrier(node, config) and
      exists(config.explorationLimit())
      or
      partialPathNodeMk0(node, cc, sc1, sc2, ap, config) and
      distSrc(node.getEnclosingCallable(), config) <= config.explorationLimit()
    }

  pragma[nomagic]
  private predicate partialPathNodeMk0(
    Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, PartialAccessPath ap,
    Configuration config
  ) {
    exists(PartialPathNode mid |
      partialPathStep(mid, node, cc, sc1, sc2, ap, config) and
      not fullBarrier(node, config) and
      if node instanceof CastingNode
      then compatibleTypes(getErasedNodeTypeBound(node), ap.getType())
      else any()
    )
  }

  /**
   * A `Node` augmented with a call context, an access path, and a configuration.
   */
  class PartialPathNode extends TPartialPathNode {
    /** Gets a textual representation of this element. */
    string toString() { result = this.getNode().toString() + this.ppAp() }

    /**
     * Gets a textual representation of this element, including a textual
     * representation of the call context.
     */
    string toStringWithContext() { result = this.getNode().toString() + this.ppAp() + this.ppCtx() }

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
      this.getNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /** Gets the underlying `Node`. */
    Node getNode() { none() }

    /** Gets the associated configuration. */
    Configuration getConfiguration() { none() }

    /** Gets a successor of this node, if any. */
    PartialPathNode getASuccessor() { none() }

    /**
     * Gets the approximate distance to the nearest source measured in number
     * of interprocedural steps.
     */
    int getSourceDistance() {
      result = distSrc(this.getNode().getEnclosingCallable(), this.getConfiguration())
    }

    private string ppAp() {
      exists(string s | s = this.(PartialPathNodePriv).getAp().toString() |
        if s = "" then result = "" else result = " " + s
      )
    }

    private string ppCtx() {
      result = " <" + this.(PartialPathNodePriv).getCallContext().toString() + ">"
    }
  }

  /**
   * Provides the query predicates needed to include a graph in a path-problem query.
   */
  module PartialPathGraph {
    /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
    query predicate edges(PartialPathNode a, PartialPathNode b) { a.getASuccessor() = b }
  }

  private class PartialPathNodePriv extends PartialPathNode {
    Node node;
    CallContext cc;
    TSummaryCtx1 sc1;
    TSummaryCtx2 sc2;
    PartialAccessPath ap;
    Configuration config;

    PartialPathNodePriv() { this = TPartialPathNodeMk(node, cc, sc1, sc2, ap, config) }

    override Node getNode() { result = node }

    CallContext getCallContext() { result = cc }

    TSummaryCtx1 getSummaryCtx1() { result = sc1 }

    TSummaryCtx2 getSummaryCtx2() { result = sc2 }

    PartialAccessPath getAp() { result = ap }

    override Configuration getConfiguration() { result = config }

    override PartialPathNodePriv getASuccessor() {
      partialPathStep(this, result.getNode(), result.getCallContext(), result.getSummaryCtx1(),
        result.getSummaryCtx2(), result.getAp(), result.getConfiguration())
    }
  }

  private predicate partialPathStep(
    PartialPathNodePriv mid, Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
    PartialAccessPath ap, Configuration config
  ) {
    not isUnreachableInCall(node, cc.(CallContextSpecificCall).getCall()) and
    (
      localFlowStep(mid.getNode(), node, config) and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      ap = mid.getAp() and
      config = mid.getConfiguration()
      or
      additionalLocalFlowStep(mid.getNode(), node, config) and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      mid.getAp() instanceof PartialAccessPathNil and
      ap = TPartialNil(getErasedNodeTypeBound(node)) and
      config = mid.getConfiguration()
    )
    or
    jumpStep(mid.getNode(), node, config) and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    ap = mid.getAp() and
    config = mid.getConfiguration()
    or
    additionalJumpStep(mid.getNode(), node, config) and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    mid.getAp() instanceof PartialAccessPathNil and
    ap = TPartialNil(getErasedNodeTypeBound(node)) and
    config = mid.getConfiguration()
    or
    partialPathStoreStep(mid, _, _, node, ap) and
    cc = mid.getCallContext() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    config = mid.getConfiguration()
    or
    exists(PartialAccessPath ap0, Content f |
      partialPathReadStep(mid, ap0, f, node, cc, config) and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      apConsFwd(ap, f, ap0, config)
    )
    or
    partialPathIntoCallable(mid, node, _, cc, sc1, sc2, _, ap, config)
    or
    partialPathOutOfCallable(mid, node, cc, ap, config) and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None()
    or
    partialPathThroughCallable(mid, node, cc, ap, config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2()
  }

  bindingset[result, i]
  private int unbindInt(int i) { i <= result and i >= result }

  pragma[inline]
  private predicate partialPathStoreStep(
    PartialPathNodePriv mid, PartialAccessPath ap1, Content f, Node node, PartialAccessPath ap2
  ) {
    ap1 = mid.getAp() and
    store(mid.getNode(), f, node) and
    ap2.getHead() = f and
    ap2.len() = unbindInt(ap1.len() + 1) and
    compatibleTypes(ap1.getType(), f.getType())
  }

  pragma[nomagic]
  private predicate apConsFwd(
    PartialAccessPath ap1, Content f, PartialAccessPath ap2, Configuration config
  ) {
    exists(PartialPathNodePriv mid |
      partialPathStoreStep(mid, ap1, f, _, ap2) and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate partialPathReadStep(
    PartialPathNodePriv mid, PartialAccessPath ap, Content f, Node node, CallContext cc,
    Configuration config
  ) {
    ap = mid.getAp() and
    readStep(mid.getNode(), f, node) and
    ap.getHead() = f and
    config = mid.getConfiguration() and
    cc = mid.getCallContext()
  }

  private predicate partialPathOutOfCallable0(
    PartialPathNodePriv mid, ReturnPosition pos, CallContext innercc, PartialAccessPath ap,
    Configuration config
  ) {
    pos = getReturnPosition(mid.getNode()) and
    innercc = mid.getCallContext() and
    not innercc instanceof CallContextCall and
    ap = mid.getAp() and
    config = mid.getConfiguration()
  }

  pragma[nomagic]
  private predicate partialPathOutOfCallable1(
    PartialPathNodePriv mid, DataFlowCall call, ReturnKindExt kind, CallContext cc,
    PartialAccessPath ap, Configuration config
  ) {
    exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
      partialPathOutOfCallable0(mid, pos, innercc, ap, config) and
      c = pos.getCallable() and
      kind = pos.getKind() and
      resolveReturn(innercc, c, call)
    |
      if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
    )
  }

  private predicate partialPathOutOfCallable(
    PartialPathNodePriv mid, Node out, CallContext cc, PartialAccessPath ap, Configuration config
  ) {
    exists(ReturnKindExt kind, DataFlowCall call |
      partialPathOutOfCallable1(mid, call, kind, cc, ap, config)
    |
      out = kind.getAnOutNode(call)
    )
  }

  pragma[noinline]
  private predicate partialPathIntoArg(
    PartialPathNodePriv mid, int i, CallContext cc, DataFlowCall call, PartialAccessPath ap,
    Configuration config
  ) {
    exists(ArgumentNode arg |
      arg = mid.getNode() and
      cc = mid.getCallContext() and
      arg.argumentOf(call, i) and
      ap = mid.getAp() and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate partialPathIntoCallable0(
    PartialPathNodePriv mid, DataFlowCallable callable, int i, CallContext outercc,
    DataFlowCall call, PartialAccessPath ap, Configuration config
  ) {
    partialPathIntoArg(mid, i, outercc, call, ap, config) and
    callable = resolveCall(call, outercc)
  }

  private predicate partialPathIntoCallable(
    PartialPathNodePriv mid, ParameterNode p, CallContext outercc, CallContextCall innercc,
    TSummaryCtx1 sc1, TSummaryCtx2 sc2, DataFlowCall call, PartialAccessPath ap,
    Configuration config
  ) {
    exists(int i, DataFlowCallable callable |
      partialPathIntoCallable0(mid, callable, i, outercc, call, ap, config) and
      p.isParameterOf(callable, i) and
      sc1 = TSummaryCtx1Param(p) and
      sc2 = TSummaryCtx2Some(ap)
    |
      if recordDataFlowCallSite(call, callable)
      then innercc = TSpecificCall(call)
      else innercc = TSomeCall()
    )
  }

  pragma[nomagic]
  private predicate paramFlowsThroughInPartialPath(
    ReturnKindExt kind, CallContextCall cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
    PartialAccessPath ap, Configuration config
  ) {
    exists(PartialPathNodePriv mid, ReturnNodeExt ret |
      mid.getNode() = ret and
      kind = ret.getKind() and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      config = mid.getConfiguration() and
      ap = mid.getAp()
    )
  }

  pragma[noinline]
  private predicate partialPathThroughCallable0(
    DataFlowCall call, PartialPathNodePriv mid, ReturnKindExt kind, CallContext cc,
    PartialAccessPath ap, Configuration config
  ) {
    exists(ParameterNode p, CallContext innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2 |
      partialPathIntoCallable(mid, p, cc, innercc, sc1, sc2, call, _, config) and
      paramFlowsThroughInPartialPath(kind, innercc, sc1, sc2, ap, config)
    )
  }

  private predicate partialPathThroughCallable(
    PartialPathNodePriv mid, Node out, CallContext cc, PartialAccessPath ap, Configuration config
  ) {
    exists(DataFlowCall call, ReturnKindExt kind |
      partialPathThroughCallable0(call, mid, kind, cc, ap, config) and
      out = kind.getAnOutNode(call)
    )
  }
}

import FlowExploration

private predicate partialFlow(
  PartialPathNode source, PartialPathNode node, Configuration configuration
) {
  source.getConfiguration() = configuration and
  configuration.isSource(source.getNode()) and
  node = source.getASuccessor+()
}
