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

pragma[noinline]
private ReturnPosition viableReturnPos(DataFlowCall call, ReturnKindExt kind) {
  viableCallable(call) = result.getCallable() and
  kind = result.getKind()
}

/**
 * Holds if `node` is reachable from a source in the given configuration
 * taking simple call contexts into consideration.
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
      storeDirect(mid, _, node) and
      not outBarrier(mid, config)
    )
    or
    // read
    exists(Content f |
      nodeCandFwd1Read(f, node, fromArg, config) and
      storeCandFwd1(f, config) and
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
      flowOutCandFwd1(call, fromArg, config)
    )
  )
}

private predicate nodeCandFwd1(Node node, Configuration config) { nodeCandFwd1(node, _, config) }

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
private predicate nodeCandFwd1Read(Content f, Node node, boolean fromArg, Configuration config) {
  exists(Node mid |
    nodeCandFwd1(mid, fromArg, config) and
    readDirect(mid, f, node)
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCandFwd1`.
 */
pragma[nomagic]
private predicate storeCandFwd1(Content f, Configuration config) {
  exists(Node mid, Node node |
    not fullBarrier(node, config) and
    useFieldFlow(config) and
    nodeCandFwd1(mid, config) and
    storeDirect(mid, f, node)
  )
}

pragma[nomagic]
private predicate nodeCandFwd1ReturnKind(
  DataFlowCall call, ReturnKindExt kind, boolean fromArg, Configuration config
) {
  exists(ReturnPosition pos |
    nodeCandFwd1ReturnPosition(pos, fromArg, config) and
    pos = viableReturnPos(call, kind)
  )
}

pragma[nomagic]
private predicate nodeCandFwd1Out(
  DataFlowCall call, Node node, boolean fromArg, Configuration config
) {
  exists(ReturnKindExt kind |
    nodeCandFwd1ReturnKind(call, kind, fromArg, config) and
    node = kind.getAnOutNode(call)
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
private predicate flowOutCandFwd1(DataFlowCall call, boolean fromArg, Configuration config) {
  exists(ArgumentNode arg |
    nodeCandFwd1(arg, fromArg, config) and
    viableParamArg(call, _, arg)
  )
}

bindingset[result, b]
private boolean unbindBool(boolean b) { result != b.booleanNot() }

/**
 * Holds if `node` is part of a path from a source to a sink in the given
 * configuration taking simple call contexts into consideration.
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
    readCand1(f, config)
  )
  or
  // read
  exists(Node mid, Content f |
    readDirect(node, f, mid) and
    storeCandFwd1(f, unbind(config)) and
    nodeCand1(mid, toReturn, config)
  )
  or
  // flow into a callable
  exists(DataFlowCall call |
    nodeCand1Arg(call, node, false, config) and
    toReturn = false
    or
    nodeCand1ArgToReturn(call, node, config) and
    flowInCand1(call, toReturn, config)
  )
  or
  // flow out of a callable
  exists(ReturnPosition pos |
    nodeCand1ReturnPosition(pos, config) and
    getReturnPosition(node) = pos and
    toReturn = true
  )
}

pragma[nomagic]
private predicate nodeCand1(Node node, Configuration config) { nodeCand1(node, _, config) }

pragma[nomagic]
private predicate nodeCand1ReturnPosition(ReturnPosition pos, Configuration config) {
  exists(DataFlowCall call, ReturnKindExt kind, Node out |
    nodeCand1(out, _, config) and
    pos = viableReturnPos(call, kind) and
    out = kind.getAnOutNode(call)
  )
}

/**
 * Holds if `f` is the target of a read in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate readCand1(Content f, Configuration config) {
  exists(Node mid, Node node |
    useFieldFlow(config) and
    nodeCandFwd1(node, unbind(config)) and
    readDirect(node, f, mid) and
    storeCandFwd1(f, unbind(config)) and
    nodeCand1(mid, _, config)
  )
}

pragma[nomagic]
private predicate nodeCand1Store(Content f, Node node, boolean toReturn, Configuration config) {
  exists(Node mid |
    nodeCand1(mid, toReturn, config) and
    storeCandFwd1(f, unbind(config)) and
    storeDirect(node, f, mid)
  )
}

/**
 * Holds if `f` is the target of both a read and a store in the flow covered
 * by `nodeCand1`.
 */
private predicate readStoreCand1(Content f, Configuration conf) {
  readCand1(f, conf) and
  nodeCand1Store(f, _, _, conf)
}

pragma[nomagic]
private predicate viableParamArgCandFwd1(
  DataFlowCall call, ParameterNode p, ArgumentNode arg, Configuration config
) {
  viableParamArg(call, p, arg) and
  nodeCandFwd1(arg, config)
}

pragma[nomagic]
private predicate nodeCand1Arg(
  DataFlowCall call, ArgumentNode arg, boolean toReturn, Configuration config
) {
  exists(ParameterNode p |
    nodeCand1(p, toReturn, config) and
    viableParamArgCandFwd1(call, p, arg, config)
  )
}

pragma[nomagic]
private predicate nodeCand1ArgToReturn(DataFlowCall call, ArgumentNode arg, Configuration config) {
  nodeCand1Arg(call, arg, true, config)
}

/**
 * Holds if an output from `call` is reached in the flow covered by `nodeCand1`.
 */
pragma[nomagic]
private predicate flowInCand1(DataFlowCall call, boolean toReturn, Configuration config) {
  exists(Node out |
    nodeCand1(out, toReturn, config) and
    nodeCandFwd1OutFromArg(call, out, config)
  )
}

private predicate throughFlowNodeCand(Node node, Configuration config) {
  nodeCand1(node, true, config) and
  not fullBarrier(node, config) and
  not inBarrier(node, config) and
  not outBarrier(node, config)
}

/** Holds if flow may return from `callable`. */
pragma[nomagic]
private predicate returnFlowCallableCand(
  DataFlowCallable callable, ReturnKindExt kind, Configuration config
) {
  exists(ReturnNodeExt ret |
    throughFlowNodeCand(ret, config) and
    callable = ret.getEnclosingCallable() and
    kind = ret.getKind()
  )
}

/**
 * Holds if flow may enter through `p` and reach a return node making `p` a
 * candidate for the origin of a summary.
 */
private predicate parameterThroughFlowCand(ParameterNode p, Configuration config) {
  exists(ReturnKindExt kind |
    throughFlowNodeCand(p, config) and
    returnFlowCallableCand(p.getEnclosingCallable(), kind, config) and
    // we don't expect a parameter to return stored in itself
    not exists(int pos |
      kind.(ParamUpdateReturnKind).getPosition() = pos and p.isParameterOf(_, pos)
    )
  )
}

pragma[nomagic]
private predicate store(Node n1, Content f, Node n2, Configuration config) {
  readStoreCand1(f, config) and
  nodeCand1(n2, unbind(config)) and
  (
    storeDirect(n1, f, n2) or
    argumentValueFlowsThrough(_, n1, TContentNone(), TContentSome(f), n2)
  )
}

pragma[nomagic]
private predicate read(Node n1, Content f, Node n2, Configuration config) {
  readStoreCand1(f, config) and
  nodeCand1(n2, unbind(config)) and
  (
    readDirect(n1, f, n2) or
    argumentValueFlowsThrough(_, n1, TContentSome(f), TContentNone(), n2)
  )
}

/**
 * Holds if `p` can flow to `node` in the same callable with `summary`
 * representing the flow path. The type of the tracked object is `t2`, and if
 * the summary includes a store step, `t1` is the tracked type just prior to the
 * store, that is, the type of the stored object, otherwise `t1` is equal to `t2`.
 */
pragma[nomagic]
private predicate parameterFlow(
  ParameterNode p, Node node, DataFlowType t1, DataFlowType t2, Summary summary,
  Configuration config
) {
  parameterThroughFlowCand(p, config) and
  p = node and
  t1 = getErasedNodeTypeBound(node) and
  t1 = t2 and
  summary = TSummaryVal()
  or
  throughFlowNodeCand(node, unbind(config)) and
  (
    exists(Node mid |
      parameterFlow(p, mid, t1, t2, summary, config) and
      localFlowStep(mid, node, config) and
      compatibleTypes(t2, getErasedNodeTypeBound(node))
    )
    or
    exists(Node mid, Summary midsum |
      parameterFlow(p, mid, _, _, midsum, config) and
      additionalLocalFlowStep(mid, node, config) and
      t1 = getErasedNodeTypeBound(node) and
      t1 = t2 and
      summary = midsum.additionalStep()
    )
    or
    // read step
    exists(Node mid, Content f, Summary midsum |
      parameterFlow(p, mid, _, _, midsum, config) and
      read(mid, f, node, config) and
      summary = midsum.readStep(f) and
      t1 = f.getType() and
      t1 = t2
    )
    or
    // store step
    exists(Node mid, Content f, Summary midsum |
      parameterFlow(p, mid, t1, /* t1 */ _, midsum, config) and
      store(mid, f, node, config) and
      summary = midsum.storeStep(f) and
      compatibleTypes(t1, f.getType()) and
      t2 = f.getContainerType()
    )
    or
    // value flow through a callable
    exists(Node arg |
      parameterFlow(p, arg, t1, t2, summary, config) and
      argumentValueFlowsThrough(_, arg, TContentNone(), TContentNone(), node) and
      compatibleTypes(t2, getErasedNodeTypeBound(node))
    )
    or
    // flow through a callable
    exists(Node arg, Summary s1, Summary s2 |
      parameterFlow(p, arg, _, _, s1, config) and
      argumentFlowsThrough(arg, node, t1, t2, s2, config) and
      summary = s1.compose(s2)
    )
  )
}

private predicate viableParamArgCand(
  DataFlowCall call, ParameterNode p, ArgumentNode arg, Configuration config
) {
  viableParamArg(call, p, arg) and
  nodeCand1(arg, unbind(config)) and
  nodeCand1(p, config) and
  not outBarrier(arg, config) and
  not inBarrier(p, config)
}

pragma[nomagic]
private predicate parameterFlowReturn(
  ParameterNode p, ReturnNodeExt ret, ReturnKindExt kind, DataFlowType t1, DataFlowType t2,
  Summary summary, Configuration config
) {
  parameterFlow(p, ret, t1, t2, summary, config) and
  kind = ret.getKind() and
  not summary.isPartial() and
  not exists(int pos | kind.(ParamUpdateReturnKind).getPosition() = pos and p.isParameterOf(_, pos))
}

pragma[nomagic]
private predicate argumentFlowsThrough0(
  DataFlowCall call, ArgumentNode arg, ReturnKindExt kind, DataFlowType t1, DataFlowType t2,
  Summary summary, Configuration config
) {
  exists(ParameterNode p |
    viableParamArgCand(call, p, arg, config) and
    parameterFlowReturn(p, _, kind, t1, t2, summary, config)
  )
}

/**
 * Holds if data can flow from `arg` to `out` through a call with `summary`
 * representing the flow path. The type of the tracked object is `t2`, and if
 * the summary includes a store step, `t1` is the tracked type just prior to the
 * store, that is, the type of the stored object, otherwise `t1` is equal to `t2`.
 */
private predicate argumentFlowsThrough(
  ArgumentNode arg, Node out, DataFlowType t1, DataFlowType t2, Summary summary,
  Configuration config
) {
  nodeCand1(out, unbind(config)) and
  not inBarrier(out, config) and
  compatibleTypes(t2, getErasedNodeTypeBound(out)) and
  exists(DataFlowCall call, ReturnKindExt kind |
    argumentFlowsThrough0(call, arg, kind, t1, t2, summary, config) and
    out = kind.getAnOutNode(call)
  )
}

pragma[noinline]
private predicate readStoreNode(
  DataFlowCall call, ArgumentNode arg, Content f1, Configuration config
) {
  exists(Content f2, Node out |
    argumentValueFlowsThrough(call, arg, TContentSome(f1), TContentSome(f2), out) and
    nodeCand1(out, config) and
    readStoreCand1(f2, unbind(config))
  )
}

private newtype TNodeExt =
  TNormalNode(Node node) { nodeCand1(node, _) } or
  TReadStoreNode(DataFlowCall call, ArgumentNode arg, Content f1, Configuration config) {
    nodeCand1(arg, config) and
    readStoreNode(call, arg, f1, config) and
    readStoreCand1(f1, unbind(config))
  } or
  TReadTaintNode(ArgumentNode arg, Content f, Configuration config) {
    argumentFlowsThrough(arg, _, _, _, TSummaryReadTaint(f), config)
  } or
  TTaintStoreNode(ArgumentNode arg, DataFlowType t, Configuration config) {
    argumentFlowsThrough(arg, _, t, _, TSummaryTaintStore(_), config)
  }

/**
 * An extended data flow node. Either a normal node, or an intermediate node
 * used to split up a summarized flow steps.
 *
 * This is purely an internal implementation detail.
 */
abstract private class NodeExt extends TNodeExt {
  /** Gets the underlying (normal) node, if any. */
  abstract Node getNode();

  abstract DataFlowType getErasedNodeTypeBound();

  abstract DataFlowCallable getEnclosingCallable();

  abstract predicate isCand1(Configuration config);

  abstract string toString();

  abstract predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  );
}

/** A `Node` at which a cast can occur such that the type should be checked. */
abstract private class CastingNodeExt extends NodeExt { }

private class NormalNodeExt extends NodeExt, TNormalNode {
  override Node getNode() { this = TNormalNode(result) }

  override DataFlowType getErasedNodeTypeBound() {
    result = getErasedRepr(this.getNode().getTypeBound())
  }

  override DataFlowCallable getEnclosingCallable() {
    result = this.getNode().getEnclosingCallable()
  }

  override predicate isCand1(Configuration config) { nodeCand1(this.getNode(), config) }

  override string toString() { result = this.getNode().toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class NormalCastingNodeExt extends CastingNodeExt, NormalNodeExt {
  NormalCastingNodeExt() { this.getNode() instanceof CastingNode }
}

private class ReadStoreNodeExt extends CastingNodeExt, TReadStoreNode {
  private DataFlowCall call;
  private ArgumentNode arg;
  private Content f1;
  private Configuration config0;

  ReadStoreNodeExt() { this = TReadStoreNode(call, arg, f1, config0) }

  override Node getNode() { none() }

  override DataFlowType getErasedNodeTypeBound() { result = f1.getType() }

  override DataFlowCallable getEnclosingCallable() { result = arg.getEnclosingCallable() }

  override predicate isCand1(Configuration config) { config = config0 }

  override string toString() { result = "(inside) " + call.toString() + " [read " + f1 + "]" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    arg.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class ReadTaintNode extends NodeExt, TReadTaintNode {
  private ArgumentNode arg;
  private Content f;
  private Configuration config0;

  ReadTaintNode() { this = TReadTaintNode(arg, f, config0) }

  override Node getNode() { none() }

  override DataFlowType getErasedNodeTypeBound() { result = f.getType() }

  override DataFlowCallable getEnclosingCallable() { result = arg.getEnclosingCallable() }

  override predicate isCand1(Configuration config) { config = config0 }

  override string toString() { result = arg.toString() + " [read taint " + f + "]" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    arg.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class TaintStoreNode extends NodeExt, TTaintStoreNode {
  private ArgumentNode arg;
  private DataFlowType t;
  private Configuration config0;

  TaintStoreNode() { this = TTaintStoreNode(arg, t, config0) }

  override Node getNode() { none() }

  override DataFlowType getErasedNodeTypeBound() { result = t }

  override DataFlowCallable getEnclosingCallable() { result = arg.getEnclosingCallable() }

  override predicate isCand1(Configuration config) { config = config0 }

  override string toString() { result = arg.toString() + " [taint store]" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    arg.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private predicate additionalLocalFlowStepExt(
  NodeExt node1, NodeExt node2, DataFlowType t, Configuration config
) {
  exists(ArgumentNode arg, Content f |
    node1 = TReadTaintNode(arg, f, config) and
    argumentFlowsThrough(arg, node2.getNode(), _, t, TSummaryReadTaint(f), config)
  )
  or
  node2 = TTaintStoreNode(node1.getNode(), t, config)
}

pragma[nomagic]
private predicate readExt(NodeExt node1, Content f, NodeExt node2, Configuration config) {
  read(node1.getNode(), f, node2.getNode(), config)
  or
  node2 = TReadStoreNode(_, node1.getNode(), f, config)
  or
  node2 = TReadTaintNode(node1.getNode(), f, config)
}

pragma[nomagic]
private predicate storeExt(NodeExt node1, Content f, NodeExt node2, Configuration config) {
  store(node1.getNode(), f, node2.getNode(), config)
  or
  exists(DataFlowCall call, ArgumentNode arg, Content f1, Node n2 |
    node1 = TReadStoreNode(call, arg, f1, config) and
    n2 = node2.getNode() and
    argumentValueFlowsThrough(call, arg, TContentSome(f1), TContentSome(f), n2) and
    nodeCand1(n2, unbind(config)) and
    readStoreCand1(f, unbind(config))
  )
  or
  exists(ArgumentNode arg, DataFlowType t |
    node1 = TTaintStoreNode(arg, t, config) and
    argumentFlowsThrough(arg, node2.getNode(), t, _, TSummaryTaintStore(f), config)
  )
}

private predicate jumpStepExt(NodeExt node1, NodeExt node2, Configuration config) {
  jumpStep(node1.getNode(), node2.getNode(), config)
}

private predicate additionalJumpStepExt(NodeExt node1, NodeExt node2, Configuration config) {
  additionalJumpStep(node1.getNode(), node2.getNode(), config)
}

private predicate argumentValueFlowsThrough(NodeExt node1, NodeExt node2) {
  argumentValueFlowsThrough(_, node1.getNode(), TContentNone(), TContentNone(), node2.getNode())
}

private predicate argumentFlowsThrough(
  NodeExt arg, NodeExt out, DataFlowType t, Configuration config
) {
  argumentFlowsThrough(arg.getNode(), out.getNode(), _, t, TSummaryTaint(), config)
}

/**
 * Holds if data can flow from `node1` to `node2` in one local step or a step
 * through a callable.
 */
pragma[noinline]
private predicate localFlowStepOrFlowThroughCallable(
  NodeExt node1, NodeExt node2, Configuration config
) {
  exists(Node n1, Node n2 |
    n1 = node1.getNode() and
    n2 = node2.getNode()
  |
    nodeCand1(n1, config) and
    localFlowStep(n1, n2, config)
    or
    nodeCand1(n1, config) and
    argumentValueFlowsThrough(_, n1, TContentNone(), TContentNone(), n2)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` in one local step or a step
 * through a callable, in both cases using an additional flow step from the
 * configuration.
 */
pragma[noinline]
private predicate additionalLocalFlowStepOrFlowThroughCallable(
  NodeExt node1, NodeExt node2, Configuration config
) {
  exists(Node n1, Node n2 |
    n1 = node1.getNode() and
    n2 = node2.getNode()
  |
    nodeCand1(n1, config) and
    additionalLocalFlowStep(n1, n2, config)
    or
    argumentFlowsThrough(n1, n2, _, _, TSummaryTaint(), config)
  )
  or
  additionalLocalFlowStepExt(node1, node2, _, config)
}

pragma[noinline]
private ReturnPosition getReturnPosition1(ReturnNodeExt node, Configuration config) {
  result = getReturnPosition(node) and
  nodeCand1(node, config)
}

/**
 * Holds if data can flow out of a callable from `node1` to `node2`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink.
 */
private predicate flowOutOfCallableNodeCand1(ReturnNodeExt node1, Node node2, Configuration config) {
  nodeCand1(node2, config) and
  not outBarrier(node1, config) and
  not inBarrier(node2, config) and
  exists(DataFlowCall call, ReturnKindExt kind |
    getReturnPosition1(node1, unbind(config)) = viableReturnPos(call, kind) and
    node2 = kind.getAnOutNode(call)
  )
}

/**
 * Holds if data can flow into a callable and that this step is part of a
 * path from a source to a sink.
 */
private predicate flowIntoCallableNodeCand1(
  ArgumentNode node1, ParameterNode node2, Configuration config
) {
  viableParamArgCand(_, node2, node1, config)
}

/**
 * Gets the amount of forward branching on the origin of a cross-call path
 * edge in the graph of paths between sources and sinks that ignores call
 * contexts.
 */
private int branch(Node n1, Configuration conf) {
  result =
    strictcount(Node n |
      flowOutOfCallableNodeCand1(n1, n, conf) or flowIntoCallableNodeCand1(n1, n, conf)
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
      flowOutOfCallableNodeCand1(n, n2, conf) or flowIntoCallableNodeCand1(n, n2, conf)
    )
}

/**
 * Holds if data can flow out of a callable from `node1` to `node2`, either
 * through a `ReturnNode` or through an argument that has been mutated, and
 * that this step is part of a path from a source to a sink. The
 * `allowsFieldFlow` flag indicates whether the branching is within the limit
 * specified by the configuration.
 */
private predicate flowOutOfCallableNodeCand1(
  NodeExt node1, NodeExt node2, boolean allowsFieldFlow, Configuration config
) {
  exists(ReturnNodeExt n1, Node n2 |
    n1 = node1.getNode() and
    n2 = node2.getNode() and
    flowOutOfCallableNodeCand1(n1, n2, config) and
    exists(int b, int j |
      b = branch(n1, config) and
      j = join(n2, config) and
      if b.minimum(j) <= config.fieldFlowBranchLimit()
      then allowsFieldFlow = true
      else allowsFieldFlow = false
    )
  )
}

/**
 * Holds if data can flow into a callable and that this step is part of a
 * path from a source to a sink. The `allowsFieldFlow` flag indicates whether
 * the branching is within the limit specified by the configuration.
 */
private predicate flowIntoCallableNodeCand1(
  NodeExt node1, NodeExt node2, boolean allowsFieldFlow, Configuration config
) {
  exists(ArgumentNode n1, ParameterNode n2 |
    n1 = node1.getNode() and
    n2 = node2.getNode() and
    flowIntoCallableNodeCand1(n1, n2, config) and
    exists(int b, int j |
      b = branch(n1, config) and
      j = join(n2, config) and
      if b.minimum(j) <= config.fieldFlowBranchLimit()
      then allowsFieldFlow = true
      else allowsFieldFlow = false
    )
  )
}

/**
 * Holds if `node` is part of a path from a source to a sink in the given
 * configuration taking simple call contexts into consideration.
 */
private predicate nodeCandFwd2(NodeExt node, boolean fromArg, boolean stored, Configuration config) {
  nodeCand1(node.getNode(), config) and
  config.isSource(node.getNode()) and
  fromArg = false and
  stored = false
  or
  node.isCand1(unbind(config)) and
  (
    exists(NodeExt mid |
      nodeCandFwd2(mid, fromArg, stored, config) and
      localFlowStepOrFlowThroughCallable(mid, node, config)
    )
    or
    exists(NodeExt mid |
      nodeCandFwd2(mid, fromArg, stored, config) and
      additionalLocalFlowStepOrFlowThroughCallable(mid, node, config) and
      stored = false
    )
    or
    exists(NodeExt mid |
      nodeCandFwd2(mid, _, stored, config) and
      jumpStepExt(mid, node, config) and
      fromArg = false
    )
    or
    exists(NodeExt mid |
      nodeCandFwd2(mid, _, stored, config) and
      additionalJumpStepExt(mid, node, config) and
      fromArg = false and
      stored = false
    )
    or
    // store
    exists(NodeExt mid, Content f |
      nodeCandFwd2(mid, fromArg, _, config) and
      storeExt(mid, f, node, config) and
      stored = true
    )
    or
    // read
    exists(Content f |
      nodeCandFwd2Read(f, node, fromArg, config) and
      storeCandFwd2(f, stored, config)
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      nodeCandFwd2(mid, _, stored, config) and
      flowIntoCallableNodeCand1(mid, node, allowsFieldFlow, config) and
      fromArg = true and
      (stored = false or allowsFieldFlow = true)
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      nodeCandFwd2(mid, false, stored, config) and
      flowOutOfCallableNodeCand1(mid, node, allowsFieldFlow, config) and
      fromArg = false and
      (stored = false or allowsFieldFlow = true)
    )
  )
}

/**
 * Holds if `f` is the target of a store in the flow covered by `nodeCandFwd2`.
 */
pragma[noinline]
private predicate storeCandFwd2(Content f, boolean stored, Configuration config) {
  exists(NodeExt mid, NodeExt node |
    useFieldFlow(config) and
    node.isCand1(unbind(config)) and
    nodeCandFwd2(mid, _, stored, config) and
    storeExt(mid, f, node, config)
  )
}

pragma[nomagic]
private predicate nodeCandFwd2Read(Content f, NodeExt node, boolean fromArg, Configuration config) {
  exists(NodeExt mid |
    nodeCandFwd2(mid, fromArg, true, config) and
    readExt(mid, f, node, config)
  )
}

/**
 * Holds if `node` is part of a path from a source to a sink in the given
 * configuration taking simple call contexts into consideration.
 */
private predicate nodeCand2(NodeExt node, boolean toReturn, boolean read, Configuration config) {
  nodeCandFwd2(node, _, false, config) and
  config.isSink(node.getNode()) and
  toReturn = false and
  read = false
  or
  nodeCandFwd2(node, _, unbindBool(read), unbind(config)) and
  (
    exists(NodeExt mid |
      localFlowStepOrFlowThroughCallable(node, mid, config) and
      nodeCand2(mid, toReturn, read, config)
    )
    or
    exists(NodeExt mid |
      additionalLocalFlowStepOrFlowThroughCallable(node, mid, config) and
      nodeCand2(mid, toReturn, read, config) and
      read = false
    )
    or
    exists(NodeExt mid |
      jumpStepExt(node, mid, config) and
      nodeCand2(mid, _, read, config) and
      toReturn = false
    )
    or
    exists(NodeExt mid |
      additionalJumpStepExt(node, mid, config) and
      nodeCand2(mid, _, read, config) and
      toReturn = false and
      read = false
    )
    or
    // store
    exists(Content f |
      nodeCand2Store(f, node, toReturn, read, config) and
      readCand2(f, read, config)
    )
    or
    // read
    exists(NodeExt mid, Content f, boolean read0 |
      readExt(node, f, mid, config) and
      storeCandFwd2(f, unbindBool(read0), unbind(config)) and
      nodeCand2(mid, toReturn, read0, config) and
      read = true
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      flowIntoCallableNodeCand1(node, mid, allowsFieldFlow, config) and
      nodeCand2(mid, false, read, config) and
      toReturn = false and
      (read = false or allowsFieldFlow = true)
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      flowOutOfCallableNodeCand1(node, mid, allowsFieldFlow, config) and
      nodeCand2(mid, _, read, config) and
      toReturn = true and
      (read = false or allowsFieldFlow = true)
    )
  )
}

/**
 * Holds if `f` is the target of a read in the flow covered by `nodeCand2`.
 */
pragma[noinline]
private predicate readCand2(Content f, boolean read, Configuration config) {
  exists(NodeExt mid, NodeExt node |
    useFieldFlow(config) and
    nodeCandFwd2(node, _, true, unbind(config)) and
    readExt(node, f, mid, config) and
    storeCandFwd2(f, unbindBool(read), unbind(config)) and
    nodeCand2(mid, _, read, config)
  )
}

pragma[nomagic]
private predicate nodeCand2Store(
  Content f, NodeExt node, boolean toReturn, boolean stored, Configuration config
) {
  exists(NodeExt mid |
    storeExt(node, f, mid, config) and
    nodeCand2(mid, toReturn, true, config) and
    nodeCandFwd2(node, _, stored, unbind(config))
  )
}

pragma[nomagic]
private predicate storeCand2(Content f, boolean stored, Configuration conf) {
  exists(NodeExt node |
    nodeCand2Store(f, node, _, stored, conf) and
    nodeCand2(node, _, stored, conf)
  )
}

/**
 * Holds if `f` is the target of both a store and a read in the path graph
 * covered by `nodeCand2`.
 */
pragma[noinline]
private predicate readStoreCand(Content f, Configuration conf) {
  exists(boolean apNonEmpty |
    storeCand2(f, apNonEmpty, conf) and
    readCand2(f, apNonEmpty, conf)
  )
}

private predicate nodeCand2(NodeExt node, Configuration config) { nodeCand2(node, _, _, config) }

pragma[nomagic]
private predicate flowOutOfCallableNodeCand2(
  NodeExt node1, NodeExt node2, boolean allowsFieldFlow, Configuration config
) {
  flowOutOfCallableNodeCand1(node1, node2, allowsFieldFlow, config) and
  nodeCand2(node2, config) and
  nodeCand2(node1, unbind(config))
}

pragma[nomagic]
private predicate flowIntoCallableNodeCand2(
  NodeExt node1, NodeExt node2, boolean allowsFieldFlow, Configuration config
) {
  flowIntoCallableNodeCand1(node1, node2, allowsFieldFlow, config) and
  nodeCand2(node2, config) and
  nodeCand2(node1, unbind(config))
}

private module LocalFlowBigStep {
  /**
   * Holds if `node` can be the first node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  private predicate localFlowEntry(Node node, Configuration config) {
    nodeCand2(TNormalNode(node), config) and
    (
      config.isSource(node) or
      jumpStep(_, node, config) or
      additionalJumpStep(_, node, config) or
      node instanceof ParameterNode or
      node instanceof OutNode or
      node instanceof PostUpdateNode or
      readDirect(_, _, node) or
      node instanceof CastNode
    )
  }

  /**
   * Holds if `node` can be the last node in a maximal subsequence of local
   * flow steps in a dataflow path.
   */
  private predicate localFlowExit(Node node, Configuration config) {
    exists(Node next | nodeCand2(TNormalNode(next), config) |
      jumpStep(node, next, config) or
      additionalJumpStep(node, next, config) or
      flowIntoCallableNodeCand1(node, next, config) or
      flowOutOfCallableNodeCand1(node, next, config) or
      argumentFlowsThrough(node, next, _, _, _, config) or
      argumentValueFlowsThrough(_, node, TContentNone(), TContentNone(), next) or
      storeDirect(node, _, next) or
      readDirect(node, _, next)
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
    Node node1, Node node2, boolean preservesValue, DataFlowType t, Configuration config,
    LocalCallContext cc
  ) {
    not isUnreachableInCall(node2, cc.(LocalCallContextSpecificCall).getCall()) and
    (
      localFlowEntry(node1, config) and
      (
        localFlowStep(node1, node2, config) and
        preservesValue = true and
        t = getErasedNodeTypeBound(node1)
        or
        additionalLocalFlowStep(node1, node2, config) and
        preservesValue = false and
        t = getErasedNodeTypeBound(node2)
      ) and
      node1 != node2 and
      cc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall(node1, cc.(LocalCallContextSpecificCall).getCall()) and
      nodeCand2(TNormalNode(node2), unbind(config))
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, preservesValue, t, config, cc) and
        localFlowStep(mid, node2, config) and
        not mid instanceof CastNode and
        nodeCand2(TNormalNode(node2), unbind(config))
      )
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, _, _, config, cc) and
        additionalLocalFlowStep(mid, node2, config) and
        not mid instanceof CastNode and
        preservesValue = false and
        t = getErasedNodeTypeBound(node2) and
        nodeCand2(TNormalNode(node2), unbind(config))
      )
    )
  }

  /**
   * Holds if `node1` can step to `node2` in one or more local steps and this
   * path can occur as a maximal subsequence of local steps in a dataflow path.
   */
  pragma[nomagic]
  predicate localFlowBigStep(
    Node node1, Node node2, boolean preservesValue, DataFlowType t, Configuration config,
    LocalCallContext callContext
  ) {
    localFlowStepPlus(node1, node2, preservesValue, t, config, callContext) and
    localFlowExit(node2, config)
  }

  pragma[nomagic]
  predicate localFlowBigStepExt(
    NodeExt node1, NodeExt node2, boolean preservesValue, AccessPathFrontNil apf,
    Configuration config
  ) {
    localFlowBigStep(node1.getNode(), node2.getNode(), preservesValue, apf.getType(), config, _)
    or
    additionalLocalFlowStepExt(node1, node2, apf.getType(), config) and
    nodeCand2(node1, config) and
    nodeCand2(node2, unbind(config)) and
    preservesValue = false
  }
}

private import LocalFlowBigStep

pragma[nomagic]
private predicate readExtCand2(NodeExt node1, Content f, NodeExt node2, Configuration config) {
  readExt(node1, f, node2, config) and
  nodeCand2(node1, _, true, unbind(config)) and
  nodeCand2(node2, config) and
  readStoreCand(f, unbind(config))
}

pragma[nomagic]
private predicate storeExtCand2(NodeExt node1, Content f, NodeExt node2, Configuration config) {
  storeExt(node1, f, node2, config) and
  nodeCand2(node1, config) and
  nodeCand2(node2, _, true, unbind(config)) and
  readStoreCand(f, unbind(config))
}

private newtype TAccessPathFront =
  TFrontNil(DataFlowType t) or
  TFrontHead(Content f)

/**
 * The front of an `AccessPath`. This is either a head or a nil.
 */
abstract private class AccessPathFront extends TAccessPathFront {
  abstract string toString();

  abstract DataFlowType getType();

  abstract boolean toBoolNonEmpty();

  predicate headUsesContent(Content f) { this = TFrontHead(f) }
}

private class AccessPathFrontNil extends AccessPathFront, TFrontNil {
  override string toString() {
    exists(DataFlowType t | this = TFrontNil(t) | result = ppReprType(t))
  }

  override DataFlowType getType() { this = TFrontNil(result) }

  override boolean toBoolNonEmpty() { result = false }
}

private class AccessPathFrontHead extends AccessPathFront, TFrontHead {
  override string toString() { exists(Content f | this = TFrontHead(f) | result = f.toString()) }

  override DataFlowType getType() {
    exists(Content head | this = TFrontHead(head) | result = head.getContainerType())
  }

  override boolean toBoolNonEmpty() { result = true }
}

/**
 * Holds if data can flow from a source to `node` with the given `apf`.
 */
pragma[nomagic]
private predicate flowCandFwd(
  NodeExt node, boolean fromArg, AccessPathFront apf, Configuration config
) {
  flowCandFwd0(node, fromArg, apf, config) and
  if node instanceof CastingNodeExt
  then compatibleTypes(node.getErasedNodeTypeBound(), apf.getType())
  else any()
}

pragma[nomagic]
private predicate flowCandFwd0(
  NodeExt node, boolean fromArg, AccessPathFront apf, Configuration config
) {
  nodeCand2(node, _, false, config) and
  config.isSource(node.getNode()) and
  fromArg = false and
  apf = TFrontNil(node.getErasedNodeTypeBound())
  or
  exists(NodeExt mid |
    flowCandFwd(mid, fromArg, apf, config) and
    localFlowBigStepExt(mid, node, true, _, config)
  )
  or
  exists(NodeExt mid, AccessPathFrontNil nil |
    flowCandFwd(mid, fromArg, nil, config) and
    localFlowBigStepExt(mid, node, false, apf, config)
  )
  or
  nodeCand2(node, unbind(config)) and
  (
    exists(NodeExt mid |
      flowCandFwd(mid, _, apf, config) and
      jumpStepExt(mid, node, config) and
      fromArg = false
    )
    or
    exists(NodeExt mid, AccessPathFrontNil nil |
      flowCandFwd(mid, _, nil, config) and
      additionalJumpStepExt(mid, node, config) and
      fromArg = false and
      apf = TFrontNil(node.getErasedNodeTypeBound())
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      flowCandFwd(mid, _, apf, config) and
      flowIntoCallableNodeCand2(mid, node, allowsFieldFlow, config) and
      fromArg = true and
      (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      flowCandFwd(mid, false, apf, config) and
      flowOutOfCallableNodeCand2(mid, node, allowsFieldFlow, config) and
      fromArg = false and
      (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
    )
    or
    exists(NodeExt mid |
      flowCandFwd(mid, fromArg, apf, config) and
      argumentValueFlowsThrough(mid, node)
    )
    or
    exists(NodeExt mid, AccessPathFrontNil nil, DataFlowType t |
      flowCandFwd(mid, fromArg, nil, config) and
      argumentFlowsThrough(mid, node, t, config) and
      apf = TFrontNil(t)
    )
  )
  or
  exists(NodeExt mid, Content f |
    flowCandFwd(mid, fromArg, _, config) and
    storeExtCand2(mid, f, node, config) and
    nodeCand2(node, _, true, unbind(config)) and
    apf.headUsesContent(f)
  )
  or
  exists(Content f |
    flowCandFwdRead(f, node, fromArg, config) and
    consCandFwd(f, apf, config) and
    nodeCand2(node, _, unbindBool(apf.toBoolNonEmpty()), unbind(config))
  )
}

pragma[nomagic]
private predicate consCandFwd(Content f, AccessPathFront apf, Configuration config) {
  exists(NodeExt mid, NodeExt n |
    flowCandFwd(mid, _, apf, config) and
    storeExtCand2(mid, f, n, config) and
    nodeCand2(n, _, true, unbind(config)) and
    compatibleTypes(apf.getType(), f.getType())
  )
}

pragma[nomagic]
private predicate flowCandFwdRead(Content f, NodeExt node, boolean fromArg, Configuration config) {
  exists(NodeExt mid, AccessPathFrontHead apf0 |
    flowCandFwd(mid, fromArg, apf0, config) and
    readExtCand2(mid, f, node, config) and
    apf0.headUsesContent(f)
  )
}

/**
 * Holds if data can flow from a source to `node` with the given `apf` and
 * from there flow to a sink.
 */
pragma[nomagic]
private predicate flowCand(NodeExt node, boolean toReturn, AccessPathFront apf, Configuration config) {
  flowCand0(node, toReturn, apf, config) and
  flowCandFwd(node, _, apf, config)
}

pragma[nomagic]
private predicate flowCand0(
  NodeExt node, boolean toReturn, AccessPathFront apf, Configuration config
) {
  flowCandFwd(node, _, apf, config) and
  config.isSink(node.getNode()) and
  toReturn = false and
  apf instanceof AccessPathFrontNil
  or
  exists(NodeExt mid |
    localFlowBigStepExt(node, mid, true, _, config) and
    flowCand(mid, toReturn, apf, config)
  )
  or
  exists(NodeExt mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, apf, config) and
    localFlowBigStepExt(node, mid, false, _, config) and
    flowCand(mid, toReturn, nil, config) and
    apf instanceof AccessPathFrontNil
  )
  or
  exists(NodeExt mid |
    jumpStepExt(node, mid, config) and
    flowCand(mid, _, apf, config) and
    toReturn = false
  )
  or
  exists(NodeExt mid, AccessPathFrontNil nil |
    flowCandFwd(node, _, apf, config) and
    additionalJumpStepExt(node, mid, config) and
    flowCand(mid, _, nil, config) and
    toReturn = false and
    apf instanceof AccessPathFrontNil
  )
  or
  exists(NodeExt mid, boolean allowsFieldFlow |
    flowIntoCallableNodeCand2(node, mid, allowsFieldFlow, config) and
    flowCand(mid, false, apf, config) and
    toReturn = false and
    (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
  )
  or
  exists(NodeExt mid, boolean allowsFieldFlow |
    flowOutOfCallableNodeCand2(node, mid, allowsFieldFlow, config) and
    flowCand(mid, _, apf, config) and
    toReturn = true and
    (apf instanceof AccessPathFrontNil or allowsFieldFlow = true)
  )
  or
  exists(NodeExt mid |
    argumentValueFlowsThrough(node, mid) and
    flowCand(mid, toReturn, apf, config)
  )
  or
  exists(NodeExt mid, AccessPathFrontNil nil |
    argumentFlowsThrough(node, mid, _, config) and
    flowCand(mid, toReturn, nil, config) and
    apf instanceof AccessPathFrontNil and
    flowCandFwd(node, _, apf, config)
  )
  or
  exists(Content f, AccessPathFrontHead apf0 |
    flowCandStore(node, f, toReturn, apf0, config) and
    apf0.headUsesContent(f) and
    consCand(f, apf, config)
  )
  or
  exists(Content f, AccessPathFront apf0 |
    flowCandRead(node, f, toReturn, apf0, config) and
    consCandFwd(f, apf0, config) and
    apf.headUsesContent(f)
  )
}

pragma[nomagic]
private predicate flowCandRead(
  NodeExt node, Content f, boolean toReturn, AccessPathFront apf0, Configuration config
) {
  exists(NodeExt mid |
    readExtCand2(node, f, mid, config) and
    flowCand(mid, toReturn, apf0, config)
  )
}

pragma[nomagic]
private predicate flowCandStore(
  NodeExt node, Content f, boolean toReturn, AccessPathFrontHead apf0, Configuration config
) {
  exists(NodeExt mid |
    storeExtCand2(node, f, mid, config) and
    flowCand(mid, toReturn, apf0, config)
  )
}

pragma[nomagic]
private predicate consCand(Content f, AccessPathFront apf, Configuration config) {
  consCandFwd(f, apf, config) and
  exists(NodeExt n, AccessPathFrontHead apf0 |
    flowCandFwd(n, _, apf0, config) and
    apf0.headUsesContent(f) and
    flowCandRead(n, f, _, apf, config)
  )
}

private newtype TAccessPath =
  TNil(DataFlowType t) or
  TConsNil(Content f, DataFlowType t) { consCand(f, TFrontNil(t), _) } or
  TConsCons(Content f1, Content f2, int len) {
    consCand(f1, TFrontHead(f2), _) and len in [2 .. accessPathLimit()]
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

/**
 * Holds if data can flow from a source to `node` with the given `ap`.
 */
private predicate flowFwd(
  NodeExt node, boolean fromArg, AccessPathFront apf, AccessPath ap, Configuration config
) {
  flowFwd0(node, fromArg, apf, ap, config) and
  flowCand(node, _, apf, config)
}

private predicate flowFwd0(
  NodeExt node, boolean fromArg, AccessPathFront apf, AccessPath ap, Configuration config
) {
  flowCand(node, _, _, config) and
  config.isSource(node.getNode()) and
  fromArg = false and
  ap = TNil(node.getErasedNodeTypeBound()) and
  apf = ap.(AccessPathNil).getFront()
  or
  flowCand(node, _, _, unbind(config)) and
  (
    exists(NodeExt mid |
      flowFwd(mid, fromArg, apf, ap, config) and
      localFlowBigStepExt(mid, node, true, _, config)
    )
    or
    exists(NodeExt mid, AccessPathNil nil |
      flowFwd(mid, fromArg, _, nil, config) and
      localFlowBigStepExt(mid, node, false, apf, config) and
      apf = ap.(AccessPathNil).getFront()
    )
    or
    exists(NodeExt mid |
      flowFwd(mid, _, apf, ap, config) and
      jumpStepExt(mid, node, config) and
      fromArg = false
    )
    or
    exists(NodeExt mid, AccessPathNil nil |
      flowFwd(mid, _, _, nil, config) and
      additionalJumpStepExt(mid, node, config) and
      fromArg = false and
      ap = TNil(node.getErasedNodeTypeBound()) and
      apf = ap.(AccessPathNil).getFront()
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      flowFwd(mid, _, apf, ap, config) and
      flowIntoCallableNodeCand2(mid, node, allowsFieldFlow, config) and
      fromArg = true and
      (ap instanceof AccessPathNil or allowsFieldFlow = true)
    )
    or
    exists(NodeExt mid, boolean allowsFieldFlow |
      flowFwd(mid, false, apf, ap, config) and
      flowOutOfCallableNodeCand2(mid, node, allowsFieldFlow, config) and
      fromArg = false and
      (ap instanceof AccessPathNil or allowsFieldFlow = true)
    )
    or
    exists(NodeExt mid |
      flowFwd(mid, fromArg, apf, ap, config) and
      argumentValueFlowsThrough(mid, node)
    )
    or
    exists(NodeExt mid, AccessPathNil nil, DataFlowType t |
      flowFwd(mid, fromArg, _, nil, config) and
      argumentFlowsThrough(mid, node, t, config) and
      ap = TNil(t) and
      apf = ap.(AccessPathNil).getFront()
    )
  )
  or
  exists(Content f, AccessPath ap0 |
    flowFwdStore(node, f, ap0, apf, fromArg, config) and
    ap = push(f, ap0)
  )
  or
  exists(Content f |
    flowFwdRead(node, f, push(f, ap), fromArg, config) and
    flowConsCandFwd(f, apf, ap, config)
  )
}

pragma[nomagic]
private predicate flowFwdStore(
  NodeExt node, Content f, AccessPath ap0, AccessPathFront apf, boolean fromArg,
  Configuration config
) {
  exists(NodeExt mid, AccessPathFront apf0 |
    flowFwd(mid, fromArg, apf0, ap0, config) and
    flowFwdStore1(mid, f, node, apf0, apf, config)
  )
}

pragma[nomagic]
private predicate flowFwdStore0(
  NodeExt mid, Content f, NodeExt node, AccessPathFront apf0, Configuration config
) {
  storeExtCand2(mid, f, node, config) and
  flowCand(mid, _, apf0, config)
}

pragma[noinline]
private predicate flowFwdStore1(
  NodeExt mid, Content f, NodeExt node, AccessPathFront apf0, AccessPathFrontHead apf,
  Configuration config
) {
  flowFwdStore0(mid, f, node, apf0, config) and
  consCand(f, apf0, config) and
  apf.headUsesContent(f) and
  flowCand(node, _, apf, unbind(config))
}

pragma[nomagic]
private predicate flowFwdRead(
  NodeExt node, Content f, AccessPath ap0, boolean fromArg, Configuration config
) {
  exists(NodeExt mid, AccessPathFrontHead apf0 |
    flowFwd(mid, fromArg, apf0, ap0, config) and
    readExtCand2(mid, f, node, config) and
    apf0.headUsesContent(f) and
    flowCand(node, _, _, unbind(config))
  )
}

pragma[nomagic]
private predicate flowConsCandFwd(
  Content f, AccessPathFront apf, AccessPath ap, Configuration config
) {
  exists(NodeExt n |
    flowFwd(n, _, apf, ap, config) and
    flowFwdStore1(n, f, _, apf, _, config)
  )
}

/**
 * Holds if data can flow from a source to `node` with the given `ap` and
 * from there flow to a sink.
 */
private predicate flow(NodeExt node, boolean toReturn, AccessPath ap, Configuration config) {
  flow0(node, toReturn, ap, config) and
  flowFwd(node, _, _, ap, config)
}

private predicate flow0(NodeExt node, boolean toReturn, AccessPath ap, Configuration config) {
  flowFwd(node, _, _, ap, config) and
  config.isSink(node.getNode()) and
  toReturn = false and
  ap instanceof AccessPathNil
  or
  exists(NodeExt mid |
    localFlowBigStepExt(node, mid, true, _, config) and
    flow(mid, toReturn, ap, config)
  )
  or
  exists(NodeExt mid, AccessPathNil nil |
    flowFwd(node, _, _, ap, config) and
    localFlowBigStepExt(node, mid, false, _, config) and
    flow(mid, toReturn, nil, config) and
    ap instanceof AccessPathNil
  )
  or
  exists(NodeExt mid |
    jumpStepExt(node, mid, config) and
    flow(mid, _, ap, config) and
    toReturn = false
  )
  or
  exists(NodeExt mid, AccessPathNil nil |
    flowFwd(node, _, _, ap, config) and
    additionalJumpStepExt(node, mid, config) and
    flow(mid, _, nil, config) and
    toReturn = false and
    ap instanceof AccessPathNil
  )
  or
  exists(NodeExt mid, boolean allowsFieldFlow |
    flowIntoCallableNodeCand2(node, mid, allowsFieldFlow, config) and
    flow(mid, false, ap, config) and
    toReturn = false and
    (ap instanceof AccessPathNil or allowsFieldFlow = true)
  )
  or
  exists(NodeExt mid, boolean allowsFieldFlow |
    flowOutOfCallableNodeCand2(node, mid, allowsFieldFlow, config) and
    flow(mid, _, ap, config) and
    toReturn = true and
    (ap instanceof AccessPathNil or allowsFieldFlow = true)
  )
  or
  exists(NodeExt mid |
    argumentValueFlowsThrough(node, mid) and
    flow(mid, toReturn, ap, config)
  )
  or
  exists(NodeExt mid, AccessPathNil nil |
    argumentFlowsThrough(node, mid, _, config) and
    flow(mid, toReturn, nil, config) and
    ap instanceof AccessPathNil and
    flowFwd(node, _, _, ap, config)
  )
  or
  exists(Content f |
    flowStore(f, node, toReturn, ap, config) and
    flowConsCand(f, ap, config)
  )
  or
  exists(NodeExt mid, AccessPath ap0 |
    readFwd(node, _, mid, ap, ap0, config) and
    flow(mid, toReturn, ap0, config)
  )
}

pragma[nomagic]
private predicate storeFwd(
  NodeExt node1, Content f, NodeExt node2, AccessPath ap, AccessPath ap0, Configuration config
) {
  storeExtCand2(node1, f, node2, config) and
  flowFwdStore(node2, f, ap, _, _, config) and
  ap0 = push(f, ap)
}

pragma[nomagic]
private predicate flowStore(
  Content f, NodeExt node, boolean toReturn, AccessPath ap, Configuration config
) {
  exists(NodeExt mid, AccessPath ap0 |
    storeFwd(node, f, mid, ap, ap0, config) and
    flow(mid, toReturn, ap0, config)
  )
}

pragma[nomagic]
private predicate readFwd(
  NodeExt node1, Content f, NodeExt node2, AccessPath ap, AccessPath ap0, Configuration config
) {
  readExtCand2(node1, f, node2, config) and
  flowFwdRead(node2, f, ap, _, config) and
  ap0 = pop(f, ap) and
  flowConsCandFwd(f, _, ap0, unbind(config))
}

pragma[nomagic]
private predicate flowConsCand(Content f, AccessPath ap, Configuration config) {
  exists(NodeExt n, NodeExt mid |
    flow(mid, _, ap, config) and
    readFwd(n, f, mid, _, ap, config)
  )
}

bindingset[conf, result]
private Configuration unbind(Configuration conf) { result >= conf and result <= conf }

private predicate flow(Node n, Configuration config) { flow(TNormalNode(n), _, _, config) }

private newtype TSummaryCtx =
  TSummaryCtxNone() or
  TSummaryCtxSome(ParameterNode p, AccessPath ap) {
    exists(ReturnNodeExt ret, Configuration config | flow(TNormalNode(p), true, ap, config) |
      exists(Summary summary |
        parameterFlowReturn(p, ret, _, _, _, summary, config) and
        flow(ret, unbind(config))
      |
        // taint through
        summary = TSummaryTaint() and
        ap instanceof AccessPathNil
        or
        // taint setter
        summary = TSummaryTaintStore(_) and
        ap instanceof AccessPathNil
        or
        // taint getter
        summary = TSummaryReadTaint(ap.(AccessPathConsNil).getHead())
      )
      or
      exists(ContentOption contentIn |
        parameterValueFlowReturn(p, ret, _, contentIn, _) and
        flow(ret, unbind(config))
      |
        // value through/setter
        contentIn = TContentNone()
        or
        // value getter (+ setter)
        contentIn = TContentSome(ap.getHead())
      )
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
      flow(TNormalNode(node), _, ap, unbind(config))
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
  exists(
    AccessPath ap0, Node midnode, Configuration conf, DataFlowCallable enclosing,
    LocalCallContext localCC
  |
    pathIntoLocalStep(mid, midnode, cc, enclosing, sc, ap0, conf) and
    localCC = getLocalCallContext(cc, enclosing)
  |
    localFlowBigStep(midnode, node, true, _, conf, localCC) and
    ap = ap0
    or
    localFlowBigStep(midnode, node, false, ap.(AccessPathNil).getType(), conf, localCC) and
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
  exists(Content f | pathReadStep(mid, node, push(f, ap), f, cc)) and
  sc = mid.getSummaryCtx()
  or
  exists(Content f | pathStoreStep(mid, node, pop(f, ap), f, cc)) and
  sc = mid.getSummaryCtx()
  or
  pathIntoCallable(mid, node, _, cc, sc, _) and ap = mid.getAp()
  or
  pathOutOfCallable(mid, node, cc) and ap = mid.getAp() and sc instanceof SummaryCtxNone
  or
  pathThroughCallable(mid, node, cc, ap) and sc = mid.getSummaryCtx()
}

pragma[nomagic]
private predicate pathIntoLocalStep(
  PathNodeMid mid, Node midnode, CallContext cc, DataFlowCallable enclosing, SummaryCtx sc,
  AccessPath ap0, Configuration conf
) {
  midnode = mid.getNode() and
  cc = mid.getCallContext() and
  conf = mid.getConfiguration() and
  localFlowBigStep(midnode, _, _, _, conf, _) and
  enclosing = midnode.getEnclosingCallable() and
  sc = mid.getSummaryCtx() and
  ap0 = mid.getAp()
}

pragma[nomagic]
private predicate readCand(Node node1, Content f, Node node2, Configuration config) {
  readDirect(node1, f, node2) and
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
  storeDirect(node1, f, node2) and
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
private Node getAnOutNodeCand(
  ReturnKindExt kind, DataFlowCall call, AccessPath ap, Configuration config
) {
  result = kind.getAnOutNode(call) and
  flow(TNormalNode(result), _, ap, config)
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
    out = getAnOutNodeCand(kind, call, ap, config)
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
    flow(TNormalNode(p), _, ap, config) and
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
    out = getAnOutNodeCand(kind, call, ap, mid.getConfiguration())
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
      exists(DataFlowCall call, ReturnKindExt kind |
        getReturnPosition(node1) = viableReturnPos(call, kind) and
        node2 = kind.getAnOutNode(call)
      )
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
    storeDirect(mid.getNode(), f, node) and
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
