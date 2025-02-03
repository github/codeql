/**
 * INTERNAL: Do not use.
 *
 * Provides an implementation of global (interprocedural) data flow.
 */

private import codeql.util.Unit
private import codeql.util.Option
private import codeql.util.Boolean
private import codeql.util.Location
private import codeql.dataflow.DataFlow

module MakeImpl<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import DataFlowMake<Location, Lang>
  private import DataFlowImplCommon::MakeImplCommon<Location, Lang>
  private import DataFlowImplCommonPublic

  /**
   * An input configuration for data flow using flow state. This signature equals
   * `StateConfigSig`, but requires explicit implementation of all predicates.
   */
  signature module FullStateConfigSig {
    bindingset[this]
    class FlowState;

    /**
     * Holds if `source` is a relevant data flow source with the given initial
     * `state`.
     */
    predicate isSource(Node source, FlowState state);

    /**
     * Holds if `sink` is a relevant data flow sink accepting `state`.
     */
    predicate isSink(Node sink, FlowState state);

    /**
     * Holds if `sink` is a relevant data flow sink for any state.
     */
    predicate isSink(Node sink);

    /**
     * Holds if data flow through `node` is prohibited. This completely removes
     * `node` from the data flow graph.
     */
    predicate isBarrier(Node node);

    /**
     * Holds if data flow through `node` is prohibited when the flow state is
     * `state`.
     */
    predicate isBarrier(Node node, FlowState state);

    /** Holds if data flow into `node` is prohibited. */
    predicate isBarrierIn(Node node);

    /** Holds if data flow into `node` is prohibited when the target flow state is `state`. */
    predicate isBarrierIn(Node node, FlowState state);

    /** Holds if data flow out of `node` is prohibited. */
    predicate isBarrierOut(Node node);

    /** Holds if data flow out of `node` is prohibited when the originating flow state is `state`. */
    predicate isBarrierOut(Node node, FlowState state);

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    predicate isAdditionalFlowStep(Node node1, Node node2, string model);

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    predicate isAdditionalFlowStep(
      Node node1, FlowState state1, Node node2, FlowState state2, string model
    );

    /**
     * Holds if an arbitrary number of implicit read steps of content `c` may be
     * taken at `node`.
     */
    predicate allowImplicitRead(Node node, ContentSet c);

    /**
     * Holds if `node` should never be skipped over in the `PathGraph` and in path
     * explanations.
     */
    predicate neverSkip(Node node);

    /**
     * Gets the virtual dispatch branching limit when calculating field flow.
     * This can be overridden to a smaller value to improve performance (a
     * value of 0 disables field flow), or a larger value to get more results.
     */
    int fieldFlowBranchLimit();

    /** Gets the access path limit. */
    int accessPathLimit();

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
     *
     * These features are generally not relevant for typical end-to-end data flow
     * queries, but should only be used for constructing paths that need to
     * somehow be pluggable in another path context.
     */
    FlowFeature getAFeature();

    /**
     * Holds if hidden nodes should be included in the data flow graph.
     *
     * This feature should only be used for debugging or when the data flow graph
     * is not visualized (as it is in a `path-problem` query).
     */
    predicate includeHiddenNodes();

    /**
     * Holds if sources and sinks should be filtered to only include those that
     * may lead to a flow path with either a source or a sink in the location
     * range given by `AlertFiltering`. This only has an effect when running
     * in diff-informed incremental mode.
     *
     * This flag should only be applied to flow configurations whose results
     * are used directly in a query result.
     */
    predicate observeDiffInformedIncrementalMode();

    Location getASelectedSourceLocation(Node source);

    Location getASelectedSinkLocation(Node sink);
  }

  /**
   * Provides default `FlowState` implementations given a `StateConfigSig`.
   */
  module DefaultState<ConfigSig Config> {
    class FlowState = Unit;

    predicate isSource(Node source, FlowState state) { Config::isSource(source) and exists(state) }

    predicate isSink(Node sink, FlowState state) { Config::isSink(sink) and exists(state) }

    predicate isBarrier(Node node, FlowState state) { none() }

    predicate isBarrierIn(Node node, FlowState state) { none() }

    predicate isBarrierOut(Node node, FlowState state) { none() }

    predicate isAdditionalFlowStep(
      Node node1, FlowState state1, Node node2, FlowState state2, string model
    ) {
      none()
    }
  }

  /**
   * Constructs a data flow computation given a full input configuration.
   */
  module Impl<FullStateConfigSig Config> {
    private class FlowState = Config::FlowState;

    private module SourceSinkFiltering {
      private import codeql.util.AlertFiltering

      private module AlertFiltering = AlertFilteringImpl<Location>;

      pragma[nomagic]
      private predicate isFilteredSource(Node source) {
        Config::isSource(source, _) and
        if Config::observeDiffInformedIncrementalMode()
        then AlertFiltering::filterByLocation(Config::getASelectedSourceLocation(source))
        else any()
      }

      pragma[nomagic]
      private predicate isFilteredSink(Node sink) {
        (
          Config::isSink(sink, _) or
          Config::isSink(sink)
        ) and
        if Config::observeDiffInformedIncrementalMode()
        then AlertFiltering::filterByLocation(Config::getASelectedSinkLocation(sink))
        else any()
      }

      private predicate hasFilteredSource() { isFilteredSource(_) }

      private predicate hasFilteredSink() { isFilteredSink(_) }

      predicate isRelevantSource(Node source, FlowState state) {
        // If there are filtered sinks, we need to pass through all sources to preserve all alerts
        // with filtered sinks. Otherwise the only alerts of interest are those with filtered
        // sources, so we can perform the source filtering right here.
        Config::isSource(source, state) and
        (
          isFilteredSource(source) or
          hasFilteredSink()
        )
      }

      predicate isRelevantSink(Node sink, FlowState state) {
        // If there are filtered sources, we need to pass through all sinks to preserve all alerts
        // with filtered sources. Otherwise the only alerts of interest are those with filtered
        // sinks, so we can perform the sink filtering right here.
        Config::isSink(sink, state) and
        (
          isFilteredSink(sink) or
          hasFilteredSource()
        )
      }

      predicate isRelevantSink(Node sink) {
        // If there are filtered sources, we need to pass through all sinks to preserve all alerts
        // with filtered sources. Otherwise the only alerts of interest are those with filtered
        // sinks, so we can perform the sink filtering right here.
        Config::isSink(sink) and
        (
          isFilteredSink(sink) or
          hasFilteredSource()
        )
      }

      bindingset[source, sink]
      pragma[inline_late]
      predicate isRelevantSourceSinkPair(Node source, Node sink) {
        isFilteredSource(source) or
        isFilteredSink(sink)
      }
    }

    private import SourceSinkFiltering

    private predicate inBarrier(NodeEx node) {
      exists(Node n |
        node.asNode() = n and
        Config::isBarrierIn(n) and
        isRelevantSource(n, _)
      )
    }

    pragma[nomagic]
    private predicate inBarrier(NodeEx node, FlowState state) {
      exists(Node n |
        node.asNode() = n and
        Config::isBarrierIn(n, state) and
        isRelevantSource(n, state)
      )
    }

    private predicate outBarrier(NodeEx node) {
      exists(Node n |
        node.asNodeOrImplicitRead() = n and
        Config::isBarrierOut(n)
      |
        isRelevantSink(n, _)
        or
        isRelevantSink(n)
      )
    }

    pragma[nomagic]
    private predicate outBarrier(NodeEx node, FlowState state) {
      exists(Node n |
        node.asNodeOrImplicitRead() = n and
        Config::isBarrierOut(n, state)
      |
        isRelevantSink(n, state)
        or
        isRelevantSink(n)
      )
    }

    pragma[nomagic]
    private predicate fullBarrier(NodeEx node) {
      exists(Node n | node.asNode() = n |
        Config::isBarrier(n)
        or
        Config::isBarrierIn(n) and
        not isRelevantSource(n, _)
        or
        Config::isBarrierOut(n) and
        not isRelevantSink(n, _) and
        not isRelevantSink(n)
      )
    }

    pragma[nomagic]
    private predicate stateBarrier(NodeEx node, FlowState state) {
      exists(Node n | node.asNode() = n |
        Config::isBarrier(n, state)
        or
        Config::isBarrierIn(n, state) and
        not isRelevantSource(n, state)
        or
        Config::isBarrierOut(n, state) and
        not isRelevantSink(n, state) and
        not isRelevantSink(n)
      )
    }

    pragma[nomagic]
    private predicate sourceNode(NodeEx node, FlowState state) {
      isRelevantSource(node.asNode(), state) and
      not fullBarrier(node) and
      not stateBarrier(node, state)
    }

    pragma[nomagic]
    private predicate sinkNodeWithState(NodeEx node, FlowState state) {
      isRelevantSink(node.asNodeOrImplicitRead(), state) and
      not fullBarrier(node) and
      not stateBarrier(node, state)
    }

    /** Provides the relevant barriers for a step from `node1` to `node2`. */
    bindingset[node1, node2]
    private predicate stepFilter(NodeEx node1, NodeEx node2) {
      not outBarrier(node1) and
      not inBarrier(node2) and
      not fullBarrier(node1) and
      not fullBarrier(node2)
    }

    /** Provides the relevant barriers for a step from `node1,state1` to `node2,state2`, including stateless barriers for `node1` to `node2`. */
    bindingset[node1, state1, node2, state2]
    private predicate stateStepFilter(NodeEx node1, FlowState state1, NodeEx node2, FlowState state2) {
      stepFilter(node1, node2) and
      not outBarrier(node1, state1) and
      not inBarrier(node2, state2) and
      not stateBarrier(node1, state1) and
      not stateBarrier(node2, state2)
    }

    bindingset[n, cc]
    pragma[inline_late]
    private predicate isUnreachableInCall1(NodeEx n, LocalCallContextSpecificCall cc) {
      cc.unreachable(n)
    }

    /**
     * Holds if data can flow in one local step from `node1` to `node2`.
     */
    private predicate localFlowStepEx(NodeEx node1, NodeEx node2, string model) {
      localFlowStepExImpl(node1, node2, model) and
      stepFilter(node1, node2)
    }

    /**
     * Holds if the additional step from `node1` to `node2` does not jump between callables.
     */
    private predicate additionalLocalFlowStep(NodeEx node1, NodeEx node2, string model) {
      exists(Node n1, Node n2 |
        node1.asNodeOrImplicitRead() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), pragma[only_bind_into](n2), model) and
        getNodeEnclosingCallable(n1) = getNodeEnclosingCallable(n2) and
        stepFilter(node1, node2)
      )
    }

    private predicate additionalLocalStateStep(
      NodeEx node1, FlowState s1, NodeEx node2, FlowState s2, string model
    ) {
      exists(Node n1, Node n2 |
        node1.asNodeOrImplicitRead() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), s1, pragma[only_bind_into](n2), s2,
          model) and
        getNodeEnclosingCallable(n1) = getNodeEnclosingCallable(n2) and
        stateStepFilter(node1, s1, node2, s2)
      )
    }

    /**
     * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
     */
    private predicate jumpStepEx(NodeEx node1, NodeEx node2) {
      exists(Node n1, Node n2 |
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        jumpStepCached(pragma[only_bind_into](n1), pragma[only_bind_into](n2)) and
        stepFilter(node1, node2) and
        not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
      )
    }

    /**
     * Holds if the additional step from `node1` to `node2` jumps between callables.
     */
    private predicate additionalJumpStep(NodeEx node1, NodeEx node2, string model) {
      exists(Node n1, Node n2 |
        node1.asNodeOrImplicitRead() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), pragma[only_bind_into](n2), model) and
        getNodeEnclosingCallable(n1) != getNodeEnclosingCallable(n2) and
        stepFilter(node1, node2) and
        not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
      )
    }

    private predicate additionalJumpStateStep(
      NodeEx node1, FlowState s1, NodeEx node2, FlowState s2, string model
    ) {
      exists(Node n1, Node n2 |
        node1.asNodeOrImplicitRead() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), s1, pragma[only_bind_into](n2), s2,
          model) and
        getNodeEnclosingCallable(n1) != getNodeEnclosingCallable(n2) and
        stateStepFilter(node1, s1, node2, s2) and
        not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
      )
    }

    pragma[nomagic]
    private predicate readSetEx(NodeEx node1, ContentSet c, NodeEx node2) {
      readEx(node1, c, node2) and
      stepFilter(node1, node2)
      or
      exists(Node n |
        node2.isImplicitReadNode(n) and
        Config::allowImplicitRead(n, c)
      |
        node1.asNode() = n and
        not fullBarrier(node1)
        or
        node1.isImplicitReadNode(n)
      )
    }

    // inline to reduce fan-out via `getAReadContent`
    bindingset[c]
    private predicate read(NodeEx node1, Content c, NodeEx node2) {
      exists(ContentSet cs |
        readSetEx(node1, cs, node2) and
        pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
      )
    }

    // inline to reduce fan-out via `getAReadContent`
    bindingset[c]
    private predicate expectsContentEx(NodeEx n, Content c) {
      exists(ContentSet cs |
        expectsContentSet(n, cs) and
        pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
      )
    }

    pragma[nomagic]
    private predicate notExpectsContent(NodeEx n) { not expectsContentSet(n, _) }

    pragma[nomagic]
    private predicate storeUnrestricted(
      NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
    ) {
      storeEx(node1, c, node2, contentType, containerType) and
      stepFilter(node1, node2)
    }

    pragma[nomagic]
    private predicate hasReadStep(Content c) { read(_, c, _) }

    pragma[nomagic]
    private predicate store(
      NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
    ) {
      storeUnrestricted(node1, c, node2, contentType, containerType) and
      hasReadStep(c)
    }

    /**
     * Holds if field flow should be used for the given configuration.
     */
    private predicate useFieldFlow() {
      Config::fieldFlowBranchLimit() >= 1 and Config::accessPathLimit() > 0
    }

    private predicate hasSourceCallCtx() {
      exists(FlowFeature feature | feature = Config::getAFeature() |
        feature instanceof FeatureHasSourceCallContext or
        feature instanceof FeatureEqualSourceSinkCallContext
      )
    }

    private predicate hasSinkCallCtx() {
      exists(FlowFeature feature | feature = Config::getAFeature() |
        feature instanceof FeatureHasSinkCallContext or
        feature instanceof FeatureEqualSourceSinkCallContext
      )
    }

    /**
     * Holds if flow from `p` to a return node of kind `kind` is allowed.
     *
     * We don't expect a parameter to return stored in itself, unless
     * explicitly allowed
     */
    bindingset[p, kind]
    private predicate parameterFlowThroughAllowed(ParamNodeEx p, ReturnKindExt kind) {
      exists(ParameterPosition pos | p.isParameterOf(_, pos) |
        not kind.(ParamUpdateReturnKind).getPosition() = pos
        or
        allowParameterReturnInSelfEx(p)
      )
    }

    private module Stage1 implements StageSig {
      class Ap = Unit;

      class ApNil = Ap;

      private class Cc = boolean;

      /* Begin: Stage 1 logic. */
      /**
       * Holds if `node` is reachable from a source.
       *
       * The Boolean `cc` records whether the node is reached through an
       * argument in a call.
       */
      private predicate fwdFlow(NodeEx node, Cc cc) {
        sourceNode(node, _) and
        if hasSourceCallCtx() then cc = true else cc = false
        or
        exists(NodeEx mid | fwdFlow(mid, cc) |
          localFlowStepEx(mid, node, _) or
          additionalLocalFlowStep(mid, node, _) or
          additionalLocalStateStep(mid, _, node, _, _)
        )
        or
        exists(NodeEx mid | fwdFlow(mid, _) and cc = false |
          jumpStepEx(mid, node) or
          additionalJumpStep(mid, node, _) or
          additionalJumpStateStep(mid, _, node, _, _)
        )
        or
        // store
        exists(NodeEx mid |
          useFieldFlow() and
          fwdFlow(mid, cc) and
          store(mid, _, node, _, _)
        )
        or
        // read
        exists(ContentSet c |
          fwdFlowReadSet(c, node, cc) and
          fwdFlowConsCandSet(c, _)
        )
        or
        // flow into a callable
        fwdFlowIn(_, _, _, node) and
        cc = true
        or
        // flow out of a callable
        fwdFlowOut(_, _, node, false) and
        cc = false
        or
        // flow through a callable
        exists(DataFlowCall call, ReturnKindExtOption kind, ReturnKindExtOption disallowReturnKind |
          fwdFlowOutFromArg(call, kind, node) and
          fwdFlowIsEntered(call, disallowReturnKind, cc) and
          kind != disallowReturnKind
        )
      }

      // inline to reduce the number of iterations
      pragma[inline]
      private predicate fwdFlowIn(DataFlowCall call, NodeEx arg, Cc cc, ParamNodeEx p) {
        // call context cannot help reduce virtual dispatch
        fwdFlow(arg, cc) and
        viableParamArgEx(call, p, arg) and
        not fullBarrier(p) and
        (
          cc = false
          or
          cc = true and
          not CachedCallContextSensitivity::reducedViableImplInCallContext(call, _, _)
        )
        or
        // call context may help reduce virtual dispatch
        exists(DataFlowCallable target |
          fwdFlowInReducedViableImplInSomeCallContext(call, arg, p, target) and
          target = viableImplInSomeFwdFlowCallContextExt(call) and
          cc = true
        )
      }

      pragma[nomagic]
      private ReturnKindExtOption getDisallowedReturnKind0(ParamNodeEx p) {
        if allowParameterReturnInSelfEx(p)
        then result.isNone()
        else p.isParameterOf(_, result.asSome().(ParamUpdateReturnKind).getPosition())
      }

      bindingset[p]
      pragma[inline_late]
      private ReturnKindExtOption getDisallowedReturnKind(ParamNodeEx p) {
        result = getDisallowedReturnKind0(p)
      }

      /**
       * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
       */
      pragma[nomagic]
      private predicate fwdFlowIsEntered(
        DataFlowCall call, ReturnKindExtOption disallowReturnKind, Cc cc
      ) {
        exists(ParamNodeEx p |
          fwdFlowIn(call, _, cc, p) and
          disallowReturnKind = getDisallowedReturnKind(p)
        )
      }

      pragma[nomagic]
      private predicate fwdFlowInReducedViableImplInSomeCallContext(
        DataFlowCall call, NodeEx arg, ParamNodeEx p, DataFlowCallable target
      ) {
        fwdFlow(arg, true) and
        viableParamArgEx(call, p, arg) and
        CachedCallContextSensitivity::reducedViableImplInCallContext(call, _, _) and
        target = p.getEnclosingCallable() and
        not fullBarrier(p)
      }

      /**
       * Gets a viable dispatch target of `call` in the context `ctx`. This is
       * restricted to those `call`s for which a context might make a difference,
       * and to `ctx`s that are reachable in `fwdFlow`.
       */
      pragma[nomagic]
      private DataFlowCallable viableImplInSomeFwdFlowCallContextExt(DataFlowCall call) {
        exists(DataFlowCall ctx |
          fwdFlowIsEntered(ctx, _, _) and
          result = viableImplInCallContextExt(call, ctx)
        )
      }

      private predicate fwdFlow(NodeEx node) { fwdFlow(node, _) }

      pragma[nomagic]
      private predicate fwdFlowReadSet(ContentSet c, NodeEx node, Cc cc) {
        exists(NodeEx mid |
          fwdFlow(mid, cc) and
          readSetEx(mid, c, node)
        )
      }

      /**
       * Holds if `c` is the target of a store in the flow covered by `fwdFlow`.
       */
      pragma[nomagic]
      private predicate fwdFlowConsCand(Content c) {
        exists(NodeEx mid, NodeEx node |
          not fullBarrier(node) and
          useFieldFlow() and
          fwdFlow(mid, _) and
          store(mid, c, node, _, _)
        )
      }

      /**
       * Holds if `cs` may be interpreted in a read as the target of some store
       * into `c`, in the flow covered by `fwdFlow`.
       */
      pragma[nomagic]
      private predicate fwdFlowConsCandSet(ContentSet cs, Content c) {
        fwdFlowConsCand(c) and
        c = cs.getAReadContent()
      }

      pragma[nomagic]
      private predicate fwdFlowReturnPosition(ReturnPosition pos, Cc cc) {
        exists(RetNodeEx ret |
          fwdFlow(ret, cc) and
          ret.getReturnPosition() = pos
        )
      }

      // inline to reduce the number of iterations
      pragma[inline]
      private predicate fwdFlowOut(DataFlowCall call, ReturnKindExt kind, NodeEx out, Cc cc) {
        exists(ReturnPosition pos |
          fwdFlowReturnPosition(pos, cc) and
          viableReturnPosOutEx(call, pos, out) and
          not fullBarrier(out) and
          kind = pos.getKind()
        )
      }

      pragma[nomagic]
      private predicate fwdFlowOutFromArg(DataFlowCall call, ReturnKindExtOption kind, NodeEx out) {
        fwdFlowOut(call, kind.asSome(), out, true)
      }

      private predicate stateStepFwd(FlowState state1, FlowState state2) {
        exists(NodeEx node1 |
          additionalLocalStateStep(node1, state1, _, state2, _) or
          additionalJumpStateStep(node1, state1, _, state2, _)
        |
          fwdFlow(node1)
        )
      }

      private predicate fwdFlowState(FlowState state) {
        sourceNode(_, state)
        or
        exists(FlowState state0 |
          fwdFlowState(state0) and
          stateStepFwd(state0, state)
        )
      }

      additional predicate sinkNode(NodeEx node, FlowState state) {
        fwdFlow(pragma[only_bind_into](node)) and
        fwdFlowState(state) and
        isRelevantSink(node.asNodeOrImplicitRead())
        or
        fwdFlow(node) and
        fwdFlowState(state) and
        sinkNodeWithState(node, state)
      }

      /**
       * Holds if `node` is part of a path from a source to a sink.
       *
       * The Boolean `toReturn` records whether the node must be returned from
       * the enclosing callable in order to reach a sink.
       */
      pragma[nomagic]
      additional predicate revFlow(NodeEx node, boolean toReturn) {
        revFlow0(node, toReturn) and
        fwdFlow(node)
      }

      pragma[nomagic]
      private predicate revFlow0(NodeEx node, boolean toReturn) {
        sinkNode(node, _) and
        if hasSinkCallCtx() then toReturn = true else toReturn = false
        or
        exists(NodeEx mid | revFlow(mid, toReturn) |
          localFlowStepEx(node, mid, _) or
          additionalLocalFlowStep(node, mid, _) or
          additionalLocalStateStep(node, _, mid, _, _)
        )
        or
        exists(NodeEx mid | revFlow(mid, _) and toReturn = false |
          jumpStepEx(node, mid) or
          additionalJumpStep(node, mid, _) or
          additionalJumpStateStep(node, _, mid, _, _)
        )
        or
        // store
        exists(Content c |
          revFlowStore(c, node, toReturn) and
          revFlowConsCand(c)
        )
        or
        // read
        exists(NodeEx mid, ContentSet c |
          readSetEx(node, c, mid) and
          fwdFlowConsCandSet(c, _) and
          revFlow(mid, toReturn)
        )
        or
        // flow into a callable
        revFlowIn(_, _, node, false) and
        toReturn = false
        or
        // flow out of a callable
        exists(ReturnPosition pos |
          revFlowOut(pos) and
          node.(RetNodeEx).getReturnPosition() = pos and
          toReturn = true
        )
        or
        // flow through a callable
        exists(DataFlowCall call, ReturnKindExtOption kind, ReturnKindExtOption disallowReturnKind |
          revFlowIsReturned(call, kind, toReturn) and
          revFlowInToReturn(call, disallowReturnKind, node) and
          kind != disallowReturnKind
        )
      }

      /**
       * Holds if `c` is the target of a read in the flow covered by `revFlow`.
       */
      pragma[nomagic]
      private predicate revFlowConsCand(Content c) {
        exists(NodeEx mid, NodeEx node, ContentSet cs |
          fwdFlow(node) and
          readSetEx(node, cs, mid) and
          fwdFlowConsCandSet(cs, c) and
          revFlow(pragma[only_bind_into](mid), _)
        )
      }

      pragma[nomagic]
      private predicate revFlowStore(Content c, NodeEx node, boolean toReturn) {
        exists(NodeEx mid |
          revFlow(mid, toReturn) and
          fwdFlowConsCand(c) and
          store(node, c, mid, _, _)
        )
      }

      /**
       * Holds if `c` is the target of both a read and a store in the flow covered
       * by `revFlow`.
       */
      pragma[nomagic]
      additional predicate revFlowIsReadAndStored(Content c) {
        revFlowConsCand(c) and
        revFlowStore(c, _, _)
      }

      pragma[nomagic]
      additional predicate viableReturnPosOutNodeCandFwd1(
        DataFlowCall call, ReturnPosition pos, NodeEx out
      ) {
        fwdFlowReturnPosition(pos, _) and
        viableReturnPosOutEx(call, pos, out)
      }

      pragma[nomagic]
      private predicate revFlowOut(ReturnPosition pos) {
        exists(NodeEx out |
          revFlow(out, _) and
          viableReturnPosOutNodeCandFwd1(_, pos, out)
        )
      }

      pragma[nomagic]
      additional predicate viableParamArgNodeCandFwd1(
        DataFlowCall call, ParamNodeEx p, ArgNodeEx arg
      ) {
        fwdFlowIn(call, arg, _, p)
      }

      // inline to reduce the number of iterations
      pragma[inline]
      private predicate revFlowIn(DataFlowCall call, ParamNodeEx p, ArgNodeEx arg, boolean toReturn) {
        revFlow(p, toReturn) and
        viableParamArgNodeCandFwd1(call, p, arg)
      }

      pragma[nomagic]
      private predicate revFlowInToReturn(
        DataFlowCall call, ReturnKindExtOption disallowReturnKind, ArgNodeEx arg
      ) {
        exists(ParamNodeEx p |
          revFlowIn(call, p, arg, true) and
          disallowReturnKind = getDisallowedReturnKind(p)
        )
      }

      /**
       * Holds if an output from `call` is reached in the flow covered by `revFlow`
       * and data might flow through the target callable resulting in reverse flow
       * reaching an argument of `call`.
       */
      pragma[nomagic]
      private predicate revFlowIsReturned(
        DataFlowCall call, ReturnKindExtOption kind, boolean toReturn
      ) {
        exists(NodeEx out |
          revFlow(out, toReturn) and
          fwdFlowOutFromArg(call, kind, out)
        )
      }

      private predicate stateStepRev(FlowState state1, FlowState state2) {
        exists(NodeEx node1, NodeEx node2 |
          additionalLocalStateStep(node1, state1, node2, state2, _) or
          additionalJumpStateStep(node1, state1, node2, state2, _)
        |
          revFlow(node1, _) and
          revFlow(node2, _) and
          fwdFlowState(state1) and
          fwdFlowState(state2)
        )
      }

      pragma[nomagic]
      additional predicate revFlowState(FlowState state) {
        exists(NodeEx node |
          sinkNode(node, state) and
          revFlow(node, _) and
          fwdFlowState(state)
        )
        or
        exists(FlowState state0 |
          revFlowState(state0) and
          stateStepRev(state, state0)
        )
      }

      pragma[nomagic]
      predicate storeStepCand(
        NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
      ) {
        revFlowIsReadAndStored(c) and
        revFlow(node2) and
        store(node1, c, node2, contentType, containerType)
      }

      pragma[nomagic]
      predicate readStepCand(NodeEx n1, Content c, NodeEx n2) {
        revFlowIsReadAndStored(c) and
        read(n1, c, n2) and
        revFlow(n2)
      }

      pragma[nomagic]
      predicate revFlow(NodeEx node) { revFlow(node, _) }

      bindingset[node, state]
      predicate revFlow(NodeEx node, FlowState state, Ap ap) {
        revFlow(node, _) and
        exists(state) and
        exists(ap)
      }

      private predicate throughFlowNodeCand(NodeEx node) {
        revFlow(node, true) and
        fwdFlow(node, true) and
        not inBarrier(node) and
        not outBarrier(node)
      }

      /** Holds if flow may return from `callable`. */
      pragma[nomagic]
      private predicate returnFlowCallableNodeCand(DataFlowCallable callable, ReturnKindExt kind) {
        exists(RetNodeEx ret |
          throughFlowNodeCand(ret) and
          callable = ret.getEnclosingCallable() and
          kind = ret.getKind()
        )
      }

      /**
       * Holds if flow may enter through `p` and reach a return node making `p` a
       * candidate for the origin of a summary.
       */
      pragma[nomagic]
      predicate parameterMayFlowThrough(ParamNodeEx p, boolean emptyAp) {
        exists(DataFlowCallable c, ReturnKindExt kind |
          throughFlowNodeCand(p) and
          returnFlowCallableNodeCand(c, kind) and
          p.getEnclosingCallable() = c and
          emptyAp = [true, false] and
          parameterFlowThroughAllowed(p, kind)
        )
      }

      pragma[nomagic]
      predicate returnMayFlowThrough(RetNodeEx ret, ReturnKindExt kind) {
        throughFlowNodeCand(ret) and
        kind = ret.getKind()
      }

      pragma[nomagic]
      predicate callMayFlowThroughRev(DataFlowCall call) {
        exists(
          ArgNodeEx arg, ReturnKindExtOption kind, ReturnKindExtOption disallowReturnKind,
          boolean toReturn
        |
          revFlow(arg, pragma[only_bind_into](toReturn)) and
          revFlowIsReturned(call, kind, pragma[only_bind_into](toReturn)) and
          revFlowInToReturn(call, disallowReturnKind, arg) and
          kind != disallowReturnKind
        )
      }

      predicate callEdgeArgParam(
        DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
      ) {
        exists(boolean allowsFieldFlow |
          flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow) and
          c = p.getEnclosingCallable() and
          (
            emptyAp = true
            or
            allowsFieldFlow = true and emptyAp = false
          )
        )
      }

      predicate callEdgeReturn(
        DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
        boolean allowsFieldFlow
      ) {
        flowOutOfCallNodeCand1(call, ret, kind, out, allowsFieldFlow) and
        c = ret.getEnclosingCallable()
      }

      predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c) {
        callEdgeArgParam(call, c, _, _, _)
      }

      predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
        callEdgeReturn(call, c, _, _, _, _)
      }

      additional predicate stats(
        boolean fwd, int nodes, int fields, int conscand, int states, int tuples, int calledges
      ) {
        fwd = true and
        nodes = count(NodeEx node | fwdFlow(node)) and
        fields = count(Content f0 | fwdFlowConsCand(f0)) and
        conscand = -1 and
        states = count(FlowState state | fwdFlowState(state)) and
        tuples = count(NodeEx n, boolean b | fwdFlow(n, b)) and
        calledges = -1
        or
        fwd = false and
        nodes = count(NodeEx node | revFlow(node, _)) and
        fields = count(Content f0 | revFlowConsCand(f0)) and
        conscand = -1 and
        states = count(FlowState state | revFlowState(state)) and
        tuples = count(NodeEx n, boolean b | revFlow(n, b)) and
        calledges =
          count(DataFlowCall call, DataFlowCallable c |
            callEdgeArgParam(call, c, _, _, _) or
            callEdgeReturn(call, c, _, _, _, _)
          )
      }
      /* End: Stage 1 logic. */
    }

    private predicate sinkNode = Stage1::sinkNode/2;

    private predicate sourceModel(NodeEx node, string model) {
      sourceNode(node, _) and
      (
        model = getSourceModel(node)
        or
        not exists(getSourceModel(node)) and model = ""
      )
    }

    private predicate sinkModel(NodeEx node, string model) {
      sinkNode(node, _) and
      (
        model = getSinkModel(node)
        or
        not exists(getSinkModel(node)) and model = ""
      )
    }

    bindingset[label1, label2]
    pragma[inline_late]
    private string mergeLabels(string label1, string label2) {
      if label2.matches("Sink:%")
      then if label1 = "" then result = label2 else result = label1 + " " + label2
      else
        // Big-step, hidden nodes, and summaries all may need to merge labels.
        // These cases are expected to involve at most one non-empty label, so
        // we'll just discard the 2nd+ label for now.
        if label1 = ""
        then result = label2
        else result = label1
    }

    pragma[nomagic]
    private predicate localStepNodeCand1(
      NodeEx node1, NodeEx node2, boolean preservesValue, DataFlowType t, LocalCallContext lcc,
      string label
    ) {
      Stage1::revFlow(node1) and
      Stage1::revFlow(node2) and
      (
        preservesValue = true and
        localFlowStepEx(node1, node2, label) and
        t = node1.getDataFlowType()
        or
        preservesValue = false and
        additionalLocalFlowStep(node1, node2, label) and
        t = node2.getDataFlowType()
      ) and
      lcc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall1(node1, lcc) and
      not isUnreachableInCall1(node2, lcc)
    }

    pragma[nomagic]
    private predicate localStateStepNodeCand1(
      NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, DataFlowType t,
      LocalCallContext lcc, string label
    ) {
      Stage1::revFlow(node1) and
      Stage1::revFlow(node2) and
      additionalLocalStateStep(node1, state1, node2, state2, label) and
      t = node2.getDataFlowType() and
      lcc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall1(node1, lcc) and
      not isUnreachableInCall1(node2, lcc)
    }

    pragma[nomagic]
    private predicate viableReturnPosOutNodeCand1(DataFlowCall call, ReturnPosition pos, NodeEx out) {
      Stage1::revFlow(out) and
      Stage1::viableReturnPosOutNodeCandFwd1(call, pos, out)
    }

    /**
     * Holds if data can flow out of `call` from `ret` to `out`, either
     * through a `ReturnNode` or through an argument that has been mutated, and
     * that this step is part of a path from a source to a sink.
     */
    pragma[nomagic]
    private predicate flowOutOfCallNodeCand1(
      DataFlowCall call, RetNodeEx ret, ReturnKindExt kind, NodeEx out
    ) {
      exists(ReturnPosition pos |
        viableReturnPosOutNodeCand1(call, pos, out) and
        pos = ret.getReturnPosition() and
        kind = pos.getKind() and
        Stage1::revFlow(ret) and
        not outBarrier(ret) and
        not inBarrier(out)
      )
    }

    pragma[nomagic]
    private predicate viableParamArgNodeCand1(DataFlowCall call, ParamNodeEx p, ArgNodeEx arg) {
      Stage1::viableParamArgNodeCandFwd1(call, p, arg) and
      Stage1::revFlow(arg)
    }

    /**
     * Holds if data can flow into `call` and that this step is part of a
     * path from a source to a sink.
     */
    pragma[nomagic]
    private predicate flowIntoCallNodeCand1(DataFlowCall call, ArgNodeEx arg, ParamNodeEx p) {
      viableParamArgNodeCand1(call, p, arg) and
      Stage1::revFlow(p) and
      not outBarrier(arg) and
      not inBarrier(p)
    }

    /**
     * Gets an additional term that is added to `branch` and `join` when deciding whether
     * the amount of forward or backward branching is within the limit specified by the
     * configuration.
     */
    pragma[nomagic]
    private int getLanguageSpecificFlowIntoCallNodeCand1(ArgNodeEx arg, ParamNodeEx p) {
      flowIntoCallNodeCand1(_, arg, p) and
      result = getAdditionalFlowIntoCallNodeTerm(arg.projectToNode(), p.projectToNode())
    }

    pragma[nomagic]
    private predicate returnCallEdge1(
      DataFlowCallable c, SndLevelScopeOption scope, DataFlowCall call, NodeEx out
    ) {
      exists(RetNodeEx ret |
        flowOutOfCallNodeCand1(call, ret, _, out) and
        c = ret.getEnclosingCallable()
      |
        scope = getSecondLevelScopeEx(ret)
        or
        ret = TParamReturnNode(_, scope)
      )
    }

    private int simpleDispatchFanoutOnReturn(DataFlowCall call, NodeEx out) {
      result =
        strictcount(DataFlowCallable c, SndLevelScopeOption scope |
          returnCallEdge1(c, scope, call, out)
        )
    }

    pragma[nomagic]
    private predicate returnCallEdgeInCtx1(
      DataFlowCallable c, SndLevelScopeOption scope, DataFlowCall call, NodeEx out, DataFlowCall ctx
    ) {
      returnCallEdge1(c, scope, call, out) and
      c = viableImplInCallContextExt(call, ctx)
    }

    private int ctxDispatchFanoutOnReturn(NodeEx out, DataFlowCall ctx) {
      exists(DataFlowCall call, DataFlowCallable c |
        simpleDispatchFanoutOnReturn(call, out) > 1 and
        not Stage1::revFlow(out, false) and
        call.getEnclosingCallable() = c and
        returnCallEdge1(c, _, ctx, _) and
        mayBenefitFromCallContextExt(call, _) and
        result =
          count(DataFlowCallable tgt, SndLevelScopeOption scope |
            returnCallEdgeInCtx1(tgt, scope, call, out, ctx)
          )
      )
    }

    private int ctxDispatchFanoutOnReturn(NodeEx out) {
      result = max(DataFlowCall ctx | | ctxDispatchFanoutOnReturn(out, ctx))
    }

    private int dispatchFanoutOnReturn(NodeEx out) {
      result = ctxDispatchFanoutOnReturn(out)
      or
      not exists(ctxDispatchFanoutOnReturn(out)) and
      result = simpleDispatchFanoutOnReturn(_, out)
    }

    /**
     * Gets the amount of forward branching on the origin of a cross-call path
     * edge in the graph of paths between sources and sinks that ignores call
     * contexts.
     */
    pragma[nomagic]
    private int branch(ArgNodeEx n1) {
      result =
        strictcount(DataFlowCallable c |
            exists(NodeEx n |
              flowIntoCallNodeCand1(_, n1, n) and
              c = n.getEnclosingCallable()
            )
          ) + sum(ParamNodeEx p1 | | getLanguageSpecificFlowIntoCallNodeCand1(n1, p1))
    }

    /**
     * Gets the amount of backward branching on the target of a cross-call path
     * edge in the graph of paths between sources and sinks that ignores call
     * contexts.
     */
    pragma[nomagic]
    private int join(ParamNodeEx n2) {
      result =
        strictcount(DataFlowCallable c |
            exists(NodeEx n |
              flowIntoCallNodeCand1(_, n, n2) and
              c = n.getEnclosingCallable()
            )
          ) + sum(ArgNodeEx arg2 | | getLanguageSpecificFlowIntoCallNodeCand1(arg2, n2))
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
      DataFlowCall call, RetNodeEx ret, ReturnKindExt kind, NodeEx out, boolean allowsFieldFlow
    ) {
      flowOutOfCallNodeCand1(call, ret, kind, out) and
      exists(int j |
        j = dispatchFanoutOnReturn(out) and
        j > 0 and
        if
          j <= Config::fieldFlowBranchLimit() or
          ignoreFieldFlowBranchLimit(ret.getEnclosingCallable())
        then allowsFieldFlow = true
        else allowsFieldFlow = false
      )
    }

    pragma[nomagic]
    private predicate allowsFieldFlowThrough(DataFlowCall call, DataFlowCallable c) {
      exists(RetNodeEx ret |
        flowOutOfCallNodeCand1(call, ret, _, _, true) and
        c = ret.getEnclosingCallable()
      )
    }

    /**
     * Holds if data can flow into `call` and that this step is part of a
     * path from a source to a sink. The `allowsFieldFlow` flag indicates whether
     * the branching is within the limit specified by the configuration.
     */
    pragma[nomagic]
    private predicate flowIntoCallNodeCand1(
      DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow
    ) {
      flowIntoCallNodeCand1(call, arg, p) and
      exists(int b, int j |
        b = branch(arg) and
        j = join(p) and
        if
          b.minimum(j) <= Config::fieldFlowBranchLimit() or
          ignoreFieldFlowBranchLimit(p.getEnclosingCallable())
        then allowsFieldFlow = true
        else allowsFieldFlow = false
      )
    }

    private signature module StageSig {
      class Ap;

      class ApNil extends Ap;

      predicate revFlow(NodeEx node);

      bindingset[node, state]
      predicate revFlow(NodeEx node, FlowState state, Ap ap);

      predicate callMayFlowThroughRev(DataFlowCall call);

      predicate parameterMayFlowThrough(ParamNodeEx p, boolean emptyAp);

      predicate returnMayFlowThrough(RetNodeEx ret, ReturnKindExt kind);

      predicate storeStepCand(
        NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
      );

      predicate readStepCand(NodeEx n1, Content c, NodeEx n2);

      predicate callEdgeArgParam(
        DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
      );

      predicate callEdgeReturn(
        DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
        boolean allowsFieldFlow
      );

      predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c);

      predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c);
    }

    private module MkStage<StageSig PrevStage> {
      class ApApprox = PrevStage::Ap;

      signature module StageParam {
        class Typ {
          string toString();
        }

        class Ap {
          string toString();
        }

        class ApNil extends Ap;

        bindingset[result, ap]
        ApApprox getApprox(Ap ap);

        Typ getTyp(DataFlowType t);

        bindingset[c, tail]
        Ap apCons(Content c, Ap tail);

        /**
         * An approximation of `Content` that corresponds to the precision level of
         * `Ap`, such that the mappings from both `Ap` and `Content` to this type
         * are functional.
         */
        class ApHeadContent;

        ApHeadContent getHeadContent(Ap ap);

        ApHeadContent projectToHeadContent(Content c);

        class ApOption;

        ApOption apNone();

        ApOption apSome(Ap ap);

        class Cc {
          string toString();
        }

        class CcCall extends Cc;

        // TODO: member predicate on CcCall
        predicate matchesCall(CcCall cc, DataFlowCall call);

        class CcNoCall extends Cc;

        Cc ccNone();

        CcCall ccSomeCall();

        /*
         * The following `instanceof` predicates are necessary for proper
         * caching, since we're able to cache predicates, but not the underlying
         * types.
         */

        predicate instanceofCc(Cc cc);

        predicate instanceofCcCall(CcCall cc);

        predicate instanceofCcNoCall(CcNoCall cc);

        class LocalCc;

        DataFlowCallable viableImplCallContextReduced(DataFlowCall call, CcCall ctx);

        bindingset[call, ctx]
        predicate viableImplNotCallContextReduced(DataFlowCall call, Cc ctx);

        bindingset[call, c]
        CcCall getCallContextCall(DataFlowCall call, DataFlowCallable c);

        DataFlowCall viableImplCallContextReducedReverse(DataFlowCallable c, CcNoCall ctx);

        predicate viableImplNotCallContextReducedReverse(CcNoCall ctx);

        bindingset[call, c]
        CcNoCall getCallContextReturn(DataFlowCallable c, DataFlowCall call);

        bindingset[cc]
        LocalCc getLocalCc(Cc cc);

        bindingset[node1, state1]
        bindingset[node2, state2]
        predicate localStep(
          NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
          Typ t, LocalCc lcc, string label
        );

        bindingset[node, state, t0, ap]
        predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t);

        bindingset[node, ap, isStoreStep]
        predicate stepFilter(NodeEx node, Ap ap, boolean isStoreStep);

        bindingset[t1, t2]
        predicate typecheck(Typ t1, Typ t2);

        default predicate enableTypeFlow() { any() }
      }

      module Stage<StageParam Param> implements StageSig {
        import Param

        private module TypOption = Option<Typ>;

        private class TypOption = TypOption::Option;

        private string ppStored(TypOption stored) {
          exists(string ppt | ppt = stored.toString() |
            if stored.isNone() or ppt = "" then result = "" else result = " : " + ppt
          )
        }

        bindingset[ap]
        private boolean isNil(Ap ap) {
          if ap instanceof ApNil then result = true else result = false
        }

        /* Begin: Stage logic. */
        pragma[nomagic]
        private Typ getNodeTyp(NodeEx node) {
          PrevStage::revFlow(node) and result = getTyp(node.getDataFlowType())
        }

        pragma[nomagic]
        private predicate flowThroughOutOfCall(
          DataFlowCall call, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow
        ) {
          exists(ReturnKindExt kind |
            PrevStage::callEdgeReturn(call, _, ret, kind, out, allowsFieldFlow) and
            PrevStage::callMayFlowThroughRev(call) and
            PrevStage::returnMayFlowThrough(ret, kind)
          )
        }

        pragma[nomagic]
        private predicate compatibleContainer0(ApHeadContent apc, DataFlowType containerType) {
          exists(DataFlowType containerType0, Content c |
            PrevStage::storeStepCand(_, c, _, _, containerType0) and
            not isTopType(containerType0) and
            compatibleTypesCached(containerType0, containerType) and
            apc = projectToHeadContent(c)
          )
        }

        pragma[nomagic]
        private predicate topTypeContent(ApHeadContent apc) {
          exists(DataFlowType containerType0, Content c |
            PrevStage::storeStepCand(_, c, _, _, containerType0) and
            isTopType(containerType0) and
            apc = projectToHeadContent(c)
          )
        }

        bindingset[apc, containerType]
        pragma[inline_late]
        private predicate compatibleContainer(ApHeadContent apc, DataFlowType containerType) {
          compatibleContainer0(apc, containerType)
        }

        /**
         * Holds if `node` is reachable with access path `ap` from a source.
         *
         * The call context `cc` records whether the node is reached through an
         * argument in a call, and if so, `summaryCtx` records the
         * corresponding parameter position and access path of that argument.
         */
        pragma[nomagic]
        additional predicate fwdFlow(
          NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
        ) {
          fwdFlow1(node, state, cc, summaryCtx, _, t, ap, stored)
        }

        private predicate fwdFlow1(
          NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t0, Typ t, Ap ap,
          TypOption stored
        ) {
          exists(ApApprox apa |
            fwdFlow0(node, state, cc, summaryCtx, t0, ap, apa, stored) and
            PrevStage::revFlow(node, state, apa) and
            filter(node, state, t0, ap, t) and
            (
              if node instanceof CastingNodeEx
              then
                ap instanceof ApNil or
                compatibleContainer(getHeadContent(ap), node.getDataFlowType()) or
                topTypeContent(getHeadContent(ap))
              else any()
            )
          )
        }

        pragma[nomagic]
        private predicate fwdFlow0(
          NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, ApApprox apa,
          TypOption stored
        ) {
          sourceNode(node, state) and
          (if hasSourceCallCtx() then cc = ccSomeCall() else cc = ccNone()) and
          summaryCtx = TSummaryCtxNone() and
          t = getNodeTyp(node) and
          ap instanceof ApNil and
          apa = getApprox(ap) and
          stored.isNone()
          or
          exists(NodeEx mid, FlowState state0, Typ t0, LocalCc localCc |
            fwdFlow(mid, state0, cc, summaryCtx, t0, ap, stored) and
            apa = getApprox(ap) and
            localCc = getLocalCc(cc)
          |
            localStep(mid, state0, node, state, true, _, localCc, _) and
            t = t0
            or
            localStep(mid, state0, node, state, false, t, localCc, _) and
            ap instanceof ApNil
          )
          or
          fwdFlowJump(node, state, t, ap, stored) and
          apa = getApprox(ap) and
          cc = ccNone() and
          summaryCtx = TSummaryCtxNone()
          or
          // store
          exists(Content c, Ap ap0 |
            fwdFlowStore(_, _, ap0, _, c, t, stored, node, state, cc, summaryCtx) and
            ap = apCons(c, ap0) and
            apa = getApprox(ap)
          )
          or
          // read
          fwdFlowRead(_, _, _, _, _, node, t, ap, stored, state, cc, summaryCtx) and
          apa = getApprox(ap)
          or
          // flow into a callable without summary context
          fwdFlowInNoFlowThrough(node, state, cc, t, ap, stored) and
          apa = getApprox(ap) and
          summaryCtx = TSummaryCtxNone() and
          // When the call contexts of source and sink needs to match then there's
          // never any reason to enter a callable except to find a summary. See also
          // the comment in `PathNodeMid::isAtSink`.
          not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
          or
          // flow into a callable with summary context (non-linear recursion)
          fwdFlowInFlowThrough(node, state, cc, t, ap, stored) and
          apa = getApprox(ap) and
          summaryCtx = TSummaryCtxSome(node, state, t, ap, stored)
          or
          // flow out of a callable
          fwdFlowOut(_, _, node, state, cc, summaryCtx, t, ap, stored) and
          apa = getApprox(ap)
          or
          // flow through a callable
          exists(DataFlowCall call, RetNodeEx ret, boolean allowsFieldFlow |
            fwdFlowThrough(call, cc, state, summaryCtx, t, ap, stored, ret) and
            flowThroughOutOfCall(call, ret, node, allowsFieldFlow) and
            apa = getApprox(ap) and
            not inBarrier(node, state) and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        private newtype TSummaryCtx =
          TSummaryCtxNone() or
          TSummaryCtxSome(ParamNodeEx p, FlowState state, Typ t, Ap ap, TypOption stored) {
            fwdFlowInFlowThrough(p, state, _, t, ap, stored)
          }

        /**
         * A context for generating flow summaries. This represents flow entry through
         * a specific parameter with an access path of a specific shape.
         *
         * Summaries are only created for parameters that may flow through.
         */
        private class SummaryCtx extends TSummaryCtx {
          abstract string toString();

          abstract Location getLocation();
        }

        /** A summary context from which no flow summary can be generated. */
        private class SummaryCtxNone extends SummaryCtx, TSummaryCtxNone {
          override string toString() { result = "<none>" }

          override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
        }

        /** A summary context from which a flow summary can be generated. */
        private class SummaryCtxSome extends SummaryCtx, TSummaryCtxSome {
          private ParamNodeEx p;
          private FlowState state;
          private Typ t;
          private Ap ap;
          private TypOption stored;

          SummaryCtxSome() { this = TSummaryCtxSome(p, state, t, ap, stored) }

          ParamNodeEx getParamNode() { result = p }

          private string ppTyp() { result = t.toString() and result != "" }

          override string toString() {
            result = p + concat(" : " + this.ppTyp()) + " " + ap + ppStored(stored)
          }

          override Location getLocation() { result = p.getLocation() }
        }

        private predicate fwdFlowJump(NodeEx node, FlowState state, Typ t, Ap ap, TypOption stored) {
          exists(NodeEx mid |
            fwdFlow(mid, state, _, _, t, ap, stored) and
            jumpStepEx(mid, node)
          )
          or
          exists(NodeEx mid |
            fwdFlow(mid, state, _, _, _, ap, stored) and
            additionalJumpStep(mid, node, _) and
            t = getNodeTyp(node) and
            ap instanceof ApNil
          )
          or
          exists(NodeEx mid, FlowState state0 |
            fwdFlow(mid, state0, _, _, _, ap, stored) and
            additionalJumpStateStep(mid, state0, node, state, _) and
            t = getNodeTyp(node) and
            ap instanceof ApNil
          )
        }

        pragma[nomagic]
        private predicate fwdFlowStore(
          NodeEx node1, Typ t1, Ap ap1, TypOption stored1, Content c, Typ t2, TypOption stored2,
          NodeEx node2, FlowState state, Cc cc, SummaryCtx summaryCtx
        ) {
          exists(DataFlowType contentType, DataFlowType containerType |
            fwdFlow(node1, state, cc, summaryCtx, t1, ap1, stored1) and
            not outBarrier(node1, state) and
            not inBarrier(node2, state) and
            PrevStage::storeStepCand(node1, c, node2, contentType, containerType) and
            t2 = getTyp(containerType) and
            // We need to typecheck stores here, since reverse flow through a getter
            // might have a different type here compared to inside the getter.
            typecheck(t1, getTyp(contentType)) and
            if ap1 instanceof ApNil then stored2.asSome() = t1 else stored2 = stored1
          )
        }

        /**
         * Holds if forward flow with access path `tail` and type `t1` reaches a
         * store of `c` on a container of type `t2` resulting in access path
         * `cons`.
         */
        pragma[nomagic]
        private predicate fwdFlowConsCand(Typ t2, Ap cons, Content c, Typ t1, Ap tail) {
          fwdFlowStore(_, t1, tail, _, c, t2, _, _, _, _, _) and
          cons = apCons(c, tail)
        }

        pragma[nomagic]
        private predicate readStepCand(NodeEx node1, ApHeadContent apc, Content c, NodeEx node2) {
          PrevStage::readStepCand(node1, c, node2) and
          apc = projectToHeadContent(c)
        }

        bindingset[node1, apc]
        pragma[inline_late]
        private predicate readStepCand0(NodeEx node1, ApHeadContent apc, Content c, NodeEx node2) {
          readStepCand(node1, apc, c, node2)
        }

        pragma[nomagic]
        private predicate fwdFlowRead0(
          Typ t, Ap ap, TypOption stored, Content c, NodeEx node1, NodeEx node2, FlowState state,
          Cc cc, SummaryCtx summaryCtx
        ) {
          exists(ApHeadContent apc |
            fwdFlow(node1, state, cc, summaryCtx, t, ap, stored) and
            not outBarrier(node1, state) and
            not inBarrier(node2, state) and
            apc = getHeadContent(ap) and
            readStepCand0(node1, apc, c, node2)
          )
        }

        pragma[nomagic]
        private predicate fwdFlowRead(
          NodeEx node1, Typ t1, Ap ap1, TypOption stored1, Content c, NodeEx node2, Typ t2, Ap ap2,
          TypOption stored2, FlowState state, Cc cc, SummaryCtx summaryCtx
        ) {
          exists(Typ ct1, Typ ct2 |
            fwdFlowRead0(t1, ap1, stored1, c, node1, node2, state, cc, summaryCtx) and
            fwdFlowConsCand(ct1, ap1, c, ct2, ap2) and
            typecheck(t1, ct1) and
            typecheck(t2, ct2) and
            if ap2 instanceof ApNil
            then stored2.isNone() and stored1.asSome() = t2
            else (
              stored2 = stored1 and t2 = getNodeTyp(node2)
            )
          )
        }

        pragma[nomagic]
        private predicate fwdFlowIntoArg(
          ArgNodeEx arg, FlowState state, Cc outercc, SummaryCtx summaryCtx, Typ t, Ap ap,
          boolean emptyAp, TypOption stored, boolean cc
        ) {
          fwdFlow(arg, state, outercc, summaryCtx, t, ap, stored) and
          (if instanceofCcCall(outercc) then cc = true else cc = false) and
          emptyAp = isNil(ap)
        }

        private signature predicate flowThroughSig();

        /**
         * Exposes the inlined predicate `fwdFlowIn`, which is used to calculate both
         * flow in and flow through.
         *
         * For flow in, only a subset of the columns are needed, specifically we don't
         * need to record the argument that flows into the parameter.
         *
         * For flow through, we do need to record the argument, however, we can restrict
         * this to arguments that may actually flow through, which reduces the
         * argument-to-parameter fan-in significantly.
         */
        private module FwdFlowIn<flowThroughSig/0 flowThrough> {
          pragma[nomagic]
          private predicate callEdgeArgParamRestricted(
            DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
          ) {
            PrevStage::callEdgeArgParam(call, c, arg, p, emptyAp) and
            if
              PrevStage::callMayFlowThroughRev(call) and
              PrevStage::parameterMayFlowThrough(p, emptyAp)
            then
              emptyAp = true and
              flowThrough()
              or
              emptyAp = false and
              if allowsFieldFlowThrough(call, c) then flowThrough() else not flowThrough()
            else not flowThrough()
          }

          pragma[nomagic]
          private DataFlowCallable viableImplCallContextReducedRestricted(
            DataFlowCall call, CcCall ctx
          ) {
            result = viableImplCallContextReduced(call, ctx) and
            callEdgeArgParamRestricted(call, result, _, _, _)
          }

          bindingset[call, ctx]
          pragma[inline_late]
          private DataFlowCallable viableImplCallContextReducedInlineLate(
            DataFlowCall call, CcCall ctx
          ) {
            result = viableImplCallContextReducedRestricted(call, ctx)
          }

          bindingset[arg, ctx]
          pragma[inline_late]
          private DataFlowCallable viableImplCallContextReducedInlineLate(
            DataFlowCall call, ArgNodeEx arg, CcCall ctx
          ) {
            callEdgeArgParamRestricted(call, _, arg, _, _) and
            instanceofCcCall(ctx) and
            result = viableImplCallContextReducedInlineLate(call, ctx)
          }

          bindingset[call]
          pragma[inline_late]
          private predicate callEdgeArgParamRestrictedInlineLate(
            DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
          ) {
            callEdgeArgParamRestricted(call, c, arg, p, emptyAp)
          }

          bindingset[call, ctx]
          pragma[inline_late]
          private predicate viableImplNotCallContextReducedInlineLate(DataFlowCall call, Cc ctx) {
            instanceofCc(ctx) and
            viableImplNotCallContextReduced(call, ctx)
          }

          bindingset[arg, outercc]
          pragma[inline_late]
          private predicate viableImplArgNotCallContextReduced(
            DataFlowCall call, ArgNodeEx arg, Cc outercc
          ) {
            callEdgeArgParamRestricted(call, _, arg, _, _) and
            instanceofCc(outercc) and
            viableImplNotCallContextReducedInlineLate(call, outercc)
          }

          pragma[inline]
          private predicate fwdFlowInCand(
            DataFlowCall call, ArgNodeEx arg, FlowState state, Cc outercc, DataFlowCallable inner,
            ParamNodeEx p, SummaryCtx summaryCtx, Typ t, Ap ap, boolean emptyAp, TypOption stored,
            boolean cc
          ) {
            fwdFlowIntoArg(arg, state, outercc, summaryCtx, t, ap, emptyAp, stored, cc) and
            (
              inner = viableImplCallContextReducedInlineLate(call, arg, outercc)
              or
              viableImplArgNotCallContextReduced(call, arg, outercc)
            ) and
            not outBarrier(arg, state) and
            not inBarrier(p, state) and
            callEdgeArgParamRestrictedInlineLate(call, inner, arg, p, emptyAp)
          }

          pragma[inline]
          private predicate fwdFlowInCandTypeFlowDisabled(
            DataFlowCall call, ArgNodeEx arg, FlowState state, Cc outercc, DataFlowCallable inner,
            ParamNodeEx p, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, boolean cc
          ) {
            not enableTypeFlow() and
            fwdFlowInCand(call, arg, state, outercc, inner, p, summaryCtx, t, ap, _, stored, cc)
          }

          pragma[nomagic]
          private predicate fwdFlowInCandTypeFlowEnabled(
            DataFlowCall call, ArgNodeEx arg, Cc outercc, DataFlowCallable inner, ParamNodeEx p,
            boolean emptyAp, boolean cc
          ) {
            enableTypeFlow() and
            fwdFlowInCand(call, arg, _, outercc, inner, p, _, _, _, emptyAp, _, cc)
          }

          pragma[nomagic]
          private predicate fwdFlowInValidEdgeTypeFlowDisabled(
            DataFlowCall call, DataFlowCallable inner, CcCall innercc, boolean cc
          ) {
            not enableTypeFlow() and
            FwdTypeFlow::typeFlowValidEdgeIn(call, inner, cc) and
            innercc = getCallContextCall(call, inner)
          }

          pragma[nomagic]
          private predicate fwdFlowInValidEdgeTypeFlowEnabled(
            DataFlowCall call, ArgNodeEx arg, Cc outercc, DataFlowCallable inner, ParamNodeEx p,
            CcCall innercc, boolean emptyAp, boolean cc
          ) {
            fwdFlowInCandTypeFlowEnabled(call, arg, outercc, inner, p, emptyAp, cc) and
            FwdTypeFlow::typeFlowValidEdgeIn(call, inner, cc) and
            innercc = getCallContextCall(call, inner)
          }

          pragma[inline]
          predicate fwdFlowIn(
            DataFlowCall call, ArgNodeEx arg, DataFlowCallable inner, ParamNodeEx p,
            FlowState state, Cc outercc, CcCall innercc, SummaryCtx summaryCtx, Typ t, Ap ap,
            TypOption stored, boolean cc
          ) {
            // type flow disabled: linear recursion
            fwdFlowInCandTypeFlowDisabled(call, arg, state, outercc, inner, p, summaryCtx, t, ap,
              stored, cc) and
            fwdFlowInValidEdgeTypeFlowDisabled(call, inner, innercc, pragma[only_bind_into](cc))
            or
            // type flow enabled: non-linear recursion
            exists(boolean emptyAp |
              fwdFlowIntoArg(arg, state, outercc, summaryCtx, t, ap, emptyAp, stored, cc) and
              fwdFlowInValidEdgeTypeFlowEnabled(call, arg, outercc, inner, p, innercc, emptyAp, cc)
            )
          }
        }

        private predicate bottom() { none() }

        private module FwdFlowInNoThrough = FwdFlowIn<bottom/0>;

        pragma[nomagic]
        private predicate fwdFlowInNoFlowThrough(
          ParamNodeEx p, FlowState state, CcCall innercc, Typ t, Ap ap, TypOption stored
        ) {
          FwdFlowInNoThrough::fwdFlowIn(_, _, _, p, state, _, innercc, _, t, ap, stored, _)
        }

        private predicate top() { any() }

        private module FwdFlowInThrough = FwdFlowIn<top/0>;

        pragma[nomagic]
        private predicate fwdFlowInFlowThrough(
          ParamNodeEx p, FlowState state, CcCall innercc, Typ t, Ap ap, TypOption stored
        ) {
          FwdFlowInThrough::fwdFlowIn(_, _, _, p, state, _, innercc, _, t, ap, stored, _)
        }

        pragma[nomagic]
        private DataFlowCall viableImplCallContextReducedReverseRestricted(
          DataFlowCallable c, CcNoCall ctx
        ) {
          result = viableImplCallContextReducedReverse(c, ctx) and
          PrevStage::callEdgeReturn(result, c, _, _, _, _)
        }

        bindingset[c, ctx]
        pragma[inline_late]
        private DataFlowCall viableImplCallContextReducedReverseInlineLate(
          DataFlowCallable c, CcNoCall ctx
        ) {
          result = viableImplCallContextReducedReverseRestricted(c, ctx)
        }

        bindingset[call]
        pragma[inline_late]
        private predicate flowOutOfCallInlineLate(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow
        ) {
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow)
        }

        bindingset[c, ret, innercc]
        pragma[inline_late]
        pragma[noopt]
        private predicate flowOutOfCallNotCallContextReduced(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
          CcNoCall innercc
        ) {
          viableImplNotCallContextReducedReverse(innercc) and
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow)
        }

        pragma[nomagic]
        private predicate fwdFlowIntoRet(
          RetNodeEx ret, FlowState state, CcNoCall cc, SummaryCtx summaryCtx, Typ t, Ap ap,
          TypOption stored
        ) {
          instanceofCcNoCall(cc) and
          not outBarrier(ret, state) and
          fwdFlow(ret, state, cc, summaryCtx, t, ap, stored)
        }

        pragma[nomagic]
        private predicate fwdFlowOutCand(
          DataFlowCall call, RetNodeEx ret, CcNoCall innercc, DataFlowCallable inner, NodeEx out,
          boolean allowsFieldFlow
        ) {
          fwdFlowIntoRet(ret, _, innercc, _, _, _, _) and
          inner = ret.getEnclosingCallable() and
          (
            call = viableImplCallContextReducedReverseInlineLate(inner, innercc) and
            flowOutOfCallInlineLate(call, inner, ret, out, allowsFieldFlow)
            or
            flowOutOfCallNotCallContextReduced(call, inner, ret, out, allowsFieldFlow, innercc)
          )
        }

        pragma[nomagic]
        private predicate fwdFlowOutValidEdge(
          DataFlowCall call, RetNodeEx ret, CcNoCall innercc, DataFlowCallable inner, NodeEx out,
          CcNoCall outercc, boolean allowsFieldFlow
        ) {
          fwdFlowOutCand(call, ret, innercc, inner, out, allowsFieldFlow) and
          FwdTypeFlow::typeFlowValidEdgeOut(call, inner) and
          outercc = getCallContextReturn(inner, call)
        }

        pragma[inline]
        private predicate fwdFlowOut(
          DataFlowCall call, DataFlowCallable inner, NodeEx out, FlowState state, CcNoCall outercc,
          SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
        ) {
          exists(RetNodeEx ret, CcNoCall innercc, boolean allowsFieldFlow |
            fwdFlowIntoRet(ret, state, innercc, summaryCtx, t, ap, stored) and
            fwdFlowOutValidEdge(call, ret, innercc, inner, out, outercc, allowsFieldFlow) and
            not inBarrier(out, state) and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        private module FwdTypeFlowInput implements TypeFlowInput {
          predicate enableTypeFlow = Param::enableTypeFlow/0;

          predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

          predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

          pragma[nomagic]
          private predicate dataFlowTakenCallEdgeIn0(
            DataFlowCall call, DataFlowCallable c, ParamNodeEx p, FlowState state, CcCall innercc,
            Typ t, Ap ap, TypOption stored, boolean cc
          ) {
            FwdFlowInNoThrough::fwdFlowIn(call, _, c, p, state, _, innercc, _, t, ap, stored, cc)
            or
            FwdFlowInThrough::fwdFlowIn(call, _, c, p, state, _, innercc, _, t, ap, stored, cc)
          }

          pragma[nomagic]
          private predicate fwdFlow1Param(
            ParamNodeEx p, FlowState state, CcCall cc, Typ t0, Ap ap, TypOption stored
          ) {
            instanceofCcCall(cc) and
            fwdFlow1(p, state, cc, _, t0, _, ap, stored)
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeIn(DataFlowCall call, DataFlowCallable c, boolean cc) {
            exists(ParamNodeEx p, FlowState state, CcCall innercc, Typ t, Ap ap, TypOption stored |
              dataFlowTakenCallEdgeIn0(call, c, p, state, innercc, t, ap, stored, cc) and
              fwdFlow1Param(p, state, innercc, t, ap, stored)
            )
          }

          pragma[nomagic]
          private predicate dataFlowTakenCallEdgeOut0(
            DataFlowCall call, DataFlowCallable c, NodeEx node, FlowState state, Cc cc, Typ t,
            Ap ap, TypOption stored
          ) {
            fwdFlowOut(call, c, node, state, cc, _, t, ap, stored)
          }

          pragma[nomagic]
          private predicate fwdFlow1Out(
            NodeEx node, FlowState state, Cc cc, Typ t0, Ap ap, TypOption stored
          ) {
            fwdFlow1(node, state, cc, _, t0, _, ap, stored) and
            PrevStage::callEdgeReturn(_, _, _, _, node, _)
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
            exists(NodeEx node, FlowState state, Cc cc, Typ t, Ap ap, TypOption stored |
              dataFlowTakenCallEdgeOut0(call, c, node, state, cc, t, ap, stored) and
              fwdFlow1Out(node, state, cc, t, ap, stored)
            )
          }

          predicate dataFlowNonCallEntry(DataFlowCallable c, boolean cc) {
            exists(NodeEx node, FlowState state |
              sourceNode(node, state) and
              (if hasSourceCallCtx() then cc = true else cc = false) and
              PrevStage::revFlow(node, state, any(PrevStage::ApNil nil)) and
              c = node.getEnclosingCallable()
            )
            or
            exists(NodeEx node |
              cc = false and
              fwdFlowJump(node, _, _, _, _) and
              c = node.getEnclosingCallable()
            )
          }
        }

        private module FwdTypeFlow = TypeFlow<FwdTypeFlowInput>;

        private predicate flowIntoCallTaken(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
        ) {
          PrevStage::callEdgeArgParam(call, c, arg, p, emptyAp) and
          FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _)
        }

        pragma[nomagic]
        private predicate fwdFlowRetFromArg(
          RetNodeEx ret, FlowState state, CcCall ccc, SummaryCtxSome summaryCtx, Typ t, Ap ap,
          TypOption stored
        ) {
          exists(ReturnKindExt kind, ParamNodeEx p, Ap argAp |
            instanceofCcCall(ccc) and
            fwdFlow(pragma[only_bind_into](ret), state, ccc, summaryCtx, t, ap, stored) and
            summaryCtx =
              TSummaryCtxSome(pragma[only_bind_into](p), _, _, pragma[only_bind_into](argAp), _) and
            not outBarrier(ret, state) and
            kind = ret.getKind() and
            parameterFlowThroughAllowed(p, kind) and
            PrevStage::returnMayFlowThrough(ret, kind)
          )
        }

        pragma[inline]
        private predicate fwdFlowThrough0(
          DataFlowCall call, ArgNodeEx arg, Cc cc, FlowState state, CcCall ccc,
          SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, RetNodeEx ret,
          SummaryCtxSome innerSummaryCtx
        ) {
          fwdFlowRetFromArg(ret, state, ccc, innerSummaryCtx, t, ap, stored) and
          fwdFlowIsEntered(call, arg, cc, ccc, summaryCtx, innerSummaryCtx)
        }

        pragma[nomagic]
        private predicate fwdFlowThrough(
          DataFlowCall call, Cc cc, FlowState state, SummaryCtx summaryCtx, Typ t, Ap ap,
          TypOption stored, RetNodeEx ret
        ) {
          fwdFlowThrough0(call, _, cc, state, _, summaryCtx, t, ap, stored, ret, _)
        }

        pragma[nomagic]
        private predicate fwdFlowIsEntered0(
          DataFlowCall call, ArgNodeEx arg, Cc cc, CcCall innerCc, SummaryCtx summaryCtx,
          ParamNodeEx p, FlowState state, Typ t, Ap ap, TypOption stored
        ) {
          FwdFlowInThrough::fwdFlowIn(call, arg, _, p, state, cc, innerCc, summaryCtx, t, ap,
            stored, _)
        }

        /**
         * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`
         * and data might flow through the target callable and back out at `call`.
         */
        pragma[nomagic]
        private predicate fwdFlowIsEntered(
          DataFlowCall call, ArgNodeEx arg, Cc cc, CcCall innerCc, SummaryCtx summaryCtx,
          SummaryCtxSome innerSummaryCtx
        ) {
          exists(ParamNodeEx p, FlowState state, Typ t, Ap ap, TypOption stored |
            fwdFlowIsEntered0(call, arg, cc, innerCc, summaryCtx, p, state, t, ap, stored) and
            innerSummaryCtx = TSummaryCtxSome(p, state, t, ap, stored)
          )
        }

        pragma[nomagic]
        private predicate storeStepFwd(NodeEx node1, Ap ap1, Content c, NodeEx node2, Ap ap2) {
          fwdFlowStore(node1, _, ap1, _, c, _, _, node2, _, _, _) and
          readStepFwd(_, ap2, c, _, ap1)
        }

        pragma[nomagic]
        private predicate readStepFwd(NodeEx n1, Ap ap1, Content c, NodeEx n2, Ap ap2) {
          fwdFlowRead(n1, _, ap1, _, c, n2, _, ap2, _, _, _, _)
        }

        pragma[nomagic]
        private predicate returnFlowsThrough0(
          DataFlowCall call, FlowState state, CcCall ccc, Ap ap, RetNodeEx ret,
          SummaryCtxSome innerSummaryCtx
        ) {
          fwdFlowThrough0(call, _, _, state, ccc, _, _, ap, _, ret, innerSummaryCtx)
        }

        pragma[nomagic]
        private predicate returnFlowsThrough(
          RetNodeEx ret, ReturnPosition pos, FlowState state, CcCall ccc, ParamNodeEx p, Typ argT,
          Ap argAp, TypOption argStored, Ap ap
        ) {
          exists(DataFlowCall call, boolean allowsFieldFlow |
            returnFlowsThrough0(call, state, ccc, ap, ret,
              TSummaryCtxSome(p, _, argT, argAp, argStored)) and
            flowThroughOutOfCall(call, ret, _, allowsFieldFlow) and
            pos = ret.getReturnPosition() and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        pragma[nomagic]
        private predicate flowThroughIntoCall(
          DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, Ap argAp
        ) {
          exists(Typ argT, TypOption argStored |
            returnFlowsThrough(_, _, _, _, pragma[only_bind_into](p), pragma[only_bind_into](argT),
              pragma[only_bind_into](argAp), pragma[only_bind_into](argStored), _) and
            flowIntoCallTaken(call, _, pragma[only_bind_into](arg), p, isNil(argAp)) and
            fwdFlow(arg, _, _, _, pragma[only_bind_into](argT), pragma[only_bind_into](argAp),
              pragma[only_bind_into](argStored))
          )
        }

        pragma[nomagic]
        private predicate flowIntoCallAp(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, Ap ap
        ) {
          flowIntoCallTaken(call, c, arg, p, isNil(ap)) and
          fwdFlow(arg, _, _, _, _, ap, _)
        }

        pragma[nomagic]
        private predicate flowOutOfCallAp(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnPosition pos, NodeEx out,
          Ap ap, boolean allowsFieldFlow
        ) {
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow) and
          fwdFlow(ret, _, _, _, _, ap, _) and
          pos = ret.getReturnPosition() and
          (if allowsFieldFlow = false then ap instanceof ApNil else any()) and
          (
            // both directions are needed for flow-through
            FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
            FwdTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
          )
        }

        /**
         * Holds if `node` with access path `ap` is part of a path from a source to a
         * sink.
         *
         * The parameter `returnCtx` records whether (and how) the node must be returned
         * from the enclosing callable in order to reach a sink, and if so, `returnAp`
         * records the access path of the returned value.
         */
        pragma[nomagic]
        additional predicate revFlow(
          NodeEx node, FlowState state, ReturnCtx returnCtx, ApOption returnAp, Ap ap
        ) {
          revFlow0(node, state, returnCtx, returnAp, ap) and
          fwdFlow(node, state, _, _, _, ap, _)
        }

        pragma[nomagic]
        private predicate revFlow0(
          NodeEx node, FlowState state, ReturnCtx returnCtx, ApOption returnAp, Ap ap
        ) {
          fwdFlow(node, state, _, _, _, ap, _) and
          sinkNode(node, state) and
          (
            if hasSinkCallCtx()
            then returnCtx = TReturnCtxNoFlowThrough()
            else returnCtx = TReturnCtxNone()
          ) and
          returnAp = apNone() and
          ap instanceof ApNil
          or
          exists(NodeEx mid, FlowState state0 |
            localStep(node, state, mid, state0, true, _, _, _) and
            revFlow(mid, state0, returnCtx, returnAp, ap)
          )
          or
          exists(NodeEx mid, FlowState state0 |
            localStep(node, pragma[only_bind_into](state), mid, state0, false, _, _, _) and
            revFlow(mid, state0, returnCtx, returnAp, ap) and
            ap instanceof ApNil
          )
          or
          revFlowJump(node, state, ap) and
          returnCtx = TReturnCtxNone() and
          returnAp = apNone()
          or
          // store
          exists(Ap ap0, Content c |
            revFlowStore(ap0, c, ap, node, state, _, returnCtx, returnAp) and
            revFlowConsCand(ap0, c, ap)
          )
          or
          // read
          exists(NodeEx mid, Ap ap0 |
            revFlow(mid, state, returnCtx, returnAp, ap0) and
            readStepFwd(node, ap, _, mid, ap0)
          )
          or
          // flow into a callable
          revFlowIn(_, _, node, state, ap) and
          returnCtx = TReturnCtxNone() and
          returnAp = apNone()
          or
          // flow through a callable
          exists(DataFlowCall call, ParamNodeEx p |
            revFlowThrough(call, returnCtx, p, state, returnAp, ap) and
            flowThroughIntoCall(call, node, p, ap)
          )
          or
          // flow out of a callable
          exists(ReturnPosition pos |
            revFlowOut(_, node, pos, state, _, _, _, ap) and
            if returnFlowsThrough(node, pos, state, _, _, _, _, _, ap)
            then (
              returnCtx = TReturnCtxMaybeFlowThrough(pos) and
              returnAp = apSome(ap)
            ) else (
              returnCtx = TReturnCtxNoFlowThrough() and returnAp = apNone()
            )
          )
        }

        private predicate revFlowJump(NodeEx node, FlowState state, Ap ap) {
          exists(NodeEx mid |
            jumpStepEx(node, mid) and
            revFlow(mid, state, _, _, ap)
          )
          or
          exists(NodeEx mid |
            additionalJumpStep(node, mid, _) and
            revFlow(pragma[only_bind_into](mid), state, _, _, ap) and
            ap instanceof ApNil
          )
          or
          exists(NodeEx mid, FlowState state0 |
            additionalJumpStateStep(node, state, mid, state0, _) and
            revFlow(pragma[only_bind_into](mid), pragma[only_bind_into](state0), _, _, ap) and
            ap instanceof ApNil
          )
        }

        pragma[nomagic]
        private predicate revFlowStore(
          Ap ap0, Content c, Ap ap, NodeEx node, FlowState state, NodeEx mid, ReturnCtx returnCtx,
          ApOption returnAp
        ) {
          revFlow(mid, state, returnCtx, returnAp, ap0) and
          storeStepFwd(node, ap, c, mid, ap0)
        }

        /**
         * Holds if reverse flow with access path `tail` reaches a read of `c`
         * resulting in access path `cons`.
         */
        pragma[nomagic]
        private predicate revFlowConsCand(Ap cons, Content c, Ap tail) {
          exists(NodeEx mid, Ap tail0 |
            revFlow(mid, _, _, _, tail) and
            tail = pragma[only_bind_into](tail0) and
            readStepFwd(_, cons, c, mid, tail0)
          )
        }

        private module RevTypeFlowInput implements TypeFlowInput {
          predicate enableTypeFlow = Param::enableTypeFlow/0;

          predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c) {
            flowOutOfCallAp(call, c, _, _, _, _, _)
          }

          predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
            flowIntoCallAp(call, c, _, _, _)
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeIn(DataFlowCall call, DataFlowCallable c, boolean cc) {
            exists(RetNodeEx ret |
              revFlowOut(call, ret, _, _, _, cc, _, _) and
              c = ret.getEnclosingCallable()
            )
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
            revFlowIn(call, c, _, _, _)
          }

          predicate dataFlowNonCallEntry(DataFlowCallable c, boolean cc) {
            exists(NodeEx node, FlowState state, ApNil nil |
              fwdFlow(node, state, _, _, _, nil, _) and
              sinkNode(node, state) and
              (if hasSinkCallCtx() then cc = true else cc = false) and
              c = node.getEnclosingCallable()
            )
            or
            exists(NodeEx node |
              cc = false and
              revFlowJump(node, _, _) and
              c = node.getEnclosingCallable()
            )
          }
        }

        private module RevTypeFlow = TypeFlow<RevTypeFlowInput>;

        pragma[nomagic]
        private predicate flowIntoCallApValid(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, Ap ap
        ) {
          flowIntoCallAp(call, c, arg, p, ap) and
          RevTypeFlow::typeFlowValidEdgeOut(call, c)
        }

        pragma[nomagic]
        private predicate flowOutOfCallApValid(
          DataFlowCall call, RetNodeEx ret, ReturnPosition pos, NodeEx out, Ap ap, boolean cc
        ) {
          exists(DataFlowCallable c |
            flowOutOfCallAp(call, c, ret, pos, out, ap, _) and
            RevTypeFlow::typeFlowValidEdgeIn(call, c, cc)
          )
        }

        private predicate revFlowIn(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, FlowState state, Ap ap
        ) {
          exists(ParamNodeEx p |
            revFlow(p, state, TReturnCtxNone(), _, ap) and
            flowIntoCallApValid(call, c, arg, p, ap)
          )
        }

        pragma[nomagic]
        private predicate revFlowOut(
          DataFlowCall call, RetNodeEx ret, ReturnPosition pos, FlowState state,
          ReturnCtx returnCtx, boolean cc, ApOption returnAp, Ap ap
        ) {
          exists(NodeEx out |
            revFlow(out, state, returnCtx, returnAp, ap) and
            flowOutOfCallApValid(call, ret, pos, out, ap, cc) and
            if returnCtx instanceof TReturnCtxNone then cc = false else cc = true
          )
        }

        pragma[nomagic]
        private predicate revFlowParamToReturn(
          ParamNodeEx p, FlowState state, ReturnPosition pos, Ap returnAp, Ap ap
        ) {
          revFlow(pragma[only_bind_into](p), state, TReturnCtxMaybeFlowThrough(pos),
            apSome(returnAp), pragma[only_bind_into](ap)) and
          parameterFlowThroughAllowed(p, pos.getKind()) and
          PrevStage::parameterMayFlowThrough(p, isNil(ap))
        }

        pragma[nomagic]
        private predicate revFlowThrough(
          DataFlowCall call, ReturnCtx returnCtx, ParamNodeEx p, FlowState state, ApOption returnAp,
          Ap ap
        ) {
          exists(ReturnPosition pos, Ap innerReturnAp |
            revFlowParamToReturn(p, state, pos, innerReturnAp, ap) and
            revFlowIsReturned(call, returnCtx, returnAp, pos, innerReturnAp)
          )
        }

        /**
         * Holds if an output from `call` is reached in the flow covered by `revFlow`
         * and data might flow through the target callable resulting in reverse flow
         * reaching an argument of `call`.
         */
        pragma[nomagic]
        private predicate revFlowIsReturned(
          DataFlowCall call, ReturnCtx returnCtx, ApOption returnAp, ReturnPosition pos, Ap ap
        ) {
          exists(RetNodeEx ret, FlowState state, CcCall ccc |
            revFlowOut(call, ret, pos, state, returnCtx, _, returnAp, ap) and
            returnFlowsThrough(ret, pos, state, ccc, _, _, _, _, ap) and
            matchesCall(ccc, call)
          )
        }

        pragma[nomagic]
        predicate storeStepCand(
          NodeEx node1, Content c, NodeEx node2, DataFlowType contentType,
          DataFlowType containerType
        ) {
          exists(Ap ap2, Ap ap1 |
            PrevStage::storeStepCand(node1, c, node2, contentType, containerType) and
            revFlowStore(ap2, c, ap1, node1, _, node2, _, _) and
            revFlowConsCand(ap2, c, ap1)
          )
        }

        predicate readStepCand(NodeEx node1, Content c, NodeEx node2) {
          exists(Ap ap1, Ap ap2 |
            revFlow(node2, _, _, _, pragma[only_bind_into](ap2)) and
            readStepFwd(node1, ap1, c, node2, ap2) and
            revFlowStore(ap1, c, pragma[only_bind_into](ap2), _, _, _, _, _)
          )
        }

        predicate revFlow(NodeEx node, FlowState state, Ap ap) { revFlow(node, state, _, _, ap) }

        pragma[nomagic]
        predicate revFlow(NodeEx node) { revFlow(node, _, _, _, _) }

        private predicate fwdConsCand(Content c, Ap ap) { storeStepFwd(_, ap, c, _, _) }

        private predicate revConsCand(Content c, Ap ap) {
          exists(Ap ap2 |
            revFlowStore(ap2, c, ap, _, _, _, _, _) and
            revFlowConsCand(ap2, c, ap)
          )
        }

        private predicate validAp(Ap ap) {
          revFlow(_, _, _, _, ap) and ap instanceof ApNil
          or
          exists(Content head, Ap tail |
            consCand(head, tail) and
            ap = apCons(head, tail)
          )
        }

        additional predicate consCand(Content c, Ap ap) {
          revConsCand(c, ap) and
          validAp(ap)
        }

        pragma[nomagic]
        private predicate parameterFlowsThroughRev(
          ParamNodeEx p, Ap ap, ReturnPosition pos, Ap returnAp
        ) {
          revFlow(p, _, TReturnCtxMaybeFlowThrough(pos), apSome(returnAp), ap) and
          parameterFlowThroughAllowed(p, pos.getKind())
        }

        pragma[nomagic]
        private predicate parameterMayFlowThroughAp(ParamNodeEx p, Ap ap) {
          exists(ReturnPosition pos |
            returnFlowsThrough(_, pos, _, _, p, _, ap, _, _) and
            parameterFlowsThroughRev(p, ap, pos, _)
          )
        }

        pragma[nomagic]
        predicate parameterMayFlowThrough(ParamNodeEx p, boolean emptyAp) {
          exists(Ap ap |
            parameterMayFlowThroughAp(p, ap) and
            emptyAp = isNil(ap)
          )
        }

        pragma[nomagic]
        private predicate nodeMayUseSummary0(NodeEx n, ParamNodeEx p, FlowState state, Ap ap) {
          exists(Ap ap0 |
            parameterMayFlowThrough(p, _) and
            revFlow(n, state, TReturnCtxMaybeFlowThrough(_), _, ap0) and
            fwdFlow(n, state, any(CcCall ccc), TSummaryCtxSome(p, _, _, ap, _), _, ap0, _)
          )
        }

        /**
         * Holds if `ap` is recorded as the summary context for flow reaching `node`
         * and remains relevant for the following pruning stage.
         */
        pragma[nomagic]
        additional predicate nodeMayUseSummary(NodeEx n, FlowState state, Ap ap) {
          exists(ParamNodeEx p |
            parameterMayFlowThroughAp(p, ap) and
            nodeMayUseSummary0(n, p, state, ap)
          )
        }

        pragma[nomagic]
        predicate returnMayFlowThrough(RetNodeEx ret, ReturnKindExt kind) {
          exists(ParamNodeEx p, ReturnPosition pos, Ap argAp, Ap ap |
            returnFlowsThrough(ret, pos, _, _, p, _, argAp, _, ap) and
            parameterFlowsThroughRev(p, argAp, pos, ap) and
            kind = pos.getKind()
          )
        }

        pragma[nomagic]
        private predicate revFlowThroughArg(
          DataFlowCall call, ArgNodeEx arg, FlowState state, ReturnCtx returnCtx, ApOption returnAp,
          Ap ap
        ) {
          exists(ParamNodeEx p |
            revFlowThrough(call, returnCtx, p, state, returnAp, ap) and
            flowThroughIntoCall(call, arg, p, ap)
          )
        }

        pragma[nomagic]
        predicate callMayFlowThroughRev(DataFlowCall call) {
          exists(ArgNodeEx arg, FlowState state, ReturnCtx returnCtx, ApOption returnAp, Ap ap |
            revFlow(arg, state, returnCtx, returnAp, ap) and
            revFlowThroughArg(call, arg, state, returnCtx, returnAp, ap)
          )
        }

        predicate callEdgeArgParam(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
        ) {
          exists(FlowState state, Ap ap |
            flowIntoCallAp(call, c, arg, p, ap) and
            revFlow(arg, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            revFlow(p, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            emptyAp = isNil(ap)
          |
            // both directions are needed for flow-through
            RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
            RevTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
          )
        }

        predicate callEdgeReturn(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
          boolean allowsFieldFlow
        ) {
          exists(FlowState state, ReturnPosition pos, Ap ap |
            flowOutOfCallAp(call, c, ret, pos, out, ap, allowsFieldFlow) and
            revFlow(ret, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            revFlow(out, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            kind = pos.getKind() and
            RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _)
          )
        }

        predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c) {
          callEdgeArgParam(call, c, _, _, _)
        }

        predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
          callEdgeReturn(call, c, _, _, _, _)
        }

        /** Holds if `node1` can step to `node2` in one or more local steps. */
        bindingset[node1, state1]
        bindingset[node2, state2]
        signature predicate localStepSig(
          NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
          DataFlowType t, LocalCallContext lcc, string label
        );

        /**
         * Provides a big-step relation for local flow steps.
         *
         * The big-step releation is based on the `localStepInput` relation,
         * restricted to nodes that are forwards and backwards reachable in
         * this stage.
         */
        additional module LocalFlowBigStep<localStepSig/8 localStepInput> {
          /**
           * A node where some checking is required, and hence the big-step relation
           * is not allowed to step over.
           */
          private class FlowCheckNode extends NodeEx {
            FlowCheckNode() {
              revFlow(this) and
              (
                flowCheckNode(this) or
                Config::neverSkip(this.asNode())
              )
            }
          }

          private predicate additionalLocalStateStep(
            NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, DataFlowType t,
            LocalCallContext lcc, string label
          ) {
            exists(ApNil nil |
              revFlow(node1, state1, pragma[only_bind_into](nil)) and
              revFlow(node2, state2, pragma[only_bind_into](nil)) and
              localStepInput(node1, state1, node2, state2, false, t, lcc, label) and
              state1 != state2
            )
          }

          /**
           * Holds if `node` can be the first node in a maximal subsequence of local
           * flow steps in a dataflow path.
           */
          private predicate localFlowEntry(NodeEx node, FlowState state, Ap ap) {
            revFlow(node, state, ap) and
            (
              sourceNode(node, state)
              or
              jumpStepEx(_, node)
              or
              additionalJumpStep(_, node, _)
              or
              additionalJumpStateStep(_, _, node, state, _)
              or
              node instanceof ParamNodeEx
              or
              node instanceof OutNodeEx
              or
              storeStepCand(_, _, node, _, _)
              or
              readStepCand(_, _, node)
              or
              node instanceof FlowCheckNode
              or
              exists(FlowState s |
                additionalLocalStateStep(_, s, node, state, _, _, _) and
                s != state
              )
            )
          }

          /**
           * Holds if `node` can be the last node in a maximal subsequence of local
           * flow steps in a dataflow path.
           */
          private predicate localFlowExit(NodeEx node, FlowState state, Ap ap) {
            revFlow(node, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            (
              exists(NodeEx next, Ap apNext | revFlow(next, pragma[only_bind_into](state), apNext) |
                jumpStepEx(node, next) and
                apNext = ap
                or
                additionalJumpStep(node, next, _) and
                apNext = ap and
                ap instanceof ApNil
                or
                callEdgeArgParam(_, _, node, next, _) and
                apNext = ap
                or
                callEdgeReturn(_, _, node, _, next, _) and
                apNext = ap
                or
                storeStepCand(node, _, next, _, _)
                or
                readStepCand(node, _, next)
              )
              or
              exists(NodeEx next, FlowState s |
                revFlow(next, s, pragma[only_bind_into](ap)) and ap instanceof ApNil
              |
                additionalJumpStateStep(node, state, next, s, _)
                or
                additionalLocalStateStep(node, state, next, s, _) and
                s != state
              )
              or
              node instanceof FlowCheckNode
              or
              sinkNode(node, state) and
              ap instanceof ApNil
            )
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
            LocalCallContext cc, string label
          ) {
            not inBarrier(node2, state) and
            not outBarrier(node1, state) and
            exists(NodeEx mid, boolean preservesValue2, DataFlowType t2, string label2, Ap ap |
              localStepInput(mid, state, node2, state, preservesValue2, t2, cc, label2) and
              revFlow(node2, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
              not outBarrier(mid, state) and
              (preservesValue = true or ap instanceof ApNil)
            |
              node1 = mid and
              localFlowEntry(node1, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
              preservesValue = preservesValue2 and
              label = label2 and
              t = t2 and
              node1 != node2
              or
              exists(boolean preservesValue1, DataFlowType t1, string label1 |
                localFlowStepPlus(node1, pragma[only_bind_into](state), mid, preservesValue1, t1,
                  cc, label1) and
                not mid instanceof FlowCheckNode and
                preservesValue = preservesValue2.booleanAnd(preservesValue1) and
                label = mergeLabels(label1, label2) and
                if preservesValue2 = true then t = t1 else t = t2
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
            DataFlowType t, LocalCallContext callContext, string label
          ) {
            exists(Ap ap |
              localFlowStepPlus(node1, state1, node2, preservesValue, t, callContext, label) and
              localFlowExit(node2, state1, ap) and
              state1 = state2 and
              node1 != node2
            |
              preservesValue = true or ap instanceof ApNil
            )
            or
            additionalLocalStateStep(node1, state1, node2, state2, t, callContext, label) and
            preservesValue = false
          }

          /**
           * Holds if `node1` can step to `node2` in one or more local steps and this
           * path can occur as a maximal subsequence of local steps in a dataflow path.
           *
           * This predicate should be used when `localStepInput` is already a big-step
           * relation, which will do the same as `localFlowBigStep`, but avoids potential
           * worst-case quadratic complexity.
           */
          pragma[nomagic]
          predicate localFlowBigStepTc(
            NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
            DataFlowType t, LocalCallContext callContext, string label
          ) {
            exists(Ap ap |
              localFlowEntry(node1, pragma[only_bind_into](state1), pragma[only_bind_into](ap)) and
              localStepInput(node1, state1, node2, state2, preservesValue, t, callContext, label) and
              localFlowExit(node2, pragma[only_bind_into](state2), pragma[only_bind_into](ap)) and
              state1 = state2
            |
              preservesValue = true or ap instanceof ApNil
            )
            or
            additionalLocalStateStep(node1, state1, node2, state2, t, callContext, label) and
            preservesValue = false
          }
        }

        /**
         * Provides a graph representation of the data flow in this stage suitable for use in a `path-problem` query.
         */
        additional module Graph {
          private newtype TPathNode =
            TPathNodeMid(
              NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap,
              TypOption stored
            ) {
              fwdFlow(node, state, cc, summaryCtx, t, ap, stored) and
              revFlow(node, state, _, _, ap)
            } or
            TPathNodeSink(NodeEx node, FlowState state) {
              exists(PathNodeMid sink |
                sink.isAtSink() and
                node = sink.toNormalSinkNodeEx() and
                state = sink.getState()
              )
            } or
            TPathNodeSrcGrp() or
            TPathNodeSinkGrp()

          class PathNodeImpl extends TPathNode {
            abstract NodeEx getNodeEx();

            /** Gets the `FlowState` of this node. */
            abstract FlowState getState();

            /** Holds if this node is a source. */
            abstract predicate isSource();

            /** Holds if this node is a sink. */
            predicate isSink() { this instanceof TPathNodeSink }

            abstract PathNodeImpl getASuccessorImpl(string label);

            pragma[nomagic]
            PathNodeImpl getAnImplicitReadSuccessorAtSink(string label) {
              exists(PathNodeMid readTarget |
                result = this.getASuccessorImpl(_) and
                localStep(this, readTarget, _) and
                readTarget.getNodeEx().isImplicitReadNode(_)
              |
                // last implicit read, leaving the access path empty
                result = readTarget.projectToSink(label)
                or
                // implicit read, leaving the access path non-empty
                exists(result.getAnImplicitReadSuccessorAtSink(label)) and
                result = readTarget
              )
            }

            private PathNodeImpl getASuccessorIfHidden(string label) {
              this.isHidden() and
              result = this.getASuccessorImpl(label)
              or
              result = this.getAnImplicitReadSuccessorAtSink(label)
            }

            private PathNodeImpl getASuccessorFromNonHidden(string label) {
              result = this.getASuccessorImpl(label) and
              not this.isHidden() and
              // In cases like
              //
              // ```
              // x.Field = taint;
              // Sink(x);
              // ```
              //
              // we only want the direct edge
              //
              //  `[post update] x [Field]` -> `x`
              //
              // and not the two edges
              //
              //  `[post update] x [Field]` -> `x [Field]`
              //  `x [Field]`               -> `x`
              //
              // which the restriction below ensures.
              not result = this.getAnImplicitReadSuccessorAtSink(_)
              or
              exists(string l1, string l2 |
                result = this.getASuccessorFromNonHidden(l1).getASuccessorIfHidden(l2) and
                label = mergeLabels(l1, l2)
              )
            }

            final PathNodeImpl getANonHiddenSuccessor(string label) {
              result = this.getASuccessorFromNonHidden(label) and not result.isHidden()
            }

            predicate isHidden() {
              not Config::includeHiddenNodes() and
              hiddenNode(this.getNodeEx()) and
              not this.isSource() and
              not this instanceof PathNodeSink
            }

            /** Gets a textual representation of this element. */
            abstract string toString();

            /** Gets the location of this node. */
            Location getLocation() { result = this.getNodeEx().getLocation() }

            predicate isArbitrarySource() { this instanceof TPathNodeSrcGrp }

            predicate isArbitrarySink() { this instanceof TPathNodeSinkGrp }
          }

          private class PathNodeSrcGrp extends PathNodeImpl, TPathNodeSrcGrp {
            override string toString() { result = "<any source>" }

            override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }

            override NodeEx getNodeEx() { none() }

            override FlowState getState() { none() }

            override PathNodeImpl getASuccessorImpl(string label) {
              result.isSource() and label = ""
            }

            override predicate isSource() { none() }
          }

          private class PathNodeSinkGrp extends PathNodeImpl, TPathNodeSinkGrp {
            override string toString() { result = "<any sink>" }

            override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }

            override NodeEx getNodeEx() { none() }

            override FlowState getState() { none() }

            override PathNodeImpl getASuccessorImpl(string label) { none() }

            override predicate isSource() { none() }
          }

          /**
           * An intermediate flow graph node. This is a tuple consisting of a node,
           * a `FlowState`, a call context, a summary context, a tracked type, and an access path.
           */
          private class PathNodeMid extends PathNodeImpl, TPathNodeMid {
            NodeEx node;
            FlowState state;
            Cc cc;
            SummaryCtx summaryCtx;
            Typ t;
            Ap ap;
            TypOption stored;

            PathNodeMid() { this = TPathNodeMid(node, state, cc, summaryCtx, t, ap, stored) }

            override NodeEx getNodeEx() { result = node }

            override FlowState getState() { result = state }

            private PathNodeMid getSuccMid(string label) {
              localStep(this, result, label)
              or
              nonLocalStep(this, result, label)
            }

            private predicate isSourceWithLabel(string labelprefix) {
              exists(string model |
                this.isSource() and
                sourceModel(node, model) and
                model != "" and
                labelprefix = "Src:" + model + " "
              )
            }

            /** If this node corresponds to a sink, gets the normal node for that sink. */
            pragma[nomagic]
            NodeEx toNormalSinkNodeEx() {
              exists(Node n |
                pragma[only_bind_out](node.asNodeOrImplicitRead()) = n and
                (isRelevantSink(n) or isRelevantSink(n, _)) and
                result.asNode() = n
              )
            }

            override PathNodeImpl getASuccessorImpl(string label) {
              // an intermediate step to another intermediate node
              exists(string l2 | result = this.getSuccMid(l2) |
                not this.isSourceWithLabel(_) and label = l2
                or
                exists(string l1 |
                  this.isSourceWithLabel(l1) and
                  label = l1 + l2
                )
              )
              or
              // a final step to a sink
              exists(string l2, string sinkLabel |
                result = this.getSuccMid(l2).projectToSink(sinkLabel)
              |
                not this.isSourceWithLabel(_) and
                label = mergeLabels(l2, sinkLabel)
                or
                exists(string l1 |
                  this.isSourceWithLabel(l1) and
                  label = l1 + mergeLabels(l2, sinkLabel)
                )
              )
            }

            private string ppType() {
              exists(string ppt | ppt = t.toString() |
                if ppt = "" then result = "" else result = " : " + ppt
              )
            }

            private string ppAp() {
              exists(string s | s = ap.toString() |
                if s = "" then result = "" else result = " " + s
              )
            }

            private string ppCtx() { result = " <" + cc + ">" }

            private string ppSummaryCtx() {
              summaryCtx instanceof SummaryCtxNone and result = ""
              or
              summaryCtx instanceof SummaryCtxSome and
              result = " <" + summaryCtx + ">"
            }

            override string toString() {
              result = node.toString() + this.ppType() + this.ppAp() + ppStored(stored)
            }

            /**
             * Gets a textual representation of this element, including a textual
             * representation of the call context.
             */
            string toStringWithContext() {
              result =
                node.toString() + this.ppType() + this.ppAp() + ppStored(stored) + this.ppCtx() +
                  this.ppSummaryCtx()
            }

            override predicate isSource() {
              sourceNode(node, state) and
              (if hasSourceCallCtx() then cc = ccSomeCall() else cc = ccNone()) and
              summaryCtx = TSummaryCtxNone() and
              t = getNodeTyp(node) and
              ap instanceof ApNil
            }

            predicate isAtSink() {
              sinkNode(node, state) and
              ap instanceof ApNil and
              // For `FeatureHasSinkCallContext` the condition `cc instanceof CallContextNoCall`
              // is exactly what we need to check.
              // For `FeatureEqualSourceSinkCallContext` the initial call
              // context was set to `CallContextSomeCall` and jumps are
              // disallowed, so `cc instanceof CallContextNoCall` never holds.
              // On the other hand, in this case there's never any need to
              // enter a call except to identify a summary, so the condition in
              // conjunction with setting the summary context enforces this,
              // which means that the summary context being empty holds if and
              // only if we are in the call context of the source.
              if Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
              then summaryCtx = TSummaryCtxNone()
              else
                if Config::getAFeature() instanceof FeatureHasSinkCallContext
                then instanceofCcNoCall(cc)
                else any()
            }

            PathNodeSink projectToSink(string label) {
              exists(string model |
                this.isAtSink() and
                sinkModel(node, model) and
                result.getNodeEx() = this.toNormalSinkNodeEx() and
                result.getState() = state and
                if model != "" then label = "Sink:" + model else label = ""
              )
            }
          }

          /**
           * A flow graph node corresponding to a sink. This is disjoint from the
           * intermediate nodes in order to uniquely correspond to a given sink by
           * excluding the call context.
           */
          private class PathNodeSink extends PathNodeImpl, TPathNodeSink {
            NodeEx node;
            FlowState state;

            PathNodeSink() { this = TPathNodeSink(node, state) }

            override NodeEx getNodeEx() { result = node }

            override FlowState getState() { result = state }

            override string toString() { result = node.toString() }

            override PathNodeImpl getASuccessorImpl(string label) {
              result.isArbitrarySink() and label = ""
            }

            override predicate isSource() { sourceNode(node, state) }
          }

          bindingset[p, state, t, ap, stored]
          pragma[inline_late]
          private SummaryCtxSome mkSummaryCtxSome(
            ParamNodeEx p, FlowState state, Typ t, Ap ap, TypOption stored
          ) {
            result = TSummaryCtxSome(p, state, t, ap, stored)
          }

          pragma[nomagic]
          private predicate fwdFlowInStep(
            ArgNodeEx arg, ParamNodeEx p, FlowState state, Cc outercc, CcCall innercc,
            SummaryCtx outerSummaryCtx, SummaryCtx innerSummaryCtx, Typ t, Ap ap, TypOption stored
          ) {
            FwdFlowInNoThrough::fwdFlowIn(_, arg, _, p, state, outercc, innercc, outerSummaryCtx, t,
              ap, stored, _) and
            innerSummaryCtx = TSummaryCtxNone()
            or
            FwdFlowInThrough::fwdFlowIn(_, arg, _, p, state, outercc, innercc, outerSummaryCtx, t,
              ap, stored, _) and
            innerSummaryCtx = mkSummaryCtxSome(p, state, t, ap, stored)
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep0(
            DataFlowCall call, ArgNodeEx arg, Cc cc, FlowState state, CcCall ccc,
            SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, RetNodeEx ret,
            SummaryCtxSome innerSummaryCtx
          ) {
            fwdFlowThrough0(call, arg, cc, state, ccc, summaryCtx, t, ap, stored, ret,
              innerSummaryCtx)
          }

          bindingset[node, state, cc, summaryCtx, t, ap, stored]
          pragma[inline_late]
          private PathNodeImpl mkPathNode(
            NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap,
            TypOption stored
          ) {
            result = TPathNodeMid(node, state, cc, summaryCtx, t, ap, stored)
          }

          private PathNodeImpl typeStrengthenToPathNode(
            NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap,
            TypOption stored
          ) {
            exists(Typ t |
              fwdFlow1(node, state, cc, summaryCtx, t0, t, ap, stored) and
              result = TPathNodeMid(node, state, cc, summaryCtx, t, ap, stored)
            )
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep1(
            PathNodeImpl pn1, PathNodeImpl pn2, PathNodeImpl pn3, DataFlowCall call, Cc cc,
            FlowState state, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, RetNodeEx ret
          ) {
            exists(
              FlowState state0, ArgNodeEx arg, SummaryCtxSome innerSummaryCtx, ParamNodeEx p,
              Typ innerArgT, Ap innerArgAp, TypOption innerArgStored, CcCall ccc
            |
              fwdFlowThroughStep0(call, arg, cc, state, ccc, summaryCtx, t, ap, stored, ret,
                innerSummaryCtx) and
              innerSummaryCtx = TSummaryCtxSome(p, state0, innerArgT, innerArgAp, innerArgStored) and
              pn1 = mkPathNode(arg, state0, cc, summaryCtx, innerArgT, innerArgAp, innerArgStored) and
              pn2 =
                typeStrengthenToPathNode(p, state0, ccc, innerSummaryCtx, innerArgT, innerArgAp,
                  innerArgStored) and
              pn3 = mkPathNode(ret, state, ccc, innerSummaryCtx, t, ap, stored)
            )
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep2(
            PathNodeImpl pn1, PathNodeImpl pn2, PathNodeImpl pn3, NodeEx node, Cc cc,
            FlowState state, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
          ) {
            exists(DataFlowCall call, RetNodeEx ret, boolean allowsFieldFlow |
              fwdFlowThroughStep1(pn1, pn2, pn3, call, cc, state, summaryCtx, t, ap, stored, ret) and
              flowThroughOutOfCall(call, ret, node, allowsFieldFlow) and
              not inBarrier(node, state) and
              if allowsFieldFlow = false then ap instanceof ApNil else any()
            )
          }

          private predicate localStep(
            PathNodeImpl pn1, NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t,
            Ap ap, TypOption stored, string label, boolean isStoreStep
          ) {
            exists(NodeEx mid, FlowState state0, Typ t0, LocalCc localCc |
              pn1 = TPathNodeMid(mid, state0, cc, summaryCtx, t0, ap, stored) and
              localCc = getLocalCc(cc) and
              isStoreStep = false
            |
              localStep(mid, state0, node, state, true, _, localCc, label) and
              t = t0
              or
              localStep(mid, state0, node, state, false, t, localCc, label) and
              ap instanceof ApNil
            )
            or
            // store
            exists(NodeEx mid, Content c, Typ t0, Ap ap0, TypOption stored0 |
              pn1 = TPathNodeMid(mid, state, cc, summaryCtx, t0, ap0, stored0) and
              fwdFlowStore(mid, t0, ap0, stored0, c, t, stored, node, state, cc, summaryCtx) and
              ap = apCons(c, ap0) and
              label = "" and
              isStoreStep = true
            )
            or
            // read
            exists(NodeEx mid, Typ t0, Ap ap0, TypOption stored0 |
              pn1 = TPathNodeMid(mid, state, cc, summaryCtx, t0, ap0, stored0) and
              fwdFlowRead(mid, t0, ap0, stored0, _, node, t, ap, stored, state, cc, summaryCtx) and
              label = "" and
              isStoreStep = false
            )
          }

          private predicate localStep(PathNodeImpl pn1, PathNodeImpl pn2, string label) {
            exists(
              NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap,
              TypOption stored, boolean isStoreStep
            |
              localStep(pn1, node, state, cc, summaryCtx, t0, ap, stored, label, isStoreStep) and
              pn2 = typeStrengthenToPathNode(node, state, cc, summaryCtx, t0, ap, stored) and
              stepFilter(node, ap, isStoreStep)
            )
            or
            summaryStep(pn1, pn2, label)
          }

          private predicate summaryLabel(PathNodeImpl pn1, PathNodeImpl pn2, string summaryLabel) {
            pn1 = pn2 and
            summaryLabel = "" and
            subpathsImpl(_, pn1, _, _)
            or
            exists(PathNodeImpl mid, string l1, string l2 |
              summaryLabel(pn1, mid, l1) and
              localStep(mid, pn2, l2) and
              summaryLabel = mergeLabels(l1, l2)
            )
          }

          private predicate summaryStep(PathNodeImpl arg, PathNodeImpl out, string label) {
            exists(PathNodeImpl par, PathNodeImpl ret |
              subpathsImpl(arg, par, ret, out) and
              summaryLabel(par, ret, label)
            )
          }

          private predicate nonLocalStep(
            PathNodeImpl pn1, NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t,
            Ap ap, TypOption stored, string label
          ) {
            // jump
            exists(NodeEx mid, FlowState state0, Typ t0 |
              pn1 = TPathNodeMid(mid, state0, _, _, t0, ap, stored) and
              cc = ccNone() and
              summaryCtx = TSummaryCtxNone()
            |
              jumpStepEx(mid, node) and
              state = state0 and
              not outBarrier(mid, state) and
              not inBarrier(node, state) and
              t = t0 and
              label = ""
              or
              additionalJumpStep(mid, node, label) and
              state = state0 and
              not outBarrier(mid, state) and
              not inBarrier(node, state) and
              t = getNodeTyp(node) and
              ap instanceof ApNil
              or
              additionalJumpStateStep(mid, state0, node, state, label) and
              t = getNodeTyp(node) and
              ap instanceof ApNil
            )
            or
            // flow into a callable
            exists(ArgNodeEx arg, Cc outercc, SummaryCtx outerSummaryCtx |
              pn1 = TPathNodeMid(arg, state, outercc, outerSummaryCtx, t, ap, stored) and
              fwdFlowInStep(arg, node, state, outercc, cc, outerSummaryCtx, summaryCtx, t, ap,
                stored) and
              label = ""
            )
            or
            // flow out of a callable
            exists(RetNodeEx ret, CcNoCall innercc, boolean allowsFieldFlow |
              pn1 = TPathNodeMid(ret, state, innercc, summaryCtx, t, ap, stored) and
              fwdFlowIntoRet(ret, state, innercc, summaryCtx, t, ap, stored) and
              fwdFlowOutValidEdge(_, ret, innercc, _, node, cc, allowsFieldFlow) and
              not inBarrier(node, state) and
              label = "" and
              if allowsFieldFlow = false then ap instanceof ApNil else any()
            )
          }

          private predicate nonLocalStep(PathNodeImpl pn1, PathNodeImpl pn2, string label) {
            exists(
              NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap,
              TypOption stored
            |
              nonLocalStep(pn1, node, state, cc, summaryCtx, t0, ap, stored, label) and
              pn2 = typeStrengthenToPathNode(node, state, cc, summaryCtx, t0, ap, stored) and
              stepFilter(node, ap, false)
            )
          }

          /**
           * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
           *
           * All of the nodes may be hidden.
           */
          private predicate subpathsImpl(
            PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
          ) {
            exists(
              NodeEx node, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap,
              TypOption stored, PathNodeImpl out0
            |
              fwdFlowThroughStep2(arg, par, ret, node, cc, state, summaryCtx, t0, ap, stored) and
              out0 = typeStrengthenToPathNode(node, state, cc, summaryCtx, t0, ap, stored) and
              stepFilter(node, ap, false)
            |
              out = out0 or out = out0.(PathNodeMid).projectToSink(_)
            )
          }

          module StagePathGraph {
            predicate edges(PathNodeImpl a, PathNodeImpl b, string key, string val) {
              a.getASuccessorImpl(val) = b and
              key = "provenance"
            }

            query predicate nodes(PathNodeImpl n, string key, string val) {
              key = "semmle.label" and val = n.toString()
            }

            query predicate subpaths = subpathsImpl/4;
          }

          module Public {
            private PathNodeImpl localStep(PathNodeImpl n) { localStep(n, result, _) }

            private predicate localStepToHidden(PathNodeImpl n1, PathNodeImpl n2) {
              n2 = localStep(n1) and
              n2.isHidden()
            }

            private predicate localStepFromHidden(PathNodeImpl n1, PathNodeImpl n2) {
              n2 = localStep(n1) and
              n1.isHidden()
              or
              n2 = n1.getAnImplicitReadSuccessorAtSink(_)
            }

            bindingset[par, ret]
            pragma[inline_late]
            private predicate localStepStar(PathNodeImpl par, PathNodeImpl ret) {
              localStep*(par) = ret
            }

            /**
             * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
             *
             * `par` and `ret` are not hidden.
             */
            pragma[nomagic]
            private predicate subpaths1(
              PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
            ) {
              // direct subpath
              subpathsImpl(arg, any(PathNodeImpl n | localStepFromHidden*(n, par)),
                any(PathNodeImpl n | localStepToHidden*(ret, n)), out) and
              not par.isHidden() and
              not ret.isHidden() and
              localStepStar(par, ret)
              or
              // wrapped subpath using hidden nodes, e.g. flow through a callback inside
              // a summarized callable
              exists(PathNodeImpl par0, PathNodeImpl ret0 |
                subpaths1(any(PathNodeImpl n | localStepToHidden*(par0, n)), par, ret,
                  any(PathNodeImpl n | localStepFromHidden*(n, ret0))) and
                subpathsImpl(arg, par0, ret0, out)
              )
            }

            /**
             * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
             * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
             * `ret -> out` is summarized as the edge `arg -> out`.
             *
             * None of the nodes are hidden.
             */
            pragma[nomagic]
            private predicate subpaths2(
              PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
            ) {
              exists(PathNodeImpl out0 |
                subpaths1(any(PathNodeImpl n | localStepToHidden*(arg, n)), par, ret,
                  any(PathNodeImpl n | localStepFromHidden*(n, out0))) and
                not arg.isHidden() and
                not out0.isHidden()
              |
                out = out0 or out = out0.(PathNodeMid).projectToSink(_)
              )
            }

            /** Holds if `n` is reachable from a source. */
            private predicate fwdReach(PathNodeImpl n) {
              n.isArbitrarySource()
              or
              exists(PathNodeImpl mid | fwdReach(mid) and mid.getANonHiddenSuccessor(_) = n)
            }

            /** Holds if `n` is reachable from a source and can reach a sink. */
            private predicate directReach(PathNodeImpl n) {
              fwdReach(n) and
              (
                n.isArbitrarySink() or
                directReach(n.getANonHiddenSuccessor(_))
              )
            }

            /**
             * Holds if `n` can reach a return node in a summarized subpath that can reach a sink.
             */
            private predicate retReach(PathNodeImpl n) {
              fwdReach(n) and
              (
                exists(PathNodeImpl out | subpaths2(_, _, n, out) |
                  directReach(out) or retReach(out)
                )
                or
                exists(PathNodeImpl mid |
                  retReach(mid) and
                  n.getANonHiddenSuccessor(_) = mid and
                  not subpaths2(_, mid, _, _)
                )
              )
            }

            /** Holds if `n` can reach a sink or is used in a subpath that can reach a sink. */
            private predicate reach(PathNodeImpl n) { directReach(n) or retReach(n) }

            /**
             * A `Node` augmented with a call context (except for sinks) and an access path.
             * Only those `PathNode`s that are reachable from a source, and which can reach a sink, are generated.
             */
            class PathNode instanceof PathNodeImpl {
              PathNode() {
                reach(this) and
                not this instanceof PathNodeSrcGrp and
                not this instanceof PathNodeSinkGrp
              }

              /** Gets a textual representation of this element. */
              final string toString() { result = super.toString() }

              /**
               * Gets a textual representation of this element, including a textual
               * representation of the call context.
               */
              final string toStringWithContext() {
                result = this.(PathNodeMid).toStringWithContext()
                or
                not this instanceof PathNodeMid and result = this.toString()
              }

              /** Gets the location of this node. */
              Location getLocation() { result = super.getLocation() }

              /** Gets the underlying `Node`. */
              final Node getNode() { super.getNodeEx().projectToNode() = result }

              /** Gets the parameter node through which data is returned, if any. */
              final ParameterNode asParameterReturnNode() {
                result = super.getNodeEx().asParamReturnNode()
              }

              /** Gets the `FlowState` of this node. */
              final FlowState getState() { result = super.getState() }

              /** Gets a successor of this node, if any. */
              final PathNode getASuccessor() { result = super.getANonHiddenSuccessor(_) }

              /** Holds if this node is a source. */
              final predicate isSource() { super.isSource() }

              /** Holds if this node is a sink. */
              final predicate isSink() { this instanceof PathNodeSink }

              /**
               * Holds if this element is at the specified location.
               * The location spans column `startcolumn` of line `startline` to
               * column `endcolumn` of line `endline` in file `filepath`.
               * For more information, see
               * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
               */
              pragma[inline]
              deprecated final predicate hasLocationInfo(
                string filepath, int startline, int startcolumn, int endline, int endcolumn
              ) {
                this.getLocation()
                    .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
              }

              /**
               * DEPRECATED: This functionality is no longer available.
               *
               * Holds if this node is a grouping of source nodes.
               */
              deprecated final predicate isSourceGroup(string group) { none() }

              /**
               * DEPRECATED: This functionality is no longer available.
               *
               * Holds if this node is a grouping of sink nodes.
               */
              deprecated final predicate isSinkGroup(string group) { none() }
            }

            /** Holds if `n1.getASuccessor() = n2` and `n2` can reach a sink. */
            private predicate pathSucc(PathNodeImpl n1, PathNodeImpl n2) {
              n1.getANonHiddenSuccessor(_) = n2 and directReach(n2)
            }

            private predicate tcSrc(PathNodeImpl n) { n.isSource() }

            private predicate tcSink(PathNodeImpl n) { n.isSink() }

            private predicate pathSuccPlus(PathNodeImpl n1, PathNodeImpl n2) =
              doublyBoundedFastTC(pathSucc/2, tcSrc/1, tcSink/1)(n1, n2)

            /**
             * Holds if data can flow from `source` to `sink`.
             *
             * The corresponding paths are generated from the end-points and the graph
             * included in the module `PathGraph`.
             */
            predicate flowPath(PathNode source, PathNode sink) {
              (
                // When there are both sources and sinks in the diff range,
                // diff-informed dataflow falls back to computing all paths without
                // any filtering. To prevent significant alert flip-flopping due to
                // minor code changes triggering the fallback, we consistently apply
                // source-or-sink filtering here to ensure that we return the same
                // paths regardless of whether the fallback is triggered.
                if Config::observeDiffInformedIncrementalMode()
                then isRelevantSourceSinkPair(source.getNode(), sink.getNode())
                else any()
              ) and
              exists(PathNodeImpl flowsource, PathNodeImpl flowsink |
                source = flowsource and sink = flowsink
              |
                flowsource.isSource() and
                (flowsource = flowsink or pathSuccPlus(flowsource, flowsink)) and
                flowsink.isSink()
              )
            }

            /**
             * Provides the query predicates needed to include a graph in a path-problem query.
             */
            module PathGraph implements PathGraphSig<PathNode> {
              /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
              query predicate edges(PathNode a, PathNode b, string key, string val) {
                a.(PathNodeImpl).getANonHiddenSuccessor(val) = b and
                key = "provenance"
              }

              /** Holds if `n` is a node in the graph of data flow path explanations. */
              query predicate nodes(PathNode n, string key, string val) {
                key = "semmle.label" and val = n.toString()
              }

              /**
               * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
               * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
               * `ret -> out` is summarized as the edge `arg -> out`.
               */
              query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
                subpaths2(arg, par, ret, out)
              }
            }
          }
        }

        additional predicate stats(
          boolean fwd, int nodes, int fields, int conscand, int states, int tuples, int calledges,
          int tfnodes, int tftuples
        ) {
          fwd = true and
          nodes = count(NodeEx node | fwdFlow(node, _, _, _, _, _, _)) and
          fields = count(Content f0 | fwdConsCand(f0, _)) and
          conscand = count(Content f0, Ap ap | fwdConsCand(f0, ap)) and
          states = count(FlowState state | fwdFlow(_, state, _, _, _, _, _)) and
          tuples =
            count(NodeEx n, FlowState state, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap,
              TypOption stored | fwdFlow(n, state, cc, summaryCtx, t, ap, stored)) and
          calledges =
            count(DataFlowCall call, DataFlowCallable c |
              FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
              FwdTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
            ) and
          FwdTypeFlow::typeFlowStats(tfnodes, tftuples)
          or
          fwd = false and
          nodes = count(NodeEx node | revFlow(node, _, _, _, _)) and
          fields = count(Content f0 | consCand(f0, _)) and
          conscand = count(Content f0, Ap ap | consCand(f0, ap)) and
          states = count(FlowState state | revFlow(_, state, _, _, _)) and
          tuples =
            count(NodeEx n, FlowState state, ReturnCtx returnCtx, ApOption retAp, Ap ap |
              revFlow(n, state, returnCtx, retAp, ap)
            ) and
          calledges =
            count(DataFlowCall call, DataFlowCallable c |
              RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
              RevTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
            ) and
          RevTypeFlow::typeFlowStats(tfnodes, tftuples)
        }
        /* End: Stage logic. */
      }
    }

    private module BooleanCallContext {
      class Cc = Boolean;

      class CcCall extends Cc {
        CcCall() { this = true }
      }

      /** Holds if the call context may be `call`. */
      predicate matchesCall(CcCall cc, DataFlowCall call) { any() }

      class CcNoCall extends Cc {
        CcNoCall() { this = false }
      }

      Cc ccNone() { result = false }

      CcCall ccSomeCall() { result = true }

      predicate instanceofCc(Cc cc) { any() }

      predicate instanceofCcCall(CcCall cc) { any() }

      predicate instanceofCcNoCall(CcNoCall cc) { any() }

      class LocalCc = Unit;

      bindingset[cc]
      LocalCc getLocalCc(Cc cc) { any() }

      DataFlowCallable viableImplCallContextReduced(DataFlowCall call, CcCall ctx) { none() }

      bindingset[call, ctx]
      predicate viableImplNotCallContextReduced(DataFlowCall call, Cc ctx) { any() }

      bindingset[call, c]
      CcCall getCallContextCall(DataFlowCall call, DataFlowCallable c) { any() }

      DataFlowCall viableImplCallContextReducedReverse(DataFlowCallable c, CcNoCall ctx) { none() }

      predicate viableImplNotCallContextReducedReverse(CcNoCall ctx) { any() }

      bindingset[call, c]
      CcNoCall getCallContextReturn(DataFlowCallable c, DataFlowCall call) { any() }
    }

    private module Stage2Param implements MkStage<Stage1>::StageParam {
      private module PrevStage = Stage1;

      class Typ = Unit;

      class Ap = Boolean;

      class ApNil extends Ap {
        ApNil() { this = false }
      }

      bindingset[result, ap]
      PrevStage::Ap getApprox(Ap ap) { any() }

      Typ getTyp(DataFlowType t) { any() }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) {
        result = true and
        exists(c) and
        if tail = true then Config::accessPathLimit() > 1 else any()
      }

      class ApHeadContent = Unit;

      pragma[inline]
      ApHeadContent getHeadContent(Ap ap) { exists(result) and ap = true }

      ApHeadContent projectToHeadContent(Content c) { any() }

      class ApOption = BooleanOption;

      ApOption apNone() { result = TBooleanNone() }

      ApOption apSome(Ap ap) { result = TBooleanSome(ap) }

      import CachedCallContextSensitivity
      import NoLocalCallContext

      bindingset[node1, state1]
      bindingset[node2, state2]
      predicate localStep(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        Typ t, LocalCc lcc, string label
      ) {
        (
          localStepNodeCand1(node1, node2, preservesValue, _, _, label) and
          state1 = state2
          or
          localStateStepNodeCand1(node1, state1, node2, state2, _, _, label) and
          preservesValue = false
        ) and
        exists(t) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate expectsContentCand(NodeEx node) {
        exists(Content c |
          PrevStage::revFlow(node) and
          PrevStage::revFlowIsReadAndStored(c) and
          expectsContentEx(node, c)
        )
      }

      bindingset[node, state, t0, ap]
      predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t) {
        PrevStage::revFlowState(state) and
        t0 = t and
        exists(ap) and
        not stateBarrier(node, state) and
        (
          notExpectsContent(node)
          or
          ap = true and
          expectsContentCand(node)
        )
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(NodeEx node, Ap ap, boolean isStoreStep) { any() }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { any() }

      predicate enableTypeFlow() { none() }
    }

    private module Stage2 = MkStage<Stage1>::Stage<Stage2Param>;

    private module Stage3Param implements MkStage<Stage2>::StageParam {
      private module PrevStage = Stage2;

      class Typ = Unit;

      class Ap = ApproxAccessPathFront;

      class ApNil = ApproxAccessPathFrontNil;

      PrevStage::Ap getApprox(Ap ap) { result = ap.toBoolNonEmpty() }

      Typ getTyp(DataFlowType t) { any() }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) { result.getAHead() = c and exists(tail) }

      class ApHeadContent = ContentApprox;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      predicate projectToHeadContent = getContentApproxCached/1;

      class ApOption = ApproxAccessPathFrontOption;

      ApOption apNone() { result = TApproxAccessPathFrontNone() }

      ApOption apSome(Ap ap) { result = TApproxAccessPathFrontSome(ap) }

      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          CachedCallContextSensitivity::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand =
          CachedCallContextSensitivity::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import NoLocalCallContext

      bindingset[node1, state1]
      bindingset[node2, state2]
      private predicate localStepInput(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        DataFlowType t, LocalCallContext lcc, string label
      ) {
        localStepNodeCand1(node1, node2, preservesValue, t, lcc, label) and
        state1 = state2
        or
        localStateStepNodeCand1(node1, state1, node2, state2, t, lcc, label) and
        preservesValue = false
      }

      additional predicate localFlowBigStep(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        DataFlowType t, LocalCallContext lcc, string label
      ) {
        PrevStage::LocalFlowBigStep<localStepInput/8>::localFlowBigStep(node1, state1, node2,
          state2, preservesValue, t, lcc, label)
      }

      bindingset[node1, state1]
      bindingset[node2, state2]
      predicate localStep(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        Typ t, LocalCc lcc, string label
      ) {
        localFlowBigStep(node1, state1, node2, state2, preservesValue, _, _, label) and
        exists(t) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate expectsContentCand(NodeEx node, Ap ap) {
        exists(Content c |
          PrevStage::revFlow(node) and
          PrevStage::readStepCand(_, c, _) and
          expectsContentEx(node, c) and
          c = ap.getAHead()
        )
      }

      bindingset[node, state, t0, ap]
      predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t) {
        exists(state) and
        t0 = t and
        (
          notExpectsContent(node)
          or
          expectsContentCand(node, ap)
        )
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(NodeEx node, Ap ap, boolean isStoreStep) { any() }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { any() }
    }

    private module Stage3 = MkStage<Stage2>::Stage<Stage3Param>;

    bindingset[node, t0]
    private predicate strengthenType(NodeEx node, DataFlowType t0, DataFlowType t) {
      if node instanceof CastingNodeEx
      then
        exists(DataFlowType nt | nt = node.getDataFlowType() |
          if typeStrongerThanFilter(nt, t0)
          then t = nt
          else (
            compatibleTypesFilter(nt, t0) and t = t0
          )
        )
      else t = t0
    }

    private module Stage4Param implements MkStage<Stage3>::StageParam {
      private module PrevStage = Stage3;

      class Typ = Unit;

      class Ap = AccessPathFront;

      class ApNil = AccessPathFrontNil;

      PrevStage::Ap getApprox(Ap ap) { result = ap.toApprox() }

      Typ getTyp(DataFlowType t) { any() }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) { result.getHead() = c and exists(tail) }

      class ApHeadContent = Content;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      ApHeadContent projectToHeadContent(Content c) { result = c }

      class ApOption = AccessPathFrontOption;

      ApOption apNone() { result = TAccessPathFrontNone() }

      ApOption apSome(Ap ap) { result = TAccessPathFrontSome(ap) }

      import BooleanCallContext

      pragma[nomagic]
      predicate localStep(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        Typ t, LocalCc lcc, string label
      ) {
        Stage3Param::localFlowBigStep(node1, state1, node2, state2, preservesValue, _, _, label) and
        PrevStage::revFlow(node1, pragma[only_bind_into](state1), _) and
        PrevStage::revFlow(node2, pragma[only_bind_into](state2), _) and
        exists(t) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate clearSet(NodeEx node, ContentSet c) {
        PrevStage::revFlow(node) and
        clearsContentSet(node, c)
      }

      pragma[nomagic]
      additional predicate clearContent(NodeEx node, Content c, boolean isStoreTarget) {
        exists(ContentSet cs |
          PrevStage::readStepCand(_, pragma[only_bind_into](c), _) and
          c = cs.getAReadContent() and
          clearSet(node, cs) and
          if PrevStage::storeStepCand(_, _, node, _, _)
          then isStoreTarget = true
          else isStoreTarget = false
        )
      }

      pragma[nomagic]
      private predicate clear(NodeEx node, Ap ap) {
        // When `node` is the target of a store, we interpret `clearsContent` as
        // only pertaining to _earlier_ store steps. In this case, we need to postpone
        // checking `clearsContent` to the step creation.
        clearContent(node, ap.getHead(), false)
      }

      pragma[nomagic]
      private predicate clearExceptStore(NodeEx node, Ap ap) {
        clearContent(node, ap.getHead(), true)
      }

      pragma[nomagic]
      private predicate expectsContentCand(NodeEx node, Ap ap) {
        exists(Content c |
          PrevStage::revFlow(node) and
          PrevStage::readStepCand(_, c, _) and
          expectsContentEx(node, c) and
          c = ap.getHead()
        )
      }

      bindingset[node, state, t0, ap]
      predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t) {
        exists(state) and
        not clear(node, ap) and
        t0 = t and
        (
          notExpectsContent(node)
          or
          expectsContentCand(node, ap)
        )
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(NodeEx node, Ap ap, boolean isStoreStep) {
        if clearExceptStore(node, ap) then isStoreStep = true else any()
      }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { any() }
    }

    private module Stage4 = MkStage<Stage3>::Stage<Stage4Param>;

    /**
     * Holds if a length 2 access path approximation with the head `c` is expected
     * to be expensive.
     */
    private predicate expensiveLen2unfolding(Content c) {
      exists(int tails, int nodes, int apLimit, int tupleLimit |
        tails = strictcount(AccessPathFront apf | Stage4::consCand(c, apf)) and
        nodes =
          strictcount(NodeEx n, FlowState state |
            Stage4::revFlow(n, state, any(AccessPathFrontHead apf | apf.getHead() = c))
            or
            Stage4::nodeMayUseSummary(n, state, any(AccessPathFrontHead apf | apf.getHead() = c))
          ) and
        accessPathApproxCostLimits(apLimit, tupleLimit) and
        apLimit < tails and
        tupleLimit < (tails - 1) * nodes and
        not forceHighPrecision(c)
      )
    }

    private newtype TAccessPathApprox =
      TNil() or
      TConsNil(Content c) {
        Stage4::consCand(c, TFrontNil()) and
        not expensiveLen2unfolding(c)
      } or
      TConsCons(Content c1, Content c2, int len) {
        Stage4::consCand(c1, TFrontHead(c2)) and
        len in [2 .. Config::accessPathLimit()] and
        not expensiveLen2unfolding(c1)
      } or
      TCons1(Content c, int len) {
        len in [1 .. Config::accessPathLimit()] and
        expensiveLen2unfolding(c)
      }

    /**
     * Conceptually a list of `Content`s, but only the first two elements of
     * the list and its length are tracked. If data flows from a source to a
     * given node with a given `AccessPathApprox`, this indicates the sequence
     * of dereference operations needed to get from the value in the node to
     * the tracked object.
     */
    abstract private class AccessPathApprox extends TAccessPathApprox {
      abstract string toString();

      abstract Content getHead();

      abstract int len();

      abstract AccessPathFront getFront();

      /** Holds if this is a representation of `head` followed by `tail`. */
      abstract predicate isCons(Content head, AccessPathApprox tail);
    }

    private class AccessPathApproxNil extends AccessPathApprox, TNil {
      override string toString() { result = "" }

      override Content getHead() { none() }

      override int len() { result = 0 }

      override AccessPathFront getFront() { result = TFrontNil() }

      override predicate isCons(Content head, AccessPathApprox tail) { none() }
    }

    abstract private class AccessPathApproxCons extends AccessPathApprox { }

    private class AccessPathApproxConsNil extends AccessPathApproxCons, TConsNil {
      private Content c;

      AccessPathApproxConsNil() { this = TConsNil(c) }

      override string toString() { result = "[" + c.toString() + "]" }

      override Content getHead() { result = c }

      override int len() { result = 1 }

      override AccessPathFront getFront() { result = TFrontHead(c) }

      override predicate isCons(Content head, AccessPathApprox tail) { head = c and tail = TNil() }
    }

    private class AccessPathApproxConsCons extends AccessPathApproxCons, TConsCons {
      private Content c1;
      private Content c2;
      private int len;

      AccessPathApproxConsCons() { this = TConsCons(c1, c2, len) }

      override string toString() {
        if len = 2
        then result = "[" + c1.toString() + ", " + c2.toString() + "]"
        else result = "[" + c1.toString() + ", " + c2.toString() + ", ... (" + len.toString() + ")]"
      }

      override Content getHead() { result = c1 }

      override int len() { result = len }

      override AccessPathFront getFront() { result = TFrontHead(c1) }

      override predicate isCons(Content head, AccessPathApprox tail) {
        head = c1 and
        (
          tail = TConsCons(c2, _, len - 1)
          or
          len = 2 and
          tail = TConsNil(c2)
          or
          tail = TCons1(c2, len - 1)
        )
      }
    }

    private class AccessPathApproxCons1 extends AccessPathApproxCons, TCons1 {
      private Content c;
      private int len;

      AccessPathApproxCons1() { this = TCons1(c, len) }

      override string toString() {
        if len = 1
        then result = "[" + c.toString() + "]"
        else result = "[" + c.toString() + ", ... (" + len.toString() + ")]"
      }

      override Content getHead() { result = c }

      override int len() { result = len }

      override AccessPathFront getFront() { result = TFrontHead(c) }

      override predicate isCons(Content head, AccessPathApprox tail) {
        head = c and
        (
          exists(Content c2 | Stage4::consCand(c, TFrontHead(c2)) |
            tail = TConsCons(c2, _, len - 1)
            or
            len = 2 and
            tail = TConsNil(c2)
            or
            tail = TCons1(c2, len - 1)
          )
          or
          len = 1 and
          Stage4::consCand(c, TFrontNil()) and
          tail = TNil()
        )
      }
    }

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

    private module Stage5Param implements MkStage<Stage4>::StageParam {
      private module PrevStage = Stage4;

      class Typ = DataFlowType;

      class Ap = AccessPathApprox;

      class ApNil = AccessPathApproxNil;

      pragma[nomagic]
      PrevStage::Ap getApprox(Ap ap) { result = ap.getFront() }

      Typ getTyp(DataFlowType t) { result = t }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) { result.isCons(c, tail) }

      class ApHeadContent = Content;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      ApHeadContent projectToHeadContent(Content c) { result = c }

      class ApOption = AccessPathApproxOption;

      ApOption apNone() { result = TAccessPathApproxNone() }

      ApOption apSome(Ap ap) { result = TAccessPathApproxSome(ap) }

      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          Stage3Param::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand = Stage3Param::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import LocalCallContext

      predicate localStep =
        PrevStage::LocalFlowBigStep<Stage3Param::localFlowBigStep/8>::localFlowBigStepTc/8;

      bindingset[node, state, t0, ap]
      predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t) {
        strengthenType(node, t0, t) and
        exists(state) and
        exists(ap)
      }

      pragma[nomagic]
      private predicate clearExceptStore(NodeEx node, Ap ap) {
        Stage4Param::clearContent(node, ap.getHead(), true)
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(NodeEx node, Ap ap, boolean isStoreStep) {
        if clearExceptStore(node, ap) then isStoreStep = true else any()
      }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { compatibleTypesFilter(t1, t2) }
    }

    private module Stage5 = MkStage<Stage4>::Stage<Stage5Param>;

    pragma[nomagic]
    private predicate stage5ConsCand(Content c, AccessPathFront apf, int len) {
      Stage5::consCand(c, any(AccessPathApprox ap | ap.getFront() = apf and ap.len() = len - 1))
    }

    /**
     * Gets the number of length 2 access path approximations that correspond to `apa`.
     */
    private int count1to2unfold(AccessPathApproxCons1 apa) {
      exists(Content c, int len |
        c = apa.getHead() and
        len = apa.len() and
        result = strictcount(AccessPathFront apf | stage5ConsCand(c, apf, len))
      )
    }

    private int countNodesUsingAccessPath(AccessPathApprox apa) {
      result =
        strictcount(NodeEx n, FlowState state |
          Stage5::revFlow(n, state, apa) or Stage5::nodeMayUseSummary(n, state, apa)
        )
    }

    /**
     * Holds if a length 2 access path approximation matching `apa` is expected
     * to be expensive.
     */
    private predicate expensiveLen1to2unfolding(AccessPathApproxCons1 apa) {
      exists(int aps, int nodes, int apLimit, int tupleLimit |
        aps = count1to2unfold(apa) and
        nodes = countNodesUsingAccessPath(apa) and
        accessPathCostLimits(apLimit, tupleLimit) and
        apLimit < aps and
        tupleLimit < (aps - 1) * nodes
      )
    }

    private predicate hasTail(AccessPathApprox apa, AccessPathApprox tail) {
      exists(Content head |
        apa.isCons(head, tail) and
        Stage5::consCand(head, tail)
      )
    }

    private predicate forceUnfold(AccessPathApprox apa) {
      forceHighPrecision(apa.getHead())
      or
      exists(Content c2 |
        apa = TConsCons(_, c2, _) and
        forceHighPrecision(c2)
      )
    }

    /**
     * Holds with `unfold = false` if a precise head-tail representation of `apa` is
     * expected to be expensive. Holds with `unfold = true` otherwise.
     */
    private predicate evalUnfold(AccessPathApprox apa, boolean unfold) {
      if forceUnfold(apa)
      then unfold = true
      else
        exists(int aps, int nodes, int apLimit, int tupleLimit |
          aps = countPotentialAps(apa) and
          nodes = countNodesUsingAccessPath(apa) and
          accessPathCostLimits(apLimit, tupleLimit) and
          if apLimit < aps and tupleLimit < (aps - 1) * nodes then unfold = false else unfold = true
        )
    }

    /**
     * Gets the number of `AccessPath`s that correspond to `apa`.
     */
    private int countAps(AccessPathApprox apa) {
      evalUnfold(apa, false) and
      result = 1 and
      (not apa instanceof AccessPathApproxCons1 or expensiveLen1to2unfolding(apa))
      or
      evalUnfold(apa, false) and
      result = count1to2unfold(apa) and
      not expensiveLen1to2unfolding(apa)
      or
      evalUnfold(apa, true) and
      result = countPotentialAps(apa)
    }

    /**
     * Gets the number of `AccessPath`s that would correspond to `apa` assuming
     * that it is expanded to a precise head-tail representation.
     */
    language[monotonicAggregates]
    private int countPotentialAps(AccessPathApprox apa) {
      apa instanceof AccessPathApproxNil and result = 1
      or
      result = strictsum(AccessPathApprox tail | hasTail(apa, tail) | countAps(tail))
    }

    private newtype TAccessPath =
      TAccessPathNil() or
      TAccessPathCons(Content head, AccessPath tail) {
        exists(AccessPathApproxCons apa |
          not evalUnfold(apa, false) and
          head = apa.getHead() and
          hasTail(apa, tail.getApprox())
        )
      } or
      TAccessPathCons2(Content head1, Content head2, int len) {
        exists(AccessPathApproxCons apa, AccessPathApprox tail |
          evalUnfold(apa, false) and
          not expensiveLen1to2unfolding(apa) and
          apa.len() = len and
          hasTail(apa, tail) and
          head1 = apa.getHead() and
          head2 = tail.getHead()
        )
      } or
      TAccessPathCons1(Content head, int len) {
        exists(AccessPathApproxCons apa |
          evalUnfold(apa, false) and
          expensiveLen1to2unfolding(apa) and
          apa.len() = len and
          head = apa.getHead()
        )
      }

    private module Stage6Param implements MkStage<Stage5>::StageParam {
      private module PrevStage = Stage5;

      class Typ = DataFlowType;

      class Ap = AccessPath;

      class ApNil = AccessPathNil;

      pragma[nomagic]
      PrevStage::Ap getApprox(Ap ap) { result = ap.getApprox() }

      Typ getTyp(DataFlowType t) { result = t }

      bindingset[c, tail]
      pragma[inline_late]
      Ap apCons(Content c, Ap tail) { result.isCons(c, tail) }

      class ApHeadContent = Content;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      ApHeadContent projectToHeadContent(Content c) { result = c }

      private module ApOption = Option<AccessPath>;

      class ApOption = ApOption::Option;

      ApOption apNone() { result.isNone() }

      ApOption apSome(Ap ap) { result = ApOption::some(ap) }

      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          Stage5Param::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand = Stage5Param::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import LocalCallContext

      predicate localStep =
        PrevStage::LocalFlowBigStep<Stage5Param::localStep/8>::localFlowBigStepTc/8;

      bindingset[node, state, t0, ap]
      predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t) {
        strengthenType(node, t0, t) and
        exists(state) and
        exists(ap)
      }

      pragma[nomagic]
      private predicate clearExceptStore(NodeEx node, Ap ap) {
        Stage4Param::clearContent(node, ap.getHead(), true)
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(NodeEx node, Ap ap, boolean isStoreStep) {
        if clearExceptStore(node, ap) then isStoreStep = true else any()
      }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { compatibleTypesFilter(t1, t2) }
    }

    module Stage6 = MkStage<Stage5>::Stage<Stage6Param>;

    /**
     * A list of `Content`s.
     *
     * If data flows from a source to a given node with a given `AccessPath`,
     * this indicates the sequence of dereference operations needed to get from
     * the value in the node to the tracked object.
     */
    private class AccessPath extends TAccessPath {
      /** Gets the head of this access path, if any. */
      abstract Content getHead();

      /** Holds if this is a representation of `head` followed by `tail`. */
      pragma[nomagic]
      abstract predicate isCons(Content head, AccessPath tail);

      /** Gets the front of this access path. */
      abstract AccessPathFront getFront();

      /** Gets the approximation of this access path. */
      abstract AccessPathApprox getApprox();

      /** Gets the length of this access path. */
      abstract int length();

      /** Gets a textual representation of this access path. */
      abstract string toString();
    }

    private class AccessPathNil extends AccessPath, TAccessPathNil {
      override Content getHead() { none() }

      override predicate isCons(Content head, AccessPath tail) { none() }

      override AccessPathFrontNil getFront() { result = TFrontNil() }

      override AccessPathApproxNil getApprox() { result = TNil() }

      override int length() { result = 0 }

      override string toString() { result = "" }
    }

    private class AccessPathCons extends AccessPath, TAccessPathCons {
      private Content head_;
      private AccessPath tail_;

      AccessPathCons() { this = TAccessPathCons(head_, tail_) }

      override Content getHead() { result = head_ }

      override predicate isCons(Content head, AccessPath tail) { head = head_ and tail = tail_ }

      override AccessPathFrontHead getFront() { result = TFrontHead(head_) }

      override AccessPathApproxCons getApprox() {
        result = TConsNil(head_) and tail_ = TAccessPathNil()
        or
        result = TConsCons(head_, tail_.getHead(), this.length())
        or
        result = TCons1(head_, this.length())
      }

      override int length() { result = 1 + tail_.length() }

      private string toStringImpl(boolean needsSuffix) {
        tail_ = TAccessPathNil() and
        needsSuffix = false and
        result = head_.toString() + "]"
        or
        result = head_ + ", " + tail_.(AccessPathCons).toStringImpl(needsSuffix)
        or
        exists(Content c2, Content c3, int len | tail_ = TAccessPathCons2(c2, c3, len) |
          result = head_ + ", " + c2 + ", " + c3 + ", ... (" and len > 2 and needsSuffix = true
          or
          result = head_ + ", " + c2 + ", " + c3 + "]" and len = 2 and needsSuffix = false
        )
        or
        exists(Content c2, int len | tail_ = TAccessPathCons1(c2, len) |
          result = head_ + ", " + c2 + ", ... (" and len > 1 and needsSuffix = true
          or
          result = head_ + ", " + c2 + "]" and len = 1 and needsSuffix = false
        )
      }

      override string toString() {
        result = "[" + this.toStringImpl(true) + this.length().toString() + ")]"
        or
        result = "[" + this.toStringImpl(false)
      }
    }

    private class AccessPathCons2 extends AccessPath, TAccessPathCons2 {
      private Content head1;
      private Content head2;
      private int len;

      AccessPathCons2() { this = TAccessPathCons2(head1, head2, len) }

      override Content getHead() { result = head1 }

      override predicate isCons(Content head, AccessPath tail) {
        head = head1 and
        Stage5::consCand(head1, tail.getApprox()) and
        tail.getHead() = head2 and
        tail.length() = len - 1
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
          result =
            "[" + head1.toString() + ", " + head2.toString() + ", ... (" + len.toString() + ")]"
      }
    }

    private class AccessPathCons1 extends AccessPath, TAccessPathCons1 {
      private Content head_;
      private int len;

      AccessPathCons1() { this = TAccessPathCons1(head_, len) }

      override Content getHead() { result = head_ }

      override predicate isCons(Content head, AccessPath tail) {
        head = head_ and
        Stage5::consCand(head_, tail.getApprox()) and
        tail.length() = len - 1
      }

      override AccessPathFrontHead getFront() { result = TFrontHead(head_) }

      override AccessPathApproxCons getApprox() { result = TCons1(head_, len) }

      override int length() { result = len }

      override string toString() {
        if len = 1
        then result = "[" + head_.toString() + "]"
        else result = "[" + head_.toString() + ", ... (" + len.toString() + ")]"
      }
    }

    private module S6Graph = Stage6::Graph;

    private module S6 = S6Graph::Public;

    import S6

    /**
     * Holds if data can flow from `source` to `sink`.
     */
    predicate flow(Node source, Node sink) {
      exists(PathNode source0, PathNode sink0 |
        flowPath(source0, sink0) and source0.getNode() = source and sink0.getNode() = sink
      )
    }

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowTo(Node sink) { exists(PathNode n | n.isSink() and n.getNode() = sink) }

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowToExpr(DataFlowExpr sink) { flowTo(exprNode(sink)) }

    /**
     * INTERNAL: Only for debugging.
     *
     * Calculates per-stage metrics for data flow.
     */
    predicate stageStats = Debug::stageStats/10;

    private module Stage1alias = Stage1;

    private module Stage2alias = Stage2;

    private module Stage3alias = Stage3;

    private module Stage4alias = Stage4;

    private module Stage5alias = Stage5;

    /**
     * INTERNAL: Subject to change without notice.
     *
     * Contains references to individual pruning stages.
     */
    module Stages {
      module Stage1 = Stage1alias;

      module Stage2 = Stage2alias;

      module Stage3 = Stage3alias;

      module Stage4 = Stage4alias;

      module Stage5 = Stage5alias;
    }

    /**
     * INTERNAL: Only for debugging.
     *
     * Contains references to individual pruning stages and stage statistics.
     */
    module Debug {
      import Stages

      predicate stageStats1(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stage = "1 Fwd" and
        n = 10 and
        Stage1::stats(true, nodes, fields, conscand, states, tuples, calledges) and
        tfnodes = -1 and
        tftuples = -1
        or
        stage = "1 Rev" and
        n = 15 and
        Stage1::stats(false, nodes, fields, conscand, states, tuples, calledges) and
        tfnodes = -1 and
        tftuples = -1
      }

      predicate stageStats2(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats1(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "2 Fwd" and
        n = 20 and
        Stage2::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "2 Rev" and
        n = 25 and
        Stage2::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats3(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats2(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "3 Fwd" and
        n = 30 and
        Stage3::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "3 Rev" and
        n = 35 and
        Stage3::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats4(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats3(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "4 Fwd" and
        n = 40 and
        Stage4::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "4 Rev" and
        n = 45 and
        Stage4::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats5(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats4(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "5 Fwd" and
        n = 50 and
        Stage5::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "5 Rev" and
        n = 55 and
        Stage5::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats5(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "6 Fwd" and
        n = 60 and
        Stage6::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "6 Rev" and
        n = 65 and
        Stage6::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }
    }

    private signature predicate flag();

    private predicate flagEnable() { any() }

    private predicate flagDisable() { none() }

    module FlowExplorationFwd<explorationLimitSig/0 explorationLimit> {
      private import FlowExploration<explorationLimit/0, flagEnable/0, flagDisable/0> as F
      import F::Public

      predicate partialFlow = F::partialFlowFwd/3;
    }

    module FlowExplorationRev<explorationLimitSig/0 explorationLimit> {
      private import FlowExploration<explorationLimit/0, flagDisable/0, flagEnable/0> as F
      import F::Public

      predicate partialFlow = F::partialFlowRev/3;
    }

    private module FlowExploration<
      explorationLimitSig/0 explorationLimit, flag/0 flagFwd, flag/0 flagRev>
    {
      class CallContext = CachedCallContextSensitivity::Cc;

      class CallContextCall = CachedCallContextSensitivity::CcCall;

      class CallContextNoCall = CachedCallContextSensitivity::CcNoCall;

      predicate callContextNone = CachedCallContextSensitivity::ccNone/0;

      predicate callContextSomeCall = CachedCallContextSensitivity::ccSomeCall/0;

      private predicate callableStep(DataFlowCallable c1, DataFlowCallable c2) {
        exists(NodeEx node1, NodeEx node2 |
          jumpStepEx(node1, node2)
          or
          additionalJumpStep(node1, node2, _)
          or
          additionalJumpStateStep(node1, _, node2, _, _)
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

      private predicate interestingCallableSrc(DataFlowCallable c) {
        exists(Node n | isRelevantSource(n, _) and c = getNodeEnclosingCallable(n))
        or
        exists(DataFlowCallable mid | interestingCallableSrc(mid) and callableStep(mid, c))
      }

      private predicate interestingCallableSink(DataFlowCallable c) {
        exists(Node n | c = getNodeEnclosingCallable(n) |
          isRelevantSink(n, _) or
          isRelevantSink(n)
        )
        or
        exists(DataFlowCallable mid | interestingCallableSink(mid) and callableStep(c, mid))
      }

      private newtype TCallableExt =
        TCallable(DataFlowCallable c) {
          interestingCallableSrc(c) or
          interestingCallableSink(c)
        } or
        TCallableSrc() or
        TCallableSink()

      private predicate callableExtSrc(TCallableSrc src) { any() }

      private predicate callableExtSink(TCallableSink sink) { any() }

      private predicate callableExtStepFwd(TCallableExt ce1, TCallableExt ce2) {
        exists(DataFlowCallable c1, DataFlowCallable c2 |
          callableStep(c1, c2) and
          ce1 = TCallable(c1) and
          ce2 = TCallable(c2)
        )
        or
        exists(Node n |
          ce1 = TCallableSrc() and
          isRelevantSource(n, _) and
          ce2 = TCallable(getNodeEnclosingCallable(n))
        )
        or
        exists(Node n |
          ce2 = TCallableSink() and
          ce1 = TCallable(getNodeEnclosingCallable(n))
        |
          isRelevantSink(n, _) or
          isRelevantSink(n)
        )
      }

      private predicate callableExtStepRev(TCallableExt ce1, TCallableExt ce2) {
        callableExtStepFwd(ce2, ce1)
      }

      private int distSrcExt(TCallableExt c) =
        shortestDistances(callableExtSrc/1, callableExtStepFwd/2)(_, c, result)

      private int distSinkExt(TCallableExt c) =
        shortestDistances(callableExtSink/1, callableExtStepRev/2)(_, c, result)

      private int distSrc(DataFlowCallable c) { result = distSrcExt(TCallable(c)) - 1 }

      private int distSink(DataFlowCallable c) { result = distSinkExt(TCallable(c)) - 1 }

      private newtype TPartialAccessPath =
        TPartialNil() or
        TPartialCons(Content c, int len) { len in [1 .. Config::accessPathLimit()] }

      /**
       * Conceptually a list of `Content`s, but only the first
       * element of the list and its length are tracked.
       */
      private class PartialAccessPath extends TPartialAccessPath {
        abstract string toString();

        Content getHead() { this = TPartialCons(result, _) }

        int len() {
          this = TPartialNil() and result = 0
          or
          this = TPartialCons(_, result)
        }
      }

      private class PartialAccessPathNil extends PartialAccessPath, TPartialNil {
        override string toString() { result = "" }
      }

      private class PartialAccessPathCons extends PartialAccessPath, TPartialCons {
        override string toString() {
          exists(Content c, int len | this = TPartialCons(c, len) |
            if len = 1
            then result = "[" + c.toString() + "]"
            else result = "[" + c.toString() + ", ... (" + len.toString() + ")]"
          )
        }
      }

      private predicate relevantState(FlowState state) {
        sourceNode(_, state) or
        sinkNodeWithState(_, state) or
        additionalLocalStateStep(_, state, _, _, _) or
        additionalLocalStateStep(_, _, _, state, _) or
        additionalJumpStateStep(_, state, _, _, _) or
        additionalJumpStateStep(_, _, _, state, _)
      }

      private predicate revSinkNode(NodeEx node, FlowState state) {
        sinkNodeWithState(node, state)
        or
        isRelevantSink(node.asNodeOrImplicitRead()) and
        relevantState(state) and
        not fullBarrier(node) and
        not stateBarrier(node, state)
      }

      private newtype TSummaryCtx1 =
        TSummaryCtx1None() or
        TSummaryCtx1Param(ParamNodeEx p)

      private newtype TSummaryCtx2 =
        TSummaryCtx2None() or
        TSummaryCtx2Some(FlowState s) { relevantState(s) }

      private newtype TSummaryCtx3 =
        TSummaryCtx3None() or
        TSummaryCtx3Some(DataFlowType t)

      private newtype TSummaryCtx4 =
        TSummaryCtx4None() or
        TSummaryCtx4Some(PartialAccessPath ap)

      private newtype TRevSummaryCtx1 =
        TRevSummaryCtx1None() or
        TRevSummaryCtx1Some(ReturnPosition pos)

      private newtype TRevSummaryCtx2 =
        TRevSummaryCtx2None() or
        TRevSummaryCtx2Some(FlowState s) { relevantState(s) }

      private newtype TRevSummaryCtx3 =
        TRevSummaryCtx3None() or
        TRevSummaryCtx3Some(PartialAccessPath ap)

      private newtype TPartialPathNode =
        TPartialPathNodeFwd(
          NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
          TSummaryCtx3 sc3, TSummaryCtx4 sc4, DataFlowType t, PartialAccessPath ap
        ) {
          flagFwd() and
          sourceNode(node, state) and
          cc = callContextNone() and
          sc1 = TSummaryCtx1None() and
          sc2 = TSummaryCtx2None() and
          sc3 = TSummaryCtx3None() and
          sc4 = TSummaryCtx4None() and
          t = node.getDataFlowType() and
          ap = TPartialNil() and
          exists(explorationLimit())
          or
          partialPathStep(_, node, state, cc, sc1, sc2, sc3, sc4, t, ap) and
          distSrc(node.getEnclosingCallable()) <= explorationLimit()
        } or
        TPartialPathNodeRev(
          NodeEx node, FlowState state, TRevSummaryCtx1 sc1, TRevSummaryCtx2 sc2,
          TRevSummaryCtx3 sc3, PartialAccessPath ap
        ) {
          flagRev() and
          revSinkNode(node, state) and
          sc1 = TRevSummaryCtx1None() and
          sc2 = TRevSummaryCtx2None() and
          sc3 = TRevSummaryCtx3None() and
          ap = TPartialNil() and
          exists(explorationLimit())
          or
          revPartialPathStep(_, node, state, sc1, sc2, sc3, ap) and
          distSink(node.getEnclosingCallable()) <= explorationLimit()
        }

      // inline to reduce fan-out via `getAReadContent`
      bindingset[c]
      private predicate clearsContentEx(NodeEx n, Content c) {
        exists(ContentSet cs |
          clearsContentSet(n, cs) and
          pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
        )
      }

      pragma[nomagic]
      private predicate partialPathStep(
        PartialPathNodeFwd mid, NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1,
        TSummaryCtx2 sc2, TSummaryCtx3 sc3, TSummaryCtx4 sc4, DataFlowType t, PartialAccessPath ap
      ) {
        partialPathStep1(mid, node, state, cc, sc1, sc2, sc3, sc4, _, t, ap)
      }

      pragma[nomagic]
      private predicate partialPathStep1(
        PartialPathNodeFwd mid, NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1,
        TSummaryCtx2 sc2, TSummaryCtx3 sc3, TSummaryCtx4 sc4, DataFlowType t0, DataFlowType t,
        PartialAccessPath ap
      ) {
        exists(boolean isStoreStep |
          partialPathStep0(mid, node, state, cc, sc1, sc2, sc3, sc4, t0, ap, isStoreStep) and
          not fullBarrier(node) and
          not stateBarrier(node, state) and
          not inBarrier(node, state) and
          (
            notExpectsContent(node) or
            expectsContentEx(node, ap.getHead())
          ) and
          strengthenType(node, t0, t)
        |
          isStoreStep = true or
          not clearsContentEx(node, ap.getHead())
        )
      }

      pragma[nomagic]
      private predicate partialPathTypeStrengthen(
        DataFlowType t0, PartialAccessPath ap, DataFlowType t
      ) {
        partialPathStep1(_, _, _, _, _, _, _, _, t0, t, ap) and t0 != t
      }

      module Public {
        /**
         * A `Node` augmented with a call context, an access path, and a configuration.
         */
        class PartialPathNode extends TPartialPathNode {
          /** Gets a textual representation of this element. */
          string toString() { result = this.getNodeEx().toString() + this.ppType() + this.ppAp() }

          /**
           * Gets a textual representation of this element, including a textual
           * representation of the call context.
           */
          string toStringWithContext() {
            result = this.getNodeEx().toString() + this.ppType() + this.ppAp() + this.ppCtx()
          }

          /** Gets the location of this node. */
          Location getLocation() { result = this.getNodeEx().getLocation() }

          /**
           * Holds if this element is at the specified location.
           * The location spans column `startcolumn` of line `startline` to
           * column `endcolumn` of line `endline` in file `filepath`.
           * For more information, see
           * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
           */
          pragma[inline]
          deprecated predicate hasLocationInfo(
            string filepath, int startline, int startcolumn, int endline, int endcolumn
          ) {
            this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
          }

          /** Gets the underlying `Node`. */
          final Node getNode() { this.getNodeEx().projectToNode() = result }

          FlowState getState() { none() }

          private NodeEx getNodeEx() {
            result = this.(PartialPathNodeFwd).getNodeEx() or
            result = this.(PartialPathNodeRev).getNodeEx()
          }

          /** Gets a successor of this node, if any. */
          PartialPathNode getASuccessor() { none() }

          /**
           * Gets the approximate distance to the nearest source measured in number
           * of interprocedural steps.
           */
          int getSourceDistance() { result = distSrc(this.getNodeEx().getEnclosingCallable()) }

          /**
           * Gets the approximate distance to the nearest sink measured in number
           * of interprocedural steps.
           */
          int getSinkDistance() { result = distSink(this.getNodeEx().getEnclosingCallable()) }

          private string ppType() {
            this instanceof PartialPathNodeRev and result = ""
            or
            exists(string t | t = this.(PartialPathNodeFwd).getType().toString() |
              if t = "" then result = "" else result = " : " + t
            )
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
      }

      import Public

      private class PartialPathNodeFwd extends PartialPathNode, TPartialPathNodeFwd {
        NodeEx node;
        FlowState state;
        CallContext cc;
        TSummaryCtx1 sc1;
        TSummaryCtx2 sc2;
        TSummaryCtx3 sc3;
        TSummaryCtx4 sc4;
        DataFlowType t;
        PartialAccessPath ap;

        PartialPathNodeFwd() {
          this = TPartialPathNodeFwd(node, state, cc, sc1, sc2, sc3, sc4, t, ap)
        }

        NodeEx getNodeEx() { result = node }

        override FlowState getState() { result = state }

        CallContext getCallContext() { result = cc }

        TSummaryCtx1 getSummaryCtx1() { result = sc1 }

        TSummaryCtx2 getSummaryCtx2() { result = sc2 }

        TSummaryCtx3 getSummaryCtx3() { result = sc3 }

        TSummaryCtx4 getSummaryCtx4() { result = sc4 }

        DataFlowType getType() { result = t }

        PartialAccessPath getAp() { result = ap }

        override PartialPathNodeFwd getASuccessor() {
          not outBarrier(node, state) and
          partialPathStep(this, result.getNodeEx(), result.getState(), result.getCallContext(),
            result.getSummaryCtx1(), result.getSummaryCtx2(), result.getSummaryCtx3(),
            result.getSummaryCtx4(), result.getType(), result.getAp())
        }

        predicate isSource() {
          sourceNode(node, state) and
          cc = callContextNone() and
          sc1 = TSummaryCtx1None() and
          sc2 = TSummaryCtx2None() and
          sc3 = TSummaryCtx3None() and
          sc4 = TSummaryCtx4None() and
          ap instanceof TPartialNil
        }
      }

      private class PartialPathNodeRev extends PartialPathNode, TPartialPathNodeRev {
        NodeEx node;
        FlowState state;
        TRevSummaryCtx1 sc1;
        TRevSummaryCtx2 sc2;
        TRevSummaryCtx3 sc3;
        PartialAccessPath ap;

        PartialPathNodeRev() { this = TPartialPathNodeRev(node, state, sc1, sc2, sc3, ap) }

        NodeEx getNodeEx() { result = node }

        override FlowState getState() { result = state }

        TRevSummaryCtx1 getSummaryCtx1() { result = sc1 }

        TRevSummaryCtx2 getSummaryCtx2() { result = sc2 }

        TRevSummaryCtx3 getSummaryCtx3() { result = sc3 }

        PartialAccessPath getAp() { result = ap }

        override PartialPathNodeRev getASuccessor() {
          not inBarrier(node, state) and
          revPartialPathStep(result, this.getNodeEx(), this.getState(), this.getSummaryCtx1(),
            this.getSummaryCtx2(), this.getSummaryCtx3(), this.getAp())
        }

        predicate isSink() {
          revSinkNode(node, state) and
          sc1 = TRevSummaryCtx1None() and
          sc2 = TRevSummaryCtx2None() and
          sc3 = TRevSummaryCtx3None() and
          ap = TPartialNil()
        }
      }

      pragma[nomagic]
      private predicate partialPathStep0(
        PartialPathNodeFwd mid, NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1,
        TSummaryCtx2 sc2, TSummaryCtx3 sc3, TSummaryCtx4 sc4, DataFlowType t, PartialAccessPath ap,
        boolean isStoreStep
      ) {
        not isUnreachableInCall1(node,
          CachedCallContextSensitivity::LocalCallContext::getLocalCc(cc)) and
        (
          localFlowStepEx(mid.getNodeEx(), node, _) and
          state = mid.getState() and
          cc = mid.getCallContext() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          sc4 = mid.getSummaryCtx4() and
          t = mid.getType() and
          ap = mid.getAp()
          or
          additionalLocalFlowStep(mid.getNodeEx(), node, _) and
          state = mid.getState() and
          cc = mid.getCallContext() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          sc4 = mid.getSummaryCtx4() and
          mid.getAp() instanceof PartialAccessPathNil and
          t = node.getDataFlowType() and
          ap = TPartialNil()
          or
          additionalLocalStateStep(mid.getNodeEx(), mid.getState(), node, state, _) and
          cc = mid.getCallContext() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          sc4 = mid.getSummaryCtx4() and
          mid.getAp() instanceof PartialAccessPathNil and
          t = node.getDataFlowType() and
          ap = TPartialNil()
        ) and
        isStoreStep = false
        or
        jumpStepEx(mid.getNodeEx(), node) and
        state = mid.getState() and
        cc = callContextNone() and
        sc1 = TSummaryCtx1None() and
        sc2 = TSummaryCtx2None() and
        sc3 = TSummaryCtx3None() and
        sc4 = TSummaryCtx4None() and
        t = mid.getType() and
        ap = mid.getAp() and
        isStoreStep = false
        or
        additionalJumpStep(mid.getNodeEx(), node, _) and
        state = mid.getState() and
        cc = callContextNone() and
        sc1 = TSummaryCtx1None() and
        sc2 = TSummaryCtx2None() and
        sc3 = TSummaryCtx3None() and
        sc4 = TSummaryCtx4None() and
        mid.getAp() instanceof PartialAccessPathNil and
        t = node.getDataFlowType() and
        ap = TPartialNil() and
        isStoreStep = false
        or
        additionalJumpStateStep(mid.getNodeEx(), mid.getState(), node, state, _) and
        cc = callContextNone() and
        sc1 = TSummaryCtx1None() and
        sc2 = TSummaryCtx2None() and
        sc3 = TSummaryCtx3None() and
        sc4 = TSummaryCtx4None() and
        mid.getAp() instanceof PartialAccessPathNil and
        t = node.getDataFlowType() and
        ap = TPartialNil() and
        isStoreStep = false
        or
        partialPathStoreStep(mid, _, _, _, node, t, ap) and
        state = mid.getState() and
        cc = mid.getCallContext() and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        sc4 = mid.getSummaryCtx4() and
        isStoreStep = true
        or
        exists(DataFlowType t0, PartialAccessPath ap0, Content c |
          partialPathReadStep(mid, t0, ap0, c, node, cc) and
          state = mid.getState() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          sc4 = mid.getSummaryCtx4() and
          apConsFwd(t, ap, c, t0, ap0)
        ) and
        isStoreStep = false
        or
        partialPathIntoCallable(mid, node, state, _, cc, sc1, sc2, sc3, sc4, _, t, ap) and
        isStoreStep = false
        or
        partialPathOutOfCallable(mid, node, state, cc, t, ap) and
        sc1 = TSummaryCtx1None() and
        sc2 = TSummaryCtx2None() and
        sc3 = TSummaryCtx3None() and
        sc4 = TSummaryCtx4None() and
        isStoreStep = false
        or
        partialPathThroughCallable(mid, node, state, cc, t, ap) and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        sc4 = mid.getSummaryCtx4() and
        isStoreStep = false
      }

      bindingset[result, i]
      private int unbindInt(int i) { pragma[only_bind_out](i) = pragma[only_bind_out](result) }

      pragma[inline]
      private predicate partialPathStoreStep(
        PartialPathNodeFwd mid, DataFlowType t1, PartialAccessPath ap1, Content c, NodeEx node,
        DataFlowType t2, PartialAccessPath ap2
      ) {
        exists(NodeEx midNode, DataFlowType contentType |
          midNode = mid.getNodeEx() and
          t1 = mid.getType() and
          ap1 = mid.getAp() and
          storeUnrestricted(midNode, c, node, contentType, t2) and
          ap2.getHead() = c and
          ap2.len() = unbindInt(ap1.len() + 1) and
          compatibleTypesFilter(t1, contentType)
        )
      }

      pragma[nomagic]
      private predicate apConsFwd(
        DataFlowType t1, PartialAccessPath ap1, Content c, DataFlowType t2, PartialAccessPath ap2
      ) {
        partialPathStoreStep(_, t1, ap1, c, _, t2, ap2)
        or
        exists(DataFlowType t0 |
          partialPathTypeStrengthen(t0, ap2, t2) and
          apConsFwd(t1, ap1, c, t0, ap2)
        )
      }

      pragma[nomagic]
      private predicate partialPathReadStep(
        PartialPathNodeFwd mid, DataFlowType t, PartialAccessPath ap, Content c, NodeEx node,
        CallContext cc
      ) {
        exists(NodeEx midNode |
          midNode = mid.getNodeEx() and
          t = mid.getType() and
          ap = mid.getAp() and
          read(midNode, c, node) and
          ap.getHead() = c and
          cc = mid.getCallContext()
        )
      }

      private predicate partialPathOutOfCallable0(
        PartialPathNodeFwd mid, ReturnPosition pos, FlowState state, CallContext innercc,
        DataFlowType t, PartialAccessPath ap
      ) {
        pos = mid.getNodeEx().(RetNodeEx).getReturnPosition() and
        state = mid.getState() and
        innercc = mid.getCallContext() and
        innercc instanceof CallContextNoCall and
        t = mid.getType() and
        ap = mid.getAp()
      }

      pragma[nomagic]
      private predicate partialPathOutOfCallable1(
        PartialPathNodeFwd mid, DataFlowCall call, ReturnKindExt kind, FlowState state,
        CallContext cc, DataFlowType t, PartialAccessPath ap
      ) {
        exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
          partialPathOutOfCallable0(mid, pos, state, innercc, t, ap) and
          c = pos.getCallable() and
          kind = pos.getKind() and
          CachedCallContextSensitivity::resolveReturn(innercc, c, call) and
          cc = CachedCallContextSensitivity::getCallContextReturn(c, call)
        )
      }

      private predicate partialPathOutOfCallable(
        PartialPathNodeFwd mid, NodeEx out, FlowState state, CallContext cc, DataFlowType t,
        PartialAccessPath ap
      ) {
        exists(ReturnKindExt kind, DataFlowCall call |
          partialPathOutOfCallable1(mid, call, kind, state, cc, t, ap) and
          out = kind.getAnOutNodeEx(call)
        )
      }

      pragma[noinline]
      private predicate partialPathIntoArg(
        PartialPathNodeFwd mid, ParameterPosition ppos, FlowState state, CallContext cc,
        DataFlowCall call, DataFlowType t, PartialAccessPath ap
      ) {
        exists(ArgNode arg, ArgumentPosition apos |
          arg = mid.getNodeEx().asNode() and
          state = mid.getState() and
          cc = mid.getCallContext() and
          arg.argumentOf(call, apos) and
          t = mid.getType() and
          ap = mid.getAp() and
          parameterMatch(ppos, apos)
        )
      }

      pragma[nomagic]
      private predicate partialPathIntoCallable0(
        PartialPathNodeFwd mid, DataFlowCallable callable, ParameterPosition pos, FlowState state,
        CallContext outercc, DataFlowCall call, DataFlowType t, PartialAccessPath ap
      ) {
        partialPathIntoArg(mid, pos, state, outercc, call, t, ap) and
        callable = CachedCallContextSensitivity::resolveCall(call, outercc)
      }

      private predicate partialPathIntoCallable(
        PartialPathNodeFwd mid, ParamNodeEx p, FlowState state, CallContext outercc,
        CallContextCall innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, TSummaryCtx3 sc3,
        TSummaryCtx4 sc4, DataFlowCall call, DataFlowType t, PartialAccessPath ap
      ) {
        exists(ParameterPosition pos, DataFlowCallable callable |
          partialPathIntoCallable0(mid, callable, pos, state, outercc, call, t, ap) and
          p.isParameterOf(callable, pos) and
          sc1 = TSummaryCtx1Param(p) and
          sc2 = TSummaryCtx2Some(state) and
          sc3 = TSummaryCtx3Some(t) and
          sc4 = TSummaryCtx4Some(ap) and
          innercc =
            CachedCallContextSensitivity::LocalCallContext::getCallContextCall(call, callable)
        )
      }

      pragma[nomagic]
      private predicate paramFlowsThroughInPartialPath(
        ReturnKindExt kind, FlowState state, CallContextCall cc, TSummaryCtx1 sc1, TSummaryCtx2 sc2,
        TSummaryCtx3 sc3, TSummaryCtx4 sc4, DataFlowType t, PartialAccessPath ap
      ) {
        exists(PartialPathNodeFwd mid, RetNodeEx ret |
          mid.getNodeEx() = ret and
          kind = ret.getKind() and
          state = mid.getState() and
          cc = mid.getCallContext() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          sc4 = mid.getSummaryCtx4() and
          t = mid.getType() and
          ap = mid.getAp()
        )
      }

      pragma[noinline]
      private predicate partialPathThroughCallable0(
        DataFlowCall call, PartialPathNodeFwd mid, ReturnKindExt kind, FlowState state,
        CallContext cc, DataFlowType t, PartialAccessPath ap
      ) {
        exists(
          CallContext innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, TSummaryCtx3 sc3,
          TSummaryCtx4 sc4
        |
          partialPathIntoCallable(mid, _, _, cc, innercc, sc1, sc2, sc3, sc4, call, _, _) and
          paramFlowsThroughInPartialPath(kind, state, innercc, sc1, sc2, sc3, sc4, t, ap)
        )
      }

      private predicate partialPathThroughCallable(
        PartialPathNodeFwd mid, NodeEx out, FlowState state, CallContext cc, DataFlowType t,
        PartialAccessPath ap
      ) {
        exists(DataFlowCall call, ReturnKindExt kind |
          partialPathThroughCallable0(call, mid, kind, state, cc, t, ap) and
          out = kind.getAnOutNodeEx(call)
        )
      }

      pragma[nomagic]
      private predicate revPartialPathStep(
        PartialPathNodeRev mid, NodeEx node, FlowState state, TRevSummaryCtx1 sc1,
        TRevSummaryCtx2 sc2, TRevSummaryCtx3 sc3, PartialAccessPath ap
      ) {
        exists(boolean isStoreStep |
          revPartialPathStep0(mid, node, state, sc1, sc2, sc3, ap, isStoreStep) and
          (
            notExpectsContent(node) or
            expectsContentEx(node, ap.getHead())
          ) and
          not fullBarrier(node) and
          not stateBarrier(node, state) and
          not outBarrier(node, state) and
          // if a node is not the target of a store, we can check `clearsContent` immediately
          (
            storeUnrestricted(_, _, node, _, _)
            or
            not clearsContentEx(node, ap.getHead())
          )
        |
          // if a node is the target of a store, we can only check `clearsContent`
          // when we know whether we took the store step
          isStoreStep = true
          or
          exists(NodeEx midNode, PartialAccessPath midAp |
            midNode = mid.getNodeEx() and
            midAp = mid.getAp() and
            not clearsContentEx(midNode, midAp.getHead())
          )
        )
      }

      pragma[nomagic]
      private predicate revPartialPathStep0(
        PartialPathNodeRev mid, NodeEx node, FlowState state, TRevSummaryCtx1 sc1,
        TRevSummaryCtx2 sc2, TRevSummaryCtx3 sc3, PartialAccessPath ap, boolean isStoreStep
      ) {
        localFlowStepEx(node, mid.getNodeEx(), _) and
        state = mid.getState() and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        ap = mid.getAp() and
        isStoreStep = false
        or
        additionalLocalFlowStep(node, mid.getNodeEx(), _) and
        state = mid.getState() and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        mid.getAp() instanceof PartialAccessPathNil and
        ap = TPartialNil() and
        isStoreStep = false
        or
        additionalLocalStateStep(node, state, mid.getNodeEx(), mid.getState(), _) and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        mid.getAp() instanceof PartialAccessPathNil and
        ap = TPartialNil() and
        isStoreStep = false
        or
        jumpStepEx(node, mid.getNodeEx()) and
        state = mid.getState() and
        sc1 = TRevSummaryCtx1None() and
        sc2 = TRevSummaryCtx2None() and
        sc3 = TRevSummaryCtx3None() and
        ap = mid.getAp() and
        isStoreStep = false
        or
        additionalJumpStep(node, mid.getNodeEx(), _) and
        state = mid.getState() and
        sc1 = TRevSummaryCtx1None() and
        sc2 = TRevSummaryCtx2None() and
        sc3 = TRevSummaryCtx3None() and
        mid.getAp() instanceof PartialAccessPathNil and
        ap = TPartialNil() and
        isStoreStep = false
        or
        additionalJumpStateStep(node, state, mid.getNodeEx(), mid.getState(), _) and
        sc1 = TRevSummaryCtx1None() and
        sc2 = TRevSummaryCtx2None() and
        sc3 = TRevSummaryCtx3None() and
        mid.getAp() instanceof PartialAccessPathNil and
        ap = TPartialNil() and
        isStoreStep = false
        or
        revPartialPathReadStep(mid, _, _, node, ap) and
        state = mid.getState() and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        isStoreStep = false
        or
        exists(PartialAccessPath ap0, Content c |
          revPartialPathStoreStep(mid, ap0, c, node) and
          state = mid.getState() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          apConsRev(ap, c, ap0) and
          isStoreStep = true
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
          isStoreStep = false
        )
        or
        exists(ReturnPosition pos |
          revPartialPathIntoReturn(mid, pos, state, sc1, sc2, sc3, _, ap) and
          pos = node.(RetNodeEx).getReturnPosition() and
          isStoreStep = false
        )
        or
        revPartialPathThroughCallable(mid, node, state, ap) and
        sc1 = mid.getSummaryCtx1() and
        sc2 = mid.getSummaryCtx2() and
        sc3 = mid.getSummaryCtx3() and
        isStoreStep = false
      }

      pragma[inline]
      private predicate revPartialPathReadStep(
        PartialPathNodeRev mid, PartialAccessPath ap1, Content c, NodeEx node, PartialAccessPath ap2
      ) {
        exists(NodeEx midNode |
          midNode = mid.getNodeEx() and
          ap1 = mid.getAp() and
          read(node, c, midNode) and
          ap2.getHead() = c and
          ap2.len() = unbindInt(ap1.len() + 1)
        )
      }

      pragma[nomagic]
      private predicate apConsRev(PartialAccessPath ap1, Content c, PartialAccessPath ap2) {
        revPartialPathReadStep(_, ap1, c, _, ap2)
      }

      pragma[nomagic]
      private predicate revPartialPathStoreStep(
        PartialPathNodeRev mid, PartialAccessPath ap, Content c, NodeEx node
      ) {
        exists(NodeEx midNode |
          midNode = mid.getNodeEx() and
          ap = mid.getAp() and
          storeUnrestricted(node, c, midNode, _, _) and
          ap.getHead() = c
        )
      }

      pragma[nomagic]
      private predicate revPartialPathIntoReturn(
        PartialPathNodeRev mid, ReturnPosition pos, FlowState state, TRevSummaryCtx1Some sc1,
        TRevSummaryCtx2Some sc2, TRevSummaryCtx3Some sc3, DataFlowCall call, PartialAccessPath ap
      ) {
        exists(NodeEx out |
          mid.getNodeEx() = out and
          mid.getState() = state and
          viableReturnPosOutEx(call, pos, out) and
          sc1 = TRevSummaryCtx1Some(pos) and
          sc2 = TRevSummaryCtx2Some(state) and
          sc3 = TRevSummaryCtx3Some(ap) and
          ap = mid.getAp()
        )
      }

      pragma[nomagic]
      private predicate revPartialPathFlowsThrough(
        ArgumentPosition apos, FlowState state, TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2,
        TRevSummaryCtx3Some sc3, PartialAccessPath ap
      ) {
        exists(PartialPathNodeRev mid, ParamNodeEx p, ParameterPosition ppos |
          mid.getNodeEx() = p and
          mid.getState() = state and
          p.getPosition() = ppos and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          ap = mid.getAp() and
          parameterMatch(ppos, apos)
        )
      }

      pragma[nomagic]
      private predicate revPartialPathThroughCallable0(
        DataFlowCall call, PartialPathNodeRev mid, ArgumentPosition pos, FlowState state,
        PartialAccessPath ap
      ) {
        exists(TRevSummaryCtx1Some sc1, TRevSummaryCtx2Some sc2, TRevSummaryCtx3Some sc3 |
          revPartialPathIntoReturn(mid, _, _, sc1, sc2, sc3, call, _) and
          revPartialPathFlowsThrough(pos, state, sc1, sc2, sc3, ap)
        )
      }

      pragma[nomagic]
      private predicate revPartialPathThroughCallable(
        PartialPathNodeRev mid, ArgNodeEx node, FlowState state, PartialAccessPath ap
      ) {
        exists(DataFlowCall call, ArgumentPosition pos |
          revPartialPathThroughCallable0(call, mid, pos, state, ap) and
          node.argumentOf(call, pos)
        )
      }

      private predicate fwdPartialFlow(PartialPathNode source, PartialPathNode node) {
        source.isFwdSource() and
        node = source.getASuccessor+()
      }

      private predicate revPartialFlow(PartialPathNode node, PartialPathNode sink) {
        sink.isRevSink() and
        node.getASuccessor+() = sink
      }

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
       * To use this in a `path-problem` query, import the module `PartialPathGraph`.
       */
      predicate partialFlowFwd(PartialPathNode source, PartialPathNode node, int dist) {
        fwdPartialFlow(source, node) and
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
       * To use this in a `path-problem` query, import the module `PartialPathGraph`.
       *
       * Note that reverse flow has slightly lower precision than the corresponding
       * forward flow, as reverse flow disregards type pruning among other features.
       */
      predicate partialFlowRev(PartialPathNode node, PartialPathNode sink, int dist) {
        revPartialFlow(node, sink) and
        dist = node.getSinkDistance()
      }
    }
  }
}
