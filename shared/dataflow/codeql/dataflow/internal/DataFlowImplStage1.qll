/**
 * INTERNAL: Do not use.
 *
 * Provides an implementation of a fast initial pruning of global
 * (interprocedural) data flow reachability (Stage 1).
 */
overlay[local?]
module;

private import codeql.util.Unit
private import codeql.util.Location
private import codeql.dataflow.DataFlow
private import DataFlowImpl

module MakeImplStage1<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import DataFlowMake<Location, Lang>
  private import MakeImpl<Location, Lang> as Impl
  private import DataFlowImplCommon::MakeImplCommon<Location, Lang>
  private import DataFlowImplCommonPublic
  private import Aliases

  bindingset[this]
  signature class FlowStateSig;

  signature module Stage1Output<FlowStateSig FlowState> {
    bindingset[source, sink]
    predicate isRelevantSourceSinkPair(Node source, Node sink);

    class Nd {
      NodeEx getNodeEx();

      FlowState getState();

      string toString();

      Location getLocation();

      Type getType();

      Callable getEnclosingCallable();
    }

    class ArgNd extends Nd;

    class ParamNd extends Nd;

    class RetNd extends Nd {
      ReturnPosition getReturnPosition();

      ReturnKindExt getKind();
    }

    class OutNd extends Nd;

    class CastingNd extends Nd;

    /** If `node` corresponds to a sink, gets the normal node for that sink. */
    Nd toNormalSinkNode(Nd node);

    predicate sourceNode(Nd node);

    predicate sinkNode(Nd node);

    predicate hasSourceCallCtx();

    predicate hasSinkCallCtx();

    predicate jumpStepEx(Nd node1, Nd node2);

    predicate additionalJumpStep(Nd node1, Nd node2, string model);

    predicate localStep1(
      Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext lcc, string label
    );

    predicate isStateStep(Nd node1, Nd node2);

    bindingset[c]
    predicate expectsContentEx(Nd n, Content c);

    predicate notExpectsContent(Nd n);

    bindingset[p, kind]
    predicate parameterFlowThroughAllowed(ParamNd p, ReturnKindExt kind);

    // begin StageSig
    class Ap;

    class ApNil extends Ap;

    predicate revFlow(Nd node);

    predicate revFlow(Nd node, Ap ap);

    predicate callMayFlowThroughRev(Call call);

    predicate parameterMayFlowThrough(ParamNd p, boolean emptyAp);

    predicate returnMayFlowThrough(RetNd ret, ReturnKindExt kind);

    predicate storeStepCand(Nd node1, Content c, Nd node2, Type contentType, Type containerType);

    predicate readStepCand(Nd n1, Content c, Nd n2);

    predicate callEdgeArgParam(Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp);

    predicate callEdgeReturn(
      Call call, Callable c, RetNd ret, ReturnKindExt kind, Nd out, boolean allowsFieldFlow
    );

    predicate relevantCallEdgeIn(Call call, Callable c);

    predicate relevantCallEdgeOut(Call call, Callable c);

    // end StageSig
    predicate revFlowIsReadAndStored(Content c);

    predicate stats(
      boolean fwd, int nodes, int fields, int conscand, int states, int tuples, int calledges
    );
  }

  module ImplStage1<Impl::FullStateConfigSig Config> {
    private class FlowState = Config::FlowState;

    private module SourceSinkFiltering {
      private import codeql.util.AlertFiltering

      private module AlertFiltering = AlertFilteringImpl<Location>;

      pragma[nomagic]
      private predicate isFilteredSource(Node source) {
        Config::isSource(source, _) and
        if Config::observeDiffInformedIncrementalMode()
        then
          AlertFiltering::filterByLocation(Config::getASelectedSourceLocation(source)) or
          AlertFiltering::filterByLocationApprox(Config::getASelectedSourceLocationApprox(source))
        else any()
      }

      pragma[nomagic]
      private predicate isFilteredSink(Node sink) {
        (
          Config::isSink(sink, _) or
          Config::isSink(sink)
        ) and
        if Config::observeDiffInformedIncrementalMode()
        then
          AlertFiltering::filterByLocation(Config::getASelectedSinkLocation(sink)) or
          AlertFiltering::filterByLocationApprox(Config::getASelectedSinkLocationApprox(sink))
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

    /** If `node` corresponds to a sink, gets the normal node for that sink. */
    pragma[nomagic]
    NodeEx toNormalSinkNodeEx(NodeEx node) {
      exists(Node n |
        pragma[only_bind_out](node.asNodeOrImplicitRead()) = n and
        (isRelevantSink(n) or isRelevantSink(n, _)) and
        result.asNode() = n
      )
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
    private predicate jumpStepEx1(NodeEx node1, NodeEx node2) {
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
    private predicate additionalJumpStep1(NodeEx node1, NodeEx node2, string model) {
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

    pragma[nomagic]
    private predicate storeUnrestricted(
      NodeEx node1, Content c, NodeEx node2, Type contentType, Type containerType
    ) {
      storeEx(node1, c, node2, contentType, containerType) and
      stepFilter(node1, node2)
    }

    pragma[nomagic]
    private predicate hasReadStep(Content c) { read(_, c, _) }

    pragma[nomagic]
    private predicate store(
      NodeEx node1, Content c, NodeEx node2, Type contentType, Type containerType
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

    /**
     * Holds if flow from `p` to a return node of kind `kind` is allowed.
     *
     * We don't expect a parameter to return stored in itself, unless
     * explicitly allowed
     */
    bindingset[p, kind]
    private predicate parameterFlowThroughAllowedEx(ParamNodeEx p, ReturnKindExt kind) {
      exists(ParameterPosition pos | p.isParameterOf(_, pos) |
        not kind.(ParamUpdateReturnKind).getPosition() = pos
        or
        allowParameterReturnInSelfEx(p)
      )
    }

    private module Stage1 {
      private import Stage1Common

      private class Cc = boolean;

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
          jumpStepEx1(mid, node) or
          additionalJumpStep1(mid, node, _) or
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
        exists(Call call, ReturnKindExtOption kind, ReturnKindExtOption disallowReturnKind |
          fwdFlowOutFromArg(call, kind, node) and
          fwdFlowIsEntered(call, disallowReturnKind, cc) and
          kind != disallowReturnKind
        )
      }

      // inline to reduce the number of iterations
      pragma[inline]
      private predicate fwdFlowIn(Call call, NodeEx arg, Cc cc, ParamNodeEx p) {
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
        exists(Callable target |
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
      private predicate fwdFlowIsEntered(Call call, ReturnKindExtOption disallowReturnKind, Cc cc) {
        exists(ParamNodeEx p |
          fwdFlowIn(call, _, cc, p) and
          disallowReturnKind = getDisallowedReturnKind(p)
        )
      }

      pragma[nomagic]
      private predicate fwdFlowInReducedViableImplInSomeCallContext(
        Call call, NodeEx arg, ParamNodeEx p, Callable target
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
      private Callable viableImplInSomeFwdFlowCallContextExt(Call call) {
        exists(Call ctx |
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
      private predicate fwdFlowOut(Call call, ReturnKindExt kind, NodeEx out, Cc cc) {
        exists(ReturnPosition pos |
          fwdFlowReturnPosition(pos, cc) and
          viableReturnPosOutEx(call, pos, out) and
          not fullBarrier(out) and
          kind = pos.getKind()
        )
      }

      pragma[nomagic]
      private predicate fwdFlowOutFromArg(Call call, ReturnKindExtOption kind, NodeEx out) {
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

      predicate sinkNode(NodeEx node, FlowState state) {
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
      predicate revFlow(NodeEx node, boolean toReturn) {
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
          jumpStepEx1(node, mid) or
          additionalJumpStep1(node, mid, _) or
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
        exists(Call call, ReturnKindExtOption kind, ReturnKindExtOption disallowReturnKind |
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
      predicate revFlowIsReadAndStored(Content c) {
        revFlowConsCand(c) and
        revFlowStore(c, _, _)
      }

      pragma[nomagic]
      predicate viableReturnPosOutNodeCandFwd1(Call call, ReturnPosition pos, NodeEx out) {
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
      predicate viableParamArgNodeCandFwd1(Call call, ParamNodeEx p, ArgNodeEx arg) {
        fwdFlowIn(call, arg, _, p)
      }

      // inline to reduce the number of iterations
      pragma[inline]
      private predicate revFlowIn(Call call, ParamNodeEx p, ArgNodeEx arg, boolean toReturn) {
        revFlow(p, toReturn) and
        viableParamArgNodeCandFwd1(call, p, arg)
      }

      pragma[nomagic]
      private predicate revFlowInToReturn(
        Call call, ReturnKindExtOption disallowReturnKind, ArgNodeEx arg
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
      private predicate revFlowIsReturned(Call call, ReturnKindExtOption kind, boolean toReturn) {
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
      predicate revFlowState(FlowState state) {
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
        NodeEx node1, Content c, NodeEx node2, Type contentType, Type containerType
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

      private predicate throughFlowNodeCand(NodeEx node) {
        revFlow(node, true) and
        fwdFlow(node, true) and
        not inBarrier(node) and
        not outBarrier(node)
      }

      /** Holds if flow may return from `callable`. */
      pragma[nomagic]
      private predicate returnFlowCallableNodeCand(Callable callable, ReturnKindExt kind) {
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
        exists(Callable c, ReturnKindExt kind |
          throughFlowNodeCand(p) and
          returnFlowCallableNodeCand(c, kind) and
          p.getEnclosingCallable() = c and
          emptyAp = [true, false] and
          parameterFlowThroughAllowedEx(p, kind)
        )
      }

      pragma[nomagic]
      predicate returnMayFlowThrough(RetNodeEx ret, ReturnKindExt kind) {
        throughFlowNodeCand(ret) and
        kind = ret.getKind()
      }

      pragma[nomagic]
      predicate callMayFlowThroughRev(Call call) {
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
        Call call, Callable c, ArgNodeEx arg, ParamNodeEx p, boolean emptyAp
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
        Call call, Callable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
        boolean allowsFieldFlow
      ) {
        flowOutOfCallNodeCand1(call, ret, kind, out, allowsFieldFlow) and
        c = ret.getEnclosingCallable()
      }

      predicate stats(
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
          count(Call call, Callable c |
            callEdgeArgParam(call, c, _, _, _) or
            callEdgeReturn(call, c, _, _, _, _)
          )
      }
    }

    private module Stage1Common {
      predicate isRelevantSourceSinkPair = SourceSinkFiltering::isRelevantSourceSinkPair/2;

      class Ap = Unit;

      class ApNil = Ap;

      predicate hasSourceCallCtx() {
        exists(FlowFeature feature | feature = Config::getAFeature() |
          feature instanceof FeatureHasSourceCallContext or
          feature instanceof FeatureEqualSourceSinkCallContext
        )
      }

      predicate hasSinkCallCtx() {
        exists(FlowFeature feature | feature = Config::getAFeature() |
          feature instanceof FeatureHasSinkCallContext or
          feature instanceof FeatureEqualSourceSinkCallContext
        )
      }

      predicate revFlowIsReadAndStored = Stage1::revFlowIsReadAndStored/1;

      predicate callMayFlowThroughRev = Stage1::callMayFlowThroughRev/1;

      predicate relevantCallEdgeIn(Call call, Callable c) {
        Stage1::callEdgeArgParam(call, c, _, _, _)
      }

      predicate relevantCallEdgeOut(Call call, Callable c) {
        Stage1::callEdgeReturn(call, c, _, _, _, _)
      }

      predicate stats = Stage1::stats/7;
    }

    pragma[nomagic]
    private predicate localStepNodeCand1(
      NodeEx node1, NodeEx node2, boolean preservesValue, Type t, LocalCallContext lcc, string label
    ) {
      Stage1::revFlow(node1) and
      Stage1::revFlow(node2) and
      (
        preservesValue = true and
        localFlowStepEx(node1, node2, label) and
        t = node1.getType()
        or
        preservesValue = false and
        additionalLocalFlowStep(node1, node2, label) and
        t = node2.getType()
      ) and
      lcc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall1(node1, lcc) and
      not isUnreachableInCall1(node2, lcc)
    }

    pragma[nomagic]
    private predicate localStateStepNodeCand1(
      NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, Type t, LocalCallContext lcc,
      string label
    ) {
      Stage1::revFlow(node1) and
      Stage1::revFlow(node2) and
      additionalLocalStateStep(node1, state1, node2, state2, label) and
      t = node2.getType() and
      lcc.relevantFor(node1.getEnclosingCallable()) and
      not isUnreachableInCall1(node1, lcc) and
      not isUnreachableInCall1(node2, lcc)
    }

    pragma[nomagic]
    private predicate viableReturnPosOutNodeCand1(Call call, ReturnPosition pos, NodeEx out) {
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
      Call call, RetNodeEx ret, ReturnKindExt kind, NodeEx out
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
    private predicate viableParamArgNodeCand1(Call call, ParamNodeEx p, ArgNodeEx arg) {
      Stage1::viableParamArgNodeCandFwd1(call, p, arg) and
      Stage1::revFlow(arg)
    }

    /**
     * Holds if data can flow into `call` and that this step is part of a
     * path from a source to a sink.
     */
    pragma[nomagic]
    private predicate flowIntoCallNodeCand1(Call call, ArgNodeEx arg, ParamNodeEx p) {
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
    private predicate returnCallEdge1(Callable c, SndLevelScopeOption scope, Call call, NodeEx out) {
      exists(RetNodeEx ret |
        flowOutOfCallNodeCand1(call, ret, _, out) and
        c = ret.getEnclosingCallable()
      |
        scope = getSecondLevelScopeEx(ret)
        or
        ret = TParamReturnNode(_, scope)
      )
    }

    private int simpleDispatchFanoutOnReturn(Call call, NodeEx out) {
      result =
        strictcount(Callable c, SndLevelScopeOption scope | returnCallEdge1(c, scope, call, out))
    }

    pragma[nomagic]
    private predicate returnCallEdgeInCtx1(
      Callable c, SndLevelScopeOption scope, Call call, NodeEx out, Call ctx
    ) {
      returnCallEdge1(c, scope, call, out) and
      c = viableImplInCallContextExt(call, ctx)
    }

    private int ctxDispatchFanoutOnReturn(NodeEx out, Call ctx) {
      exists(Call call, Callable c |
        simpleDispatchFanoutOnReturn(call, out) > 1 and
        not Stage1::revFlow(out, false) and
        call.getEnclosingCallable() = c and
        returnCallEdge1(c, _, ctx, _) and
        mayBenefitFromCallContextExt(call, _) and
        result =
          count(Callable tgt, SndLevelScopeOption scope |
            returnCallEdgeInCtx1(tgt, scope, call, out, ctx)
          )
      )
    }

    private int ctxDispatchFanoutOnReturn(NodeEx out) {
      result = max(Call ctx | | ctxDispatchFanoutOnReturn(out, ctx))
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
        strictcount(Callable c |
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
        strictcount(Callable c |
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
      Call call, RetNodeEx ret, ReturnKindExt kind, NodeEx out, boolean allowsFieldFlow
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

    /**
     * Holds if data can flow into `call` and that this step is part of a
     * path from a source to a sink. The `allowsFieldFlow` flag indicates whether
     * the branching is within the limit specified by the configuration.
     */
    pragma[nomagic]
    private predicate flowIntoCallNodeCand1(
      Call call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow
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

    module Stage1NoState implements Stage1Output<Unit> {
      class Nd = NodeEx;

      class ArgNd = ArgNodeEx;

      class ParamNd = ParamNodeEx;

      class RetNd = RetNodeEx;

      class OutNd = OutNodeEx;

      class CastingNd = CastingNodeEx;

      // inline to reduce fan-out via `getAReadContent`
      bindingset[c]
      predicate expectsContentEx(NodeEx n, Content c) {
        exists(ContentSet cs |
          expectsContentSet(n, cs) and
          pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
        )
      }

      pragma[nomagic]
      predicate notExpectsContent(NodeEx n) { not expectsContentSet(n, _) }

      predicate parameterFlowThroughAllowed = parameterFlowThroughAllowedEx/2;

      import Stage1
      import Stage1Common

      predicate revFlow(NodeEx node, Ap ap) { Stage1::revFlow(node) and exists(ap) }

      predicate toNormalSinkNode = toNormalSinkNodeEx/1;

      predicate sourceNode(NodeEx node) { sourceNode(node, _) }

      predicate sinkNode(NodeEx node) { sinkNode(node, _) }

      predicate jumpStepEx = jumpStepEx1/2;

      predicate additionalJumpStep = additionalJumpStep1/3;

      predicate localStep1 = localStepNodeCand1/6;

      predicate isStateStep(NodeEx node1, NodeEx node2) { none() }
    }

    module Stage1WithState implements Stage1Output<FlowState> {
      private predicate flowState(NodeEx node, FlowState state) {
        Stage1::revFlow(node) and
        Stage1::revFlowState(state) and
        not stateBarrier(node, state) and
        (
          sourceNode(node, state)
          or
          exists(NodeEx mid, FlowState state0 | flowState(mid, state0) |
            additionalLocalStateStep(mid, state0, node, state, _) or
            additionalJumpStateStep(mid, state0, node, state, _)
          )
          or
          exists(NodeEx mid | flowState(mid, state) |
            localFlowStepEx(mid, node, _) or
            additionalLocalFlowStep(mid, node, _) or
            jumpStepEx1(mid, node) or
            additionalJumpStep1(mid, node, _) or
            store(mid, _, node, _, _) or
            readSetEx(mid, _, node) or
            flowIntoCallNodeCand1(_, mid, node) or
            flowOutOfCallNodeCand1(_, mid, _, node)
          )
        )
      }

      private newtype TNd = TNodeState(NodeEx node, FlowState state) { flowState(node, state) }

      class Nd extends TNd {
        NodeEx node;

        Nd() { this = TNodeState(node, _) }

        NodeEx getNodeEx() { result = node }

        FlowState getState() { this = TNodeState(_, result) }

        string toString() { result = node.toString() }

        Location getLocation() { result = node.getLocation() }

        Type getType() { result = node.getType() }

        Callable getEnclosingCallable() { result = node.getEnclosingCallable() }
      }

      class ArgNd extends Nd {
        ArgNd() { node instanceof ArgNodeEx }
      }

      class ParamNd extends Nd {
        ParamNd() { node instanceof ParamNodeEx }
      }

      class RetNd extends Nd {
        override RetNodeEx node;

        ReturnPosition getReturnPosition() { result = node.getReturnPosition() }

        ReturnKindExt getKind() { result = node.getKind() }
      }

      class OutNd extends Nd {
        OutNd() { node instanceof OutNodeEx }
      }

      class CastingNd extends Nd {
        CastingNd() { node instanceof CastingNodeEx }
      }

      // inline to reduce fan-out via `getAReadContent`
      bindingset[c]
      predicate expectsContentEx(Nd n, Content c) {
        Stage1NoState::expectsContentEx(n.getNodeEx(), c)
      }

      pragma[nomagic]
      predicate notExpectsContent(Nd n) { Stage1NoState::notExpectsContent(n.getNodeEx()) }

      bindingset[p, kind]
      pragma[inline_late]
      predicate parameterFlowThroughAllowed(ParamNd p, ReturnKindExt kind) {
        parameterFlowThroughAllowedEx(p.getNodeEx(), kind)
      }

      import Stage1Common

      predicate revFlow(Nd node) { Stage1::revFlow(node.getNodeEx()) }

      predicate revFlow(Nd node, Ap ap) { Stage1::revFlow(node.getNodeEx()) and exists(ap) }

      predicate parameterMayFlowThrough(ParamNd p, boolean emptyAp) {
        Stage1::parameterMayFlowThrough(p.getNodeEx(), emptyAp)
      }

      predicate returnMayFlowThrough(RetNd ret, ReturnKindExt kind) {
        Stage1::returnMayFlowThrough(ret.getNodeEx(), kind)
      }

      bindingset[node]
      pragma[inline_late]
      private Nd mkNodeState(NodeEx node, FlowState state) { result = TNodeState(node, state) }

      pragma[nomagic]
      predicate storeStepCand(Nd node1, Content c, Nd node2, Type contentType, Type containerType) {
        exists(NodeEx n1, NodeEx n2, FlowState s |
          Stage1::storeStepCand(n1, c, n2, contentType, containerType) and
          node1 = mkNodeState(n1, s) and
          node2 = mkNodeState(n2, s) and
          not outBarrier(n1, s) and
          not inBarrier(n2, s)
        )
      }

      pragma[nomagic]
      predicate readStepCand(Nd node1, Content c, Nd node2) {
        exists(NodeEx n1, NodeEx n2, FlowState s |
          Stage1::readStepCand(n1, c, n2) and
          node1 = mkNodeState(n1, s) and
          node2 = mkNodeState(n2, s) and
          not outBarrier(n1, s) and
          not inBarrier(n2, s)
        )
      }

      predicate callEdgeArgParam(Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp) {
        exists(ArgNodeEx arg0, ParamNodeEx p0, FlowState s |
          Stage1::callEdgeArgParam(call, c, arg0, p0, emptyAp) and
          arg = mkNodeState(arg0, s) and
          p = mkNodeState(p0, s) and
          not outBarrier(arg0, s) and
          not inBarrier(p0, s)
        )
      }

      predicate callEdgeReturn(
        Call call, Callable c, RetNd ret, ReturnKindExt kind, Nd out, boolean allowsFieldFlow
      ) {
        exists(RetNodeEx ret0, NodeEx out0, FlowState s |
          Stage1::callEdgeReturn(call, c, ret0, kind, out0, allowsFieldFlow) and
          ret = mkNodeState(ret0, s) and
          out = mkNodeState(out0, s) and
          not outBarrier(ret0, s) and
          not inBarrier(out0, s)
        )
      }

      /** If `node` corresponds to a sink, gets the normal node for that sink. */
      Nd toNormalSinkNode(Nd node) {
        exists(NodeEx res, NodeEx n, FlowState s |
          res = toNormalSinkNodeEx(n) and
          node = mkNodeState(n, s) and
          result = mkNodeState(res, s)
        )
      }

      predicate sourceNode(Nd node) {
        exists(NodeEx n, FlowState state |
          sourceNode(n, state) and
          node = TNodeState(n, state)
        )
      }

      predicate sinkNode(Nd node) {
        exists(NodeEx n, FlowState state |
          Stage1::sinkNode(n, state) and
          node = TNodeState(n, state)
        )
      }

      predicate jumpStepEx(Nd node1, Nd node2) {
        exists(NodeEx n1, NodeEx n2, FlowState s |
          jumpStepEx1(n1, n2) and
          node1 = mkNodeState(n1, s) and
          node2 = mkNodeState(n2, s) and
          not outBarrier(n1, s) and
          not inBarrier(n2, s)
        )
      }

      predicate additionalJumpStep(Nd node1, Nd node2, string model) {
        exists(NodeEx n1, NodeEx n2, FlowState s |
          additionalJumpStep1(n1, n2, model) and
          node1 = mkNodeState(n1, s) and
          node2 = mkNodeState(n2, s) and
          not outBarrier(n1, s) and
          not inBarrier(n2, s)
        )
        or
        exists(NodeEx n1, FlowState s1, NodeEx n2, FlowState s2 |
          additionalJumpStateStep(n1, s1, n2, s2, model) and
          node1 = mkNodeState(n1, s1) and
          node2 = mkNodeState(n2, s2)
        )
      }

      pragma[nomagic]
      predicate localStep1(
        Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext lcc, string label
      ) {
        exists(NodeEx n1, NodeEx n2, FlowState s |
          localStepNodeCand1(n1, n2, preservesValue, t, lcc, label) and
          node1 = mkNodeState(n1, s) and
          node2 = mkNodeState(n2, s) and
          not outBarrier(n1, s) and
          not inBarrier(n2, s)
        )
        or
        exists(NodeEx n1, NodeEx n2, FlowState s1, FlowState s2 |
          localStateStepNodeCand1(n1, s1, n2, s2, t, lcc, label) and
          preservesValue = false and
          node1 = mkNodeState(n1, s1) and
          node2 = mkNodeState(n2, s2)
        )
      }

      predicate isStateStep(Nd node1, Nd node2) {
        exists(NodeEx n1, NodeEx n2, FlowState s1, FlowState s2 |
          localStateStepNodeCand1(n1, s1, n2, s2, _, _, _) and
          s1 != s2 and
          node1 = TNodeState(n1, s1) and
          node2 = TNodeState(n2, s2)
        )
      }
    }

    private signature predicate flag();

    private predicate flagEnable() { any() }

    private predicate flagDisable() { none() }

    module PartialFlow {
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
    }

    private module FlowExploration<
      explorationLimitSig/0 explorationLimit, flag/0 flagFwd, flag/0 flagRev>
    {
      class CallContext = CachedCallContextSensitivity::Cc;

      class CallContextCall = CachedCallContextSensitivity::CcCall;

      class CallContextNoCall = CachedCallContextSensitivity::CcNoCall;

      predicate callContextNone = CachedCallContextSensitivity::ccNone/0;

      private predicate callableStep(Callable c1, Callable c2) {
        exists(NodeEx node1, NodeEx node2 |
          jumpStepEx1(node1, node2)
          or
          additionalJumpStep1(node1, node2, _)
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

      private predicate interestingCallableSrc(Callable c) {
        exists(Node n | isRelevantSource(n, _) and c = getNodeEnclosingCallable(n))
        or
        exists(Callable mid | interestingCallableSrc(mid) and callableStep(mid, c))
      }

      private predicate interestingCallableSink(Callable c) {
        exists(Node n | c = getNodeEnclosingCallable(n) |
          isRelevantSink(n, _) or
          isRelevantSink(n)
        )
        or
        exists(Callable mid | interestingCallableSink(mid) and callableStep(c, mid))
      }

      private newtype TCallableExt =
        TCallable(Callable c) {
          interestingCallableSrc(c) or
          interestingCallableSink(c)
        } or
        TCallableSrc() or
        TCallableSink()

      private predicate callableExtSrc(TCallableSrc src) { any() }

      private predicate callableExtSink(TCallableSink sink) { any() }

      private predicate callableExtStepFwd(TCallableExt ce1, TCallableExt ce2) {
        exists(Callable c1, Callable c2 |
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

      private int distSrc(Callable c) { result = distSrcExt(TCallable(c)) - 1 }

      private int distSink(Callable c) { result = distSinkExt(TCallable(c)) - 1 }

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
        TSummaryCtx3Some(Type t)

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
          TSummaryCtx3 sc3, TSummaryCtx4 sc4, Type t, PartialAccessPath ap
        ) {
          flagFwd() and
          sourceNode(node, state) and
          cc = callContextNone() and
          sc1 = TSummaryCtx1None() and
          sc2 = TSummaryCtx2None() and
          sc3 = TSummaryCtx3None() and
          sc4 = TSummaryCtx4None() and
          t = node.getType() and
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
        TSummaryCtx2 sc2, TSummaryCtx3 sc3, TSummaryCtx4 sc4, Type t, PartialAccessPath ap
      ) {
        partialPathStep1(mid, node, state, cc, sc1, sc2, sc3, sc4, _, t, ap)
      }

      bindingset[node, t0]
      private predicate strengthenType(NodeEx node, Type t0, Type t) {
        if node instanceof CastingNodeEx
        then
          exists(Type nt | nt = node.getType() |
            if typeStrongerThanFilter(nt, t0)
            then t = nt
            else (
              compatibleTypesFilter(nt, t0) and t = t0
            )
          )
        else t = t0
      }

      pragma[nomagic]
      private predicate partialPathStep1(
        PartialPathNodeFwd mid, NodeEx node, FlowState state, CallContext cc, TSummaryCtx1 sc1,
        TSummaryCtx2 sc2, TSummaryCtx3 sc3, TSummaryCtx4 sc4, Type t0, Type t, PartialAccessPath ap
      ) {
        exists(boolean isStoreStep |
          partialPathStep0(mid, node, state, cc, sc1, sc2, sc3, sc4, t0, ap, isStoreStep) and
          not fullBarrier(node) and
          not stateBarrier(node, state) and
          not inBarrier(node, state) and
          (
            Stage1NoState::notExpectsContent(node) or
            Stage1NoState::expectsContentEx(node, ap.getHead())
          ) and
          strengthenType(node, t0, t)
        |
          isStoreStep = true or
          not clearsContentEx(node, ap.getHead())
        )
      }

      pragma[nomagic]
      private predicate partialPathTypeStrengthen(Type t0, PartialAccessPath ap, Type t) {
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
          overlay[caller?]
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
        Type t;
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

        Type getType() { result = t }

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
        TSummaryCtx2 sc2, TSummaryCtx3 sc3, TSummaryCtx4 sc4, Type t, PartialAccessPath ap,
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
          t = node.getType() and
          ap = TPartialNil()
          or
          additionalLocalStateStep(mid.getNodeEx(), mid.getState(), node, state, _) and
          cc = mid.getCallContext() and
          sc1 = mid.getSummaryCtx1() and
          sc2 = mid.getSummaryCtx2() and
          sc3 = mid.getSummaryCtx3() and
          sc4 = mid.getSummaryCtx4() and
          mid.getAp() instanceof PartialAccessPathNil and
          t = node.getType() and
          ap = TPartialNil()
        ) and
        isStoreStep = false
        or
        jumpStepEx1(mid.getNodeEx(), node) and
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
        additionalJumpStep1(mid.getNodeEx(), node, _) and
        state = mid.getState() and
        cc = callContextNone() and
        sc1 = TSummaryCtx1None() and
        sc2 = TSummaryCtx2None() and
        sc3 = TSummaryCtx3None() and
        sc4 = TSummaryCtx4None() and
        mid.getAp() instanceof PartialAccessPathNil and
        t = node.getType() and
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
        t = node.getType() and
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
        exists(Type t0, PartialAccessPath ap0, Content c |
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
        PartialPathNodeFwd mid, Type t1, PartialAccessPath ap1, Content c, NodeEx node, Type t2,
        PartialAccessPath ap2
      ) {
        exists(NodeEx midNode, Type contentType |
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
        Type t1, PartialAccessPath ap1, Content c, Type t2, PartialAccessPath ap2
      ) {
        partialPathStoreStep(_, t1, ap1, c, _, t2, ap2)
        or
        exists(Type t0 |
          partialPathTypeStrengthen(t0, ap2, t2) and
          apConsFwd(t1, ap1, c, t0, ap2)
        )
      }

      pragma[nomagic]
      private predicate partialPathReadStep(
        PartialPathNodeFwd mid, Type t, PartialAccessPath ap, Content c, NodeEx node, CallContext cc
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
        PartialPathNodeFwd mid, ReturnPosition pos, FlowState state, CallContext innercc, Type t,
        PartialAccessPath ap
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
        PartialPathNodeFwd mid, Call call, ReturnKindExt kind, FlowState state, CallContext cc,
        Type t, PartialAccessPath ap
      ) {
        exists(ReturnPosition pos, Callable c, CallContext innercc |
          partialPathOutOfCallable0(mid, pos, state, innercc, t, ap) and
          c = pos.getCallable() and
          kind = pos.getKind() and
          CachedCallContextSensitivity::resolveReturn(innercc, c, call) and
          cc = CachedCallContextSensitivity::getCallContextReturn(c, call)
        )
      }

      private predicate partialPathOutOfCallable(
        PartialPathNodeFwd mid, NodeEx out, FlowState state, CallContext cc, Type t,
        PartialAccessPath ap
      ) {
        exists(ReturnKindExt kind, Call call |
          partialPathOutOfCallable1(mid, call, kind, state, cc, t, ap) and
          out = kind.getAnOutNodeEx(call)
        )
      }

      pragma[noinline]
      private predicate partialPathIntoArg(
        PartialPathNodeFwd mid, ParameterPosition ppos, FlowState state, CallContext cc, Call call,
        Type t, PartialAccessPath ap
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
        PartialPathNodeFwd mid, Callable callable, ParameterPosition pos, FlowState state,
        CallContext outercc, Call call, Type t, PartialAccessPath ap
      ) {
        partialPathIntoArg(mid, pos, state, outercc, call, t, ap) and
        callable = CachedCallContextSensitivity::resolveCall(call, outercc)
      }

      private predicate partialPathIntoCallable(
        PartialPathNodeFwd mid, ParamNodeEx p, FlowState state, CallContext outercc,
        CallContextCall innercc, TSummaryCtx1 sc1, TSummaryCtx2 sc2, TSummaryCtx3 sc3,
        TSummaryCtx4 sc4, Call call, Type t, PartialAccessPath ap
      ) {
        exists(ParameterPosition pos, Callable callable |
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
        TSummaryCtx3 sc3, TSummaryCtx4 sc4, Type t, PartialAccessPath ap
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
        Call call, PartialPathNodeFwd mid, ReturnKindExt kind, FlowState state, CallContext cc,
        Type t, PartialAccessPath ap
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
        PartialPathNodeFwd mid, NodeEx out, FlowState state, CallContext cc, Type t,
        PartialAccessPath ap
      ) {
        exists(Call call, ReturnKindExt kind |
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
            Stage1NoState::notExpectsContent(node) or
            Stage1NoState::expectsContentEx(node, ap.getHead())
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
        jumpStepEx1(node, mid.getNodeEx()) and
        state = mid.getState() and
        sc1 = TRevSummaryCtx1None() and
        sc2 = TRevSummaryCtx2None() and
        sc3 = TRevSummaryCtx3None() and
        ap = mid.getAp() and
        isStoreStep = false
        or
        additionalJumpStep1(node, mid.getNodeEx(), _) and
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
        TRevSummaryCtx2Some sc2, TRevSummaryCtx3Some sc3, Call call, PartialAccessPath ap
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
        Call call, PartialPathNodeRev mid, ArgumentPosition pos, FlowState state,
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
        exists(Call call, ArgumentPosition pos |
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
