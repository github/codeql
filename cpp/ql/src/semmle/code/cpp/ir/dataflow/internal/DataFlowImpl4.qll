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
      store(mid, _, node, _) and
      not outBarrier(mid, config)
    )
    or
    // read
    exists(Content c |
      nodeCandFwd1Read(c, node, fromArg, config) and
      nodeCandFwd1IsStored(c, config) and
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
private predicate nodeCandFwd1Read(Content c, Node node, boolean fromArg, Configuration config) {
  exists(Node mid |
    nodeCandFwd1(mid, fromArg, config) and
    read(mid, c, node)
  )
}

/**
 * Holds if `c` is the target of a store in the flow covered by `nodeCandFwd1`.
 */
pragma[nomagic]
private predicate nodeCandFwd1IsStored(Content c, Configuration config) {
  exists(Node mid, Node node, TypedContent tc |
    not fullBarrier(node, config) and
    useFieldFlow(config) and
    nodeCandFwd1(mid, config) and
    store(mid, tc, node, _) and
    c = tc.getContent()
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
  exists(Content c |
    nodeCand1Store(c, node, toReturn, config) and
    nodeCand1IsRead(c, config)
  )
  or
  // read
  exists(Node mid, Content c |
    read(node, c, mid) and
    nodeCandFwd1IsStored(c, unbind(config)) and
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
 * Holds if `c` is the target of a read in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate nodeCand1IsRead(Content c, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd1(node, unbind(config)) and
    read(node, c, mid) and
    nodeCandFwd1IsStored(c, unbind(config)) and
    nodeCand1(mid, _, config)
  )
}

pragma[nomagic]
private predicate nodeCand1Store(Content c, Node node, boolean toReturn, Configuration config) {
  exists(Node mid, TypedContent tc |
    nodeCand1(mid, toReturn, config) and
    nodeCandFwd1IsStored(c, unbind(config)) and
    store(node, tc, mid, _) and
    c = tc.getContent()
  )
}

/**
 * Holds if `c` is the target of both a read and a store in the flow covered
 * by `nodeCand1`.
 */
private predicate nodeCand1IsReadAndStored(Content c, Configuration conf) {
  nodeCand1IsRead(c, conf) and
  nodeCand1Store(c, _, _, conf)
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
private predicate storeCand1(Node n1, Content c, Node n2, Configuration config) {
  exists(TypedContent tc |
    nodeCand1IsReadAndStored(c, config) and
    nodeCand1(n2, unbind(config)) and
    store(n1, tc, n2, _) and
    c = tc.getContent()
  )
}

pragma[nomagic]
private predicate read(Node n1, Content c, Node n2, Configuration config) {
  nodeCand1IsReadAndStored(c, config) and
  nodeCand1(n2, unbind(config)) and
  read(n1, c, n2)
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
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, argStored, _, config) and
      storeCand1(mid, _, node, config) and
      stored = true
    )
    or
    // read
    exists(Content c |
      nodeCandFwd2Read(c, node, fromArg, argStored, config) and
      nodeCandFwd2IsStored(c, stored, config)
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
 * Holds if `c` is the target of a store in the flow covered by `nodeCandFwd2`.
 */
pragma[noinline]
private predicate nodeCandFwd2IsStored(Content c, boolean stored, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCand1(node, unbind(config)) and
    nodeCandFwd2(mid, _, _, stored, config) and
    storeCand1(mid, c, node, config)
  )
}

pragma[nomagic]
private predicate nodeCandFwd2Read(
  Content c, Node node, boolean fromArg, BooleanOption argStored, Configuration config
) {
  exists(Node mid |
    nodeCandFwd2(mid, fromArg, argStored, true, config) and
    read(mid, c, node, config)
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
    exists(Content c |
      nodeCand2Store(c, node, toReturn, returnRead, read, config) and
      nodeCand2IsRead(c, read, config)
    )
    or
    // read
    exists(Node mid, Content c, boolean read0 |
      read(node, c, mid, config) and
      nodeCandFwd2IsStored(c, unbindBool(read0), unbind(config)) and
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
 * Holds if `c` is the target of a read in the flow covered by `nodeCand2`.
 */
pragma[noinline]
private predicate nodeCand2IsRead(Content c, boolean read, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd2(node, _, _, true, unbind(config)) and
    read(node, c, mid, config) and
    nodeCandFwd2IsStored(c, unbindBool(read), unbind(config)) and
    nodeCand2(mid, _, _, read, config)
  )
}

pragma[nomagic]
private predicate nodeCand2Store(
  Content c, Node node, boolean toReturn, BooleanOption returnRead, boolean stored,
  Configuration config
) {
  exists(Node mid |
    storeCand1(node, c, mid, config) and
    nodeCand2(mid, toReturn, returnRead, true, config) and
    nodeCandFwd2(node, _, _, stored, unbind(config))
  )
}

/**
 * Holds if `c` is the target of a store in the flow covered by `nodeCand2`.
 */
pragma[nomagic]
private predicate nodeCand2IsStored(Content c, boolean stored, Configuration conf) {
  exists(Node node |
    nodeCand2Store(c, node, _, _, stored, conf) and
    nodeCand2(node, _, _, stored, conf)
  )
}

/**
 * Holds if `c` is the target of both a store and a read in the path graph
 * covered by `nodeCand2`.
 */
pragma[noinline]
private predicate nodeCand2IsReadAndStored(Content c, Configuration conf) {
  exists(boolean apNonEmpty |
    nodeCand2IsStored(c, apNonEmpty, conf) and
    nodeCand2IsRead(c, apNonEmpty, conf)
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
   * A node where some checking is required, and hence the big-step relation
   * is not allowed to step over.
   */
  private class FlowCheckNode extends Node {
    FlowCheckNode() {
      this instanceof CastNode or
      clearsContent(this, _)
    }
  }

  /**
   * Holds if `node` can be the first node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  predicate localFlowEntry(Node node, Configuration config) {
    nodeCand2(node, config) and
    (
      config.isSource(node) or
      jumpStep(_, node, config) or
      additionalJumpStep(_, node, config) or
      node instanceof ParameterNode or
      node instanceof OutNodeExt or
      store(_, _, node, _) or
      read(_, _, node) or
      node instanceof FlowCheckNode
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
      store(node, _, next, _) or
      read(node, _, next)
    )
    or
    node instanceof FlowCheckNode
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
        t = getNodeType(node1)
        or
        additionalLocalFlowStepNodeCand2(node1, node2, config) and
        preservesValue = false and
        t = getNodeType(node2)
      ) and
      node1 != node2 and
      cc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall(node1, cc.(LocalCallContextSpecificCall).getCall()) and
      nodeCand2(node2, unbind(config))
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, preservesValue, t, config, cc) and
        localFlowStepNodeCand1(mid, node2, config) and
        not mid instanceof FlowCheckNode and
        nodeCand2(node2, unbind(config))
      )
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, _, _, config, cc) and
        additionalLocalFlowStepNodeCand2(mid, node2, config) and
        not mid instanceof FlowCheckNode and
        preservesValue = false and
        t = getNodeType(node2) and
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
private predicate readCand2(Node node1, Content c, Node node2, Configuration config) {
  read(node1, c, node2, config) and
  nodeCand2(node1, _, _, true, unbind(config)) and
  nodeCand2(node2, config) and
  nodeCand2IsReadAndStored(c, unbind(config))
}

pragma[nomagic]
private predicate storeCand2(
  Node node1, TypedContent tc, Node node2, DataFlowType contentType, Configuration config
) {
  store(node1, tc, node2, contentType) and
  nodeCand2(node1, config) and
  nodeCand2(node2, _, _, true, unbind(config)) and
  nodeCand2IsReadAndStored(tc.getContent(), unbind(config))
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
  not apf.isClearedAt(node) and
  if node instanceof CastingNode then compatibleTypes(getNodeType(node), apf.getType()) else any()
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
  apf = TFrontNil(getNodeType(node))
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
    apf = TFrontNil(getNodeType(node))
  )
  or
  // store
  exists(Node mid, TypedContent tc, AccessPathFront apf0, DataFlowType contentType |
    flowCandFwd(mid, fromArg, argApf, apf0, config) and
    storeCand2(mid, tc, node, contentType, config) and
    nodeCand2(node, _, _, true, unbind(config)) and
    apf.headUsesContent(tc) and
    compatibleTypes(apf0.getType(), contentType)
  )
  or
  // read
  exists(TypedContent tc |
    flowCandFwdRead(tc, node, fromArg, argApf, config) and
    flowCandFwdConsCand(tc, apf, config) and
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
private predicate flowCandFwdConsCand(TypedContent tc, AccessPathFront apf, Configuration config) {
  exists(Node mid, Node n, DataFlowType contentType |
    flowCandFwd(mid, _, _, apf, config) and
    storeCand2(mid, tc, n, contentType, config) and
    nodeCand2(n, _, _, true, unbind(config)) and
    compatibleTypes(apf.getType(), contentType)
  )
}

pragma[nomagic]
private predicate flowCandFwdRead0(
  Node node1, TypedContent tc, Content c, Node node2, boolean fromArg, AccessPathFrontOption argApf,
  AccessPathFrontHead apf, Configuration config
) {
  flowCandFwd(node1, fromArg, argApf, apf, config) and
  readCand2(node1, c, node2, config) and
  apf.headUsesContent(tc)
}

pragma[nomagic]
private predicate flowCandFwdRead(
  TypedContent tc, Node node, boolean fromArg, AccessPathFrontOption argApf, Configuration config
) {
  flowCandFwdRead0(_, tc, tc.getContent(), node, fromArg, argApf, _, config)
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
  exists(TypedContent tc |
    flowCandStore(node, tc, apf, toReturn, returnApf, config) and
    flowCandConsCand(tc, apf, config)
  )
  or
  // read
  exists(TypedContent tc, AccessPathFront apf0 |
    flowCandRead(node, tc, apf, toReturn, returnApf, apf0, config) and
    flowCandFwdConsCand(tc, apf0, config)
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
private predicate readCandFwd(
  Node node1, TypedContent tc, AccessPathFront apf, Node node2, Configuration config
) {
  flowCandFwdRead0(node1, tc, tc.getContent(), node2, _, _, apf, config)
}

pragma[nomagic]
private predicate flowCandRead(
  Node node, TypedContent tc, AccessPathFront apf, boolean toReturn,
  AccessPathFrontOption returnApf, AccessPathFront apf0, Configuration config
) {
  exists(Node mid |
    readCandFwd(node, tc, apf, mid, config) and
    flowCand(mid, toReturn, returnApf, apf0, config)
  )
}

pragma[nomagic]
private predicate flowCandStore(
  Node node, TypedContent tc, AccessPathFront apf, boolean toReturn,
  AccessPathFrontOption returnApf, Configuration config
) {
  exists(Node mid |
    flowCandFwd(node, _, _, apf, config) and
    storeCand2(node, tc, mid, _, unbind(config)) and
    flowCand(mid, toReturn, returnApf, TFrontHead(tc), unbind(config))
  )
}

pragma[nomagic]
private predicate flowCandConsCand(TypedContent tc, AccessPathFront apf, Configuration config) {
  flowCandFwdConsCand(tc, apf, config) and
  flowCandRead(_, tc, _, _, _, apf, config)
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

private newtype TAccessPathApprox =
  TNil(DataFlowType t) or
  TConsNil(TypedContent tc, DataFlowType t) { flowCandConsCand(tc, TFrontNil(t), _) } or
  TConsCons(TypedContent tc1, TypedContent tc2, int len) {
    flowCandConsCand(tc1, TFrontHead(tc2), _) and len in [2 .. accessPathLimit()]
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

/**
 * Holds if `node` is reachable with approximate access path `apa` from a source
 * in the configuration `config`.
 *
 * The call context `cc` records whether the node is reached through an
 * argument in a call, and if so, `argApa` records the approximate access path
 * of that argument.
 */
private predicate flowFwd(
  Node node, CallContext cc, AccessPathApproxOption argApa, AccessPathFront apf,
  AccessPathApprox apa, Configuration config
) {
  flowFwd0(node, cc, argApa, apf, apa, config) and
  flowCand(node, _, _, apf, config)
}

private predicate flowFwd0(
  Node node, CallContext cc, AccessPathApproxOption argApa, AccessPathFront apf,
  AccessPathApprox apa, Configuration config
) {
  flowCand(node, _, _, _, config) and
  config.isSource(node) and
  cc instanceof CallContextAny and
  argApa = TAccessPathApproxNone() and
  apa = TNil(getNodeType(node)) and
  apf = apa.(AccessPathApproxNil).getFront()
  or
  flowCand(node, _, _, _, unbind(config)) and
  (
    exists(Node mid, LocalCallContext localCC |
      flowFwdLocalEntry(mid, cc, argApa, apf, apa, localCC, config) and
      localFlowBigStep(mid, node, true, _, config, localCC)
    )
    or
    exists(Node mid, AccessPathApproxNil nil, LocalCallContext localCC |
      flowFwdLocalEntry(mid, cc, argApa, _, nil, localCC, config) and
      localFlowBigStep(mid, node, false, apf, config, localCC) and
      apf = apa.(AccessPathApproxNil).getFront()
    )
    or
    exists(Node mid |
      flowFwd(mid, _, _, apf, apa, config) and
      jumpStep(mid, node, config) and
      cc instanceof CallContextAny and
      argApa = TAccessPathApproxNone()
    )
    or
    exists(Node mid, AccessPathApproxNil nil |
      flowFwd(mid, _, _, _, nil, config) and
      additionalJumpStep(mid, node, config) and
      cc instanceof CallContextAny and
      argApa = TAccessPathApproxNone() and
      apa = TNil(getNodeType(node)) and
      apf = apa.(AccessPathApproxNil).getFront()
    )
  )
  or
  // store
  exists(TypedContent tc | flowFwdStore(node, tc, pop(tc, apa), apf, cc, argApa, config))
  or
  // read
  exists(TypedContent tc |
    flowFwdRead(node, _, push(tc, apa), apf, cc, argApa, config) and
    flowFwdConsCand(tc, apf, apa, config)
  )
  or
  // flow into a callable
  flowFwdIn(_, node, _, cc, _, apf, apa, config) and
  if flowCand(node, true, _, apf, config)
  then argApa = TAccessPathApproxSome(apa)
  else argApa = TAccessPathApproxNone()
  or
  // flow out of a callable
  exists(DataFlowCall call |
    exists(DataFlowCallable c |
      flowFwdOut(call, node, any(CallContextNoCall innercc), c, argApa, apf, apa, config) and
      if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
    )
    or
    exists(AccessPathApprox argApa0 |
      flowFwdOutFromArg(call, node, argApa0, apf, apa, config) and
      flowFwdIsEntered(call, cc, argApa, argApa0, config)
    )
  )
}

pragma[nomagic]
private predicate flowFwdLocalEntry(
  Node node, CallContext cc, AccessPathApproxOption argApa, AccessPathFront apf,
  AccessPathApprox apa, LocalCallContext localCC, Configuration config
) {
  flowFwd(node, cc, argApa, apf, apa, config) and
  localFlowEntry(node, config) and
  localCC = getLocalCallContext(cc, node.getEnclosingCallable())
}

pragma[nomagic]
private predicate flowFwdStore(
  Node node, TypedContent tc, AccessPathApprox apa0, AccessPathFront apf, CallContext cc,
  AccessPathApproxOption argApa, Configuration config
) {
  exists(Node mid, AccessPathFront apf0 |
    flowFwd(mid, cc, argApa, apf0, apa0, config) and
    flowFwdStore0(mid, tc, node, apf0, apf, config)
  )
}

pragma[nomagic]
private predicate storeCand(
  Node mid, TypedContent tc, Node node, AccessPathFront apf0, AccessPathFront apf,
  Configuration config
) {
  storeCand2(mid, tc, node, _, config) and
  flowCand(mid, _, _, apf0, config) and
  apf.headUsesContent(tc)
}

pragma[noinline]
private predicate flowFwdStore0(
  Node mid, TypedContent tc, Node node, AccessPathFront apf0, AccessPathFrontHead apf,
  Configuration config
) {
  storeCand(mid, tc, node, apf0, apf, config) and
  flowCandConsCand(tc, apf0, config) and
  flowCand(node, _, _, apf, unbind(config))
}

pragma[nomagic]
private predicate flowFwdRead0(
  Node node1, TypedContent tc, AccessPathFrontHead apf0, AccessPathApprox apa0, Node node2,
  CallContext cc, AccessPathApproxOption argApa, Configuration config
) {
  flowFwd(node1, cc, argApa, apf0, apa0, config) and
  readCandFwd(node1, tc, apf0, node2, config)
}

pragma[nomagic]
private predicate flowFwdRead(
  Node node, AccessPathFrontHead apf0, AccessPathApprox apa0, AccessPathFront apf, CallContext cc,
  AccessPathApproxOption argApa, Configuration config
) {
  exists(Node mid, TypedContent tc |
    flowFwdRead0(mid, tc, apf0, apa0, node, cc, argApa, config) and
    flowCand(node, _, _, apf, unbind(config)) and
    flowCandConsCand(tc, apf, unbind(config))
  )
}

pragma[nomagic]
private predicate flowFwdConsCand(
  TypedContent tc, AccessPathFront apf, AccessPathApprox apa, Configuration config
) {
  exists(Node n |
    flowFwd(n, _, _, apf, apa, config) and
    flowFwdStore0(n, tc, _, apf, _, config)
  )
}

pragma[nomagic]
private predicate flowFwdIn(
  DataFlowCall call, ParameterNode p, CallContext outercc, CallContext innercc,
  AccessPathApproxOption argApa, AccessPathFront apf, AccessPathApprox apa, Configuration config
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow, DataFlowCallable c |
    flowFwd(arg, outercc, argApa, apf, apa, config) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config) and
    c = p.getEnclosingCallable() and
    c = resolveCall(call, outercc) and
    flowCand(p, _, _, _, unbind(config)) and
    if recordDataFlowCallSite(call, c) then innercc = TSpecificCall(call) else innercc = TSomeCall()
  |
    apa instanceof AccessPathApproxNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowFwdOut(
  DataFlowCall call, Node node, CallContext innercc, DataFlowCallable innerc,
  AccessPathApproxOption argApa, AccessPathFront apf, AccessPathApprox apa, Configuration config
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    flowFwd(ret, innercc, argApa, apf, apa, config) and
    flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow, config) and
    innerc = ret.getEnclosingCallable() and
    flowCand(node, _, _, _, unbind(config)) and
    (
      resolveReturn(innercc, innerc, call)
      or
      innercc.(CallContextCall).matchesCall(call)
    )
  |
    apa instanceof AccessPathApproxNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowFwdOutFromArg(
  DataFlowCall call, Node node, AccessPathApprox argApa, AccessPathFront apf, AccessPathApprox apa,
  Configuration config
) {
  flowFwdOut(call, node, any(CallContextCall ccc), _, TAccessPathApproxSome(argApa), apf, apa,
    config)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `flowFwd`.
 */
pragma[nomagic]
private predicate flowFwdIsEntered(
  DataFlowCall call, CallContext cc, AccessPathApproxOption argApa, AccessPathApprox apa,
  Configuration config
) {
  exists(ParameterNode p, AccessPathFront apf |
    flowFwdIn(call, p, cc, _, argApa, apf, apa, config) and
    flowCand(p, true, TAccessPathFrontSome(_), apf, config)
  )
}

/**
 * Holds if `node` with approximate access path `apa` is part of a path from a
 * source to a sink in the configuration `config`.
 *
 * The Boolean `toReturn` records whether the node must be returned from
 * the enclosing callable in order to reach a sink, and if so, `returnApa`
 * records the approximate access path of the returned value.
 */
private predicate flow(
  Node node, boolean toReturn, AccessPathApproxOption returnApa, AccessPathApprox apa,
  Configuration config
) {
  flow0(node, toReturn, returnApa, apa, config) and
  flowFwd(node, _, _, _, apa, config)
}

private predicate flow0(
  Node node, boolean toReturn, AccessPathApproxOption returnApa, AccessPathApprox apa,
  Configuration config
) {
  flowFwd(node, _, _, _, apa, config) and
  config.isSink(node) and
  toReturn = false and
  returnApa = TAccessPathApproxNone() and
  apa instanceof AccessPathApproxNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, _, config, _) and
    flow(mid, toReturn, returnApa, apa, config)
  )
  or
  exists(Node mid, AccessPathApproxNil nil |
    flowFwd(node, _, _, _, apa, config) and
    localFlowBigStep(node, mid, false, _, config, _) and
    flow(mid, toReturn, returnApa, nil, config) and
    apa instanceof AccessPathApproxNil
  )
  or
  exists(Node mid |
    jumpStep(node, mid, config) and
    flow(mid, _, _, apa, config) and
    toReturn = false and
    returnApa = TAccessPathApproxNone()
  )
  or
  exists(Node mid, AccessPathApproxNil nil |
    flowFwd(node, _, _, _, apa, config) and
    additionalJumpStep(node, mid, config) and
    flow(mid, _, _, nil, config) and
    toReturn = false and
    returnApa = TAccessPathApproxNone() and
    apa instanceof AccessPathApproxNil
  )
  or
  // store
  exists(TypedContent tc |
    flowStore(tc, node, toReturn, returnApa, apa, config) and
    flowConsCand(tc, apa, config)
  )
  or
  // read
  exists(Node mid, AccessPathApprox apa0 |
    readFlowFwd(node, _, mid, apa, apa0, config) and
    flow(mid, toReturn, returnApa, apa0, config)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    flowIn(call, node, toReturn, returnApa, apa, config) and
    toReturn = false
    or
    exists(AccessPathApprox returnApa0 |
      flowInToReturn(call, node, returnApa0, apa, config) and
      flowIsReturned(call, toReturn, returnApa, returnApa0, config)
    )
  )
  or
  // flow out of a callable
  flowOut(_, node, _, _, apa, config) and
  toReturn = true and
  if flowFwd(node, any(CallContextCall ccc), TAccessPathApproxSome(_), _, apa, config)
  then returnApa = TAccessPathApproxSome(apa)
  else returnApa = TAccessPathApproxNone()
}

pragma[nomagic]
private predicate storeFlowFwd(
  Node node1, TypedContent tc, Node node2, AccessPathApprox apa, AccessPathApprox apa0,
  Configuration config
) {
  storeCand2(node1, tc, node2, _, config) and
  flowFwdStore(node2, tc, apa, _, _, _, config) and
  apa0 = push(tc, apa)
}

pragma[nomagic]
private predicate flowStore(
  TypedContent tc, Node node, boolean toReturn, AccessPathApproxOption returnApa,
  AccessPathApprox apa, Configuration config
) {
  exists(Node mid, AccessPathApprox apa0 |
    storeFlowFwd(node, tc, mid, apa, apa0, config) and
    flow(mid, toReturn, returnApa, apa0, config)
  )
}

pragma[nomagic]
private predicate readFlowFwd(
  Node node1, TypedContent tc, Node node2, AccessPathApprox apa, AccessPathApprox apa0,
  Configuration config
) {
  exists(AccessPathFrontHead apf |
    readCandFwd(node1, tc, apf, node2, config) and
    flowFwdRead(node2, apf, apa, _, _, _, config) and
    apa0 = pop(tc, apa) and
    flowFwdConsCand(tc, _, apa0, unbind(config))
  )
}

pragma[nomagic]
private predicate flowConsCand(TypedContent tc, AccessPathApprox apa, Configuration config) {
  exists(Node n, Node mid |
    flow(mid, _, _, apa, config) and
    readFlowFwd(n, tc, mid, _, apa, config)
  )
}

pragma[nomagic]
private predicate flowOut(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, AccessPathApproxOption returnApa,
  AccessPathApprox apa, Configuration config
) {
  exists(Node out, boolean allowsFieldFlow |
    flow(out, toReturn, returnApa, apa, config) and
    flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow, config)
  |
    apa instanceof AccessPathApproxNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowIn(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, AccessPathApproxOption returnApa,
  AccessPathApprox apa, Configuration config
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    flow(p, toReturn, returnApa, apa, config) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
  |
    apa instanceof AccessPathApproxNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowInToReturn(
  DataFlowCall call, ArgumentNode arg, AccessPathApprox returnApa, AccessPathApprox apa,
  Configuration config
) {
  flowIn(call, arg, true, TAccessPathApproxSome(returnApa), apa, config)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `flow`.
 */
pragma[nomagic]
private predicate flowIsReturned(
  DataFlowCall call, boolean toReturn, AccessPathApproxOption returnApa, AccessPathApprox apa,
  Configuration config
) {
  exists(ReturnNodeExt ret, CallContextCall ccc |
    flowOut(call, ret, toReturn, returnApa, apa, config) and
    flowFwd(ret, ccc, TAccessPathApproxSome(_), _, apa, config) and
    ccc.matchesCall(call)
  )
}

bindingset[conf, result]
private Configuration unbind(Configuration conf) { result >= conf and result <= conf }

private predicate flow(Node n, Configuration config) { flow(n, _, _, _, config) }

pragma[noinline]
private predicate parameterFlow(
  ParameterNode p, AccessPathApprox apa, DataFlowCallable c, Configuration config
) {
  flow(p, true, _, apa, config) and
  c = p.getEnclosingCallable()
}

private predicate parameterMayFlowThrough(ParameterNode p, AccessPathApprox apa) {
  exists(ReturnNodeExt ret, Configuration config, AccessPathApprox apa0 |
    parameterFlow(p, apa, ret.getEnclosingCallable(), config) and
    flow(ret, true, TAccessPathApproxSome(_), apa0, config) and
    flowFwd(ret, any(CallContextCall ccc), TAccessPathApproxSome(apa), _, apa0, config)
  )
}

private newtype TSummaryCtx =
  TSummaryCtxNone() or
  TSummaryCtxSome(ParameterNode p, AccessPath ap) { parameterMayFlowThrough(p, ap.getApprox()) }

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

private newtype TAccessPath =
  TAccessPathNil(DataFlowType t) or
  TAccessPathCons(TypedContent head, AccessPath tail) { flowConsCand(head, tail.getApprox(), _) }

private newtype TPathNode =
  TPathNodeMid(Node node, CallContext cc, SummaryCtx sc, AccessPath ap, Configuration config) {
    // A PathNode is introduced by a source ...
    flow(node, config) and
    config.isSource(node) and
    cc instanceof CallContextAny and
    sc instanceof SummaryCtxNone and
    ap = TAccessPathNil(getNodeType(node))
    or
    // ... or a step from an existing PathNode to another node.
    exists(PathNodeMid mid |
      pathStep(mid, node, cc, sc, ap) and
      config = mid.getConfiguration() and
      flow(node, _, _, ap.getApprox(), unbind(config))
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
        pathStep(mid, node, _, _, TAccessPathNil(_)) and
        config = unbind(mid.getConfiguration())
      )
    )
  }

/**
 * A list of `TypedContent`s followed by a `DataFlowType`. If data flows from a
 * source to a given node with a given `AccessPath`, this indicates the sequence
 * of dereference operations needed to get from the value in the node to the
 * tracked object. The final type indicates the type of the tracked object.
 */
abstract private class AccessPath extends TAccessPath {
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
  }

  override int length() { result = 1 + tail.length() }

  private string toStringImpl() {
    exists(DataFlowType t |
      tail = TAccessPathNil(t) and
      result = head.toString() + "]" + concat(" : " + ppReprType(t))
    )
    or
    result = head + ", " + tail.(AccessPathCons).toStringImpl()
  }

  override string toString() { result = "[" + this.toStringImpl() }
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

  private predicate isHidden() {
    nodeIsHidden(this.getNode()) and
    not this.isSource() and
    not this instanceof PathNodeSink
  }

  private PathNode getASuccessorIfHidden() {
    this.isHidden() and
    result = this.(PathNodeImpl).getASuccessorImpl()
  }

  /** Gets a successor of this node, if any. */
  final PathNode getASuccessor() {
    result = this.(PathNodeImpl).getASuccessorImpl().getASuccessorIfHidden*() and
    not this.isHidden() and
    not result.isHidden()
  }

  /** Holds if this node is a source. */
  predicate isSource() { none() }
}

abstract private class PathNodeImpl extends PathNode {
  abstract PathNode getASuccessorImpl();

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

  override PathNodeImpl getASuccessorImpl() {
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

  override PathNode getASuccessorImpl() { none() }

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
  ap = TAccessPathNil(getNodeType(node))
  or
  exists(TypedContent tc | pathStoreStep(mid, node, ap.pop(tc), tc, cc)) and
  sc = mid.getSummaryCtx()
  or
  exists(TypedContent tc | pathReadStep(mid, node, ap.push(tc), tc, cc)) and
  sc = mid.getSummaryCtx()
  or
  pathIntoCallable(mid, node, _, cc, sc, _) and ap = mid.getAp()
  or
  pathOutOfCallable(mid, node, cc) and ap = mid.getAp() and sc instanceof SummaryCtxNone
  or
  pathThroughCallable(mid, node, cc, ap) and sc = mid.getSummaryCtx()
}

pragma[nomagic]
private predicate readCand(Node node1, TypedContent tc, Node node2, Configuration config) {
  readCandFwd(node1, tc, _, node2, config) and
  flow(node2, config)
}

pragma[nomagic]
private predicate pathReadStep(
  PathNodeMid mid, Node node, AccessPath ap0, TypedContent tc, CallContext cc
) {
  ap0 = mid.getAp() and
  readCand(mid.getNode(), tc, node, mid.getConfiguration()) and
  cc = mid.getCallContext()
}

pragma[nomagic]
private predicate storeCand(Node node1, TypedContent tc, Node node2, Configuration config) {
  storeCand2(node1, tc, node2, _, config) and
  flow(node2, config)
}

pragma[nomagic]
private predicate pathStoreStep(
  PathNodeMid mid, Node node, AccessPath ap0, TypedContent tc, CallContext cc
) {
  ap0 = mid.getAp() and
  storeCand(mid.getNode(), tc, node, mid.getConfiguration()) and
  cc = mid.getCallContext()
}

private predicate pathOutOfCallable0(
  PathNodeMid mid, ReturnPosition pos, CallContext innercc, AccessPathApprox apa,
  Configuration config
) {
  pos = getReturnPosition(mid.getNode()) and
  innercc = mid.getCallContext() and
  innercc instanceof CallContextNoCall and
  apa = mid.getAp().getApprox() and
  config = mid.getConfiguration()
}

pragma[nomagic]
private predicate pathOutOfCallable1(
  PathNodeMid mid, DataFlowCall call, ReturnKindExt kind, CallContext cc, AccessPathApprox apa,
  Configuration config
) {
  exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
    pathOutOfCallable0(mid, pos, innercc, apa, config) and
    c = pos.getCallable() and
    kind = pos.getKind() and
    resolveReturn(innercc, c, call)
  |
    if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
  )
}

pragma[noinline]
private Node getAnOutNodeFlow(
  ReturnKindExt kind, DataFlowCall call, AccessPathApprox apa, Configuration config
) {
  result = kind.getAnOutNode(call) and
  flow(result, _, _, apa, config)
}

/**
 * Holds if data may flow from `mid` to `out`. The last step of this path
 * is a return from a callable and is recorded by `cc`, if needed.
 */
pragma[noinline]
private predicate pathOutOfCallable(PathNodeMid mid, Node out, CallContext cc) {
  exists(ReturnKindExt kind, DataFlowCall call, AccessPathApprox apa, Configuration config |
    pathOutOfCallable1(mid, call, kind, cc, apa, config) and
    out = getAnOutNodeFlow(kind, call, apa, config)
  )
}

/**
 * Holds if data may flow from `mid` to the `i`th argument of `call` in `cc`.
 */
pragma[noinline]
private predicate pathIntoArg(
  PathNodeMid mid, int i, CallContext cc, DataFlowCall call, AccessPath ap, AccessPathApprox apa
) {
  exists(ArgumentNode arg |
    arg = mid.getNode() and
    cc = mid.getCallContext() and
    arg.argumentOf(call, i) and
    ap = mid.getAp() and
    apa = ap.getApprox()
  )
}

pragma[noinline]
private predicate parameterCand(
  DataFlowCallable callable, int i, AccessPathApprox apa, Configuration config
) {
  exists(ParameterNode p |
    flow(p, _, _, apa, config) and
    p.isParameterOf(callable, i)
  )
}

pragma[nomagic]
private predicate pathIntoCallable0(
  PathNodeMid mid, DataFlowCallable callable, int i, CallContext outercc, DataFlowCall call,
  AccessPath ap
) {
  exists(AccessPathApprox apa |
    pathIntoArg(mid, i, outercc, call, ap, apa) and
    callable = resolveCall(call, outercc) and
    parameterCand(callable, any(int j | j <= i and j >= i), apa, mid.getConfiguration())
  )
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
  ReturnKindExt kind, CallContextCall cc, SummaryCtxSome sc, AccessPath ap, AccessPathApprox apa,
  Configuration config
) {
  exists(PathNodeMid mid, ReturnNodeExt ret, int pos |
    mid.getNode() = ret and
    kind = ret.getKind() and
    cc = mid.getCallContext() and
    sc = mid.getSummaryCtx() and
    config = mid.getConfiguration() and
    ap = mid.getAp() and
    apa = ap.getApprox() and
    pos = sc.getParameterPos() and
    not kind.(ParamUpdateReturnKind).getPosition() = pos
  )
}

pragma[nomagic]
private predicate pathThroughCallable0(
  DataFlowCall call, PathNodeMid mid, ReturnKindExt kind, CallContext cc, AccessPath ap,
  AccessPathApprox apa
) {
  exists(CallContext innercc, SummaryCtx sc |
    pathIntoCallable(mid, _, cc, innercc, sc, call) and
    paramFlowsThrough(kind, innercc, sc, ap, apa, unbind(mid.getConfiguration()))
  )
}

/**
 * Holds if data may flow from `mid` through a callable to the node `out`.
 * The context `cc` is restored to its value prior to entering the callable.
 */
pragma[noinline]
private predicate pathThroughCallable(PathNodeMid mid, Node out, CallContext cc, AccessPath ap) {
  exists(DataFlowCall call, ReturnKindExt kind, AccessPathApprox apa |
    pathThroughCallable0(call, mid, kind, cc, ap, apa) and
    out = getAnOutNodeFlow(kind, call, apa, unbind(mid.getConfiguration()))
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
      exists(TypedContent tc, int len | this = TPartialCons(tc, len) |
        if len = 1
        then result = "[" + tc.toString() + "]"
        else result = "[" + tc.toString() + ", ... (" + len.toString() + ")]"
      )
    }

    override AccessPathFront getFront() {
      exists(TypedContent tc | this = TPartialCons(tc, _) | result = TFrontHead(tc))
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
      ap = TPartialNil(getNodeType(node)) and
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
      then compatibleTypes(getNodeType(node), ap.getType())
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
      ap = TPartialNil(getNodeType(node)) and
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
    ap = TPartialNil(getNodeType(node)) and
    config = mid.getConfiguration()
    or
    partialPathStoreStep(mid, _, _, node, ap) and
    cc = mid.getCallContext() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    config = mid.getConfiguration()
    or
    exists(PartialAccessPath ap0, TypedContent tc |
      partialPathReadStep(mid, ap0, tc, node, cc, config) and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      apConsFwd(ap, tc, ap0, config) and
      compatibleTypes(ap.getType(), getNodeType(node))
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
    PartialPathNodePriv mid, PartialAccessPath ap1, TypedContent tc, Node node,
    PartialAccessPath ap2
  ) {
    exists(Node midNode, DataFlowType contentType |
      midNode = mid.getNode() and
      ap1 = mid.getAp() and
      store(midNode, tc, node, contentType) and
      ap2.getHead() = tc and
      ap2.len() = unbindInt(ap1.len() + 1) and
      compatibleTypes(ap1.getType(), contentType)
    )
  }

  pragma[nomagic]
  private predicate apConsFwd(
    PartialAccessPath ap1, TypedContent tc, PartialAccessPath ap2, Configuration config
  ) {
    exists(PartialPathNodePriv mid |
      partialPathStoreStep(mid, ap1, tc, _, ap2) and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate partialPathReadStep(
    PartialPathNodePriv mid, PartialAccessPath ap, TypedContent tc, Node node, CallContext cc,
    Configuration config
  ) {
    exists(Node midNode |
      midNode = mid.getNode() and
      ap = mid.getAp() and
      read(midNode, tc.getContent(), node) and
      ap.getHead() = tc and
      config = mid.getConfiguration() and
      cc = mid.getCallContext()
    )
  }

  private predicate partialPathOutOfCallable0(
    PartialPathNodePriv mid, ReturnPosition pos, CallContext innercc, PartialAccessPath ap,
    Configuration config
  ) {
    pos = getReturnPosition(mid.getNode()) and
    innercc = mid.getCallContext() and
    innercc instanceof CallContextNoCall and
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
