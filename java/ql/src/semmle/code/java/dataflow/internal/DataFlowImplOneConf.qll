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

private newtype TUnit = TMkUnit()

private class Unit extends TUnit {
  string toString() { result = "unit" }
}

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
class Configuration extends Unit {
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
  predicate hasFlow(Node source, Node sink) { flowsTo(source, sink) }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   *
   * The corresponding paths are generated from the end-points and the graph
   * included in the module `PathGraph`.
   */
  predicate hasFlowPath(PathNode source, PathNode sink) { flowsTo(source, sink, _, _) }

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
    partialFlow(source, node) and
    dist = node.getSourceDistance()
  }
}

// /**
//  * This class exists to prevent mutual recursion between the user-overridden
//  * member predicates of `Configuration` and the rest of the data-flow library.
//  * Good performance cannot be guaranteed in the presence of such recursion, so
//  * it should be replaced by using more than one copy of the data flow library.
//  */
// abstract private class ConfigurationRecursionPrevention extends Configuration {
//   bindingset[this]
//   ConfigurationRecursionPrevention() { any() }
//   override predicate hasFlow(Node source, Node sink) {
//     strictcount(Node n | this.isSource(n)) < 0
//     or
//     strictcount(Node n | this.isSink(n)) < 0
//     or
//     strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0
//     or
//     super.hasFlow(source, sink)
//   }
// }
private predicate inBarrier(Node node) {
  exists(Configuration config |
    config.isBarrierIn(node) and
    config.isSource(node)
  )
}

private predicate outBarrier(Node node) {
  exists(Configuration config |
    config.isBarrierOut(node) and
    config.isSink(node)
  )
}

private predicate fullBarrier(Node node) {
  exists(Configuration config |
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
  )
}

private class AdditionalFlowStepSource extends Node {
  AdditionalFlowStepSource() { any(Configuration c).isAdditionalFlowStep(this, _) }
}

pragma[noinline]
private predicate isAdditionalFlowStep(
  AdditionalFlowStepSource node1, Node node2, DataFlowCallable callable1
) {
  exists(Configuration config |
    config.isAdditionalFlowStep(node1, node2) and
    callable1 = node1.getEnclosingCallable()
  )
}

/**
 * Holds if data can flow in one local step from `node1` to `node2`.
 */
private predicate localFlowStep_(Node node1, Node node2) {
  simpleLocalFlowStep(node1, node2) and
  not outBarrier(node1) and
  not inBarrier(node2) and
  not fullBarrier(node1) and
  not fullBarrier(node2)
}

/**
 * Holds if the additional step from `node1` to `node2` does not jump between callables.
 */
private predicate additionalLocalFlowStep(Node node1, Node node2) {
  isAdditionalFlowStep(node1, node2, node2.getEnclosingCallable()) and
  not outBarrier(node1) and
  not inBarrier(node2) and
  not fullBarrier(node1) and
  not fullBarrier(node2)
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
 */
private predicate jumpStep_(Node node1, Node node2) {
  jumpStep(node1, node2) and
  not outBarrier(node1) and
  not inBarrier(node2) and
  not fullBarrier(node1) and
  not fullBarrier(node2)
}

/**
 * Holds if the additional step from `node1` to `node2` jumps between callables.
 */
private predicate additionalJumpStep(Node node1, Node node2) {
  exists(DataFlowCallable callable1 |
    isAdditionalFlowStep(node1, node2, callable1) and
    node2.getEnclosingCallable() != callable1 and
    not outBarrier(node1) and
    not inBarrier(node2) and
    not fullBarrier(node1) and
    not fullBarrier(node2)
  )
}

/**
 * Holds if field flow should be used for the given configuration.
 */
private predicate useFieldFlow() { any(Configuration config).fieldFlowBranchLimit() >= 1 }

/**
 * Holds if `node` is reachable from a source in the configuration `config`.
 *
 * The Boolean `fromArg` records whether the node is reached through an
 * argument in a call.
 */
private predicate nodeCandFwd1(Node node, boolean fromArg) {
  not fullBarrier(node) and
  (
    any(Configuration config).isSource(node) and
    fromArg = false
    or
    exists(Node mid |
      nodeCandFwd1(mid, fromArg) and
      localFlowStep_(mid, node)
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid, fromArg) and
      additionalLocalFlowStep(mid, node)
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid) and
      jumpStep_(mid, node) and
      fromArg = false
    )
    or
    exists(Node mid |
      nodeCandFwd1(mid) and
      additionalJumpStep(mid, node) and
      fromArg = false
    )
    or
    // store
    exists(Node mid |
      useFieldFlow() and
      nodeCandFwd1(mid, fromArg) and
      store(mid, _, node, _) and
      not outBarrier(mid)
    )
    or
    // read
    exists(Content c |
      nodeCandFwd1Read(c, node, fromArg) and
      nodeCandFwd1IsStored(c) and
      not inBarrier(node)
    )
    or
    // flow into a callable
    exists(Node arg |
      nodeCandFwd1(arg) and
      viableParamArg(_, node, arg) and
      fromArg = true
    )
    or
    // flow out of a callable
    exists(DataFlowCall call |
      nodeCandFwd1Out(call, node, false) and
      fromArg = false
      or
      nodeCandFwd1OutFromArg(call, node) and
      nodeCandFwd1IsEntered(call, fromArg)
    )
  )
}

private predicate nodeCandFwd1(Node node) { nodeCandFwd1(node, _) }

pragma[nomagic]
private predicate nodeCandFwd1Read(Content c, Node node, boolean fromArg) {
  exists(Node mid |
    nodeCandFwd1(mid, fromArg) and
    read(mid, c, node)
  )
}

/**
 * Holds if `c` is the target of a store in the flow covered by `nodeCandFwd1`.
 */
pragma[nomagic]
private predicate nodeCandFwd1IsStored(Content c) {
  exists(Node mid, Node node, TypedContent tc |
    not fullBarrier(node) and
    useFieldFlow() and
    nodeCandFwd1(mid) and
    store(mid, tc, node, _) and
    c = tc.getContent()
  )
}

pragma[nomagic]
private predicate nodeCandFwd1ReturnPosition(ReturnPosition pos, boolean fromArg) {
  exists(ReturnNodeExt ret |
    nodeCandFwd1(ret, fromArg) and
    getReturnPosition(ret) = pos
  )
}

pragma[nomagic]
private predicate nodeCandFwd1Out(DataFlowCall call, Node out, boolean fromArg) {
  exists(ReturnPosition pos |
    nodeCandFwd1ReturnPosition(pos, fromArg) and
    viableReturnPosOut(call, pos, out)
  )
}

pragma[nomagic]
private predicate nodeCandFwd1OutFromArg(DataFlowCall call, Node node) {
  nodeCandFwd1Out(call, node, true)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `nodeCandFwd1`.
 */
pragma[nomagic]
private predicate nodeCandFwd1IsEntered(DataFlowCall call, boolean fromArg) {
  exists(ArgumentNode arg |
    nodeCandFwd1(arg, fromArg) and
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
private predicate nodeCand1(Node node, boolean toReturn) {
  nodeCand1_0(node, toReturn) and
  nodeCandFwd1(node)
}

pragma[nomagic]
private predicate nodeCand1_0(Node node, boolean toReturn) {
  nodeCandFwd1(node) and
  any(Configuration config).isSink(node) and
  toReturn = false
  or
  exists(Node mid |
    localFlowStep_(node, mid) and
    nodeCand1(mid, toReturn)
  )
  or
  exists(Node mid |
    additionalLocalFlowStep(node, mid) and
    nodeCand1(mid, toReturn)
  )
  or
  exists(Node mid |
    jumpStep_(node, mid) and
    nodeCand1(mid, _) and
    toReturn = false
  )
  or
  exists(Node mid |
    additionalJumpStep(node, mid) and
    nodeCand1(mid, _) and
    toReturn = false
  )
  or
  // store
  exists(Content c |
    nodeCand1Store(c, node, toReturn) and
    nodeCand1IsRead(c)
  )
  or
  // read
  exists(Node mid, Content c |
    read(node, c, mid) and
    nodeCandFwd1IsStored(c) and
    nodeCand1(mid, toReturn)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    nodeCand1In(call, node, false) and
    toReturn = false
    or
    nodeCand1InToReturn(call, node) and
    nodeCand1IsReturned(call, toReturn)
  )
  or
  // flow out of a callable
  exists(ReturnPosition pos |
    nodeCand1Out(pos) and
    getReturnPosition(node) = pos and
    toReturn = true
  )
}

/**
 * Holds if `c` is the target of a read in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate nodeCand1IsRead(Content c) {
  exists(Node mid, Node node |
    useFieldFlow() and
    nodeCandFwd1(node) and
    read(node, c, mid) and
    nodeCandFwd1IsStored(c) and
    nodeCand1(mid, _)
  )
}

pragma[nomagic]
private predicate nodeCand1Store(Content c, Node node, boolean toReturn) {
  exists(Node mid, TypedContent tc |
    nodeCand1(mid, toReturn) and
    nodeCandFwd1IsStored(c) and
    store(node, tc, mid, _) and
    c = tc.getContent()
  )
}

/**
 * Holds if `c` is the target of both a read and a store in the flow covered
 * by `nodeCand1`.
 */
private predicate nodeCand1IsReadAndStored(Content c) {
  nodeCand1IsRead(c) and
  nodeCand1Store(c, _, _)
}

pragma[nomagic]
private predicate viableReturnPosOutNodeCandFwd1(DataFlowCall call, ReturnPosition pos, Node out) {
  nodeCandFwd1ReturnPosition(pos, _) and
  viableReturnPosOut(call, pos, out)
}

pragma[nomagic]
private predicate nodeCand1Out(ReturnPosition pos) {
  exists(DataFlowCall call, Node out |
    nodeCand1(out, _) and
    viableReturnPosOutNodeCandFwd1(call, pos, out)
  )
}

pragma[nomagic]
private predicate viableParamArgNodeCandFwd1(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
  viableParamArg(call, p, arg) and
  nodeCandFwd1(arg)
}

pragma[nomagic]
private predicate nodeCand1In(DataFlowCall call, ArgumentNode arg, boolean toReturn) {
  exists(ParameterNode p |
    nodeCand1(p, toReturn) and
    viableParamArgNodeCandFwd1(call, p, arg)
  )
}

pragma[nomagic]
private predicate nodeCand1InToReturn(DataFlowCall call, ArgumentNode arg) {
  nodeCand1In(call, arg, true)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate nodeCand1IsReturned(DataFlowCall call, boolean toReturn) {
  exists(Node out |
    nodeCand1(out, toReturn) and
    nodeCandFwd1OutFromArg(call, out)
  )
}

pragma[nomagic]
private predicate nodeCand1(Node node) { nodeCand1(node, _) }

private predicate throughFlowNodeCand1(Node node) {
  nodeCand1(node, true) and
  not fullBarrier(node) and
  not inBarrier(node) and
  not outBarrier(node)
}

/** Holds if flow may return from `callable`. */
pragma[nomagic]
private predicate returnFlowCallableNodeCand1(DataFlowCallable callable, ReturnKindExt kind) {
  exists(ReturnNodeExt ret |
    throughFlowNodeCand1(ret) and
    callable = ret.getEnclosingCallable() and
    kind = ret.getKind()
  )
}

/**
 * Holds if flow may enter through `p` and reach a return node making `p` a
 * candidate for the origin of a summary.
 */
private predicate parameterThroughFlowNodeCand1(ParameterNode p) {
  exists(ReturnKindExt kind |
    throughFlowNodeCand1(p) and
    returnFlowCallableNodeCand1(p.getEnclosingCallable(), kind) and
    // we don't expect a parameter to return stored in itself
    not exists(int pos |
      kind.(ParamUpdateReturnKind).getPosition() = pos and p.isParameterOf(_, pos)
    )
  )
}

pragma[nomagic]
private predicate storeCand1(Node n1, Content c, Node n2) {
  exists(TypedContent tc |
    nodeCand1IsReadAndStored(c) and
    nodeCand1(n2) and
    store(n1, tc, n2, _) and
    c = tc.getContent()
  )
}

pragma[nomagic]
private predicate read_(Node n1, Content c, Node n2) {
  nodeCand1IsReadAndStored(c) and
  nodeCand1(n2) and
  read(n1, c, n2)
}

pragma[noinline]
private predicate localFlowStepNodeCand1(Node node1, Node node2) {
  nodeCand1(node1) and
  localFlowStep_(node1, node2)
}

pragma[noinline]
private predicate additionalLocalFlowStepNodeCand1(Node node1, Node node2) {
  nodeCand1(node1) and
  additionalLocalFlowStep(node1, node2)
}

pragma[nomagic]
private predicate viableReturnPosOutNodeCand1(DataFlowCall call, ReturnPosition pos, Node out) {
  nodeCand1(out, _) and
  viableReturnPosOutNodeCandFwd1(call, pos, out)
}

/**
 * Holds if data can flow out of `call` from `ret` to `out`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink.
 */
pragma[nomagic]
private predicate flowOutOfCallNodeCand1(DataFlowCall call, ReturnNodeExt ret, Node out) {
  viableReturnPosOutNodeCand1(call, getReturnPosition(ret), out) and
  nodeCand1(ret) and
  not outBarrier(ret) and
  not inBarrier(out)
}

pragma[nomagic]
private predicate viableParamArgNodeCand1(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
  viableParamArgNodeCandFwd1(call, p, arg) and
  nodeCand1(arg)
}

/**
 * Holds if data can flow into `call` and that this step is part of a
 * path from a source to a sink.
 */
pragma[nomagic]
private predicate flowIntoCallNodeCand1(DataFlowCall call, ArgumentNode arg, ParameterNode p) {
  viableParamArgNodeCand1(call, p, arg) and
  nodeCand1(p) and
  not outBarrier(arg) and
  not inBarrier(p)
}

/**
 * Gets the amount of forward branching on the origin of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int branch(Node n1) {
  result = strictcount(Node n | flowOutOfCallNodeCand1(_, n1, n) or flowIntoCallNodeCand1(_, n1, n))
}

/**
 * Gets the amount of backward branching on the target of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int join(Node n2) {
  result = strictcount(Node n | flowOutOfCallNodeCand1(_, n, n2) or flowIntoCallNodeCand1(_, n, n2))
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
  DataFlowCall call, ReturnNodeExt ret, Node out, boolean allowsFieldFlow
) {
  flowOutOfCallNodeCand1(call, ret, out) and
  exists(int b, int j |
    b = branch(ret) and
    j = join(out) and
    if b.minimum(j) <= any(Configuration config).fieldFlowBranchLimit()
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
  DataFlowCall call, ArgumentNode arg, ParameterNode p, boolean allowsFieldFlow
) {
  flowIntoCallNodeCand1(call, arg, p) and
  exists(int b, int j |
    b = branch(arg) and
    j = join(p) and
    if b.minimum(j) <= any(Configuration config).fieldFlowBranchLimit()
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
private predicate nodeCandFwd2(Node node, boolean fromArg, BooleanOption argStored, boolean stored) {
  nodeCand1(node) and
  any(Configuration config).isSource(node) and
  fromArg = false and
  argStored = TBooleanNone() and
  stored = false
  or
  nodeCand1(node) and
  (
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, argStored, stored) and
      localFlowStepNodeCand1(mid, node)
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, argStored, stored) and
      additionalLocalFlowStepNodeCand1(mid, node) and
      stored = false
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, _, _, stored) and
      jumpStep_(mid, node) and
      fromArg = false and
      argStored = TBooleanNone()
    )
    or
    exists(Node mid |
      nodeCandFwd2(mid, _, _, stored) and
      additionalJumpStep(mid, node) and
      fromArg = false and
      argStored = TBooleanNone() and
      stored = false
    )
    or
    // store
    exists(Node mid |
      nodeCandFwd2(mid, fromArg, argStored, _) and
      storeCand1(mid, _, node) and
      stored = true
    )
    or
    // read
    exists(Content c |
      nodeCandFwd2Read(c, node, fromArg, argStored) and
      nodeCandFwd2IsStored(c, stored)
    )
    or
    // flow into a callable
    nodeCandFwd2In(_, node, _, _, stored) and
    fromArg = true and
    if parameterThroughFlowNodeCand1(node)
    then argStored = TBooleanSome(stored)
    else argStored = TBooleanNone()
    or
    // flow out of a callable
    exists(DataFlowCall call |
      nodeCandFwd2Out(call, node, fromArg, argStored, stored) and
      fromArg = false
      or
      exists(boolean argStored0 |
        nodeCandFwd2OutFromArg(call, node, argStored0, stored) and
        nodeCandFwd2IsEntered(call, fromArg, argStored, argStored0)
      )
    )
  )
}

/**
 * Holds if `c` is the target of a store in the flow covered by `nodeCandFwd2`.
 */
pragma[noinline]
private predicate nodeCandFwd2IsStored(Content c, boolean stored) {
  exists(Node mid, Node node |
    useFieldFlow() and
    nodeCand1(node) and
    nodeCandFwd2(mid, _, _, stored) and
    storeCand1(mid, c, node)
  )
}

pragma[nomagic]
private predicate nodeCandFwd2Read(Content c, Node node, boolean fromArg, BooleanOption argStored) {
  exists(Node mid |
    nodeCandFwd2(mid, fromArg, argStored, true) and
    read_(mid, c, node)
  )
}

pragma[nomagic]
private predicate nodeCandFwd2In(
  DataFlowCall call, ParameterNode p, boolean fromArg, BooleanOption argStored, boolean stored
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow |
    nodeCandFwd2(arg, fromArg, argStored, stored) and
    flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow)
  |
    stored = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCandFwd2Out(
  DataFlowCall call, Node out, boolean fromArg, BooleanOption argStored, boolean stored
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    nodeCandFwd2(ret, fromArg, argStored, stored) and
    flowOutOfCallNodeCand1(call, ret, out, allowsFieldFlow)
  |
    stored = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCandFwd2OutFromArg(
  DataFlowCall call, Node out, boolean argStored, boolean stored
) {
  nodeCandFwd2Out(call, out, true, TBooleanSome(argStored), stored)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `nodeCandFwd2`.
 */
pragma[nomagic]
private predicate nodeCandFwd2IsEntered(
  DataFlowCall call, boolean fromArg, BooleanOption argStored, boolean stored
) {
  exists(ParameterNode p |
    nodeCandFwd2In(call, p, fromArg, argStored, stored) and
    parameterThroughFlowNodeCand1(p)
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
private predicate nodeCand2(Node node, boolean toReturn, BooleanOption returnRead, boolean read) {
  nodeCandFwd2(node, _, _, false) and
  any(Configuration config).isSink(node) and
  toReturn = false and
  returnRead = TBooleanNone() and
  read = false
  or
  nodeCandFwd2(node, _, _, unbindBool(read)) and
  (
    exists(Node mid |
      localFlowStepNodeCand1(node, mid) and
      nodeCand2(mid, toReturn, returnRead, read)
    )
    or
    exists(Node mid |
      additionalLocalFlowStepNodeCand1(node, mid) and
      nodeCand2(mid, toReturn, returnRead, read) and
      read = false
    )
    or
    exists(Node mid |
      jumpStep_(node, mid) and
      nodeCand2(mid, _, _, read) and
      toReturn = false and
      returnRead = TBooleanNone()
    )
    or
    exists(Node mid |
      additionalJumpStep(node, mid) and
      nodeCand2(mid, _, _, read) and
      toReturn = false and
      returnRead = TBooleanNone() and
      read = false
    )
    or
    // store
    exists(Content c |
      nodeCand2Store(c, node, toReturn, returnRead, read) and
      nodeCand2IsRead(c, read)
    )
    or
    // read
    exists(Node mid, Content c, boolean read0 |
      read_(node, c, mid) and
      nodeCandFwd2IsStored(c, unbindBool(read0)) and
      nodeCand2(mid, toReturn, returnRead, read0) and
      read = true
    )
    or
    // flow into a callable
    exists(DataFlowCall call |
      nodeCand2In(call, node, toReturn, returnRead, read) and
      toReturn = false
      or
      exists(boolean returnRead0 |
        nodeCand2InToReturn(call, node, returnRead0, read) and
        nodeCand2IsReturned(call, toReturn, returnRead, returnRead0)
      )
    )
    or
    // flow out of a callable
    nodeCand2Out(_, node, _, _, read) and
    toReturn = true and
    if nodeCandFwd2(node, true, TBooleanSome(_), unbindBool(read))
    then returnRead = TBooleanSome(read)
    else returnRead = TBooleanNone()
  )
}

/**
 * Holds if `c` is the target of a read in the flow covered by `nodeCand2`.
 */
pragma[noinline]
private predicate nodeCand2IsRead(Content c, boolean read) {
  exists(Node mid, Node node |
    useFieldFlow() and
    nodeCandFwd2(node, _, _, true) and
    read_(node, c, mid) and
    nodeCandFwd2IsStored(c, unbindBool(read)) and
    nodeCand2(mid, _, _, read)
  )
}

pragma[nomagic]
private predicate nodeCand2Store(
  Content c, Node node, boolean toReturn, BooleanOption returnRead, boolean stored
) {
  exists(Node mid |
    storeCand1(node, c, mid) and
    nodeCand2(mid, toReturn, returnRead, true) and
    nodeCandFwd2(node, _, _, stored)
  )
}

/**
 * Holds if `c` is the target of a store in the flow covered by `nodeCand2`.
 */
pragma[nomagic]
private predicate nodeCand2IsStored(Content c, boolean stored) {
  exists(Node node |
    nodeCand2Store(c, node, _, _, stored) and
    nodeCand2(node, _, _, stored)
  )
}

/**
 * Holds if `c` is the target of both a store and a read in the path graph
 * covered by `nodeCand2`.
 */
pragma[noinline]
private predicate nodeCand2IsReadAndStored(Content c) {
  exists(boolean apNonEmpty |
    nodeCand2IsStored(c, apNonEmpty) and
    nodeCand2IsRead(c, apNonEmpty)
  )
}

pragma[nomagic]
private predicate nodeCand2Out(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, BooleanOption returnRead, boolean read
) {
  exists(Node out, boolean allowsFieldFlow |
    nodeCand2(out, toReturn, returnRead, read) and
    flowOutOfCallNodeCand1(call, ret, out, allowsFieldFlow)
  |
    read = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCand2In(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, BooleanOption returnRead, boolean read
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    nodeCand2(p, toReturn, returnRead, read) and
    flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow)
  |
    read = false or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate nodeCand2InToReturn(
  DataFlowCall call, ArgumentNode arg, boolean returnRead, boolean read
) {
  nodeCand2In(call, arg, true, TBooleanSome(returnRead), read)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `nodeCand2`.
 */
pragma[nomagic]
private predicate nodeCand2IsReturned(
  DataFlowCall call, boolean toReturn, BooleanOption returnRead, boolean read
) {
  exists(ReturnNodeExt ret |
    nodeCand2Out(call, ret, toReturn, returnRead, read) and
    nodeCandFwd2(ret, true, TBooleanSome(_), read)
  )
}

private predicate nodeCand2(Node node) { nodeCand2(node, _, _, _) }

pragma[nomagic]
private predicate flowOutOfCallNodeCand2(
  DataFlowCall call, ReturnNodeExt node1, Node node2, boolean allowsFieldFlow
) {
  flowOutOfCallNodeCand1(call, node1, node2, allowsFieldFlow) and
  nodeCand2(node2) and
  nodeCand2(node1)
}

pragma[nomagic]
private predicate flowIntoCallNodeCand2(
  DataFlowCall call, ArgumentNode node1, ParameterNode node2, boolean allowsFieldFlow
) {
  flowIntoCallNodeCand1(call, node1, node2, allowsFieldFlow) and
  nodeCand2(node2) and
  nodeCand2(node1)
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
  private predicate localFlowEntry(Node node) {
    nodeCand2(node) and
    (
      any(Configuration config).isSource(node) or
      jumpStep_(_, node) or
      additionalJumpStep(_, node) or
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
  private predicate localFlowExit(Node node) {
    exists(Node next | nodeCand2(next) |
      jumpStep_(node, next) or
      additionalJumpStep(node, next) or
      flowIntoCallNodeCand1(_, node, next) or
      flowOutOfCallNodeCand1(_, node, next) or
      store(node, _, next, _) or
      read(node, _, next)
    )
    or
    node instanceof FlowCheckNode
    or
    any(Configuration config).isSink(node)
  }

  pragma[noinline]
  private predicate additionalLocalFlowStepNodeCand2(Node node1, Node node2) {
    additionalLocalFlowStepNodeCand1(node1, node2) and
    nodeCand2(node1, _, _, false) and
    nodeCand2(node2, _, _, false)
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
    Node node1, Node node2, boolean preservesValue, DataFlowType t, LocalCallContext cc
  ) {
    not isUnreachableInCall(node2, cc.(LocalCallContextSpecificCall).getCall()) and
    (
      localFlowEntry(node1) and
      (
        localFlowStepNodeCand1(node1, node2) and
        preservesValue = true and
        t = getNodeType(node1)
        or
        additionalLocalFlowStepNodeCand2(node1, node2) and
        preservesValue = false and
        t = getNodeType(node2)
      ) and
      node1 != node2 and
      cc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall(node1, cc.(LocalCallContextSpecificCall).getCall()) and
      nodeCand2(node2)
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, preservesValue, t, cc) and
        localFlowStepNodeCand1(mid, node2) and
        not mid instanceof FlowCheckNode and
        nodeCand2(node2)
      )
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, _, _, cc) and
        additionalLocalFlowStepNodeCand2(mid, node2) and
        not mid instanceof FlowCheckNode and
        preservesValue = false and
        t = getNodeType(node2) and
        nodeCand2(node2)
      )
    )
  }

  /**
   * Holds if `node1` can step to `node2` in one or more local steps and this
   * path can occur as a maximal subsequence of local steps in a dataflow path.
   */
  pragma[nomagic]
  predicate localFlowBigStep(
    Node node1, Node node2, boolean preservesValue, AccessPathFrontNil apf,
    LocalCallContext callContext
  ) {
    localFlowStepPlus(node1, node2, preservesValue, apf.getType(), callContext) and
    localFlowExit(node2)
  }
}

private import LocalFlowBigStep

pragma[nomagic]
private predicate readCand2(Node node1, Content c, Node node2) {
  read_(node1, c, node2) and
  nodeCand2(node1, _, _, true) and
  nodeCand2(node2) and
  nodeCand2IsReadAndStored(c)
}

pragma[nomagic]
private predicate storeCand2(Node node1, TypedContent tc, Node node2, DataFlowType contentType) {
  store(node1, tc, node2, contentType) and
  nodeCand2(node1) and
  nodeCand2(node2, _, _, true) and
  nodeCand2IsReadAndStored(tc.getContent())
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
  Node node, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf
) {
  flowCandFwd0(node, fromArg, argApf, apf) and
  not apf.isClearedAt(node) and
  if node instanceof CastingNode then compatibleTypes(getNodeType(node), apf.getType()) else any()
}

pragma[nomagic]
private predicate flowCandFwd0(
  Node node, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf
) {
  nodeCand2(node, _, _, false) and
  any(Configuration config).isSource(node) and
  fromArg = false and
  argApf = TAccessPathFrontNone() and
  apf = TFrontNil(getNodeType(node))
  or
  exists(Node mid |
    flowCandFwd(mid, fromArg, argApf, apf) and
    localFlowBigStep(mid, node, true, _, _)
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(mid, fromArg, argApf, nil) and
    localFlowBigStep(mid, node, false, apf, _)
  )
  or
  exists(Node mid |
    flowCandFwd(mid, _, _, apf) and
    nodeCand2(node) and
    jumpStep_(mid, node) and
    fromArg = false and
    argApf = TAccessPathFrontNone()
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(mid, _, _, nil) and
    nodeCand2(node) and
    additionalJumpStep(mid, node) and
    fromArg = false and
    argApf = TAccessPathFrontNone() and
    apf = TFrontNil(getNodeType(node))
  )
  or
  // store
  exists(Node mid, TypedContent tc, AccessPathFront apf0, DataFlowType contentType |
    flowCandFwd(mid, fromArg, argApf, apf0) and
    storeCand2(mid, tc, node, contentType) and
    nodeCand2(node, _, _, true) and
    apf.headUsesContent(tc) and
    compatibleTypes(apf0.getType(), contentType)
  )
  or
  // read
  exists(TypedContent tc |
    flowCandFwdRead(tc, node, fromArg, argApf) and
    flowCandFwdConsCand(tc, apf) and
    nodeCand2(node, _, _, unbindBool(apf.toBoolNonEmpty()))
  )
  or
  // flow into a callable
  flowCandFwdIn(_, node, _, _, apf) and
  fromArg = true and
  if nodeCand2(node, true, _, unbindBool(apf.toBoolNonEmpty()))
  then argApf = TAccessPathFrontSome(apf)
  else argApf = TAccessPathFrontNone()
  or
  // flow out of a callable
  exists(DataFlowCall call |
    flowCandFwdOut(call, node, fromArg, argApf, apf) and
    fromArg = false
    or
    exists(AccessPathFront argApf0 |
      flowCandFwdOutFromArg(call, node, argApf0, apf) and
      flowCandFwdIsEntered(call, fromArg, argApf, argApf0)
    )
  )
}

pragma[nomagic]
private predicate flowCandFwdConsCand(TypedContent tc, AccessPathFront apf) {
  exists(Node mid, Node n, DataFlowType contentType |
    flowCandFwd(mid, _, _, apf) and
    storeCand2(mid, tc, n, contentType) and
    nodeCand2(n, _, _, true) and
    compatibleTypes(apf.getType(), contentType)
  )
}

pragma[nomagic]
private predicate flowCandFwdRead0(
  Node node1, TypedContent tc, Content c, Node node2, boolean fromArg, AccessPathFrontOption argApf,
  AccessPathFrontHead apf
) {
  flowCandFwd(node1, fromArg, argApf, apf) and
  readCand2(node1, c, node2) and
  apf.headUsesContent(tc)
}

pragma[nomagic]
private predicate flowCandFwdRead(
  TypedContent tc, Node node, boolean fromArg, AccessPathFrontOption argApf
) {
  flowCandFwdRead0(_, tc, tc.getContent(), node, fromArg, argApf, _)
}

pragma[nomagic]
private predicate flowCandFwdIn(
  DataFlowCall call, ParameterNode p, boolean fromArg, AccessPathFrontOption argApf,
  AccessPathFront apf
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow |
    flowCandFwd(arg, fromArg, argApf, apf) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandFwdOut(
  DataFlowCall call, Node node, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    flowCandFwd(ret, fromArg, argApf, apf) and
    flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandFwdOutFromArg(
  DataFlowCall call, Node node, AccessPathFront argApf, AccessPathFront apf
) {
  flowCandFwdOut(call, node, true, TAccessPathFrontSome(argApf), apf)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `flowCandFwd`.
 */
pragma[nomagic]
private predicate flowCandFwdIsEntered(
  DataFlowCall call, boolean fromArg, AccessPathFrontOption argApf, AccessPathFront apf
) {
  exists(ParameterNode p |
    flowCandFwdIn(call, p, fromArg, argApf, apf) and
    nodeCand2(p, true, TBooleanSome(_), unbindBool(apf.toBoolNonEmpty()))
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
  Node node, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf
) {
  flowCand0(node, toReturn, returnApf, apf) and
  flowCandFwd(node, _, _, apf)
}

pragma[nomagic]
private predicate flowCand0(
  Node node, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf
) {
  flowCandFwd(node, _, _, apf) and
  any(Configuration config).isSink(node) and
  toReturn = false and
  returnApf = TAccessPathFrontNone() and
  apf instanceof AccessPathFrontNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, _, _) and
    flowCand(mid, toReturn, returnApf, apf)
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, _, apf) and
    localFlowBigStep(node, mid, false, _, _) and
    flowCand(mid, toReturn, returnApf, nil) and
    apf instanceof AccessPathFrontNil
  )
  or
  exists(Node mid |
    jumpStep_(node, mid) and
    flowCand(mid, _, _, apf) and
    toReturn = false and
    returnApf = TAccessPathFrontNone()
  )
  or
  exists(Node mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, _, apf) and
    additionalJumpStep(node, mid) and
    flowCand(mid, _, _, nil) and
    toReturn = false and
    returnApf = TAccessPathFrontNone() and
    apf instanceof AccessPathFrontNil
  )
  or
  // store
  exists(TypedContent tc |
    flowCandStore(node, tc, apf, toReturn, returnApf) and
    flowCandConsCand(tc, apf)
  )
  or
  // read
  exists(TypedContent tc, AccessPathFront apf0 |
    flowCandRead(node, tc, apf, toReturn, returnApf, apf0) and
    flowCandFwdConsCand(tc, apf0)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    flowCandIn(call, node, toReturn, returnApf, apf) and
    toReturn = false
    or
    exists(AccessPathFront returnApf0 |
      flowCandInToReturn(call, node, returnApf0, apf) and
      flowCandIsReturned(call, toReturn, returnApf, returnApf0)
    )
  )
  or
  // flow out of a callable
  flowCandOut(_, node, _, _, apf) and
  toReturn = true and
  if flowCandFwd(node, true, _, apf)
  then returnApf = TAccessPathFrontSome(apf)
  else returnApf = TAccessPathFrontNone()
}

pragma[nomagic]
private predicate readCandFwd(Node node1, TypedContent tc, AccessPathFront apf, Node node2) {
  flowCandFwdRead0(node1, tc, tc.getContent(), node2, _, _, apf)
}

pragma[nomagic]
private predicate flowCandRead(
  Node node, TypedContent tc, AccessPathFront apf, boolean toReturn,
  AccessPathFrontOption returnApf, AccessPathFront apf0
) {
  exists(Node mid |
    readCandFwd(node, tc, apf, mid) and
    flowCand(mid, toReturn, returnApf, apf0)
  )
}

pragma[nomagic]
private predicate flowCandStore(
  Node node, TypedContent tc, AccessPathFront apf, boolean toReturn, AccessPathFrontOption returnApf
) {
  exists(Node mid |
    flowCandFwd(node, _, _, apf) and
    storeCand2(node, tc, mid, _) and
    flowCand(mid, toReturn, returnApf, TFrontHead(tc))
  )
}

pragma[nomagic]
private predicate flowCandConsCand(TypedContent tc, AccessPathFront apf) {
  flowCandFwdConsCand(tc, apf) and
  flowCandRead(_, tc, _, _, _, apf)
}

pragma[nomagic]
private predicate flowCandOut(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, AccessPathFrontOption returnApf,
  AccessPathFront apf
) {
  exists(Node out, boolean allowsFieldFlow |
    flowCand(out, toReturn, returnApf, apf) and
    flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandIn(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, AccessPathFrontOption returnApf,
  AccessPathFront apf
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    flowCand(p, toReturn, returnApf, apf) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow)
  |
    apf instanceof AccessPathFrontNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowCandInToReturn(
  DataFlowCall call, ArgumentNode arg, AccessPathFront returnApf, AccessPathFront apf
) {
  flowCandIn(call, arg, true, TAccessPathFrontSome(returnApf), apf)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `flowCand`.
 */
pragma[nomagic]
private predicate flowCandIsReturned(
  DataFlowCall call, boolean toReturn, AccessPathFrontOption returnApf, AccessPathFront apf
) {
  exists(ReturnNodeExt ret |
    flowCandOut(call, ret, toReturn, returnApf, apf) and
    flowCandFwd(ret, true, TAccessPathFrontSome(_), apf)
  )
}

private newtype TAccessPath =
  TNil(DataFlowType t) or
  TConsNil(TypedContent tc, DataFlowType t) { flowCandConsCand(tc, TFrontNil(t)) } or
  TConsCons(TypedContent tc1, TypedContent tc2, int len) {
    flowCandConsCand(tc1, TFrontHead(tc2)) and len in [2 .. accessPathLimit()]
  }

/**
 * Conceptually a list of `TypedContent`s followed by a `Type`, but only the first two
 * elements of the list and its length are tracked. If data flows from a source to
 * a given node with a given `AccessPath`, this indicates the sequence of
 * dereference operations needed to get from the value in the node to the
 * tracked object. The final type indicates the type of the tracked object.
 */
abstract private class AccessPath extends TAccessPath {
  abstract string toString();

  abstract TypedContent getHead();

  abstract int len();

  abstract DataFlowType getType();

  abstract AccessPathFront getFront();

  /**
   * Holds if this access path has `head` at the front and may be followed by `tail`.
   */
  abstract predicate pop(TypedContent head, AccessPath tail);
}

private class AccessPathNil extends AccessPath, TNil {
  private DataFlowType t;

  AccessPathNil() { this = TNil(t) }

  override string toString() { result = concat(": " + ppReprType(t)) }

  override TypedContent getHead() { none() }

  override int len() { result = 0 }

  override DataFlowType getType() { result = t }

  override AccessPathFront getFront() { result = TFrontNil(t) }

  override predicate pop(TypedContent head, AccessPath tail) { none() }
}

abstract private class AccessPathCons extends AccessPath { }

private class AccessPathConsNil extends AccessPathCons, TConsNil {
  private TypedContent tc;
  private DataFlowType t;

  AccessPathConsNil() { this = TConsNil(tc, t) }

  override string toString() {
    // The `concat` becomes "" if `ppReprType` has no result.
    result = "[" + tc.toString() + "]" + concat(" : " + ppReprType(t))
  }

  override TypedContent getHead() { result = tc }

  override int len() { result = 1 }

  override DataFlowType getType() { result = tc.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(tc) }

  override predicate pop(TypedContent head, AccessPath tail) { head = tc and tail = TNil(t) }
}

private class AccessPathConsCons extends AccessPathCons, TConsCons {
  private TypedContent tc1;
  private TypedContent tc2;
  private int len;

  AccessPathConsCons() { this = TConsCons(tc1, tc2, len) }

  override string toString() {
    if len = 2
    then result = "[" + tc1.toString() + ", " + tc2.toString() + "]"
    else result = "[" + tc1.toString() + ", " + tc2.toString() + ", ... (" + len.toString() + ")]"
  }

  override TypedContent getHead() { result = tc1 }

  override int len() { result = len }

  override DataFlowType getType() { result = tc1.getContainerType() }

  override AccessPathFront getFront() { result = TFrontHead(tc1) }

  override predicate pop(TypedContent head, AccessPath tail) {
    head = tc1 and
    (
      tail = TConsCons(tc2, _, len - 1)
      or
      len = 2 and
      tail = TConsNil(tc2, _)
    )
  }
}

/** Gets the access path obtained by popping `tc` from `ap`, if any. */
private AccessPath pop(TypedContent tc, AccessPath ap) { ap.pop(tc, result) }

/** Gets the access path obtained by pushing `tc` onto `ap`. */
private AccessPath push(TypedContent tc, AccessPath ap) { ap = pop(tc, result) }

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
  Node node, boolean fromArg, AccessPathOption argAp, AccessPathFront apf, AccessPath ap
) {
  flowFwd0(node, fromArg, argAp, apf, ap) and
  flowCand(node, _, _, apf)
}

private predicate flowFwd0(
  Node node, boolean fromArg, AccessPathOption argAp, AccessPathFront apf, AccessPath ap
) {
  flowCand(node, _, _, _) and
  any(Configuration config).isSource(node) and
  fromArg = false and
  argAp = TAccessPathNone() and
  ap = TNil(getNodeType(node)) and
  apf = ap.(AccessPathNil).getFront()
  or
  flowCand(node, _, _, _) and
  (
    exists(Node mid |
      flowFwd(mid, fromArg, argAp, apf, ap) and
      localFlowBigStep(mid, node, true, _, _)
    )
    or
    exists(Node mid, AccessPathNil nil |
      flowFwd(mid, fromArg, argAp, _, nil) and
      localFlowBigStep(mid, node, false, apf, _) and
      apf = ap.(AccessPathNil).getFront()
    )
    or
    exists(Node mid |
      flowFwd(mid, _, _, apf, ap) and
      jumpStep_(mid, node) and
      fromArg = false and
      argAp = TAccessPathNone()
    )
    or
    exists(Node mid, AccessPathNil nil |
      flowFwd(mid, _, _, _, nil) and
      additionalJumpStep(mid, node) and
      fromArg = false and
      argAp = TAccessPathNone() and
      ap = TNil(getNodeType(node)) and
      apf = ap.(AccessPathNil).getFront()
    )
  )
  or
  // store
  exists(TypedContent tc | flowFwdStore(node, tc, pop(tc, ap), apf, fromArg, argAp))
  or
  // read
  exists(TypedContent tc |
    flowFwdRead(node, _, push(tc, ap), apf, fromArg, argAp) and
    flowFwdConsCand(tc, apf, ap)
  )
  or
  // flow into a callable
  flowFwdIn(_, node, _, _, apf, ap) and
  fromArg = true and
  if flowCand(node, true, _, apf) then argAp = TAccessPathSome(ap) else argAp = TAccessPathNone()
  or
  // flow out of a callable
  exists(DataFlowCall call |
    flowFwdOut(call, node, fromArg, argAp, apf, ap) and
    fromArg = false
    or
    exists(AccessPath argAp0 |
      flowFwdOutFromArg(call, node, argAp0, apf, ap) and
      flowFwdIsEntered(call, fromArg, argAp, argAp0)
    )
  )
}

pragma[nomagic]
private predicate flowFwdStore(
  Node node, TypedContent tc, AccessPath ap0, AccessPathFront apf, boolean fromArg,
  AccessPathOption argAp
) {
  exists(Node mid, AccessPathFront apf0 |
    flowFwd(mid, fromArg, argAp, apf0, ap0) and
    flowFwdStore0(mid, tc, node, apf0, apf)
  )
}

pragma[nomagic]
private predicate storeCand(
  Node mid, TypedContent tc, Node node, AccessPathFront apf0, AccessPathFront apf
) {
  storeCand2(mid, tc, node, _) and
  flowCand(mid, _, _, apf0) and
  apf.headUsesContent(tc)
}

pragma[noinline]
private predicate flowFwdStore0(
  Node mid, TypedContent tc, Node node, AccessPathFront apf0, AccessPathFrontHead apf
) {
  storeCand(mid, tc, node, apf0, apf) and
  flowCandConsCand(tc, apf0) and
  flowCand(node, _, _, apf)
}

pragma[nomagic]
private predicate flowFwdRead0(
  Node node1, TypedContent tc, AccessPathFrontHead apf0, AccessPath ap0, Node node2,
  boolean fromArg, AccessPathOption argAp
) {
  flowFwd(node1, fromArg, argAp, apf0, ap0) and
  readCandFwd(node1, tc, apf0, node2)
}

pragma[nomagic]
private predicate flowFwdRead(
  Node node, AccessPathFrontHead apf0, AccessPath ap0, AccessPathFront apf, boolean fromArg,
  AccessPathOption argAp
) {
  exists(Node mid, TypedContent tc |
    flowFwdRead0(mid, tc, apf0, ap0, node, fromArg, argAp) and
    flowCand(node, _, _, apf) and
    flowCandConsCand(tc, apf)
  )
}

pragma[nomagic]
private predicate flowFwdConsCand(TypedContent tc, AccessPathFront apf, AccessPath ap) {
  exists(Node n |
    flowFwd(n, _, _, apf, ap) and
    flowFwdStore0(n, tc, _, apf, _)
  )
}

pragma[nomagic]
private predicate flowFwdIn(
  DataFlowCall call, ParameterNode p, boolean fromArg, AccessPathOption argAp, AccessPathFront apf,
  AccessPath ap
) {
  exists(ArgumentNode arg, boolean allowsFieldFlow |
    flowFwd(arg, fromArg, argAp, apf, ap) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow) and
    flowCand(p, _, _, _)
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowFwdOut(
  DataFlowCall call, Node node, boolean fromArg, AccessPathOption argAp, AccessPathFront apf,
  AccessPath ap
) {
  exists(ReturnNodeExt ret, boolean allowsFieldFlow |
    flowFwd(ret, fromArg, argAp, apf, ap) and
    flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow) and
    flowCand(node, _, _, _)
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowFwdOutFromArg(
  DataFlowCall call, Node node, AccessPath argAp, AccessPathFront apf, AccessPath ap
) {
  flowFwdOut(call, node, true, TAccessPathSome(argAp), apf, ap)
}

/**
 * Holds if an argument to `call` is reached in the flow covered by `flowFwd`.
 */
pragma[nomagic]
private predicate flowFwdIsEntered(
  DataFlowCall call, boolean fromArg, AccessPathOption argAp, AccessPath ap
) {
  exists(ParameterNode p, AccessPathFront apf |
    flowFwdIn(call, p, fromArg, argAp, apf, ap) and
    flowCand(p, true, TAccessPathFrontSome(_), apf)
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
private predicate flow(Node node, boolean toReturn, AccessPathOption returnAp, AccessPath ap) {
  flow0(node, toReturn, returnAp, ap) and
  flowFwd(node, _, _, _, ap)
}

private predicate flow0(Node node, boolean toReturn, AccessPathOption returnAp, AccessPath ap) {
  flowFwd(node, _, _, _, ap) and
  any(Configuration config).isSink(node) and
  toReturn = false and
  returnAp = TAccessPathNone() and
  ap instanceof AccessPathNil
  or
  exists(Node mid |
    localFlowBigStep(node, mid, true, _, _) and
    flow(mid, toReturn, returnAp, ap)
  )
  or
  exists(Node mid, AccessPathNil nil |
    flowFwd(node, _, _, _, ap) and
    localFlowBigStep(node, mid, false, _, _) and
    flow(mid, toReturn, returnAp, nil) and
    ap instanceof AccessPathNil
  )
  or
  exists(Node mid |
    jumpStep_(node, mid) and
    flow(mid, _, _, ap) and
    toReturn = false and
    returnAp = TAccessPathNone()
  )
  or
  exists(Node mid, AccessPathNil nil |
    flowFwd(node, _, _, _, ap) and
    additionalJumpStep(node, mid) and
    flow(mid, _, _, nil) and
    toReturn = false and
    returnAp = TAccessPathNone() and
    ap instanceof AccessPathNil
  )
  or
  // store
  exists(TypedContent tc |
    flowStore(tc, node, toReturn, returnAp, ap) and
    flowConsCand(tc, ap)
  )
  or
  // read
  exists(Node mid, AccessPath ap0 |
    readFlowFwd(node, _, mid, ap, ap0) and
    flow(mid, toReturn, returnAp, ap0)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    flowIn(call, node, toReturn, returnAp, ap) and
    toReturn = false
    or
    exists(AccessPath returnAp0 |
      flowInToReturn(call, node, returnAp0, ap) and
      flowIsReturned(call, toReturn, returnAp, returnAp0)
    )
  )
  or
  // flow out of a callable
  flowOut(_, node, _, _, ap) and
  toReturn = true and
  if flowFwd(node, true, TAccessPathSome(_), _, ap)
  then returnAp = TAccessPathSome(ap)
  else returnAp = TAccessPathNone()
}

pragma[nomagic]
private predicate storeFlowFwd(
  Node node1, TypedContent tc, Node node2, AccessPath ap, AccessPath ap0
) {
  storeCand2(node1, tc, node2, _) and
  flowFwdStore(node2, tc, ap, _, _, _) and
  ap0 = push(tc, ap)
}

pragma[nomagic]
private predicate flowStore(
  TypedContent tc, Node node, boolean toReturn, AccessPathOption returnAp, AccessPath ap
) {
  exists(Node mid, AccessPath ap0 |
    storeFlowFwd(node, tc, mid, ap, ap0) and
    flow(mid, toReturn, returnAp, ap0)
  )
}

pragma[nomagic]
private predicate readFlowFwd(Node node1, TypedContent tc, Node node2, AccessPath ap, AccessPath ap0) {
  exists(AccessPathFrontHead apf |
    readCandFwd(node1, tc, apf, node2) and
    flowFwdRead(node2, apf, ap, _, _, _) and
    ap0 = pop(tc, ap) and
    flowFwdConsCand(tc, _, ap0)
  )
}

pragma[nomagic]
private predicate flowConsCand(TypedContent tc, AccessPath ap) {
  exists(Node n, Node mid |
    flow(mid, _, _, ap) and
    readFlowFwd(n, tc, mid, _, ap)
  )
}

pragma[nomagic]
private predicate flowOut(
  DataFlowCall call, ReturnNodeExt ret, boolean toReturn, AccessPathOption returnAp, AccessPath ap
) {
  exists(Node out, boolean allowsFieldFlow |
    flow(out, toReturn, returnAp, ap) and
    flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow)
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowIn(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, AccessPathOption returnAp, AccessPath ap
) {
  exists(ParameterNode p, boolean allowsFieldFlow |
    flow(p, toReturn, returnAp, ap) and
    flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow)
  |
    ap instanceof AccessPathNil or allowsFieldFlow = true
  )
}

pragma[nomagic]
private predicate flowInToReturn(
  DataFlowCall call, ArgumentNode arg, AccessPath returnAp, AccessPath ap
) {
  flowIn(call, arg, true, TAccessPathSome(returnAp), ap)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `flow`.
 */
pragma[nomagic]
private predicate flowIsReturned(
  DataFlowCall call, boolean toReturn, AccessPathOption returnAp, AccessPath ap
) {
  exists(ReturnNodeExt ret |
    flowOut(call, ret, toReturn, returnAp, ap) and
    flowFwd(ret, true, TAccessPathSome(_), _, ap)
  )
}

private predicate flow(Node n) { flow(n, _, _, _) }

pragma[noinline]
private predicate parameterFlow(ParameterNode p, AccessPath ap, DataFlowCallable c) {
  flow(p, true, _, ap) and
  c = p.getEnclosingCallable()
}

private newtype TSummaryCtx =
  TSummaryCtxNone() or
  TSummaryCtxSome(ParameterNode p, AccessPath ap) {
    exists(ReturnNodeExt ret, AccessPath ap0 |
      parameterFlow(p, ap, ret.getEnclosingCallable()) and
      flow(ret, true, TAccessPathSome(_), ap0) and
      flowFwd(ret, true, TAccessPathSome(ap), _, ap0)
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
  TPathNodeMid(Node node, CallContext cc, SummaryCtx sc, AccessPath ap) {
    // A PathNode is introduced by a source ...
    flow(node) and
    any(Configuration config).isSource(node) and
    cc instanceof CallContextAny and
    sc instanceof SummaryCtxNone and
    ap = TNil(getNodeType(node))
    or
    // ... or a step from an existing PathNode to another node.
    exists(PathNodeMid mid |
      pathStep(mid, node, cc, sc, ap) and
      flow(node, _, _, ap)
    )
  } or
  TPathNodeSink(Node node) {
    any(Configuration config).isSink(node) and
    flow(node) and
    (
      // A sink that is also a source ...
      any(Configuration config).isSource(node)
      or
      // ... or a sink that can be reached from a source
      exists(PathNodeMid mid | pathStep(mid, node, _, _, any(AccessPathNil nil)))
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

  PathNodeMid() { this = TPathNodeMid(node, cc, sc, ap) }

  override Node getNode() { result = node }

  CallContext getCallContext() { result = cc }

  SummaryCtx getSummaryCtx() { result = sc }

  AccessPath getAp() { result = ap }

  private PathNodeMid getSuccMid() {
    pathStep(this, result.getNode(), result.getCallContext(), result.getSummaryCtx(), result.getAp())
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
      result = sink
    )
  }

  override predicate isSource() {
    any(Configuration config).isSource(node) and
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

  PathNodeSink() { this = TPathNodeSink(node) }

  override Node getNode() { result = node }

  override PathNode getASuccessorImpl() { none() }

  override predicate isSource() { any(Configuration config).isSource(node) }
}

/**
 * Holds if data may flow from `mid` to `node`. The last step in or out of
 * a callable is recorded by `cc`.
 */
private predicate pathStep(PathNodeMid mid, Node node, CallContext cc, SummaryCtx sc, AccessPath ap) {
  exists(AccessPath ap0, Node midnode, LocalCallContext localCC |
    midnode = mid.getNode() and
    cc = mid.getCallContext() and
    sc = mid.getSummaryCtx() and
    localCC = getLocalCallContext(cc, midnode.getEnclosingCallable()) and
    ap0 = mid.getAp()
  |
    localFlowBigStep(midnode, node, true, _, localCC) and
    ap = ap0
    or
    localFlowBigStep(midnode, node, false, ap.getFront(), localCC) and
    ap0 instanceof AccessPathNil
  )
  or
  jumpStep_(mid.getNode(), node) and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  ap = mid.getAp()
  or
  additionalJumpStep(mid.getNode(), node) and
  cc instanceof CallContextAny and
  sc instanceof SummaryCtxNone and
  mid.getAp() instanceof AccessPathNil and
  ap = TNil(getNodeType(node))
  or
  exists(TypedContent tc | pathStoreStep(mid, node, pop(tc, ap), tc, cc)) and
  sc = mid.getSummaryCtx()
  or
  exists(TypedContent tc | pathReadStep(mid, node, push(tc, ap), tc, cc)) and
  sc = mid.getSummaryCtx()
  or
  pathIntoCallable(mid, node, _, cc, sc, _) and ap = mid.getAp()
  or
  pathOutOfCallable(mid, node, cc) and ap = mid.getAp() and sc instanceof SummaryCtxNone
  or
  pathThroughCallable(mid, node, cc, ap) and sc = mid.getSummaryCtx()
}

pragma[nomagic]
private predicate readCand(Node node1, TypedContent tc, Node node2) {
  readCandFwd(node1, tc, _, node2) and
  flow(node2)
}

pragma[nomagic]
private predicate pathReadStep(
  PathNodeMid mid, Node node, AccessPath ap0, TypedContent tc, CallContext cc
) {
  ap0 = mid.getAp() and
  readCand(mid.getNode(), tc, node) and
  cc = mid.getCallContext()
}

pragma[nomagic]
private predicate storeCand(Node node1, TypedContent tc, Node node2) {
  storeCand2(node1, tc, node2, _) and
  flow(node2)
}

pragma[nomagic]
private predicate pathStoreStep(
  PathNodeMid mid, Node node, AccessPath ap0, TypedContent tc, CallContext cc
) {
  ap0 = mid.getAp() and
  storeCand(mid.getNode(), tc, node) and
  cc = mid.getCallContext()
}

private predicate pathOutOfCallable0(
  PathNodeMid mid, ReturnPosition pos, CallContext innercc, AccessPath ap
) {
  pos = getReturnPosition(mid.getNode()) and
  innercc = mid.getCallContext() and
  not innercc instanceof CallContextCall and
  ap = mid.getAp()
}

pragma[nomagic]
private predicate pathOutOfCallable1(
  PathNodeMid mid, DataFlowCall call, ReturnKindExt kind, CallContext cc, AccessPath ap
) {
  exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
    pathOutOfCallable0(mid, pos, innercc, ap) and
    c = pos.getCallable() and
    kind = pos.getKind() and
    resolveReturn(innercc, c, call)
  |
    if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
  )
}

pragma[noinline]
private Node getAnOutNodeFlow(ReturnKindExt kind, DataFlowCall call, AccessPath ap) {
  result = kind.getAnOutNode(call) and
  flow(result, _, _, ap)
}

/**
 * Holds if data may flow from `mid` to `out`. The last step of this path
 * is a return from a callable and is recorded by `cc`, if needed.
 */
pragma[noinline]
private predicate pathOutOfCallable(PathNodeMid mid, Node out, CallContext cc) {
  exists(ReturnKindExt kind, DataFlowCall call, AccessPath ap |
    pathOutOfCallable1(mid, call, kind, cc, ap)
  |
    out = getAnOutNodeFlow(kind, call, ap)
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
private predicate parameterCand(DataFlowCallable callable, int i, AccessPath ap) {
  exists(ParameterNode p |
    flow(p, _, _, ap) and
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
  parameterCand(callable, any(int j | j <= i and j >= i), ap)
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
  ReturnKindExt kind, CallContextCall cc, SummaryCtxSome sc, AccessPath ap
) {
  exists(PathNodeMid mid, ReturnNodeExt ret, int pos |
    mid.getNode() = ret and
    kind = ret.getKind() and
    cc = mid.getCallContext() and
    sc = mid.getSummaryCtx() and
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
    paramFlowsThrough(kind, innercc, sc, ap)
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
    out = getAnOutNodeFlow(kind, call, ap)
  )
}

/**
 * Holds if data can flow (inter-procedurally) from `source` to `sink`.
 *
 * Will only have results if `configuration` has non-empty sources and
 * sinks.
 */
private predicate flowsTo(PathNode flowsource, PathNodeSink flowsink, Node source, Node sink) {
  flowsource.isSource() and
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
predicate flowsTo(Node source, Node sink) { flowsTo(_, _, source, sink) }

private module FlowExploration {
  private predicate callableStep(DataFlowCallable c1, DataFlowCallable c2) {
    exists(Node node1, Node node2 |
      jumpStep_(node1, node2)
      or
      additionalJumpStep(node1, node2)
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

  private predicate interestingCallableSrc(DataFlowCallable c) {
    exists(Node n | any(Configuration config).isSource(n) and c = n.getEnclosingCallable())
    or
    exists(DataFlowCallable mid | interestingCallableSrc(mid) and callableStep(mid, c))
  }

  private newtype TCallableExt =
    TCallable(DataFlowCallable c) { interestingCallableSrc(c) } or
    TCallableSrc()

  private predicate callableExtSrc(TCallableSrc src) { any() }

  private predicate callableExtStepFwd(TCallableExt ce1, TCallableExt ce2) {
    exists(DataFlowCallable c1, DataFlowCallable c2 |
      callableStep(c1, c2) and
      ce1 = TCallable(c1) and
      ce2 = TCallable(c2)
    )
    or
    exists(Node n |
      ce1 = TCallableSrc() and
      any(Configuration config).isSource(n) and
      ce2 = TCallable(n.getEnclosingCallable())
    )
  }

  private int distSrcExt(TCallableExt c) =
    shortestDistances(callableExtSrc/1, callableExtStepFwd/2)(_, c, result)

  private int distSrc(DataFlowCallable c) { result = distSrcExt(TCallable(c)) - 1 }

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
      Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, PartialAccessPath ap
    ) {
      any(Configuration config).isSource(node) and
      cc instanceof CallContextAny and
      sc1 = TSummaryCtx1None() and
      sc2 = TSummaryCtx2None() and
      ap = TPartialNil(getNodeType(node)) and
      not fullBarrier(node) and
      exists(any(Configuration config).explorationLimit())
      or
      partialPathNodeMk0(node, cc, sc1, sc2, ap) and
      distSrc(node.getEnclosingCallable()) <= any(Configuration config).explorationLimit()
    }

  pragma[nomagic]
  private predicate partialPathNodeMk0(
    Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, PartialAccessPath ap
  ) {
    exists(PartialPathNode mid |
      partialPathStep(mid, node, cc, sc1, sc2, ap) and
      not fullBarrier(node) and
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

    /** Gets a successor of this node, if any. */
    PartialPathNode getASuccessor() { none() }

    /**
     * Gets the approximate distance to the nearest source measured in number
     * of interprocedural steps.
     */
    int getSourceDistance() { result = distSrc(this.getNode().getEnclosingCallable()) }

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

    PartialPathNodePriv() { this = TPartialPathNodeMk(node, cc, sc1, sc2, ap) }

    override Node getNode() { result = node }

    CallContext getCallContext() { result = cc }

    TSummaryCtx1 getSummaryCtx1() { result = sc1 }

    TSummaryCtx2 getSummaryCtx2() { result = sc2 }

    PartialAccessPath getAp() { result = ap }

    override PartialPathNodePriv getASuccessor() {
      partialPathStep(this, result.getNode(), result.getCallContext(), result.getSummaryCtx1(),
        result.getSummaryCtx2(), result.getAp())
    }
  }

  private predicate partialPathStep(
    PartialPathNodePriv mid, Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
    PartialAccessPath ap
  ) {
    not isUnreachableInCall(node, cc.(CallContextSpecificCall).getCall()) and
    (
      localFlowStep_(mid.getNode(), node) and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      ap = mid.getAp()
      or
      additionalLocalFlowStep(mid.getNode(), node) and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      mid.getAp() instanceof PartialAccessPathNil and
      ap = TPartialNil(getNodeType(node))
    )
    or
    jumpStep_(mid.getNode(), node) and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    ap = mid.getAp()
    or
    additionalJumpStep(mid.getNode(), node) and
    cc instanceof CallContextAny and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None() and
    mid.getAp() instanceof PartialAccessPathNil and
    ap = TPartialNil(getNodeType(node))
    or
    partialPathStoreStep(mid, _, _, node, ap) and
    cc = mid.getCallContext() and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2()
    or
    exists(PartialAccessPath ap0, TypedContent tc |
      partialPathReadStep(mid, ap0, tc, node, cc) and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      apConsFwd(ap, tc, ap0) and
      compatibleTypes(ap.getType(), getNodeType(node))
    )
    or
    partialPathIntoCallable(mid, node, _, cc, sc1, sc2, _, ap)
    or
    partialPathOutOfCallable(mid, node, cc, ap) and
    sc1 = TSummaryCtx1None() and
    sc2 = TSummaryCtx2None()
    or
    partialPathThroughCallable(mid, node, cc, ap) and
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
  private predicate apConsFwd(PartialAccessPath ap1, TypedContent tc, PartialAccessPath ap2) {
    exists(PartialPathNodePriv mid | partialPathStoreStep(mid, ap1, tc, _, ap2))
  }

  pragma[nomagic]
  private predicate partialPathReadStep(
    PartialPathNodePriv mid, PartialAccessPath ap, TypedContent tc, Node node, CallContext cc
  ) {
    exists(Node midNode |
      midNode = mid.getNode() and
      ap = mid.getAp() and
      read(midNode, tc.getContent(), node) and
      ap.getHead() = tc and
      cc = mid.getCallContext()
    )
  }

  private predicate partialPathOutOfCallable0(
    PartialPathNodePriv mid, ReturnPosition pos, CallContext innercc, PartialAccessPath ap
  ) {
    pos = getReturnPosition(mid.getNode()) and
    innercc = mid.getCallContext() and
    not innercc instanceof CallContextCall and
    ap = mid.getAp()
  }

  pragma[nomagic]
  private predicate partialPathOutOfCallable1(
    PartialPathNodePriv mid, DataFlowCall call, ReturnKindExt kind, CallContext cc,
    PartialAccessPath ap
  ) {
    exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
      partialPathOutOfCallable0(mid, pos, innercc, ap) and
      c = pos.getCallable() and
      kind = pos.getKind() and
      resolveReturn(innercc, c, call)
    |
      if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
    )
  }

  private predicate partialPathOutOfCallable(
    PartialPathNodePriv mid, Node out, CallContext cc, PartialAccessPath ap
  ) {
    exists(ReturnKindExt kind, DataFlowCall call |
      partialPathOutOfCallable1(mid, call, kind, cc, ap)
    |
      out = kind.getAnOutNode(call)
    )
  }

  pragma[noinline]
  private predicate partialPathIntoArg(
    PartialPathNodePriv mid, int i, CallContext cc, DataFlowCall call, PartialAccessPath ap
  ) {
    exists(ArgumentNode arg |
      arg = mid.getNode() and
      cc = mid.getCallContext() and
      arg.argumentOf(call, i) and
      ap = mid.getAp()
    )
  }

  pragma[nomagic]
  private predicate partialPathIntoCallable0(
    PartialPathNodePriv mid, DataFlowCallable callable, int i, CallContext outercc,
    DataFlowCall call, PartialAccessPath ap
  ) {
    partialPathIntoArg(mid, i, outercc, call, ap) and
    callable = resolveCall(call, outercc)
  }

  private predicate partialPathIntoCallable(
    PartialPathNodePriv mid, ParameterNode p, CallContext outercc, CallContextCall innercc,
    TSummaryCtx1 sc1, TSummaryCtx2 sc2, DataFlowCall call, PartialAccessPath ap
  ) {
    exists(int i, DataFlowCallable callable |
      partialPathIntoCallable0(mid, callable, i, outercc, call, ap) and
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
    ReturnKindExt kind, CallContextCall cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, PartialAccessPath ap
  ) {
    exists(PartialPathNodePriv mid, ReturnNodeExt ret |
      mid.getNode() = ret and
      kind = ret.getKind() and
      cc = mid.getCallContext() and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      ap = mid.getAp()
    )
  }

  pragma[noinline]
  private predicate partialPathThroughCallable0(
    DataFlowCall call, PartialPathNodePriv mid, ReturnKindExt kind, CallContext cc,
    PartialAccessPath ap
  ) {
    exists(ParameterNode p, CallContext innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2 |
      partialPathIntoCallable(mid, p, cc, innercc, sc1, sc2, call, _) and
      paramFlowsThroughInPartialPath(kind, innercc, sc1, sc2, ap)
    )
  }

  private predicate partialPathThroughCallable(
    PartialPathNodePriv mid, Node out, CallContext cc, PartialAccessPath ap
  ) {
    exists(DataFlowCall call, ReturnKindExt kind |
      partialPathThroughCallable0(call, mid, kind, cc, ap) and
      out = kind.getAnOutNode(call)
    )
  }
}

import FlowExploration

private predicate partialFlow(PartialPathNode source, PartialPathNode node) {
  any(Configuration conf).isSource(source.getNode()) and
  node = source.getASuccessor+()
}
