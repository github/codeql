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
   * Gets the exploration limit for `hasPartialFlow` and `hasPartialFlowRev`
   * measured in approximate number of interprocedural steps.
   */
  int explorationLimit() { none() }

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
  predicate fwdFlow(Node node, Cc cc, Configuration config) {
    not fullBarrier(node, config) and
    (
      config.isSource(node) and
      cc = false
      or
      exists(Node mid |
        fwdFlow(mid, cc, config) and
        localFlowStep(mid, node, config)
      )
      or
      exists(Node mid |
        fwdFlow(mid, cc, config) and
        additionalLocalFlowStep(mid, node, config)
      )
      or
      exists(Node mid |
        fwdFlow(mid, _, config) and
        jumpStep(mid, node, config) and
        cc = false
      )
      or
      exists(Node mid |
        fwdFlow(mid, _, config) and
        additionalJumpStep(mid, node, config) and
        cc = false
      )
      or
      // store
      exists(Node mid |
        useFieldFlow(config) and
        fwdFlow(mid, cc, config) and
        store(mid, _, node, _) and
        not outBarrier(mid, config)
      )
      or
      // read
      exists(Content c |
        fwdFlowRead(c, node, cc, config) and
        fwdFlowIsStored(c, config) and
        not inBarrier(node, config)
      )
      or
      // flow into a callable
      exists(Node arg |
        fwdFlow(arg, _, config) and
        viableParamArg(_, node, arg) and
        cc = true
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
    )
  }

  private predicate fwdFlow(Node node, Configuration config) { fwdFlow(node, _, config) }

  pragma[nomagic]
  private predicate fwdFlowRead(Content c, Node node, Cc cc, Configuration config) {
    exists(Node mid |
      fwdFlow(mid, cc, config) and
      read(mid, c, node)
    )
  }

  /**
   * Holds if `c` is the target of a store in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsStored(Content c, Configuration config) {
    exists(Node mid, Node node, TypedContent tc |
      not fullBarrier(node, config) and
      useFieldFlow(config) and
      fwdFlow(mid, config) and
      store(mid, tc, node, _) and
      c = tc.getContent()
    )
  }

  pragma[nomagic]
  private predicate fwdFlowReturnPosition(ReturnPosition pos, Cc cc, Configuration config) {
    exists(ReturnNodeExt ret |
      fwdFlow(ret, cc, config) and
      getReturnPosition(ret) = pos
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOut(DataFlowCall call, Node out, Cc cc, Configuration config) {
    exists(ReturnPosition pos |
      fwdFlowReturnPosition(pos, cc, config) and
      viableReturnPosOut(call, pos, out)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(DataFlowCall call, Node node, Configuration config) {
    fwdFlowOut(call, node, true, config)
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(DataFlowCall call, Cc cc, Configuration config) {
    exists(ArgumentNode arg |
      fwdFlow(arg, cc, config) and
      viableParamArg(call, _, arg)
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
  predicate revFlow(Node node, boolean toReturn, Configuration config) {
    revFlow_0(node, toReturn, config) and
    fwdFlow(node, config)
  }

  pragma[nomagic]
  private predicate revFlow_0(Node node, boolean toReturn, Configuration config) {
    fwdFlow(node, config) and
    config.isSink(node) and
    toReturn = false
    or
    exists(Node mid |
      localFlowStep(node, mid, config) and
      revFlow(mid, toReturn, config)
    )
    or
    exists(Node mid |
      additionalLocalFlowStep(node, mid, config) and
      revFlow(mid, toReturn, config)
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      revFlow(mid, _, config) and
      toReturn = false
    )
    or
    exists(Node mid |
      additionalJumpStep(node, mid, config) and
      revFlow(mid, _, config) and
      toReturn = false
    )
    or
    // store
    exists(Content c |
      revFlowStore(c, node, toReturn, config) and
      revFlowIsRead(c, config)
    )
    or
    // read
    exists(Node mid, Content c |
      read(node, c, mid) and
      fwdFlowIsStored(c, unbind(config)) and
      revFlow(mid, toReturn, config)
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
      getReturnPosition(node) = pos and
      toReturn = true
    )
  }

  /**
   * Holds if `c` is the target of a read in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowIsRead(Content c, Configuration config) {
    exists(Node mid, Node node |
      useFieldFlow(config) and
      fwdFlow(node, unbind(config)) and
      read(node, c, mid) and
      fwdFlowIsStored(c, unbind(config)) and
      revFlow(mid, _, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowStore(Content c, Node node, boolean toReturn, Configuration config) {
    exists(Node mid, TypedContent tc |
      revFlow(mid, toReturn, config) and
      fwdFlowIsStored(c, unbind(config)) and
      store(node, tc, mid, _) and
      c = tc.getContent()
    )
  }

  /**
   * Holds if `c` is the target of both a read and a store in the flow covered
   * by `revFlow`.
   */
  predicate revFlowIsReadAndStored(Content c, Configuration conf) {
    revFlowIsRead(c, conf) and
    revFlowStore(c, _, _, conf)
  }

  pragma[nomagic]
  predicate viableReturnPosOutNodeCandFwd1(
    DataFlowCall call, ReturnPosition pos, Node out, Configuration config
  ) {
    fwdFlowReturnPosition(pos, _, config) and
    viableReturnPosOut(call, pos, out)
  }

  pragma[nomagic]
  private predicate revFlowOut(ReturnPosition pos, Configuration config) {
    exists(DataFlowCall call, Node out |
      revFlow(out, _, config) and
      viableReturnPosOutNodeCandFwd1(call, pos, out, config)
    )
  }

  pragma[nomagic]
  predicate viableParamArgNodeCandFwd1(
    DataFlowCall call, ParameterNode p, ArgumentNode arg, Configuration config
  ) {
    viableParamArg(call, p, arg) and
    fwdFlow(arg, config)
  }

  pragma[nomagic]
  private predicate revFlowIn(
    DataFlowCall call, ArgumentNode arg, boolean toReturn, Configuration config
  ) {
    exists(ParameterNode p |
      revFlow(p, toReturn, config) and
      viableParamArgNodeCandFwd1(call, p, arg, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(DataFlowCall call, ArgumentNode arg, Configuration config) {
    revFlowIn(call, arg, true, config)
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(DataFlowCall call, boolean toReturn, Configuration config) {
    exists(Node out |
      revFlow(out, toReturn, config) and
      fwdFlowOutFromArg(call, out, config)
    )
  }

  pragma[nomagic]
  predicate revFlow(Node node, Configuration config) { revFlow(node, _, config) }
  /* End: Stage 1 logic. */
}

bindingset[result, b]
private boolean unbindBool(boolean b) { result != b.booleanNot() }

private predicate throughFlowNodeCand1(Node node, Configuration config) {
  Stage1::revFlow(node, true, config) and
  Stage1::fwdFlow(node, true, config) and
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
    Stage1::revFlowIsReadAndStored(c, config) and
    Stage1::revFlow(n2, unbind(config)) and
    store(n1, tc, n2, _) and
    c = tc.getContent()
  )
}

pragma[nomagic]
private predicate read(Node n1, Content c, Node n2, Configuration config) {
  Stage1::revFlowIsReadAndStored(c, config) and
  Stage1::revFlow(n2, unbind(config)) and
  read(n1, c, n2)
}

pragma[noinline]
private predicate localFlowStepNodeCand1(Node node1, Node node2, Configuration config) {
  Stage1::revFlow(node1, config) and
  localFlowStep(node1, node2, config)
}

pragma[noinline]
private predicate additionalLocalFlowStepNodeCand1(Node node1, Node node2, Configuration config) {
  Stage1::revFlow(node1, config) and
  additionalLocalFlowStep(node1, node2, config)
}

pragma[nomagic]
private predicate viableReturnPosOutNodeCand1(
  DataFlowCall call, ReturnPosition pos, Node out, Configuration config
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
  DataFlowCall call, ReturnNodeExt ret, Node out, Configuration config
) {
  viableReturnPosOutNodeCand1(call, getReturnPosition(ret), out, config) and
  Stage1::revFlow(ret, config) and
  not outBarrier(ret, config) and
  not inBarrier(out, config)
}

pragma[nomagic]
private predicate viableParamArgNodeCand1(
  DataFlowCall call, ParameterNode p, ArgumentNode arg, Configuration config
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
  DataFlowCall call, ArgumentNode arg, ParameterNode p, Configuration config
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

private module Stage2 {
  class ApApprox = Stage1::Ap;

  class Ap = boolean;

  class ApNil extends Ap {
    ApNil() { this = false }
  }

  class ApOption = BooleanOption;

  ApOption apNone() { result = TBooleanNone() }

  ApOption apSome(Ap ap) { result = TBooleanSome(ap) }

  class Cc = boolean;

  /* Begin: Stage 2 logic. */
  /**
   * Holds if `node` is reachable from a source in the configuration `config`.
   * The Boolean `ap` records whether the tracked value is stored into a
   * field of `node`.
   *
   * The Boolean `cc` records whether the node is reached through an
   * argument in a call, and if so, `argAp` records whether the tracked
   * value was stored into a field of the argument.
   */
  private predicate fwdFlow(Node node, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    Stage1::revFlow(node, config) and
    config.isSource(node) and
    cc = false and
    argAp = apNone() and
    ap = false
    or
    Stage1::revFlow(node, unbind(config)) and
    (
      exists(Node mid |
        fwdFlow(mid, cc, argAp, ap, config) and
        localFlowStepNodeCand1(mid, node, config)
      )
      or
      exists(Node mid |
        fwdFlow(mid, cc, argAp, ap, config) and
        additionalLocalFlowStepNodeCand1(mid, node, config) and
        ap = false
      )
      or
      exists(Node mid |
        fwdFlow(mid, _, _, ap, config) and
        jumpStep(mid, node, config) and
        cc = false and
        argAp = apNone()
      )
      or
      exists(Node mid |
        fwdFlow(mid, _, _, ap, config) and
        additionalJumpStep(mid, node, config) and
        cc = false and
        argAp = apNone() and
        ap = false
      )
      or
      // store
      exists(Node mid |
        fwdFlow(mid, cc, argAp, _, config) and
        storeCand1(mid, _, node, config) and
        ap = true
      )
      or
      // read
      exists(Content c |
        fwdFlowRead(c, node, cc, argAp, config) and
        fwdFlowConsCand(c, ap, config)
      )
      or
      // flow into a callable
      fwdFlowIn(_, node, _, _, ap, config) and
      cc = true and
      if parameterThroughFlowNodeCand1(node, config) then argAp = apSome(ap) else argAp = apNone()
      or
      // flow out of a callable
      exists(DataFlowCall call |
        fwdFlowOut(call, node, cc, argAp, ap, config) and
        cc = false
        or
        exists(boolean argStored0 |
          fwdFlowOutFromArg(call, node, argStored0, ap, config) and
          fwdFlowIsEntered(call, cc, argAp, argStored0, config)
        )
      )
    )
  }

  /**
   * Holds if `c` is the target of a store in the flow covered by `fwdFlow`.
   */
  pragma[noinline]
  private predicate fwdFlowConsCand(Content c, Ap ap, Configuration config) {
    exists(Node mid, Node node |
      useFieldFlow(config) and
      Stage1::revFlow(node, unbind(config)) and
      fwdFlow(mid, _, _, ap, config) and
      storeCand1(mid, c, node, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowRead(Content c, Node node, Cc cc, ApOption argAp, Configuration config) {
    exists(Node mid |
      fwdFlow(mid, cc, argAp, true, config) and
      read(mid, c, node, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowIn(
    DataFlowCall call, ParameterNode p, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ArgumentNode arg, boolean allowsFieldFlow |
      fwdFlow(arg, cc, argAp, ap, config) and
      flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOut(
    DataFlowCall call, Node out, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ReturnNodeExt ret, boolean allowsFieldFlow |
      fwdFlow(ret, cc, argAp, ap, config) and
      flowOutOfCallNodeCand1(call, ret, out, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(
    DataFlowCall call, Node out, boolean argAp, Ap ap, Configuration config
  ) {
    fwdFlowOut(call, out, true, apSome(argAp), ap, config)
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(
    DataFlowCall call, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ParameterNode p |
      fwdFlowIn(call, p, cc, argAp, ap, config) and
      parameterThroughFlowNodeCand1(p, config)
    )
  }

  /**
   * Holds if `node` is part of a path from a source to a sink in the
   * configuration `config`. The Boolean `ap` records whether the tracked
   * value must be read from a field of `node` in order to reach a sink.
   *
   * The Boolean `toReturn` records whether the node must be returned from
   * the enclosing callable in order to reach a sink, and if so, `returnAp`
   * records whether a field must be read from the returned value.
   */
  pragma[nomagic]
  predicate revFlow(Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config) {
    revFlow0(node, toReturn, returnAp, ap, config) and
    fwdFlow(node, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlow0(
    Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    fwdFlow(node, _, _, ap, config) and
    config.isSink(node) and
    toReturn = false and
    returnAp = apNone() and
    ap instanceof ApNil
    or
    exists(Node mid |
      localFlowStepNodeCand1(node, mid, config) and
      revFlow(mid, toReturn, returnAp, ap, config)
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(node, _, _, ap, config) and
      additionalLocalFlowStepNodeCand1(node, mid, config) and
      revFlow(mid, toReturn, returnAp, nil, config) and
      ap instanceof ApNil
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      revFlow(mid, _, _, ap, config) and
      toReturn = false and
      returnAp = apNone()
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(node, _, _, ap, config) and
      additionalJumpStep(node, mid, config) and
      revFlow(mid, _, _, nil, config) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    // store
    exists(Content c |
      revFlowStore(c, node, toReturn, returnAp, ap, config) and
      revFlowConsCand(c, ap, config)
    )
    or
    // read
    exists(Node mid, Content c, Ap ap0 |
      read(node, c, mid, config) and
      fwdFlowConsCand(c, unbindBool(ap0), unbind(config)) and
      revFlow(mid, toReturn, returnAp, ap0, config) and
      ap = true
    )
    or
    // flow into a callable
    exists(DataFlowCall call |
      revFlowIn(call, node, toReturn, returnAp, ap, config) and
      toReturn = false
      or
      exists(Ap returnAp0 |
        revFlowInToReturn(call, node, returnAp0, ap, config) and
        revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
      )
    )
    or
    // flow out of a callable
    revFlowOut(_, node, _, _, ap, config) and
    toReturn = true and
    if fwdFlow(node, true, apSome(_), unbindBool(ap), config)
    then returnAp = apSome(ap)
    else returnAp = apNone()
  }

  /**
   * Holds if `c` is the target of a read in the flow covered by `revFlow`.
   */
  pragma[noinline]
  private predicate revFlowConsCand(Content c, Ap ap, Configuration config) {
    exists(Node mid, Node node |
      useFieldFlow(config) and
      fwdFlow(node, _, _, true, unbind(config)) and
      read(node, c, mid, config) and
      fwdFlowConsCand(c, unbindBool(ap), unbind(config)) and
      revFlow(mid, _, _, ap, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowStore(
    Content c, Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(Node mid |
      storeCand1(node, c, mid, config) and
      revFlow(mid, toReturn, returnAp, true, config) and
      fwdFlow(node, _, _, ap, unbind(config))
    )
  }

  /**
   * Holds if `c` is the target of a store in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowIsStored(Content c, Ap ap, Configuration conf) {
    exists(Node node |
      revFlowStore(c, node, _, _, ap, conf) and
      revFlow(node, _, _, ap, conf)
    )
  }

  /**
   * Holds if `c` is the target of both a store and a read in the path graph
   * covered by `revFlow`.
   */
  pragma[noinline]
  predicate revFlowIsReadAndStored(Content c, Configuration conf) {
    exists(boolean apNonEmpty |
      revFlowIsStored(c, apNonEmpty, conf) and
      revFlowConsCand(c, apNonEmpty, conf)
    )
  }

  pragma[nomagic]
  private predicate revFlowOut(
    DataFlowCall call, ReturnNodeExt ret, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(Node out, boolean allowsFieldFlow |
      revFlow(out, toReturn, returnAp, ap, config) and
      flowOutOfCallNodeCand1(call, ret, out, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate revFlowIn(
    DataFlowCall call, ArgumentNode arg, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(ParameterNode p, boolean allowsFieldFlow |
      revFlow(p, toReturn, returnAp, ap, config) and
      flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(
    DataFlowCall call, ArgumentNode arg, Ap returnAp, Ap ap, Configuration config
  ) {
    revFlowIn(call, arg, true, apSome(returnAp), ap, config)
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(
    DataFlowCall call, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(ReturnNodeExt ret |
      revFlowOut(call, ret, toReturn, returnAp, ap, config) and
      fwdFlow(ret, true, apSome(_), ap, config)
    )
  }

  predicate revFlow(Node node, Configuration config) { revFlow(node, _, _, _, config) }
  /* End: Stage 2 logic. */
}

pragma[nomagic]
private predicate flowOutOfCallNodeCand2(
  DataFlowCall call, ReturnNodeExt node1, Node node2, boolean allowsFieldFlow, Configuration config
) {
  flowOutOfCallNodeCand1(call, node1, node2, allowsFieldFlow, config) and
  Stage2::revFlow(node2, config) and
  Stage2::revFlow(node1, unbind(config))
}

pragma[nomagic]
private predicate flowIntoCallNodeCand2(
  DataFlowCall call, ArgumentNode node1, ParameterNode node2, boolean allowsFieldFlow,
  Configuration config
) {
  flowIntoCallNodeCand1(call, node1, node2, allowsFieldFlow, config) and
  Stage2::revFlow(node2, config) and
  Stage2::revFlow(node1, unbind(config))
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
    Stage2::revFlow(node, config) and
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
    exists(Node next | Stage2::revFlow(next, config) |
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
    Stage2::revFlow(node1, _, _, false, config) and
    Stage2::revFlow(node2, _, _, false, unbind(config))
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
      Stage2::revFlow(node2, unbind(config))
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, preservesValue, t, config, cc) and
        localFlowStepNodeCand1(mid, node2, config) and
        not mid instanceof FlowCheckNode and
        Stage2::revFlow(node2, unbind(config))
      )
      or
      exists(Node mid |
        localFlowStepPlus(node1, mid, _, _, config, cc) and
        additionalLocalFlowStepNodeCand2(mid, node2, config) and
        not mid instanceof FlowCheckNode and
        preservesValue = false and
        t = getNodeType(node2) and
        Stage2::revFlow(node2, unbind(config))
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
  Stage2::revFlow(node1, _, _, true, unbind(config)) and
  Stage2::revFlow(node2, config) and
  Stage2::revFlowIsReadAndStored(c, unbind(config))
}

pragma[nomagic]
private predicate storeCand2(
  Node node1, TypedContent tc, Node node2, DataFlowType contentType, Configuration config
) {
  store(node1, tc, node2, contentType) and
  Stage2::revFlow(node1, config) and
  Stage2::revFlow(node2, _, _, true, unbind(config)) and
  Stage2::revFlowIsReadAndStored(tc.getContent(), unbind(config))
}

private module Stage3 {
  class ApApprox = Stage2::Ap;

  class Ap = AccessPathFront;

  class ApNil = AccessPathFrontNil;

  class ApOption = AccessPathFrontOption;

  ApOption apNone() { result = TAccessPathFrontNone() }

  ApOption apSome(Ap ap) { result = TAccessPathFrontSome(ap) }

  class Cc = boolean;

  /* Begin: Stage 3 logic. */
  /**
   * Holds if `node` is reachable with access path front `ap` from a
   * source in the configuration `config`.
   *
   * The Boolean `cc` records whether the node is reached through an
   * argument in a call, and if so, `argAp` records the front of the
   * access path of that argument.
   */
  pragma[nomagic]
  predicate fwdFlow(Node node, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    fwdFlow0(node, cc, argAp, ap, config) and
    not ap.isClearedAt(node) and
    if node instanceof CastingNode then compatibleTypes(getNodeType(node), ap.getType()) else any()
  }

  pragma[nomagic]
  private predicate fwdFlow0(Node node, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    Stage2::revFlow(node, _, _, false, config) and
    config.isSource(node) and
    cc = false and
    argAp = apNone() and
    ap = TFrontNil(getNodeType(node))
    or
    exists(Node mid |
      fwdFlow(mid, cc, argAp, ap, config) and
      localFlowBigStep(mid, node, true, _, config, _)
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(mid, cc, argAp, nil, config) and
      localFlowBigStep(mid, node, false, ap, config, _)
    )
    or
    exists(Node mid |
      fwdFlow(mid, _, _, ap, config) and
      Stage2::revFlow(node, unbind(config)) and
      jumpStep(mid, node, config) and
      cc = false and
      argAp = apNone()
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(mid, _, _, nil, config) and
      Stage2::revFlow(node, unbind(config)) and
      additionalJumpStep(mid, node, config) and
      cc = false and
      argAp = apNone() and
      ap = TFrontNil(getNodeType(node))
    )
    or
    // store
    exists(Node mid, TypedContent tc, Ap ap0, DataFlowType contentType |
      fwdFlow(mid, cc, argAp, ap0, config) and
      storeCand2(mid, tc, node, contentType, config) and
      Stage2::revFlow(node, _, _, true, unbind(config)) and
      ap.headUsesContent(tc) and
      compatibleTypes(ap0.getType(), contentType)
    )
    or
    // read
    exists(TypedContent tc |
      fwdFlowRead(tc, node, cc, argAp, config) and
      fwdFlowConsCand(tc, ap, config) and
      Stage2::revFlow(node, _, _, unbindBool(ap.toBoolNonEmpty()), unbind(config))
    )
    or
    // flow into a callable
    fwdFlowIn(_, node, _, _, ap, config) and
    cc = true and
    if Stage2::revFlow(node, true, _, unbindBool(ap.toBoolNonEmpty()), config)
    then argAp = apSome(ap)
    else argAp = apNone()
    or
    // flow out of a callable
    exists(DataFlowCall call |
      fwdFlowOut(call, node, cc, argAp, ap, config) and
      cc = false
      or
      exists(Ap argApf0 |
        fwdFlowOutFromArg(call, node, argApf0, ap, config) and
        fwdFlowIsEntered(call, cc, argAp, argApf0, config)
      )
    )
  }

  pragma[nomagic]
  private predicate fwdFlowConsCand(TypedContent tc, Ap ap, Configuration config) {
    exists(Node mid, Node n, DataFlowType contentType |
      fwdFlow(mid, _, _, ap, config) and
      storeCand2(mid, tc, n, contentType, config) and
      Stage2::revFlow(n, _, _, true, unbind(config)) and
      compatibleTypes(ap.getType(), contentType)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowRead0(
    Node node1, TypedContent tc, Content c, Node node2, Cc cc, ApOption argAp,
    AccessPathFrontHead ap, Configuration config
  ) {
    fwdFlow(node1, cc, argAp, ap, config) and
    readCand2(node1, c, node2, config) and
    ap.headUsesContent(tc)
  }

  pragma[nomagic]
  private predicate fwdFlowRead(
    TypedContent tc, Node node, Cc cc, ApOption argAp, Configuration config
  ) {
    fwdFlowRead0(_, tc, tc.getContent(), node, cc, argAp, _, config)
  }

  pragma[nomagic]
  private predicate fwdFlowIn(
    DataFlowCall call, ParameterNode p, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ArgumentNode arg, boolean allowsFieldFlow |
      fwdFlow(arg, cc, argAp, ap, config) and
      flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOut(
    DataFlowCall call, Node node, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ReturnNodeExt ret, boolean allowsFieldFlow |
      fwdFlow(ret, cc, argAp, ap, config) and
      flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(
    DataFlowCall call, Node node, Ap argAp, Ap ap, Configuration config
  ) {
    fwdFlowOut(call, node, true, apSome(argAp), ap, config)
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(
    DataFlowCall call, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ParameterNode p |
      fwdFlowIn(call, p, cc, argAp, ap, config) and
      Stage2::revFlow(p, true, TBooleanSome(_), unbindBool(ap.toBoolNonEmpty()), config)
    )
  }

  /**
   * Holds if `node` with access path front `ap` is part of a path from a
   * source to a sink in the configuration `config`.
   *
   * The Boolean `toReturn` records whether the node must be returned from
   * the enclosing callable in order to reach a sink, and if so, `returnAp`
   * records the front of the access path of the returned value.
   */
  pragma[nomagic]
  predicate revFlow(Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config) {
    revFlow0(node, toReturn, returnAp, ap, config) and
    fwdFlow(node, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlow0(
    Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    fwdFlow(node, _, _, ap, config) and
    config.isSink(node) and
    toReturn = false and
    returnAp = apNone() and
    ap instanceof ApNil
    or
    exists(Node mid |
      localFlowBigStep(node, mid, true, _, config, _) and
      revFlow(mid, toReturn, returnAp, ap, config)
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(node, _, _, ap, config) and
      localFlowBigStep(node, mid, false, _, config, _) and
      revFlow(mid, toReturn, returnAp, nil, config) and
      ap instanceof ApNil
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      revFlow(mid, _, _, ap, config) and
      toReturn = false and
      returnAp = apNone()
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(node, _, _, ap, config) and
      additionalJumpStep(node, mid, config) and
      revFlow(mid, _, _, nil, config) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    // store
    exists(TypedContent tc |
      revFlowStore(node, tc, ap, toReturn, returnAp, config) and
      revFlowConsCand(tc, ap, config)
    )
    or
    // read
    exists(TypedContent tc, Ap ap0 |
      revFlowRead(node, tc, ap, toReturn, returnAp, ap0, config) and
      fwdFlowConsCand(tc, ap0, config)
    )
    or
    // flow into a callable
    exists(DataFlowCall call |
      revFlowIn(call, node, toReturn, returnAp, ap, config) and
      toReturn = false
      or
      exists(Ap returnAp0 |
        revFlowInToReturn(call, node, returnAp0, ap, config) and
        revFlowIsReturned(call, toReturn, returnAp, returnAp0, config)
      )
    )
    or
    // flow out of a callable
    revFlowOut(_, node, _, _, ap, config) and
    toReturn = true and
    if fwdFlow(node, true, _, ap, config) then returnAp = apSome(ap) else returnAp = apNone()
  }

  pragma[nomagic]
  predicate readCandFwd(Node node1, TypedContent tc, Ap ap, Node node2, Configuration config) {
    fwdFlowRead0(node1, tc, tc.getContent(), node2, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlowRead(
    Node node, TypedContent tc, Ap ap, boolean toReturn, ApOption returnAp, Ap apf0,
    Configuration config
  ) {
    exists(Node mid |
      readCandFwd(node, tc, ap, mid, config) and
      revFlow(mid, toReturn, returnAp, apf0, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowStore(
    Node node, TypedContent tc, Ap ap, boolean toReturn, ApOption returnAp, Configuration config
  ) {
    exists(Node mid |
      fwdFlow(node, _, _, ap, config) and
      storeCand2(node, tc, mid, _, unbind(config)) and
      revFlow(mid, toReturn, returnAp, TFrontHead(tc), unbind(config))
    )
  }

  pragma[nomagic]
  predicate revFlowConsCand(TypedContent tc, Ap ap, Configuration config) {
    fwdFlowConsCand(tc, ap, config) and
    revFlowRead(_, tc, _, _, _, ap, config)
  }

  pragma[nomagic]
  private predicate revFlowOut(
    DataFlowCall call, ReturnNodeExt ret, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(Node out, boolean allowsFieldFlow |
      revFlow(out, toReturn, returnAp, ap, config) and
      flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate revFlowIn(
    DataFlowCall call, ArgumentNode arg, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(ParameterNode p, boolean allowsFieldFlow |
      revFlow(p, toReturn, returnAp, ap, config) and
      flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(
    DataFlowCall call, ArgumentNode arg, Ap returnAp, Ap ap, Configuration config
  ) {
    revFlowIn(call, arg, true, apSome(returnAp), ap, config)
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(
    DataFlowCall call, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(ReturnNodeExt ret |
      revFlowOut(call, ret, toReturn, returnAp, ap, config) and
      fwdFlow(ret, true, apSome(_), ap, config)
    )
  }
  /* End: Stage 3 logic. */
}

/**
 * Holds if `argApf` is recorded as the summary context for flow reaching `node`
 * and remains relevant for the following pruning stage.
 */
private predicate flowCandSummaryCtx(Node node, AccessPathFront argApf, Configuration config) {
  exists(AccessPathFront apf |
    Stage3::revFlow(node, true, _, apf, config) and
    Stage3::fwdFlow(node, true, TAccessPathFrontSome(argApf), apf, config)
  )
}

/**
 * Holds if a length 2 access path approximation with the head `tc` is expected
 * to be expensive.
 */
private predicate expensiveLen2unfolding(TypedContent tc, Configuration config) {
  exists(int tails, int nodes, int apLimit, int tupleLimit |
    tails = strictcount(AccessPathFront apf | Stage3::revFlowConsCand(tc, apf, config)) and
    nodes =
      strictcount(Node n |
        Stage3::revFlow(n, _, _, any(AccessPathFrontHead apf | apf.headUsesContent(tc)), config)
        or
        flowCandSummaryCtx(n, any(AccessPathFrontHead apf | apf.headUsesContent(tc)), config)
      ) and
    accessPathApproxCostLimits(apLimit, tupleLimit) and
    apLimit < tails and
    tupleLimit < (tails - 1) * nodes
  )
}

private newtype TAccessPathApprox =
  TNil(DataFlowType t) or
  TConsNil(TypedContent tc, DataFlowType t) {
    Stage3::revFlowConsCand(tc, TFrontNil(t), _) and
    not expensiveLen2unfolding(tc, _)
  } or
  TConsCons(TypedContent tc1, TypedContent tc2, int len) {
    Stage3::revFlowConsCand(tc1, TFrontHead(tc2), _) and
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
      exists(TypedContent tc2 | Stage3::revFlowConsCand(tc, TFrontHead(tc2), _) |
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
        Stage3::revFlowConsCand(tc, TFrontNil(t), _) and
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
  class ApApprox = Stage3::Ap;

  class Ap = AccessPathApprox;

  class ApNil = AccessPathApproxNil;

  class ApOption = AccessPathApproxOption;

  ApOption apNone() { result = TAccessPathApproxNone() }

  ApOption apSome(Ap ap) { result = TAccessPathApproxSome(ap) }

  class Cc = CallContext;

  /* Begin: Stage 4 logic. */
  /**
   * Holds if `node` is reachable with approximate access path `ap` from a source
   * in the configuration `config`.
   *
   * The call context `cc` records whether the node is reached through an
   * argument in a call, and if so, `argAp` records the approximate access path
   * of that argument.
   */
  predicate fwdFlow(Node node, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    fwdFlow0(node, cc, argAp, ap, config) and
    Stage3::revFlow(node, _, _, ap.getFront(), config)
  }

  private predicate fwdFlow0(Node node, Cc cc, ApOption argAp, Ap ap, Configuration config) {
    Stage3::revFlow(node, _, _, _, config) and
    config.isSource(node) and
    cc instanceof CallContextAny and
    argAp = apNone() and
    ap = TNil(getNodeType(node))
    or
    Stage3::revFlow(node, _, _, _, unbind(config)) and
    (
      exists(Node mid, LocalCallContext localCC |
        fwdFlowLocalEntry(mid, cc, argAp, ap, localCC, config) and
        localFlowBigStep(mid, node, true, _, config, localCC)
      )
      or
      exists(Node mid, ApNil nil, LocalCallContext localCC, AccessPathFront apf |
        fwdFlowLocalEntry(mid, cc, argAp, nil, localCC, config) and
        localFlowBigStep(mid, node, false, apf, config, localCC) and
        apf = ap.(ApNil).getFront()
      )
      or
      exists(Node mid |
        fwdFlow(mid, _, _, ap, config) and
        jumpStep(mid, node, config) and
        cc instanceof CallContextAny and
        argAp = apNone()
      )
      or
      exists(Node mid, ApNil nil |
        fwdFlow(mid, _, _, nil, config) and
        additionalJumpStep(mid, node, config) and
        cc instanceof CallContextAny and
        argAp = apNone() and
        ap = TNil(getNodeType(node))
      )
    )
    or
    // store
    exists(TypedContent tc | fwdFlowStore(node, tc, pop(tc, ap), cc, argAp, config))
    or
    // read
    exists(TypedContent tc, AccessPathFront apf |
      fwdFlowRead(node, push(tc, ap), apf, cc, argAp, config) and
      fwdFlowConsCand(tc, apf, ap, config)
    )
    or
    // flow into a callable
    exists(ApApprox apa |
      fwdFlowIn(_, node, _, cc, _, ap, config) and
      apa = ap.getFront() and
      if Stage3::revFlow(node, true, _, apa, config) then argAp = apSome(ap) else argAp = apNone()
    )
    or
    // flow out of a callable
    exists(DataFlowCall call |
      exists(DataFlowCallable c |
        fwdFlowOut(call, node, any(CallContextNoCall innercc), c, argAp, ap, config) and
        if reducedViableImplInReturn(c, call) then cc = TReturn(c, call) else cc = TAnyCallContext()
      )
      or
      exists(Ap argAp0 |
        fwdFlowOutFromArg(call, node, argAp0, ap, config) and
        fwdFlowIsEntered(call, cc, argAp, argAp0, config)
      )
    )
  }

  pragma[nomagic]
  private predicate fwdFlowLocalEntry(
    Node node, Cc cc, ApOption argAp, Ap ap, LocalCallContext localCC, Configuration config
  ) {
    fwdFlow(node, cc, argAp, ap, config) and
    localFlowEntry(node, config) and
    localCC = getLocalCallContext(cc, node.getEnclosingCallable())
  }

  pragma[nomagic]
  private predicate fwdFlowStore(
    Node node, TypedContent tc, Ap ap0, Cc cc, ApOption argAp, Configuration config
  ) {
    exists(Node mid |
      fwdFlow(mid, cc, argAp, ap0, config) and
      fwdFlowStore0(mid, tc, node, ap0.getFront(), config)
    )
  }

  pragma[nomagic]
  private predicate storeCand(
    Node mid, TypedContent tc, Node node, AccessPathFront apf0, AccessPathFront apf,
    Configuration config
  ) {
    storeCand2(mid, tc, node, _, config) and
    Stage3::revFlow(mid, _, _, apf0, config) and
    apf.headUsesContent(tc)
  }

  pragma[noinline]
  private predicate fwdFlowStore0(
    Node mid, TypedContent tc, Node node, AccessPathFront apf0, Configuration config
  ) {
    exists(AccessPathFront apf |
      storeCand(mid, tc, node, apf0, apf, config) and
      Stage3::revFlowConsCand(tc, apf0, config) and
      Stage3::revFlow(node, _, _, apf, unbind(config))
    )
  }

  pragma[nomagic]
  private predicate fwdFlowRead0(
    Node node1, TypedContent tc, Ap ap0, Node node2, Cc cc, ApOption argAp, Configuration config
  ) {
    fwdFlow(node1, cc, argAp, ap0, config) and
    Stage3::readCandFwd(node1, tc, ap0.getFront(), node2, config)
  }

  pragma[nomagic]
  private predicate fwdFlowRead(
    Node node, Ap ap0, AccessPathFront apf, Cc cc, ApOption argAp, Configuration config
  ) {
    exists(Node mid, TypedContent tc |
      fwdFlowRead0(mid, tc, ap0, node, cc, argAp, config) and
      Stage3::revFlow(node, _, _, apf, unbind(config)) and
      Stage3::revFlowConsCand(tc, apf, unbind(config))
    )
  }

  pragma[nomagic]
  private predicate fwdFlowConsCand(
    TypedContent tc, AccessPathFront apf, Ap ap, Configuration config
  ) {
    exists(Node n |
      fwdFlow(n, _, _, ap, config) and
      apf = ap.getFront() and
      fwdFlowStore0(n, tc, _, apf, config)
    )
  }

  pragma[nomagic]
  private predicate fwdFlowIn(
    DataFlowCall call, ParameterNode p, Cc outercc, Cc innercc, ApOption argAp, Ap ap,
    Configuration config
  ) {
    exists(ArgumentNode arg, boolean allowsFieldFlow, DataFlowCallable c |
      fwdFlow(arg, outercc, argAp, ap, config) and
      flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config) and
      c = p.getEnclosingCallable() and
      c = resolveCall(call, outercc) and
      Stage3::revFlow(p, _, _, _, unbind(config)) and
      if recordDataFlowCallSite(call, c)
      then innercc = TSpecificCall(call)
      else innercc = TSomeCall()
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOut(
    DataFlowCall call, Node node, Cc innercc, DataFlowCallable innerc, ApOption argAp, Ap ap,
    Configuration config
  ) {
    exists(ReturnNodeExt ret, boolean allowsFieldFlow |
      fwdFlow(ret, innercc, argAp, ap, config) and
      flowOutOfCallNodeCand2(call, ret, node, allowsFieldFlow, config) and
      innerc = ret.getEnclosingCallable() and
      Stage3::revFlow(node, _, _, _, unbind(config)) and
      (
        resolveReturn(innercc, innerc, call)
        or
        innercc.(CallContextCall).matchesCall(call)
      )
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate fwdFlowOutFromArg(
    DataFlowCall call, Node node, Ap argAp, Ap ap, Configuration config
  ) {
    fwdFlowOut(call, node, any(CallContextCall ccc), _, apSome(argAp), ap, config)
  }

  /**
   * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
   */
  pragma[nomagic]
  private predicate fwdFlowIsEntered(
    DataFlowCall call, Cc cc, ApOption argAp, Ap ap, Configuration config
  ) {
    exists(ParameterNode p |
      fwdFlowIn(call, p, cc, _, argAp, ap, config) and
      Stage3::revFlow(p, true, TAccessPathFrontSome(_), ap.getFront(), config)
    )
  }

  /**
   * Holds if `node` with approximate access path `ap` is part of a path from a
   * source to a sink in the configuration `config`.
   *
   * The Boolean `toReturn` records whether the node must be returned from
   * the enclosing callable in order to reach a sink, and if so, `returnAp`
   * records the approximate access path of the returned value.
   */
  predicate revFlow(Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config) {
    revFlow0(node, toReturn, returnAp, ap, config) and
    fwdFlow(node, _, _, ap, config)
  }

  private predicate revFlow0(
    Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    fwdFlow(node, _, _, ap, config) and
    config.isSink(node) and
    toReturn = false and
    returnAp = apNone() and
    ap instanceof ApNil
    or
    exists(Node mid |
      localFlowBigStep(node, mid, true, _, config, _) and
      revFlow(mid, toReturn, returnAp, ap, config)
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(node, _, _, ap, config) and
      localFlowBigStep(node, mid, false, _, config, _) and
      revFlow(mid, toReturn, returnAp, nil, config) and
      ap instanceof ApNil
    )
    or
    exists(Node mid |
      jumpStep(node, mid, config) and
      revFlow(mid, _, _, ap, config) and
      toReturn = false and
      returnAp = apNone()
    )
    or
    exists(Node mid, ApNil nil |
      fwdFlow(node, _, _, ap, config) and
      additionalJumpStep(node, mid, config) and
      revFlow(mid, _, _, nil, config) and
      toReturn = false and
      returnAp = apNone() and
      ap instanceof ApNil
    )
    or
    // store
    exists(TypedContent tc |
      revFlowStore(tc, node, toReturn, returnAp, ap, config) and
      revFlowConsCand(tc, ap, config)
    )
    or
    // read
    exists(Node mid, Ap ap0 |
      readFlowFwd(node, _, mid, ap, ap0, config) and
      revFlow(mid, toReturn, returnAp, ap0, config)
    )
    or
    // flow into a callable
    exists(DataFlowCall call |
      revFlowIn(call, node, toReturn, returnAp, ap, config) and
      toReturn = false
      or
      exists(Ap returnApa0 |
        revFlowInToReturn(call, node, returnApa0, ap, config) and
        revFlowIsReturned(call, toReturn, returnAp, returnApa0, config)
      )
    )
    or
    // flow out of a callable
    revFlowOut(_, node, _, _, ap, config) and
    toReturn = true and
    if fwdFlow(node, any(CallContextCall ccc), apSome(_), ap, config)
    then returnAp = apSome(ap)
    else returnAp = apNone()
  }

  pragma[nomagic]
  private predicate storeFlowFwd(
    Node node1, TypedContent tc, Node node2, Ap ap, Ap ap0, Configuration config
  ) {
    storeCand2(node1, tc, node2, _, config) and
    fwdFlowStore(node2, tc, ap, _, _, config) and
    ap0 = push(tc, ap)
  }

  pragma[nomagic]
  private predicate revFlowStore(
    TypedContent tc, Node node, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(Node mid, Ap ap0 |
      storeFlowFwd(node, tc, mid, ap, ap0, config) and
      revFlow(mid, toReturn, returnAp, ap0, config)
    )
  }

  pragma[nomagic]
  private predicate readFlowFwd(
    Node node1, TypedContent tc, Node node2, Ap ap, Ap ap0, Configuration config
  ) {
    exists(AccessPathFrontHead apf |
      Stage3::readCandFwd(node1, tc, apf, node2, config) and
      apf = ap.getFront() and
      fwdFlowRead(node2, ap, _, _, _, config) and
      ap0 = pop(tc, ap) and
      fwdFlowConsCand(tc, _, ap0, unbind(config))
    )
  }

  pragma[nomagic]
  predicate revFlowConsCand(TypedContent tc, Ap ap, Configuration config) {
    exists(Node n, Node mid |
      revFlow(mid, _, _, ap, config) and
      readFlowFwd(n, tc, mid, _, ap, config)
    )
  }

  pragma[nomagic]
  private predicate revFlowOut(
    DataFlowCall call, ReturnNodeExt ret, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(Node out, boolean allowsFieldFlow |
      revFlow(out, toReturn, returnAp, ap, config) and
      flowOutOfCallNodeCand2(call, ret, out, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate revFlowIn(
    DataFlowCall call, ArgumentNode arg, boolean toReturn, ApOption returnAp, Ap ap,
    Configuration config
  ) {
    exists(ParameterNode p, boolean allowsFieldFlow |
      revFlow(p, toReturn, returnAp, ap, config) and
      flowIntoCallNodeCand2(call, arg, p, allowsFieldFlow, config)
    |
      ap instanceof ApNil or allowsFieldFlow = true
    )
  }

  pragma[nomagic]
  private predicate revFlowInToReturn(
    DataFlowCall call, ArgumentNode arg, Ap returnAp, Ap ap, Configuration config
  ) {
    revFlowIn(call, arg, true, apSome(returnAp), ap, config)
  }

  /**
   * Holds if an output from `call` is reached in the flow covered by `revFlow`.
   */
  pragma[nomagic]
  private predicate revFlowIsReturned(
    DataFlowCall call, boolean toReturn, ApOption returnAp, Ap ap, Configuration config
  ) {
    exists(ReturnNodeExt ret, CallContextCall ccc |
      revFlowOut(call, ret, toReturn, returnAp, ap, config) and
      fwdFlow(ret, ccc, apSome(_), ap, config) and
      ccc.matchesCall(call)
    )
  }

  predicate revFlow(Node n, Configuration config) { revFlow(n, _, _, _, config) }
  /* End: Stage 4 logic. */
}

bindingset[conf, result]
private Configuration unbind(Configuration conf) { result >= conf and result <= conf }

pragma[noinline]
private predicate parameterFlow(
  ParameterNode p, AccessPathApprox apa, AccessPathApprox apa0, DataFlowCallable c,
  Configuration config
) {
  Stage4::revFlow(p, true, TAccessPathApproxSome(apa0), apa, config) and
  c = p.getEnclosingCallable()
}

private predicate parameterMayFlowThrough(ParameterNode p, DataFlowCallable c, AccessPathApprox apa) {
  exists(ReturnNodeExt ret, Configuration config, AccessPathApprox apa0 |
    parameterFlow(p, apa, apa0, c, config) and
    c = ret.getEnclosingCallable() and
    Stage4::revFlow(ret, true, TAccessPathApproxSome(_), apa0, config) and
    Stage4::fwdFlow(ret, any(CallContextCall ccc), TAccessPathApproxSome(apa), apa0, config)
  )
}

private predicate nodeMayUseSummary(Node n, AccessPathApprox apa, Configuration config) {
  exists(DataFlowCallable c, AccessPathApprox apa0 |
    parameterMayFlowThrough(_, c, apa) and
    Stage4::revFlow(n, true, _, apa0, config) and
    Stage4::fwdFlow(n, any(CallContextCall ccc), TAccessPathApproxSome(apa), apa0, config) and
    n.getEnclosingCallable() = c
  )
}

private newtype TSummaryCtx =
  TSummaryCtxNone() or
  TSummaryCtxSome(ParameterNode p, AccessPath ap) { parameterMayFlowThrough(p, _, ap.getApprox()) }

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

/**
 * Gets the number of length 2 access path approximations that correspond to `apa`.
 */
private int count1to2unfold(AccessPathApproxCons1 apa, Configuration config) {
  exists(TypedContent tc, int len |
    tc = apa.getHead() and
    len = apa.len() and
    result =
      strictcount(AccessPathFront apf |
        Stage4::revFlowConsCand(tc,
          any(AccessPathApprox ap | ap.getFront() = apf and ap.len() = len - 1), config)
      )
  )
}

private int countNodesUsingAccessPath(AccessPathApprox apa, Configuration config) {
  result =
    strictcount(Node n | Stage4::revFlow(n, _, _, apa, config) or nodeMayUseSummary(n, apa, config))
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
    Stage4::revFlowConsCand(head, result, config)
  )
}

/**
 * Holds with `unfold = false` if a precise head-tail representation of `apa` is
 * expected to be expensive. Holds with `unfold = true` otherwise.
 */
private predicate evalUnfold(AccessPathApprox apa, boolean unfold, Configuration config) {
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
  TPathNodeMid(Node node, CallContext cc, SummaryCtx sc, AccessPath ap, Configuration config) {
    // A PathNode is introduced by a source ...
    Stage4::revFlow(node, config) and
    config.isSource(node) and
    cc instanceof CallContextAny and
    sc instanceof SummaryCtxNone and
    ap = TAccessPathNil(getNodeType(node))
    or
    // ... or a step from an existing PathNode to another node.
    exists(PathNodeMid mid |
      pathStep(mid, node, cc, sc, ap) and
      config = mid.getConfiguration() and
      Stage4::revFlow(node, _, _, ap.getApprox(), unbind(config))
    )
  } or
  TPathNodeSink(Node node, Configuration config) {
    config.isSink(node) and
    Stage4::revFlow(node, unbind(config)) and
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
    result = "[" + this.toStringImpl(true) + length().toString() + ")]"
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
    Stage4::revFlowConsCand(head1, result.getApprox(), _) and
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
    Stage4::revFlowConsCand(head, result.getApprox(), _) and result.length() = len - 1
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
  Stage3::readCandFwd(node1, tc, _, node2, config) and
  Stage4::revFlow(node2, config)
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
  Stage4::revFlow(node2, config)
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
  Stage4::revFlow(result, _, _, apa, config)
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
    Stage4::revFlow(p, _, _, apa, config) and
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

  private predicate interestingCallableSink(DataFlowCallable c, Configuration config) {
    exists(Node n | config.isSink(n) and c = n.getEnclosingCallable())
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
      ce1 = TCallable(c1, config) and
      ce2 = TCallable(c2, unbind(config))
    )
    or
    exists(Node n, Configuration config |
      ce1 = TCallableSrc() and
      config.isSource(n) and
      ce2 = TCallable(n.getEnclosingCallable(), config)
    )
    or
    exists(Node n, Configuration config |
      ce2 = TCallableSink() and
      config.isSink(n) and
      ce1 = TCallable(n.getEnclosingCallable(), config)
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

  private newtype TSummaryCtx1 =
    TSummaryCtx1None() or
    TSummaryCtx1Param(ParameterNode p)

  private newtype TSummaryCtx2 =
    TSummaryCtx2None() or
    TSummaryCtx2Some(PartialAccessPath ap)

  private newtype TRevSummaryCtx1 =
    TRevSummaryCtx1None() or
    TRevSummaryCtx1Some(ReturnPosition pos)

  private newtype TRevSummaryCtx2 =
    TRevSummaryCtx2None() or
    TRevSummaryCtx2Some(RevPartialAccessPath ap)

  private newtype TPartialPathNode =
    TPartialPathNodeFwd(
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
    } or
    TPartialPathNodeRev(
      Node node, TRevSummaryCtx1 sc1, TRevSummaryCtx2 sc2, RevPartialAccessPath ap,
      Configuration config
    ) {
      config.isSink(node) and
      sc1 = TRevSummaryCtx1None() and
      sc2 = TRevSummaryCtx2None() and
      ap = TRevPartialNil() and
      not fullBarrier(node, config) and
      exists(config.explorationLimit())
      or
      exists(PartialPathNodeRev mid |
        revPartialPathStep(mid, node, sc1, sc2, ap, config) and
        not fullBarrier(node, config) and
        distSink(node.getEnclosingCallable(), config) <= config.explorationLimit()
      )
    }

  pragma[nomagic]
  private predicate partialPathNodeMk0(
    Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, PartialAccessPath ap,
    Configuration config
  ) {
    exists(PartialPathNodeFwd mid |
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

    /**
     * Gets the approximate distance to the nearest sink measured in number
     * of interprocedural steps.
     */
    int getSinkDistance() {
      result = distSink(this.getNode().getEnclosingCallable(), this.getConfiguration())
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
    Node node;
    CallContext cc;
    TSummaryCtx1 sc1;
    TSummaryCtx2 sc2;
    PartialAccessPath ap;
    Configuration config;

    PartialPathNodeFwd() { this = TPartialPathNodeFwd(node, cc, sc1, sc2, ap, config) }

    override Node getNode() { result = node }

    CallContext getCallContext() { result = cc }

    TSummaryCtx1 getSummaryCtx1() { result = sc1 }

    TSummaryCtx2 getSummaryCtx2() { result = sc2 }

    PartialAccessPath getAp() { result = ap }

    override Configuration getConfiguration() { result = config }

    override PartialPathNodeFwd getASuccessor() {
      partialPathStep(this, result.getNode(), result.getCallContext(), result.getSummaryCtx1(),
        result.getSummaryCtx2(), result.getAp(), result.getConfiguration())
    }

    predicate isSource() {
      config.isSource(node) and
      cc instanceof CallContextAny and
      sc1 = TSummaryCtx1None() and
      sc2 = TSummaryCtx2None() and
      ap instanceof TPartialNil
    }
  }

  private class PartialPathNodeRev extends PartialPathNode, TPartialPathNodeRev {
    Node node;
    TRevSummaryCtx1 sc1;
    TRevSummaryCtx2 sc2;
    RevPartialAccessPath ap;
    Configuration config;

    PartialPathNodeRev() { this = TPartialPathNodeRev(node, sc1, sc2, ap, config) }

    override Node getNode() { result = node }

    TRevSummaryCtx1 getSummaryCtx1() { result = sc1 }

    TRevSummaryCtx2 getSummaryCtx2() { result = sc2 }

    RevPartialAccessPath getAp() { result = ap }

    override Configuration getConfiguration() { result = config }

    override PartialPathNodeRev getASuccessor() {
      revPartialPathStep(result, this.getNode(), this.getSummaryCtx1(), this.getSummaryCtx2(),
        this.getAp(), this.getConfiguration())
    }

    predicate isSink() {
      config.isSink(node) and
      sc1 = TRevSummaryCtx1None() and
      sc2 = TRevSummaryCtx2None() and
      ap = TRevPartialNil()
    }
  }

  private predicate partialPathStep(
    PartialPathNodeFwd mid, Node node, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
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
    PartialPathNodeFwd mid, PartialAccessPath ap1, TypedContent tc, Node node, PartialAccessPath ap2
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
    exists(PartialPathNodeFwd mid |
      partialPathStoreStep(mid, ap1, tc, _, ap2) and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate partialPathReadStep(
    PartialPathNodeFwd mid, PartialAccessPath ap, TypedContent tc, Node node, CallContext cc,
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
    PartialPathNodeFwd mid, ReturnPosition pos, CallContext innercc, PartialAccessPath ap,
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
    PartialPathNodeFwd mid, DataFlowCall call, ReturnKindExt kind, CallContext cc,
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
    PartialPathNodeFwd mid, Node out, CallContext cc, PartialAccessPath ap, Configuration config
  ) {
    exists(ReturnKindExt kind, DataFlowCall call |
      partialPathOutOfCallable1(mid, call, kind, cc, ap, config)
    |
      out = kind.getAnOutNode(call)
    )
  }

  pragma[noinline]
  private predicate partialPathIntoArg(
    PartialPathNodeFwd mid, int i, CallContext cc, DataFlowCall call, PartialAccessPath ap,
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
    PartialPathNodeFwd mid, DataFlowCallable callable, int i, CallContext outercc,
    DataFlowCall call, PartialAccessPath ap, Configuration config
  ) {
    partialPathIntoArg(mid, i, outercc, call, ap, config) and
    callable = resolveCall(call, outercc)
  }

  private predicate partialPathIntoCallable(
    PartialPathNodeFwd mid, ParameterNode p, CallContext outercc, CallContextCall innercc,
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
    exists(PartialPathNodeFwd mid, ReturnNodeExt ret |
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
    DataFlowCall call, PartialPathNodeFwd mid, ReturnKindExt kind, CallContext cc,
    PartialAccessPath ap, Configuration config
  ) {
    exists(ParameterNode p, CallContext innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2 |
      partialPathIntoCallable(mid, p, cc, innercc, sc1, sc2, call, _, config) and
      paramFlowsThroughInPartialPath(kind, innercc, sc1, sc2, ap, config)
    )
  }

  private predicate partialPathThroughCallable(
    PartialPathNodeFwd mid, Node out, CallContext cc, PartialAccessPath ap, Configuration config
  ) {
    exists(DataFlowCall call, ReturnKindExt kind |
      partialPathThroughCallable0(call, mid, kind, cc, ap, config) and
      out = kind.getAnOutNode(call)
    )
  }

  private predicate revPartialPathStep(
    PartialPathNodeRev mid, Node node, TRevSummaryCtx1 sc1, TRevSummaryCtx2 sc2,
    RevPartialAccessPath ap, Configuration config
  ) {
    localFlowStep(node, mid.getNode(), config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    ap = mid.getAp() and
    config = mid.getConfiguration()
    or
    additionalLocalFlowStep(node, mid.getNode(), config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    mid.getAp() instanceof RevPartialAccessPathNil and
    ap = TRevPartialNil() and
    config = mid.getConfiguration()
    or
    jumpStep(node, mid.getNode(), config) and
    sc1 = TRevSummaryCtx1None() and
    sc2 = TRevSummaryCtx2None() and
    ap = mid.getAp() and
    config = mid.getConfiguration()
    or
    additionalJumpStep(node, mid.getNode(), config) and
    sc1 = TRevSummaryCtx1None() and
    sc2 = TRevSummaryCtx2None() and
    mid.getAp() instanceof RevPartialAccessPathNil and
    ap = TRevPartialNil() and
    config = mid.getConfiguration()
    or
    revPartialPathReadStep(mid, _, _, node, ap) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2() and
    config = mid.getConfiguration()
    or
    exists(RevPartialAccessPath ap0, Content c |
      revPartialPathStoreStep(mid, ap0, c, node, config) and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      apConsRev(ap, c, ap0, config)
    )
    or
    exists(ParameterNode p |
      mid.getNode() = p and
      viableParamArg(_, p, node) and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      sc1 = TRevSummaryCtx1None() and
      sc2 = TRevSummaryCtx2None() and
      ap = mid.getAp() and
      config = mid.getConfiguration()
    )
    or
    exists(ReturnPosition pos |
      revPartialPathIntoReturn(mid, pos, sc1, sc2, _, ap, config) and
      pos = getReturnPosition(node)
    )
    or
    revPartialPathThroughCallable(mid, node, ap, config) and
    sc1 = mid.getSummaryCtx1() and
    sc2 = mid.getSummaryCtx2()
  }

  pragma[inline]
  private predicate revPartialPathReadStep(
    PartialPathNodeRev mid, RevPartialAccessPath ap1, Content c, Node node, RevPartialAccessPath ap2
  ) {
    exists(Node midNode |
      midNode = mid.getNode() and
      ap1 = mid.getAp() and
      read(node, c, midNode) and
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
    PartialPathNodeRev mid, RevPartialAccessPath ap, Content c, Node node, Configuration config
  ) {
    exists(Node midNode, TypedContent tc |
      midNode = mid.getNode() and
      ap = mid.getAp() and
      store(node, tc, midNode, _) and
      ap.getHead() = c and
      config = mid.getConfiguration() and
      tc.getContent() = c
    )
  }

  pragma[nomagic]
  private predicate revPartialPathIntoReturn(
    PartialPathNodeRev mid, ReturnPosition pos, TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2,
    DataFlowCall call, RevPartialAccessPath ap, Configuration config
  ) {
    exists(Node out |
      mid.getNode() = out and
      viableReturnPosOut(call, pos, out) and
      sc1 = TRevSummaryCtx1Some(pos) and
      sc2 = TRevSummaryCtx2Some(ap) and
      ap = mid.getAp() and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate revPartialPathFlowsThrough(
    int pos, TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2, RevPartialAccessPath ap,
    Configuration config
  ) {
    exists(PartialPathNodeRev mid, ParameterNode p |
      mid.getNode() = p and
      p.isParameterOf(_, pos) and
      sc1 = mid.getSummaryCtx1() and
      sc2 = mid.getSummaryCtx2() and
      ap = mid.getAp() and
      config = mid.getConfiguration()
    )
  }

  pragma[nomagic]
  private predicate revPartialPathThroughCallable0(
    DataFlowCall call, PartialPathNodeRev mid, int pos, RevPartialAccessPath ap,
    Configuration config
  ) {
    exists(TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2 |
      revPartialPathIntoReturn(mid, _, sc1, sc2, call, _, config) and
      revPartialPathFlowsThrough(pos, sc1, sc2, ap, config)
    )
  }

  pragma[nomagic]
  private predicate revPartialPathThroughCallable(
    PartialPathNodeRev mid, ArgumentNode node, RevPartialAccessPath ap, Configuration config
  ) {
    exists(DataFlowCall call, int pos |
      revPartialPathThroughCallable0(call, mid, pos, ap, config) and
      node.argumentOf(call, pos)
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
