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
    predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2);

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

    /** Holds if sources should be grouped in the result of `flowPath`. */
    predicate sourceGrouping(Node source, string sourceGroup);

    /** Holds if sinks should be grouped in the result of `flowPath`. */
    predicate sinkGrouping(Node sink, string sinkGroup);

    /**
     * Holds if hidden nodes should be included in the data flow graph.
     *
     * This feature should only be used for debugging or when the data flow graph
     * is not visualized (as it is in a `path-problem` query).
     */
    predicate includeHiddenNodes();
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

    predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
      none()
    }
  }

  /**
   * Constructs a data flow computation given a full input configuration.
   */
  module Impl<FullStateConfigSig Config> {
    private class FlowState = Config::FlowState;

    private newtype TNodeEx =
      TNodeNormal(Node n) or
      TNodeImplicitRead(Node n, boolean hasRead) {
        Config::allowImplicitRead(n, _) and hasRead = [false, true]
      } or
      TParamReturnNode(ParameterNode p, SndLevelScopeOption scope) {
        paramReturnNode(_, p, scope, _)
      }

    private class NodeEx extends TNodeEx {
      string toString() {
        result = this.asNode().toString()
        or
        exists(Node n | this.isImplicitReadNode(n, _) | result = n.toString() + " [Ext]")
        or
        result = this.asParamReturnNode().toString() + " [Return]"
      }

      Node asNode() { this = TNodeNormal(result) }

      predicate isImplicitReadNode(Node n, boolean hasRead) { this = TNodeImplicitRead(n, hasRead) }

      ParameterNode asParamReturnNode() { this = TParamReturnNode(result, _) }

      Node projectToNode() {
        this = TNodeNormal(result) or
        this = TNodeImplicitRead(result, _) or
        this = TParamReturnNode(result, _)
      }

      pragma[nomagic]
      private DataFlowCallable getEnclosingCallable0() {
        nodeEnclosingCallable(this.projectToNode(), result)
      }

      pragma[inline]
      DataFlowCallable getEnclosingCallable() {
        pragma[only_bind_out](this).getEnclosingCallable0() = pragma[only_bind_into](result)
      }

      pragma[nomagic]
      private DataFlowType getDataFlowType0() {
        nodeDataFlowType(this.asNode(), result)
        or
        nodeDataFlowType(this.asParamReturnNode(), result)
      }

      pragma[inline]
      DataFlowType getDataFlowType() {
        pragma[only_bind_out](this).getDataFlowType0() = pragma[only_bind_into](result)
      }

      Location getLocation() { result = this.projectToNode().getLocation() }
    }

    private class ArgNodeEx extends NodeEx {
      ArgNodeEx() { this.asNode() instanceof ArgNode }

      DataFlowCall getCall() { this.asNode().(ArgNode).argumentOf(result, _) }
    }

    private class ParamNodeEx extends NodeEx {
      ParamNodeEx() { this.asNode() instanceof ParamNode }

      predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
        this.asNode().(ParamNode).isParameterOf(c, pos)
      }

      ParameterPosition getPosition() { this.isParameterOf(_, result) }
    }

    /**
     * A node from which flow can return to the caller. This is either a regular
     * `ReturnNode` or a synthesized node for flow out via a parameter.
     */
    private class RetNodeEx extends NodeEx {
      private ReturnPosition pos;

      RetNodeEx() {
        pos = getValueReturnPosition(this.asNode()) or
        pos = getParamReturnPosition(_, this.asParamReturnNode())
      }

      ReturnPosition getReturnPosition() { result = pos }

      ReturnKindExt getKind() { result = pos.getKind() }
    }

    private predicate inBarrier(NodeEx node) {
      exists(Node n |
        node.asNode() = n and
        Config::isBarrierIn(n) and
        Config::isSource(n, _)
      )
    }

    pragma[nomagic]
    private predicate inBarrier(NodeEx node, FlowState state) {
      exists(Node n |
        node.asNode() = n and
        Config::isBarrierIn(n, state) and
        Config::isSource(n, state)
      )
    }

    private predicate outBarrier(NodeEx node) {
      exists(Node n |
        node.asNode() = n and
        Config::isBarrierOut(n)
      |
        Config::isSink(n, _)
        or
        Config::isSink(n)
      )
    }

    pragma[nomagic]
    private predicate outBarrier(NodeEx node, FlowState state) {
      exists(Node n |
        node.asNode() = n and
        Config::isBarrierOut(n, state)
      |
        Config::isSink(n, state)
        or
        Config::isSink(n)
      )
    }

    pragma[nomagic]
    private predicate fullBarrier(NodeEx node) {
      exists(Node n | node.asNode() = n |
        Config::isBarrier(n)
        or
        Config::isBarrierIn(n) and
        not Config::isSource(n, _)
        or
        Config::isBarrierOut(n) and
        not Config::isSink(n, _) and
        not Config::isSink(n)
      )
    }

    pragma[nomagic]
    private predicate stateBarrier(NodeEx node, FlowState state) {
      exists(Node n | node.asNode() = n |
        Config::isBarrier(n, state)
        or
        Config::isBarrierIn(n, state) and
        not Config::isSource(n, state)
        or
        Config::isBarrierOut(n, state) and
        not Config::isSink(n, state) and
        not Config::isSink(n)
      )
    }

    pragma[nomagic]
    private predicate sourceNode(NodeEx node, FlowState state) {
      Config::isSource(node.asNode(), state) and
      not fullBarrier(node) and
      not stateBarrier(node, state)
    }

    pragma[nomagic]
    private predicate sinkNodeWithState(NodeEx node, FlowState state) {
      Config::isSink(node.asNode(), state) and
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
      cc.unreachable(n.asNode())
    }

    /**
     * Holds if data can flow in one local step from `node1` to `node2`.
     */
    private predicate localFlowStepEx(NodeEx node1, NodeEx node2, string model) {
      exists(Node n1, Node n2 |
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        simpleLocalFlowStepExt(pragma[only_bind_into](n1), pragma[only_bind_into](n2), model) and
        stepFilter(node1, node2)
      )
      or
      exists(Node n |
        node1.asNode() = n and
        node2.isImplicitReadNode(n, false) and
        not fullBarrier(node1) and
        model = ""
      )
      or
      exists(Node n1, Node n2, SndLevelScopeOption scope |
        node1.asNode() = n1 and
        node2 = TParamReturnNode(n2, scope) and
        paramReturnNode(pragma[only_bind_into](n1), pragma[only_bind_into](n2),
          pragma[only_bind_into](scope), _) and
        model = ""
      )
    }

    /**
     * Holds if the additional step from `node1` to `node2` does not jump between callables.
     */
    private predicate additionalLocalFlowStep(NodeEx node1, NodeEx node2, string model) {
      exists(Node n1, Node n2 |
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), pragma[only_bind_into](n2), model) and
        getNodeEnclosingCallable(n1) = getNodeEnclosingCallable(n2) and
        stepFilter(node1, node2)
      )
      or
      exists(Node n |
        node1.isImplicitReadNode(n, true) and
        node2.asNode() = n and
        not fullBarrier(node2) and
        model = ""
      )
    }

    private predicate additionalLocalStateStep(
      NodeEx node1, FlowState s1, NodeEx node2, FlowState s2
    ) {
      exists(Node n1, Node n2 |
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), s1, pragma[only_bind_into](n2), s2) and
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
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), pragma[only_bind_into](n2), model) and
        getNodeEnclosingCallable(n1) != getNodeEnclosingCallable(n2) and
        stepFilter(node1, node2) and
        not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
      )
    }

    private predicate additionalJumpStateStep(NodeEx node1, FlowState s1, NodeEx node2, FlowState s2) {
      exists(Node n1, Node n2 |
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        Config::isAdditionalFlowStep(pragma[only_bind_into](n1), s1, pragma[only_bind_into](n2), s2) and
        getNodeEnclosingCallable(n1) != getNodeEnclosingCallable(n2) and
        stateStepFilter(node1, s1, node2, s2) and
        not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
      )
    }

    pragma[nomagic]
    private predicate readSetEx(NodeEx node1, ContentSet c, NodeEx node2) {
      readSet(pragma[only_bind_into](node1.asNode()), c, pragma[only_bind_into](node2.asNode())) and
      stepFilter(node1, node2)
      or
      exists(Node n |
        node2.isImplicitReadNode(n, true) and
        node1.isImplicitReadNode(n, _) and
        Config::allowImplicitRead(n, c)
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
        expectsContentCached(n.asNode(), cs) and
        pragma[only_bind_out](c) = pragma[only_bind_into](cs).getAReadContent()
      )
    }

    pragma[nomagic]
    private predicate notExpectsContent(NodeEx n) { not expectsContentCached(n.asNode(), _) }

    pragma[nomagic]
    private predicate storeExUnrestricted(
      NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
    ) {
      store(pragma[only_bind_into](node1.asNode()), c, pragma[only_bind_into](node2.asNode()),
        contentType, containerType) and
      stepFilter(node1, node2)
    }

    pragma[nomagic]
    private predicate hasReadStep(Content c) { read(_, c, _) }

    pragma[nomagic]
    private predicate storeEx(
      NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
    ) {
      storeExUnrestricted(node1, c, node2, contentType, containerType) and
      hasReadStep(c)
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
        allowParameterReturnInSelfCached(p.asNode())
      )
    }

    private module Stage1 implements StageSig {
      class Ap = Unit;

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
          additionalLocalStateStep(mid, _, node, _)
        )
        or
        exists(NodeEx mid | fwdFlow(mid, _) and cc = false |
          jumpStepEx(mid, node) or
          additionalJumpStep(mid, node, _) or
          additionalJumpStateStep(mid, _, node, _)
        )
        or
        // store
        exists(NodeEx mid |
          useFieldFlow() and
          fwdFlow(mid, cc) and
          storeEx(mid, _, node, _, _)
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
        fwdFlowOut(_, node, false) and
        cc = false
        or
        // flow through a callable
        exists(DataFlowCall call |
          fwdFlowOutFromArg(call, node) and
          fwdFlowIsEntered(call, cc)
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

      /**
       * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`.
       */
      pragma[nomagic]
      private predicate fwdFlowIsEntered(DataFlowCall call, Cc cc) { fwdFlowIn(call, _, cc, _) }

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
          fwdFlowIsEntered(ctx, _) and
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
          storeEx(mid, c, node, _, _)
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
      private predicate fwdFlowOut(DataFlowCall call, NodeEx out, Cc cc) {
        exists(ReturnPosition pos |
          fwdFlowReturnPosition(pos, cc) and
          viableReturnPosOutEx(call, pos, out) and
          not fullBarrier(out)
        )
      }

      pragma[nomagic]
      private predicate fwdFlowOutFromArg(DataFlowCall call, NodeEx out) {
        fwdFlowOut(call, out, true)
      }

      private predicate stateStepFwd(FlowState state1, FlowState state2) {
        exists(NodeEx node1 |
          additionalLocalStateStep(node1, state1, _, state2) or
          additionalJumpStateStep(node1, state1, _, state2)
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
        fwdFlow(node) and
        fwdFlowState(state) and
        Config::isSink(node.asNode())
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
          additionalLocalStateStep(node, _, mid, _)
        )
        or
        exists(NodeEx mid | revFlow(mid, _) and toReturn = false |
          jumpStepEx(node, mid) or
          additionalJumpStep(node, mid, _) or
          additionalJumpStateStep(node, _, mid, _)
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
        revFlowIn(_, node, false) and
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
        exists(DataFlowCall call |
          revFlowInToReturn(call, node) and
          revFlowIsReturned(call, toReturn)
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
          storeEx(node, c, mid, _, _)
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
      private predicate revFlowIn(DataFlowCall call, ArgNodeEx arg, boolean toReturn) {
        exists(ParamNodeEx p |
          revFlow(p, toReturn) and
          viableParamArgNodeCandFwd1(call, p, arg)
        )
      }

      pragma[nomagic]
      private predicate revFlowInToReturn(DataFlowCall call, ArgNodeEx arg) {
        revFlowIn(call, arg, true)
      }

      /**
       * Holds if an output from `call` is reached in the flow covered by `revFlow`
       * and data might flow through the target callable resulting in reverse flow
       * reaching an argument of `call`.
       */
      pragma[nomagic]
      private predicate revFlowIsReturned(DataFlowCall call, boolean toReturn) {
        exists(NodeEx out |
          revFlow(out, toReturn) and
          fwdFlowOutFromArg(call, out)
        )
      }

      private predicate stateStepRev(FlowState state1, FlowState state2) {
        exists(NodeEx node1, NodeEx node2 |
          additionalLocalStateStep(node1, state1, node2, state2) or
          additionalJumpStateStep(node1, state1, node2, state2)
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
        NodeEx node1, Ap ap1, Content c, NodeEx node2, DataFlowType contentType,
        DataFlowType containerType
      ) {
        revFlowIsReadAndStored(c) and
        revFlow(node2) and
        storeEx(node1, c, node2, contentType, containerType) and
        exists(ap1)
      }

      pragma[nomagic]
      predicate readStepCand(NodeEx n1, Content c, NodeEx n2) {
        revFlowIsReadAndStored(c) and
        read(n1, c, n2) and
        revFlow(n2)
      }

      pragma[nomagic]
      predicate revFlow(NodeEx node) { revFlow(node, _) }

      pragma[nomagic]
      predicate revFlowAp(NodeEx node, Ap ap) {
        revFlow(node) and
        exists(ap)
      }

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
      predicate parameterMayFlowThrough(ParamNodeEx p, Ap ap) {
        exists(DataFlowCallable c, ReturnKindExt kind |
          throughFlowNodeCand(p) and
          returnFlowCallableNodeCand(c, kind) and
          p.getEnclosingCallable() = c and
          exists(ap) and
          parameterFlowThroughAllowed(p, kind)
        )
      }

      pragma[nomagic]
      predicate returnMayFlowThrough(RetNodeEx ret, Ap argAp, Ap ap, ReturnKindExt kind) {
        throughFlowNodeCand(ret) and
        kind = ret.getKind() and
        exists(argAp) and
        exists(ap)
      }

      pragma[nomagic]
      predicate callMayFlowThroughRev(DataFlowCall call) {
        exists(ArgNodeEx arg, boolean toReturn |
          revFlow(arg, toReturn) and
          revFlowInToReturn(call, arg) and
          revFlowIsReturned(call, toReturn)
        )
      }

      predicate callEdgeArgParam(
        DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p,
        boolean allowsFieldFlow, Ap ap
      ) {
        flowIntoCallNodeCand1(call, arg, p, allowsFieldFlow) and
        c = p.getEnclosingCallable() and
        exists(ap)
      }

      predicate callEdgeReturn(
        DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
        boolean allowsFieldFlow, Ap ap
      ) {
        flowOutOfCallNodeCand1(call, ret, kind, out, allowsFieldFlow) and
        c = ret.getEnclosingCallable() and
        exists(ap)
      }

      predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c) {
        callEdgeArgParam(call, c, _, _, _, _)
      }

      predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
        callEdgeReturn(call, c, _, _, _, _, _)
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
            callEdgeArgParam(call, c, _, _, _, _) or
            callEdgeReturn(call, c, _, _, _, _, _)
          )
      }
      /* End: Stage 1 logic. */
    }

    private predicate sinkNode = Stage1::sinkNode/2;

    private predicate sourceModel(NodeEx node, string model) {
      sourceNode(node, _) and
      exists(Node n | n = node.asNode() |
        knownSourceModel(n, model)
        or
        not knownSourceModel(n, _) and model = ""
      )
    }

    private predicate sinkModel(NodeEx node, string model) {
      sinkNode(node, _) and
      exists(Node n | n = node.asNode() |
        knownSinkModel(n, model)
        or
        not knownSinkModel(n, _) and model = ""
      )
    }

    bindingset[label1, label2]
    pragma[inline_late]
    private string mergeLabels(string label1, string label2) {
      // Big-step, hidden nodes, and summaries all may need to merge labels.
      // These cases are expected to involve at most one non-empty label, so
      // we'll just discard the 2nd+ label for now.
      if label1 = "" then result = label2 else result = label1
    }

    pragma[noinline]
    private predicate localFlowStepNodeCand1(NodeEx node1, NodeEx node2, string model) {
      Stage1::revFlow(node2) and
      localFlowStepEx(node1, node2, model)
    }

    pragma[noinline]
    private predicate additionalLocalFlowStepNodeCand1(NodeEx node1, NodeEx node2, string model) {
      Stage1::revFlow(node2) and
      additionalLocalFlowStep(node1, node2, model)
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
        scope = getSecondLevelScopeCached(ret.asNode())
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

      predicate revFlow(NodeEx node);

      predicate revFlowAp(NodeEx node, Ap ap);

      bindingset[node, state]
      predicate revFlow(NodeEx node, FlowState state, Ap ap);

      predicate callMayFlowThroughRev(DataFlowCall call);

      predicate parameterMayFlowThrough(ParamNodeEx p, Ap ap);

      predicate returnMayFlowThrough(RetNodeEx ret, Ap argAp, Ap ap, ReturnKindExt kind);

      predicate storeStepCand(
        NodeEx node1, Ap ap1, Content c, NodeEx node2, DataFlowType contentType,
        DataFlowType containerType
      );

      predicate readStepCand(NodeEx n1, Content c, NodeEx n2);

      predicate callEdgeArgParam(
        DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p,
        boolean allowsFieldFlow, Ap ap
      );

      predicate callEdgeReturn(
        DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
        boolean allowsFieldFlow, Ap ap
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

        bindingset[c, t, tail]
        Ap apCons(Content c, Typ t, Ap tail);

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
          Typ t, LocalCc lcc
        );

        bindingset[node, state, t0, ap]
        predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t);

        bindingset[typ, contentType]
        predicate typecheckStore(Typ typ, DataFlowType contentType);

        default predicate enableTypeFlow() { any() }
      }

      module Stage<StageParam Param> implements StageSig {
        import Param

        /* Begin: Stage logic. */
        private module TypOption = Option<Typ>;

        private class TypOption = TypOption::Option;

        pragma[nomagic]
        private Typ getNodeTyp(NodeEx node) {
          PrevStage::revFlow(node) and result = getTyp(node.getDataFlowType())
        }

        pragma[nomagic]
        private predicate flowThroughOutOfCall(
          DataFlowCall call, CcCall ccc, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
          ApApprox argApa, ApApprox apa
        ) {
          exists(ReturnKindExt kind |
            PrevStage::callEdgeReturn(call, _, ret, kind, out, allowsFieldFlow, apa) and
            PrevStage::callMayFlowThroughRev(call) and
            PrevStage::returnMayFlowThrough(ret, argApa, apa, kind) and
            matchesCall(ccc, call)
          )
        }

        pragma[nomagic]
        private predicate compatibleContainer0(ApHeadContent apc, DataFlowType containerType) {
          exists(DataFlowType containerType0, Content c |
            PrevStage::storeStepCand(_, _, c, _, _, containerType0) and
            not isTopType(containerType0) and
            compatibleTypesCached(containerType0, containerType) and
            apc = projectToHeadContent(c)
          )
        }

        pragma[nomagic]
        private predicate topTypeContent(ApHeadContent apc) {
          exists(DataFlowType containerType0, Content c |
            PrevStage::storeStepCand(_, _, c, _, _, containerType0) and
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
         * argument in a call, and if so, `summaryCtx` and `argAp` record the
         * corresponding parameter position and access path of that argument, respectively.
         */
        pragma[nomagic]
        additional predicate fwdFlow(
          NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
          ApOption argAp, Typ t, Ap ap, ApApprox apa
        ) {
          fwdFlow1(node, state, cc, summaryCtx, argT, argAp, _, t, ap, apa)
        }

        private predicate fwdFlow1(
          NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
          ApOption argAp, Typ t0, Typ t, Ap ap, ApApprox apa
        ) {
          fwdFlow0(node, state, cc, summaryCtx, argT, argAp, t0, ap, apa) and
          PrevStage::revFlow(node, state, apa) and
          filter(node, state, t0, ap, t) and
          (
            if castingNodeEx(node)
            then
              ap instanceof ApNil or
              compatibleContainer(getHeadContent(ap), node.getDataFlowType()) or
              topTypeContent(getHeadContent(ap))
            else any()
          )
        }

        pragma[nomagic]
        private predicate typeStrengthen(Typ t0, Ap ap, Typ t) {
          fwdFlow1(_, _, _, _, _, _, t0, t, ap, _) and t0 != t
        }

        pragma[nomagic]
        private predicate fwdFlow0(
          NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
          ApOption argAp, Typ t, Ap ap, ApApprox apa
        ) {
          sourceNode(node, state) and
          (if hasSourceCallCtx() then cc = ccSomeCall() else cc = ccNone()) and
          argT instanceof TypOption::None and
          argAp = apNone() and
          summaryCtx = TParamNodeNone() and
          t = getNodeTyp(node) and
          ap instanceof ApNil and
          apa = getApprox(ap)
          or
          exists(NodeEx mid, FlowState state0, Typ t0, LocalCc localCc |
            fwdFlow(mid, state0, cc, summaryCtx, argT, argAp, t0, ap, apa) and
            localCc = getLocalCc(cc)
          |
            localStep(mid, state0, node, state, true, _, localCc) and
            t = t0
            or
            localStep(mid, state0, node, state, false, t, localCc) and
            ap instanceof ApNil
          )
          or
          fwdFlowJump(node, state, t, ap, apa) and
          cc = ccNone() and
          summaryCtx = TParamNodeNone() and
          argT instanceof TypOption::None and
          argAp = apNone()
          or
          // store
          exists(Content c, Typ t0, Ap ap0 |
            fwdFlowStore(_, t0, ap0, c, t, node, state, cc, summaryCtx, argT, argAp) and
            ap = apCons(c, t0, ap0) and
            apa = getApprox(ap)
          )
          or
          // read
          exists(Typ t0, Ap ap0, Content c |
            fwdFlowRead(t0, ap0, c, _, node, state, cc, summaryCtx, argT, argAp) and
            fwdFlowConsCand(t0, ap0, c, t, ap) and
            apa = getApprox(ap)
          )
          or
          // flow into a callable
          exists(boolean allowsFlowThrough |
            fwdFlowIn(node, apa, state, cc, t, ap, allowsFlowThrough) and
            if allowsFlowThrough = true
            then (
              summaryCtx = TParamNodeSome(node.asNode()) and
              argT = TypOption::some(t) and
              argAp = apSome(ap)
            ) else (
              summaryCtx = TParamNodeNone() and argT instanceof TypOption::None and argAp = apNone()
            )
          )
          or
          // flow out of a callable
          fwdFlowOut(_, _, node, state, cc, summaryCtx, argT, argAp, t, ap, apa)
          or
          // flow through a callable
          exists(
            DataFlowCall call, CcCall ccc, RetNodeEx ret, boolean allowsFieldFlow,
            ApApprox innerArgApa
          |
            fwdFlowThrough(call, cc, state, ccc, summaryCtx, argT, argAp, t, ap, apa, ret,
              innerArgApa) and
            flowThroughOutOfCall(call, ccc, ret, node, allowsFieldFlow, innerArgApa, apa) and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        private predicate fwdFlowJump(NodeEx node, FlowState state, Typ t, Ap ap, ApApprox apa) {
          exists(NodeEx mid |
            fwdFlow(mid, state, _, _, _, _, t, ap, apa) and
            jumpStepEx(mid, node)
          )
          or
          exists(NodeEx mid |
            fwdFlow(mid, state, _, _, _, _, _, ap, apa) and
            additionalJumpStep(mid, node, _) and
            t = getNodeTyp(node) and
            ap instanceof ApNil
          )
          or
          exists(NodeEx mid, FlowState state0 |
            fwdFlow(mid, state0, _, _, _, _, _, ap, apa) and
            additionalJumpStateStep(mid, state0, node, state) and
            t = getNodeTyp(node) and
            ap instanceof ApNil
          )
        }

        pragma[nomagic]
        private predicate fwdFlowStore(
          NodeEx node1, Typ t1, Ap ap1, Content c, Typ t2, NodeEx node2, FlowState state, Cc cc,
          ParamNodeOption summaryCtx, TypOption argT, ApOption argAp
        ) {
          exists(DataFlowType contentType, DataFlowType containerType, ApApprox apa1 |
            fwdFlow(node1, state, cc, summaryCtx, argT, argAp, t1, ap1, apa1) and
            PrevStage::storeStepCand(node1, apa1, c, node2, contentType, containerType) and
            t2 = getTyp(containerType) and
            typecheckStore(t1, contentType)
          )
        }

        /**
         * Holds if forward flow with access path `tail` and type `t1` reaches a
         * store of `c` on a container of type `t2` resulting in access path
         * `cons`.
         */
        pragma[nomagic]
        private predicate fwdFlowConsCand(Typ t2, Ap cons, Content c, Typ t1, Ap tail) {
          fwdFlowStore(_, t1, tail, c, t2, _, _, _, _, _, _) and
          cons = apCons(c, t1, tail)
          or
          exists(Typ t0 |
            typeStrengthen(t0, cons, t2) and
            fwdFlowConsCand(t0, cons, c, t1, tail)
          )
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
        private predicate fwdFlowRead(
          Typ t, Ap ap, Content c, NodeEx node1, NodeEx node2, FlowState state, Cc cc,
          ParamNodeOption summaryCtx, TypOption argT, ApOption argAp
        ) {
          exists(ApHeadContent apc |
            fwdFlow(node1, state, cc, summaryCtx, argT, argAp, t, ap, _) and
            apc = getHeadContent(ap) and
            readStepCand0(node1, apc, c, node2)
          )
        }

        pragma[nomagic]
        private predicate fwdFlowIntoArg(
          ArgNodeEx arg, FlowState state, Cc outercc, ParamNodeOption summaryCtx, TypOption argT,
          ApOption argAp, Typ t, Ap ap, boolean emptyAp, ApApprox apa, boolean cc
        ) {
          fwdFlow(arg, state, outercc, summaryCtx, argT, argAp, t, ap, apa) and
          (if instanceofCcCall(outercc) then cc = true else cc = false) and
          if ap instanceof ApNil then emptyAp = true else emptyAp = false
        }

        private signature module FwdFlowInInputSig {
          default predicate callRestriction(DataFlowCall call) { any() }

          bindingset[p, apa]
          default predicate parameterRestriction(ParamNodeEx p, ApApprox apa) { any() }
        }

        /**
         * Exposes the inlined predicate `fwdFlowIn`, which is used to calculate both
         * flow in and flow through.
         *
         * For flow in, only a subset of the columns are needed, specifically we don't
         * need to record the argument that flows into the parameter.
         *
         * For flow through, we do need to record the argument, however, we can restrict
         * this to arguments that may actually flow through, using `callRestriction` and
         * `parameterRestriction`, which reduces the argument-to-parameter fan-in
         * significantly.
         */
        private module FwdFlowIn<FwdFlowInInputSig I> {
          pragma[nomagic]
          private predicate callEdgeArgParamRestricted(
            DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p,
            boolean allowsFieldFlow, ApApprox apa
          ) {
            PrevStage::callEdgeArgParam(call, c, arg, p, allowsFieldFlow, apa) and
            I::callRestriction(call) and
            I::parameterRestriction(p, apa)
          }

          pragma[nomagic]
          private DataFlowCallable viableImplCallContextReducedRestricted(
            DataFlowCall call, CcCall ctx
          ) {
            result = viableImplCallContextReduced(call, ctx) and
            callEdgeArgParamRestricted(call, result, _, _, _, _)
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
            callEdgeArgParamRestricted(call, _, arg, _, _, _) and
            instanceofCcCall(ctx) and
            result = viableImplCallContextReducedInlineLate(call, ctx)
          }

          bindingset[call]
          pragma[inline_late]
          private predicate callEdgeArgParamRestrictedInlineLate(
            DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p,
            boolean allowsFieldFlow, ApApprox apa
          ) {
            callEdgeArgParamRestricted(call, c, arg, p, allowsFieldFlow, apa)
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
            callEdgeArgParamRestricted(call, _, arg, _, _, _) and
            instanceofCc(outercc) and
            viableImplNotCallContextReducedInlineLate(call, outercc)
          }

          pragma[inline]
          private predicate fwdFlowInCand(
            DataFlowCall call, ArgNodeEx arg, FlowState state, Cc outercc, DataFlowCallable inner,
            ParamNodeEx p, ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t, Ap ap,
            boolean emptyAp, ApApprox apa, boolean cc, boolean allowsFlowThrough
          ) {
            exists(boolean allowsFieldFlow |
              fwdFlowIntoArg(arg, state, outercc, summaryCtx, argT, argAp, t, ap, emptyAp, apa, cc) and
              (
                inner = viableImplCallContextReducedInlineLate(call, arg, outercc)
                or
                viableImplArgNotCallContextReduced(call, arg, outercc)
              ) and
              callEdgeArgParamRestrictedInlineLate(call, inner, arg, p, allowsFieldFlow, apa) and
              (if allowsFieldFlow = false then emptyAp = true else any()) and
              if allowsFieldFlowThrough(call, inner)
              then allowsFlowThrough = true
              else allowsFlowThrough = emptyAp
            )
          }

          pragma[inline]
          private predicate fwdFlowInCandTypeFlowDisabled(
            DataFlowCall call, ArgNodeEx arg, FlowState state, Cc outercc, DataFlowCallable inner,
            ParamNodeEx p, ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t, Ap ap,
            ApApprox apa, boolean cc, boolean allowsFlowThrough
          ) {
            not enableTypeFlow() and
            fwdFlowInCand(call, arg, state, outercc, inner, p, summaryCtx, argT, argAp, t, ap, _,
              apa, cc, allowsFlowThrough)
          }

          pragma[nomagic]
          private predicate fwdFlowInCandTypeFlowEnabled(
            DataFlowCall call, ArgNodeEx arg, Cc outercc, DataFlowCallable inner, ParamNodeEx p,
            boolean emptyAp, ApApprox apa, boolean cc, boolean allowsFlowThrough
          ) {
            enableTypeFlow() and
            fwdFlowInCand(call, arg, _, outercc, inner, p, _, _, _, _, _, emptyAp, apa, cc,
              allowsFlowThrough)
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
            CcCall innercc, boolean emptyAp, ApApprox apa, boolean cc, boolean allowsFlowThrough
          ) {
            fwdFlowInCandTypeFlowEnabled(call, arg, outercc, inner, p, emptyAp, apa, cc,
              allowsFlowThrough) and
            FwdTypeFlow::typeFlowValidEdgeIn(call, inner, cc) and
            innercc = getCallContextCall(call, inner)
          }

          pragma[inline]
          predicate fwdFlowIn(
            DataFlowCall call, ArgNodeEx arg, DataFlowCallable inner, ParamNodeEx p,
            FlowState state, Cc outercc, CcCall innercc, ParamNodeOption summaryCtx, TypOption argT,
            ApOption argAp, Typ t, Ap ap, ApApprox apa, boolean cc, boolean allowsFlowThrough
          ) {
            // type flow disabled: linear recursion
            fwdFlowInCandTypeFlowDisabled(call, arg, state, outercc, inner, p, summaryCtx, argT,
              argAp, t, ap, apa, cc, allowsFlowThrough) and
            fwdFlowInValidEdgeTypeFlowDisabled(call, inner, innercc, pragma[only_bind_into](cc))
            or
            // type flow enabled: non-linear recursion
            exists(boolean emptyAp |
              fwdFlowIntoArg(arg, state, outercc, summaryCtx, argT, argAp, t, ap, emptyAp, apa, cc) and
              fwdFlowInValidEdgeTypeFlowEnabled(call, arg, outercc, inner, p, innercc, emptyAp, apa,
                cc, allowsFlowThrough)
            )
          }
        }

        private module FwdFlowInNoRestriction implements FwdFlowInInputSig { }

        pragma[nomagic]
        private predicate fwdFlowIn(
          ParamNodeEx p, ApApprox apa, FlowState state, CcCall innercc, Typ t, Ap ap,
          boolean allowsFlowThrough
        ) {
          exists(boolean allowsFlowThrough0 |
            FwdFlowIn<FwdFlowInNoRestriction>::fwdFlowIn(_, _, _, p, state, _, innercc, _, _, _, t,
              ap, apa, _, allowsFlowThrough0) and
            if PrevStage::parameterMayFlowThrough(p, apa)
            then allowsFlowThrough = allowsFlowThrough0
            else allowsFlowThrough = false
          )
        }

        pragma[nomagic]
        private DataFlowCall viableImplCallContextReducedReverseRestricted(
          DataFlowCallable c, CcNoCall ctx
        ) {
          result = viableImplCallContextReducedReverse(c, ctx) and
          PrevStage::callEdgeReturn(result, c, _, _, _, _, _)
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
        private predicate flowOutOfCallApaInlineLate(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
          ApApprox apa
        ) {
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow, apa)
        }

        bindingset[c, ret, apa, innercc]
        pragma[inline_late]
        pragma[noopt]
        private predicate flowOutOfCallApaNotCallContextReduced(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, NodeEx out, boolean allowsFieldFlow,
          ApApprox apa, CcNoCall innercc
        ) {
          viableImplNotCallContextReducedReverse(innercc) and
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow, apa)
        }

        pragma[nomagic]
        private predicate fwdFlowIntoRet(
          RetNodeEx ret, FlowState state, CcNoCall cc, ParamNodeOption summaryCtx, TypOption argT,
          ApOption argAp, Typ t, Ap ap, ApApprox apa
        ) {
          instanceofCcNoCall(cc) and
          fwdFlow(ret, state, cc, summaryCtx, argT, argAp, t, ap, apa)
        }

        pragma[nomagic]
        private predicate fwdFlowOutCand(
          DataFlowCall call, RetNodeEx ret, CcNoCall innercc, DataFlowCallable inner, NodeEx out,
          ApApprox apa, boolean allowsFieldFlow
        ) {
          fwdFlowIntoRet(ret, _, innercc, _, _, _, _, _, apa) and
          inner = ret.getEnclosingCallable() and
          (
            call = viableImplCallContextReducedReverseInlineLate(inner, innercc) and
            flowOutOfCallApaInlineLate(call, inner, ret, out, allowsFieldFlow, apa)
            or
            flowOutOfCallApaNotCallContextReduced(call, inner, ret, out, allowsFieldFlow, apa,
              innercc)
          )
        }

        pragma[nomagic]
        private predicate fwdFlowOutValidEdge(
          DataFlowCall call, RetNodeEx ret, CcNoCall innercc, DataFlowCallable inner, NodeEx out,
          CcNoCall outercc, ApApprox apa, boolean allowsFieldFlow
        ) {
          fwdFlowOutCand(call, ret, innercc, inner, out, apa, allowsFieldFlow) and
          FwdTypeFlow::typeFlowValidEdgeOut(call, inner) and
          outercc = getCallContextReturn(inner, call)
        }

        pragma[inline]
        private predicate fwdFlowOut(
          DataFlowCall call, DataFlowCallable inner, NodeEx out, FlowState state, CcNoCall outercc,
          ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t, Ap ap, ApApprox apa
        ) {
          exists(RetNodeEx ret, CcNoCall innercc, boolean allowsFieldFlow |
            fwdFlowIntoRet(ret, state, innercc, summaryCtx, argT, argAp, t, ap, apa) and
            fwdFlowOutValidEdge(call, ret, innercc, inner, out, outercc, apa, allowsFieldFlow) and
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
            Typ t, Ap ap, boolean cc
          ) {
            FwdFlowIn<FwdFlowInNoRestriction>::fwdFlowIn(call, _, c, p, state, _, innercc, _, _, _,
              t, ap, _, cc, _)
          }

          pragma[nomagic]
          private predicate fwdFlow1Param(ParamNodeEx p, FlowState state, CcCall cc, Typ t0, Ap ap) {
            instanceofCcCall(cc) and
            fwdFlow1(p, state, cc, _, _, _, t0, _, ap, _)
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeIn(DataFlowCall call, DataFlowCallable c, boolean cc) {
            exists(ParamNodeEx p, FlowState state, CcCall innercc, Typ t, Ap ap |
              dataFlowTakenCallEdgeIn0(call, c, p, state, innercc, t, ap, cc) and
              fwdFlow1Param(p, state, innercc, t, ap)
            )
          }

          pragma[nomagic]
          private predicate dataFlowTakenCallEdgeOut0(
            DataFlowCall call, DataFlowCallable c, NodeEx node, FlowState state, Cc cc, Typ t, Ap ap
          ) {
            fwdFlowOut(call, c, node, state, cc, _, _, _, t, ap, _)
          }

          pragma[nomagic]
          private predicate fwdFlow1Out(NodeEx node, FlowState state, Cc cc, Typ t0, Ap ap) {
            exists(ApApprox apa |
              fwdFlow1(node, state, cc, _, _, _, t0, _, ap, apa) and
              PrevStage::callEdgeReturn(_, _, _, _, node, _, apa)
            )
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
            exists(NodeEx node, FlowState state, Cc cc, Typ t, Ap ap |
              dataFlowTakenCallEdgeOut0(call, c, node, state, cc, t, ap) and
              fwdFlow1Out(node, state, cc, t, ap)
            )
          }

          predicate dataFlowNonCallEntry(DataFlowCallable c, boolean cc) {
            exists(NodeEx node, FlowState state |
              sourceNode(node, state) and
              (if hasSourceCallCtx() then cc = true else cc = false) and
              PrevStage::revFlow(node, state, getApprox(any(ApNil nil))) and
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

        private predicate flowIntoCallApaTaken(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p,
          boolean allowsFieldFlow, ApApprox apa
        ) {
          PrevStage::callEdgeArgParam(call, c, arg, p, allowsFieldFlow, apa) and
          FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _)
        }

        pragma[nomagic]
        private predicate fwdFlowRetFromArg(
          RetNodeEx ret, FlowState state, CcCall ccc, ParamNodeEx summaryCtx, Typ argT, Ap argAp,
          ApApprox argApa, Typ t, Ap ap, ApApprox apa
        ) {
          exists(ReturnKindExt kind |
            instanceofCcCall(ccc) and
            fwdFlow(pragma[only_bind_into](ret), state, ccc,
              TParamNodeSome(pragma[only_bind_into](summaryCtx.asNode())), TypOption::some(argT),
              pragma[only_bind_into](apSome(argAp)), t, ap, pragma[only_bind_into](apa)) and
            kind = ret.getKind() and
            parameterFlowThroughAllowed(summaryCtx, kind) and
            argApa = getApprox(argAp) and
            PrevStage::returnMayFlowThrough(ret, argApa, apa, kind)
          )
        }

        pragma[inline]
        private predicate fwdFlowThrough0(
          DataFlowCall call, ArgNodeEx arg, Cc cc, FlowState state, CcCall ccc,
          ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t, Ap ap, ApApprox apa,
          RetNodeEx ret, ParamNodeEx innerSummaryCtx, Typ innerArgT, Ap innerArgAp,
          ApApprox innerArgApa
        ) {
          fwdFlowRetFromArg(ret, state, ccc, innerSummaryCtx, innerArgT, innerArgAp, innerArgApa, t,
            ap, apa) and
          fwdFlowIsEntered(call, arg, cc, ccc, summaryCtx, argT, argAp, innerSummaryCtx, innerArgT,
            innerArgAp)
        }

        pragma[nomagic]
        private predicate fwdFlowThrough(
          DataFlowCall call, Cc cc, FlowState state, CcCall ccc, ParamNodeOption summaryCtx,
          TypOption argT, ApOption argAp, Typ t, Ap ap, ApApprox apa, RetNodeEx ret,
          ApApprox innerArgApa
        ) {
          fwdFlowThrough0(call, _, cc, state, ccc, summaryCtx, argT, argAp, t, ap, apa, ret, _, _,
            _, innerArgApa)
        }

        private module FwdFlowThroughRestriction implements FwdFlowInInputSig {
          predicate callRestriction = PrevStage::callMayFlowThroughRev/1;

          predicate parameterRestriction = PrevStage::parameterMayFlowThrough/2;
        }

        /**
         * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`
         * and data might flow through the target callable and back out at `call`.
         */
        pragma[nomagic]
        private predicate fwdFlowIsEntered(
          DataFlowCall call, ArgNodeEx arg, Cc cc, CcCall innerCc, ParamNodeOption summaryCtx,
          TypOption argT, ApOption argAp, ParamNodeEx p, Typ t, Ap ap
        ) {
          FwdFlowIn<FwdFlowThroughRestriction>::fwdFlowIn(call, arg, _, p, _, cc, innerCc,
            summaryCtx, argT, argAp, t, ap, _, _, true)
        }

        pragma[nomagic]
        private predicate storeStepFwd(NodeEx node1, Typ t1, Ap ap1, Content c, NodeEx node2, Ap ap2) {
          fwdFlowStore(node1, t1, ap1, c, _, node2, _, _, _, _, _) and
          ap2 = apCons(c, t1, ap1) and
          readStepFwd(_, ap2, c, _, _)
        }

        pragma[nomagic]
        private predicate readStepFwd(NodeEx n1, Ap ap1, Content c, NodeEx n2, Ap ap2) {
          exists(Typ t1 |
            fwdFlowRead(t1, ap1, c, n1, n2, _, _, _, _, _) and
            fwdFlowConsCand(t1, ap1, c, _, ap2)
          )
        }

        pragma[nomagic]
        private predicate returnFlowsThrough0(
          DataFlowCall call, FlowState state, CcCall ccc, Ap ap, ApApprox apa, RetNodeEx ret,
          ParamNodeEx innerSummaryCtx, Typ innerArgT, Ap innerArgAp, ApApprox innerArgApa
        ) {
          fwdFlowThrough0(call, _, _, state, ccc, _, _, _, _, ap, apa, ret, innerSummaryCtx,
            innerArgT, innerArgAp, innerArgApa)
        }

        pragma[nomagic]
        private predicate returnFlowsThrough(
          RetNodeEx ret, ReturnPosition pos, FlowState state, CcCall ccc, ParamNodeEx p, Typ argT,
          Ap argAp, ApApprox argApa, Ap ap
        ) {
          exists(DataFlowCall call, ApApprox apa, boolean allowsFieldFlow |
            returnFlowsThrough0(call, state, ccc, ap, apa, ret, p, argT, argAp, argApa) and
            flowThroughOutOfCall(call, ccc, ret, _, allowsFieldFlow, argApa, apa) and
            pos = ret.getReturnPosition() and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        pragma[nomagic]
        private predicate flowThroughIntoCall(
          DataFlowCall call, ArgNodeEx arg, ParamNodeEx p, boolean allowsFieldFlow, Ap argAp, Ap ap
        ) {
          exists(ApApprox argApa, Typ argT |
            returnFlowsThrough(_, _, _, _, pragma[only_bind_into](p), pragma[only_bind_into](argT),
              pragma[only_bind_into](argAp), pragma[only_bind_into](argApa), ap) and
            flowIntoCallApaTaken(call, _, pragma[only_bind_into](arg), p, allowsFieldFlow, argApa) and
            fwdFlow(arg, _, _, _, _, _, pragma[only_bind_into](argT), pragma[only_bind_into](argAp),
              pragma[only_bind_into](argApa)) and
            if allowsFieldFlow = false then argAp instanceof ApNil else any()
          )
        }

        pragma[nomagic]
        private predicate flowIntoCallAp(
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p, Ap ap
        ) {
          exists(ApApprox apa, boolean allowsFieldFlow |
            flowIntoCallApaTaken(call, c, arg, p, allowsFieldFlow, apa) and
            fwdFlow(arg, _, _, _, _, _, _, ap, apa) and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        pragma[nomagic]
        private predicate flowOutOfCallAp(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnPosition pos, NodeEx out,
          Ap ap
        ) {
          exists(ApApprox apa, boolean allowsFieldFlow |
            PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow, apa) and
            fwdFlow(ret, _, _, _, _, _, _, ap, apa) and
            pos = ret.getReturnPosition() and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          |
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
          fwdFlow(node, state, _, _, _, _, _, ap, _)
        }

        pragma[nomagic]
        private predicate revFlow0(
          NodeEx node, FlowState state, ReturnCtx returnCtx, ApOption returnAp, Ap ap
        ) {
          fwdFlow(node, state, _, _, _, _, _, ap, _) and
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
            localStep(node, state, mid, state0, true, _, _) and
            revFlow(mid, state0, returnCtx, returnAp, ap)
          )
          or
          exists(NodeEx mid, FlowState state0 |
            localStep(node, pragma[only_bind_into](state), mid, state0, false, _, _) and
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
            revFlowStore(ap0, c, ap, _, node, state, _, returnCtx, returnAp) and
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
          exists(DataFlowCall call, ParamNodeEx p, Ap innerReturnAp |
            revFlowThrough(call, returnCtx, p, state, _, returnAp, ap, innerReturnAp) and
            flowThroughIntoCall(call, node, p, _, ap, innerReturnAp)
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
            additionalJumpStateStep(node, state, mid, state0) and
            revFlow(pragma[only_bind_into](mid), pragma[only_bind_into](state0), _, _, ap) and
            ap instanceof ApNil
          )
        }

        pragma[nomagic]
        private predicate revFlowStore(
          Ap ap0, Content c, Ap ap, Typ t, NodeEx node, FlowState state, NodeEx mid,
          ReturnCtx returnCtx, ApOption returnAp
        ) {
          revFlow(mid, state, returnCtx, returnAp, ap0) and
          storeStepFwd(node, t, ap, c, mid, ap0)
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
            flowOutOfCallAp(call, c, _, _, _, _)
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
              fwdFlow(node, state, _, _, _, _, _, nil, _) and
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
            flowOutOfCallAp(call, c, ret, pos, out, ap) and
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
          PrevStage::parameterMayFlowThrough(p, getApprox(ap))
        }

        pragma[nomagic]
        private predicate revFlowThrough(
          DataFlowCall call, ReturnCtx returnCtx, ParamNodeEx p, FlowState state,
          ReturnPosition pos, ApOption returnAp, Ap ap, Ap innerReturnAp
        ) {
          revFlowParamToReturn(p, state, pos, innerReturnAp, ap) and
          revFlowIsReturned(call, returnCtx, returnAp, pos, innerReturnAp)
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
          NodeEx node1, Ap ap1, Content c, NodeEx node2, DataFlowType contentType,
          DataFlowType containerType
        ) {
          exists(Ap ap2 |
            PrevStage::storeStepCand(node1, _, c, node2, contentType, containerType) and
            revFlowStore(ap2, c, ap1, _, node1, _, node2, _, _) and
            revFlowConsCand(ap2, c, ap1)
          )
        }

        predicate readStepCand(NodeEx node1, Content c, NodeEx node2) {
          exists(Ap ap1, Ap ap2 |
            revFlow(node2, _, _, _, pragma[only_bind_into](ap2)) and
            readStepFwd(node1, ap1, c, node2, ap2) and
            revFlowStore(ap1, c, pragma[only_bind_into](ap2), _, _, _, _, _, _)
          )
        }

        additional predicate revFlow(NodeEx node, FlowState state) { revFlow(node, state, _, _, _) }

        predicate revFlow(NodeEx node, FlowState state, Ap ap) { revFlow(node, state, _, _, ap) }

        pragma[nomagic]
        predicate revFlow(NodeEx node) { revFlow(node, _, _, _, _) }

        pragma[nomagic]
        predicate revFlowAp(NodeEx node, Ap ap) { revFlow(node, _, _, _, ap) }

        private predicate fwdConsCand(Content c, Typ t, Ap ap) { storeStepFwd(_, t, ap, c, _, _) }

        private predicate revConsCand(Content c, Typ t, Ap ap) {
          exists(Ap ap2 |
            revFlowStore(ap2, c, ap, t, _, _, _, _, _) and
            revFlowConsCand(ap2, c, ap)
          )
        }

        private predicate validAp(Ap ap) {
          revFlow(_, _, _, _, ap) and ap instanceof ApNil
          or
          exists(Content head, Typ t, Ap tail |
            consCand(head, t, tail) and
            ap = apCons(head, t, tail)
          )
        }

        additional predicate consCand(Content c, Typ t, Ap ap) {
          revConsCand(c, t, ap) and
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
        predicate parameterMayFlowThrough(ParamNodeEx p, Ap ap) {
          exists(ReturnPosition pos |
            returnFlowsThrough(_, pos, _, _, p, _, ap, _, _) and
            parameterFlowsThroughRev(p, ap, pos, _)
          )
        }

        pragma[nomagic]
        predicate returnMayFlowThrough(RetNodeEx ret, Ap argAp, Ap ap, ReturnKindExt kind) {
          exists(ParamNodeEx p, ReturnPosition pos |
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
          exists(ParamNodeEx p, Ap innerReturnAp |
            revFlowThrough(call, returnCtx, p, state, _, returnAp, ap, innerReturnAp) and
            flowThroughIntoCall(call, arg, p, _, ap, innerReturnAp)
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
          DataFlowCall call, DataFlowCallable c, ArgNodeEx arg, ParamNodeEx p,
          boolean allowsFieldFlow, Ap ap
        ) {
          exists(FlowState state |
            flowIntoCallAp(call, c, arg, p, ap) and
            revFlow(arg, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            revFlow(p, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            // allowsFieldFlow has already been checked in flowIntoCallAp, since
            // `Ap` is at least as precise as a boolean from Stage 2 and
            // forward, so no need to check it again later.
            allowsFieldFlow = true
          |
            // both directions are needed for flow-through
            RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
            RevTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
          )
        }

        predicate callEdgeReturn(
          DataFlowCall call, DataFlowCallable c, RetNodeEx ret, ReturnKindExt kind, NodeEx out,
          boolean allowsFieldFlow, Ap ap
        ) {
          exists(FlowState state, ReturnPosition pos |
            flowOutOfCallAp(call, c, ret, pos, out, ap) and
            revFlow(ret, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            revFlow(out, pragma[only_bind_into](state), pragma[only_bind_into](ap)) and
            kind = pos.getKind() and
            allowsFieldFlow = true and
            RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _)
          )
        }

        predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c) {
          callEdgeArgParam(call, c, _, _, _, _)
        }

        predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
          callEdgeReturn(call, c, _, _, _, _, _)
        }

        /**
         * INTERNAL: Only for debugging.
         *
         * Provides a graph representation of the data flow in this stage suitable for use in a `path-problem` query.
         */
        additional module Graph {
          private newtype TStagePathNode =
            TStagePathNodeMid(
              NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
              ApOption argAp, Typ t, Ap ap
            ) {
              fwdFlow(node, state, cc, summaryCtx, argT, argAp, t, ap, _) and
              revFlow(node, state, _, _, ap)
            } or
            TStagePathNodeSrcGrp() or
            TStagePathNodeSinkGrp()

          class StagePathNode extends TStagePathNode {
            abstract string toString();

            abstract Location getLocation();

            /** Gets the corresponding `Node`, if any. */
            Node getNode() { none() }

            predicate isSource() { none() }

            predicate isSink() { none() }

            predicate isArbitrarySource() { this instanceof TStagePathNodeSrcGrp }

            predicate isArbitrarySink() { this instanceof TStagePathNodeSinkGrp }
          }

          class StagePathNodeSrcGrp extends StagePathNode, TStagePathNodeSrcGrp {
            override string toString() { result = "<any source>" }

            override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
          }

          class StagePathNodeSinkGrp extends StagePathNode, TStagePathNodeSinkGrp {
            override string toString() { result = "<any sink>" }

            override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
          }

          class StagePathNodeMid extends StagePathNode, TStagePathNodeMid {
            NodeEx node;
            FlowState state;
            Cc cc;
            ParamNodeOption summaryCtx;
            TypOption argT;
            ApOption argAp;
            Typ t;
            Ap ap;

            StagePathNodeMid() {
              this = TStagePathNodeMid(node, state, cc, summaryCtx, argT, argAp, t, ap)
            }

            override string toString() {
              result =
                node.toString() + " " + cc.toString() + " " + t.toString() + " " + ap.toString()
            }

            override Location getLocation() { result = node.getLocation() }

            override Node getNode() { result = node.asNode() }

            override predicate isSource() {
              sourceNode(node, state) and
              (if hasSourceCallCtx() then cc = ccSomeCall() else cc = ccNone()) and
              summaryCtx = TParamNodeNone() and
              t = getNodeTyp(node) and
              ap instanceof ApNil
            }

            override predicate isSink() {
              sinkNode(node, state) and
              (if hasSinkCallCtx() then instanceofCcNoCall(cc) else any()) and
              ap instanceof ApNil
            }
          }

          pragma[nomagic]
          private predicate fwdFlowInStep(
            ArgNodeEx arg, ParamNodeEx p, FlowState state, Cc outercc, CcCall innercc,
            ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t, Ap ap,
            boolean allowsFlowThrough
          ) {
            exists(ApApprox apa, boolean allowsFlowThrough0 |
              FwdFlowIn<FwdFlowInNoRestriction>::fwdFlowIn(_, arg, _, p, state, outercc, innercc,
                summaryCtx, argT, argAp, t, ap, apa, _, allowsFlowThrough0) and
              if PrevStage::parameterMayFlowThrough(p, apa)
              then allowsFlowThrough = allowsFlowThrough0
              else allowsFlowThrough = false
            )
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep0(
            DataFlowCall call, ArgNodeEx arg, Cc cc, FlowState state, CcCall ccc,
            ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t, Ap ap, ApApprox apa,
            RetNodeEx ret, ParamNodeEx innerSummaryCtx, Typ innerArgT, Ap innerArgAp,
            ApApprox innerArgApa
          ) {
            fwdFlowThrough0(call, arg, cc, state, ccc, summaryCtx, argT, argAp, t, ap, apa, ret,
              innerSummaryCtx, innerArgT, innerArgAp, innerArgApa)
          }

          bindingset[node, state, cc, summaryCtx, argT, argAp, t, ap]
          pragma[inline_late]
          private StagePathNode mkStagePathNode(
            NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
            ApOption argAp, Typ t, Ap ap
          ) {
            result = TStagePathNodeMid(node, state, cc, summaryCtx, argT, argAp, t, ap)
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep1(
            StagePathNode pn1, StagePathNode pn2, StagePathNode pn3, DataFlowCall call, Cc cc,
            FlowState state, CcCall ccc, ParamNodeOption summaryCtx, TypOption argT, ApOption argAp,
            Typ t, Ap ap, ApApprox apa, RetNodeEx ret, ApApprox innerArgApa
          ) {
            exists(FlowState state0, ArgNodeEx arg, ParamNodeEx p, Typ innerArgT, Ap innerArgAp |
              fwdFlowThroughStep0(call, arg, cc, state, ccc, summaryCtx, argT, argAp, t, ap, apa,
                ret, p, innerArgT, innerArgAp, innerArgApa) and
              revFlow(arg, state0, _, _, _) and
              pn1 = mkStagePathNode(arg, state0, cc, summaryCtx, argT, argAp, innerArgT, innerArgAp) and
              pn2 =
                mkStagePathNode(p, state0, ccc, TParamNodeSome(p.asNode()),
                  TypOption::some(innerArgT), apSome(innerArgAp), innerArgT, innerArgAp) and
              pn3 =
                mkStagePathNode(ret, state, ccc, TParamNodeSome(p.asNode()),
                  TypOption::some(innerArgT), apSome(innerArgAp), t, ap)
            )
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep2(
            StagePathNode pn1, StagePathNode pn2, StagePathNode pn3, NodeEx node, Cc cc,
            FlowState state, ParamNodeOption summaryCtx, TypOption argT, ApOption argAp, Typ t,
            Ap ap
          ) {
            exists(
              DataFlowCall call, CcCall ccc, RetNodeEx ret, boolean allowsFieldFlow,
              ApApprox innerArgApa, ApApprox apa
            |
              fwdFlowThroughStep1(pn1, pn2, pn3, call, cc, state, ccc, summaryCtx, argT, argAp, t,
                ap, apa, ret, innerArgApa) and
              flowThroughOutOfCall(call, ccc, ret, node, allowsFieldFlow, innerArgApa, apa) and
              if allowsFieldFlow = false then ap instanceof ApNil else any()
            )
          }

          private predicate step(
            StagePathNode pn1, NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx,
            TypOption argT, ApOption argAp, Typ t, Ap ap
          ) {
            exists(NodeEx mid, FlowState state0, Typ t0, LocalCc localCc |
              pn1 = TStagePathNodeMid(mid, state0, cc, summaryCtx, argT, argAp, t0, ap) and
              localCc = getLocalCc(cc)
            |
              localStep(mid, state0, node, state, true, _, localCc) and
              t = t0
              or
              localStep(mid, state0, node, state, false, t, localCc) and
              ap instanceof ApNil
            )
            or
            exists(NodeEx mid, FlowState state0, Typ t0 |
              pn1 = TStagePathNodeMid(mid, state0, _, _, _, _, t0, ap) and
              cc = ccNone() and
              summaryCtx = TParamNodeNone() and
              argT instanceof TypOption::None and
              argAp = apNone()
            |
              jumpStepEx(mid, node) and
              state = state0 and
              t = t0
              or
              additionalJumpStep(mid, node, _) and
              state = state0 and
              t = getNodeTyp(node) and
              ap instanceof ApNil
              or
              additionalJumpStateStep(mid, state0, node, state) and
              t = getNodeTyp(node) and
              ap instanceof ApNil
            )
            or
            // store
            exists(NodeEx mid, Content c, Typ t0, Ap ap0 |
              pn1 = TStagePathNodeMid(mid, state, cc, summaryCtx, argT, argAp, t0, ap0) and
              fwdFlowStore(mid, t0, ap0, c, t, node, state, cc, summaryCtx, argT, argAp) and
              ap = apCons(c, t0, ap0)
            )
            or
            // read
            exists(NodeEx mid, Typ t0, Ap ap0, Content c |
              pn1 = TStagePathNodeMid(mid, state, cc, summaryCtx, argT, argAp, t0, ap0) and
              fwdFlowRead(t0, ap0, c, mid, node, state, cc, summaryCtx, argT, argAp) and
              fwdFlowConsCand(t0, ap0, c, t, ap)
            )
            or
            // flow into a callable
            exists(
              ArgNodeEx arg, boolean allowsFlowThrough, Cc outercc, ParamNodeOption outerSummaryCtx,
              TypOption outerArgT, ApOption outerArgAp
            |
              pn1 =
                TStagePathNodeMid(arg, state, outercc, outerSummaryCtx, outerArgT, outerArgAp, t, ap) and
              fwdFlowInStep(arg, node, state, outercc, cc, outerSummaryCtx, outerArgT, outerArgAp,
                t, ap, allowsFlowThrough) and
              if allowsFlowThrough = true
              then (
                summaryCtx = TParamNodeSome(node.asNode()) and
                argT = TypOption::some(t) and
                argAp = apSome(ap)
              ) else (
                summaryCtx = TParamNodeNone() and
                argT instanceof TypOption::None and
                argAp = apNone()
              )
            )
            or
            // flow out of a callable
            exists(RetNodeEx ret, CcNoCall innercc, boolean allowsFieldFlow, ApApprox apa |
              pn1 = TStagePathNodeMid(ret, state, innercc, summaryCtx, argT, argAp, t, ap) and
              fwdFlowIntoRet(ret, state, innercc, summaryCtx, argT, argAp, t, ap, apa) and
              fwdFlowOutValidEdge(_, ret, innercc, _, node, cc, apa, allowsFieldFlow) and
              if allowsFieldFlow = false then ap instanceof ApNil else any()
            )
            or
            // flow through a callable
            fwdFlowThroughStep2(pn1, _, _, node, cc, state, summaryCtx, argT, argAp, t, ap)
          }

          query predicate subpaths(
            StagePathNode arg, StagePathNode par, StagePathNode ret, StagePathNode out
          ) {
            exists(
              NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
              ApOption argAp, Typ t0, Typ t, Ap ap
            |
              fwdFlowThroughStep2(arg, par, ret, node, cc, state, summaryCtx, argT, argAp, t0, ap) and
              fwdFlow1(node, state, cc, summaryCtx, argT, argAp, t0, t, ap, _) and
              out = TStagePathNodeMid(node, state, cc, summaryCtx, argT, argAp, t, ap)
            )
          }

          query predicate edges(StagePathNode pn1, StagePathNode pn2) {
            exists(
              NodeEx node, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
              ApOption argAp, Typ t0, Typ t, Ap ap
            |
              step(pn1, node, state, cc, summaryCtx, argT, argAp, t0, ap) and
              fwdFlow1(node, state, cc, summaryCtx, argT, argAp, t0, t, ap, _) and
              pn2 = TStagePathNodeMid(node, state, cc, summaryCtx, argT, argAp, t, ap)
            )
            or
            pn1.isArbitrarySource() and pn2.isSource()
            or
            pn1.isSink() and pn2.isArbitrarySink()
          }
        }

        additional predicate stats(
          boolean fwd, int nodes, int fields, int conscand, int states, int tuples, int calledges,
          int tfnodes, int tftuples
        ) {
          fwd = true and
          nodes = count(NodeEx node | fwdFlow(node, _, _, _, _, _, _, _, _)) and
          fields = count(Content f0 | fwdConsCand(f0, _, _)) and
          conscand = count(Content f0, Typ t, Ap ap | fwdConsCand(f0, t, ap)) and
          states = count(FlowState state | fwdFlow(_, state, _, _, _, _, _, _, _)) and
          tuples =
            count(NodeEx n, FlowState state, Cc cc, ParamNodeOption summaryCtx, TypOption argT,
              ApOption argAp, Typ t, Ap ap |
              fwdFlow(n, state, cc, summaryCtx, argT, argAp, t, ap, _)
            ) and
          calledges =
            count(DataFlowCall call, DataFlowCallable c |
              FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
              FwdTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
            ) and
          FwdTypeFlow::typeFlowStats(tfnodes, tftuples)
          or
          fwd = false and
          nodes = count(NodeEx node | revFlow(node, _, _, _, _)) and
          fields = count(Content f0 | consCand(f0, _, _)) and
          conscand = count(Content f0, Typ t, Ap ap | consCand(f0, t, ap)) and
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

      bindingset[c, t, tail]
      Ap apCons(Content c, Typ t, Ap tail) {
        result = true and
        exists(c) and
        exists(t) and
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
        Typ t, LocalCc lcc
      ) {
        (
          preservesValue = true and
          localFlowStepNodeCand1(node1, node2, _) and
          state1 = state2
          or
          preservesValue = false and
          additionalLocalFlowStepNodeCand1(node1, node2, _) and
          state1 = state2
          or
          preservesValue = false and
          additionalLocalStateStep(node1, state1, node2, state2)
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

      bindingset[typ, contentType]
      predicate typecheckStore(Typ typ, DataFlowType contentType) { any() }

      predicate enableTypeFlow() { none() }
    }

    private module Stage2 = MkStage<Stage1>::Stage<Stage2Param>;

    pragma[nomagic]
    private predicate flowOutOfCallNodeCand2(
      DataFlowCall call, RetNodeEx node1, ReturnKindExt kind, NodeEx node2, boolean allowsFieldFlow
    ) {
      flowOutOfCallNodeCand1(call, node1, kind, node2, allowsFieldFlow) and
      Stage2::revFlow(node2) and
      Stage2::revFlow(node1)
    }

    pragma[nomagic]
    private predicate flowIntoCallNodeCand2(
      DataFlowCall call, ArgNodeEx node1, ParamNodeEx node2, boolean allowsFieldFlow
    ) {
      flowIntoCallNodeCand1(call, node1, node2, allowsFieldFlow) and
      Stage2::revFlow(node2) and
      Stage2::revFlow(node1)
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
          expectsContentCached(this.asNode(), _) or
          neverSkipInPathGraph(this.asNode()) or
          Config::neverSkip(this.asNode())
        }
      }

      /**
       * Holds if `node` can be the first node in a maximal subsequence of local
       * flow steps in a dataflow path.
       */
      private predicate localFlowEntry(NodeEx node, FlowState state) {
        Stage2::revFlow(node, state) and
        (
          sourceNode(node, state)
          or
          jumpStepEx(_, node)
          or
          additionalJumpStep(_, node, _)
          or
          additionalJumpStateStep(_, _, node, state)
          or
          node instanceof ParamNodeEx
          or
          node.asNode() instanceof OutNodeExt
          or
          Stage2::storeStepCand(_, _, _, node, _, _)
          or
          Stage2::readStepCand(_, _, node)
          or
          node instanceof FlowCheckNode
          or
          exists(FlowState s |
            additionalLocalStateStep(_, s, node, state) and
            s != state
          )
        )
      }

      /**
       * Holds if `node` can be the last node in a maximal subsequence of local
       * flow steps in a dataflow path.
       */
      private predicate localFlowExit(NodeEx node, FlowState state) {
        exists(NodeEx next | Stage2::revFlow(next, state) |
          jumpStepEx(node, next) or
          additionalJumpStep(node, next, _) or
          flowIntoCallNodeCand2(_, node, next, _) or
          flowOutOfCallNodeCand2(_, node, _, next, _) or
          Stage2::storeStepCand(node, _, _, next, _, _) or
          Stage2::readStepCand(node, _, next)
        )
        or
        exists(NodeEx next, FlowState s | Stage2::revFlow(next, s) |
          additionalJumpStateStep(node, state, next, s)
          or
          additionalLocalStateStep(node, state, next, s) and
          s != state
        )
        or
        Stage2::revFlow(node, state) and
        node instanceof FlowCheckNode
        or
        sinkNode(node, state)
      }

      pragma[noinline]
      private predicate additionalLocalFlowStepNodeCand2(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, string label
      ) {
        additionalLocalFlowStepNodeCand1(node1, node2, label) and
        state1 = state2 and
        Stage2::revFlow(node1, pragma[only_bind_into](state1), false) and
        Stage2::revFlow(node2, pragma[only_bind_into](state2), false)
        or
        additionalLocalStateStep(node1, state1, node2, state2) and
        label = "Config" and
        Stage2::revFlow(node1, state1, false) and
        Stage2::revFlow(node2, state2, false)
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
        not isUnreachableInCall1(node2, cc) and
        not inBarrier(node2, state) and
        not outBarrier(node1, state) and
        (
          localFlowEntry(node1, pragma[only_bind_into](state)) and
          (
            localFlowStepNodeCand1(node1, node2, label) and
            preservesValue = true and
            t = node1.getDataFlowType() and // irrelevant dummy value
            Stage2::revFlow(node2, pragma[only_bind_into](state))
            or
            additionalLocalFlowStepNodeCand2(node1, state, node2, state, label) and
            preservesValue = false and
            t = node2.getDataFlowType()
          ) and
          node1 != node2 and
          cc.relevantFor(node1.getEnclosingCallable()) and
          not isUnreachableInCall1(node1, cc) and
          not outBarrier(node1, state)
          or
          exists(NodeEx mid, string label1, string label2 |
            localFlowStepPlus(node1, pragma[only_bind_into](state), mid, preservesValue, t, cc,
              label1) and
            localFlowStepNodeCand1(mid, node2, label2) and
            not outBarrier(mid, state) and
            not mid instanceof FlowCheckNode and
            Stage2::revFlow(node2, pragma[only_bind_into](state)) and
            label = mergeLabels(label1, label2)
          )
          or
          exists(NodeEx mid, string label1, string label2 |
            localFlowStepPlus(node1, state, mid, _, _, cc, label1) and
            additionalLocalFlowStepNodeCand2(mid, state, node2, state, label2) and
            not outBarrier(mid, state) and
            not mid instanceof FlowCheckNode and
            preservesValue = false and
            t = node2.getDataFlowType() and
            label = mergeLabels(label1, label2)
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
        localFlowStepPlus(node1, state1, node2, preservesValue, t, callContext, label) and
        localFlowExit(node2, state1) and
        state1 = state2
        or
        additionalLocalFlowStepNodeCand2(node1, state1, node2, state2, label) and
        state1 != state2 and
        preservesValue = false and
        t = node2.getDataFlowType() and
        callContext.relevantFor(node1.getEnclosingCallable()) and
        not isUnreachableInCall1(node1, callContext) and
        not isUnreachableInCall1(node2, callContext)
      }
    }

    private import LocalFlowBigStep

    pragma[nomagic]
    private predicate castingNodeEx(NodeEx node) {
      node.asNode() instanceof CastingNode or exists(node.asParamReturnNode())
    }

    private module Stage3Param implements MkStage<Stage2>::StageParam {
      private module PrevStage = Stage2;

      class Typ = Unit;

      class Ap = ApproxAccessPathFront;

      class ApNil = ApproxAccessPathFrontNil;

      PrevStage::Ap getApprox(Ap ap) { result = ap.toBoolNonEmpty() }

      Typ getTyp(DataFlowType t) { any() }

      bindingset[c, t, tail]
      Ap apCons(Content c, Typ t, Ap tail) { result.getAHead() = c and exists(t) and exists(tail) }

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

      predicate localStep(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        Typ t, LocalCc lcc
      ) {
        localFlowBigStep(node1, state1, node2, state2, preservesValue, _, _, _) and
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
        // We can get away with not using type strengthening here, since we aren't
        // going to use the tracked types in the construction of Stage 4 access
        // paths. For Stage 4 and onwards, the tracked types must be consistent as
        // the cons candidates including types are used to construct subsequent
        // access path approximations.
        t0 = t and
        (
          notExpectsContent(node)
          or
          expectsContentCand(node, ap)
        )
      }

      bindingset[typ, contentType]
      predicate typecheckStore(Typ typ, DataFlowType contentType) { any() }
    }

    private module Stage3 = MkStage<Stage2>::Stage<Stage3Param>;

    bindingset[node, t0]
    private predicate strengthenType(NodeEx node, DataFlowType t0, DataFlowType t) {
      if castingNodeEx(node)
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

      class Typ = DataFlowType;

      class Ap = AccessPathFront;

      class ApNil = AccessPathFrontNil;

      PrevStage::Ap getApprox(Ap ap) { result = ap.toApprox() }

      Typ getTyp(DataFlowType t) { result = t }

      bindingset[c, t, tail]
      Ap apCons(Content c, Typ t, Ap tail) { result.getHead() = c and exists(t) and exists(tail) }

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
        Typ t, LocalCc lcc
      ) {
        localFlowBigStep(node1, state1, node2, state2, preservesValue, t, _, _) and
        PrevStage::revFlow(node1, pragma[only_bind_into](state1), _) and
        PrevStage::revFlow(node2, pragma[only_bind_into](state2), _) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate clearSet(NodeEx node, ContentSet c) {
        PrevStage::revFlow(node) and
        clearsContentCached(node.asNode(), c)
      }

      pragma[nomagic]
      additional predicate clearContent(NodeEx node, Content c, boolean isStoreTarget) {
        exists(ContentSet cs |
          PrevStage::readStepCand(_, pragma[only_bind_into](c), _) and
          c = cs.getAReadContent() and
          clearSet(node, cs) and
          if PrevStage::storeStepCand(_, _, _, node, _, _)
          then isStoreTarget = true
          else isStoreTarget = false
        )
      }

      pragma[nomagic]
      private predicate clear(NodeEx node, Ap ap) {
        // When `node` is the target of a store, we interpret `clearsContent` as
        // only pertaining to _earlier_ store steps. In this case, we need to postpone
        // checking `clearsContent` to the `pathStep` predicate
        clearContent(node, ap.getHead(), false)
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
        strengthenType(node, t0, t) and
        (
          notExpectsContent(node)
          or
          expectsContentCand(node, ap)
        )
      }

      bindingset[typ, contentType]
      predicate typecheckStore(Typ typ, DataFlowType contentType) {
        // We need to typecheck stores here, since reverse flow through a getter
        // might have a different type here compared to inside the getter.
        compatibleTypesFilter(typ, contentType)
      }
    }

    private module Stage4 = MkStage<Stage3>::Stage<Stage4Param>;

    /**
     * Holds if `argApf` is recorded as the summary context for flow reaching `node`
     * and remains relevant for the following pruning stage.
     */
    private predicate flowCandSummaryCtx(NodeEx node, FlowState state, AccessPathFront argApf) {
      exists(AccessPathFront apf |
        Stage4::revFlow(node, state, TReturnCtxMaybeFlowThrough(_), _, apf) and
        Stage4::fwdFlow(node, state, any(Stage4::CcCall ccc), _, _, TAccessPathFrontSome(argApf), _,
          apf, _)
      )
    }

    /**
     * Holds if a length 2 access path approximation with the head `c` is expected
     * to be expensive.
     */
    private predicate expensiveLen2unfolding(Content c) {
      exists(int tails, int nodes, int apLimit, int tupleLimit |
        tails = strictcount(DataFlowType t, AccessPathFront apf | Stage4::consCand(c, t, apf)) and
        nodes =
          strictcount(NodeEx n, FlowState state |
            Stage4::revFlow(n, state, any(AccessPathFrontHead apf | apf.getHead() = c))
            or
            flowCandSummaryCtx(n, state, any(AccessPathFrontHead apf | apf.getHead() = c))
          ) and
        accessPathApproxCostLimits(apLimit, tupleLimit) and
        apLimit < tails and
        tupleLimit < (tails - 1) * nodes and
        not forceHighPrecision(c)
      )
    }

    private newtype TAccessPathApprox =
      TNil() or
      TConsNil(Content c, DataFlowType t) {
        Stage4::consCand(c, t, TFrontNil()) and
        not expensiveLen2unfolding(c)
      } or
      TConsCons(Content c1, DataFlowType t, Content c2, int len) {
        Stage4::consCand(c1, t, TFrontHead(c2)) and
        len in [2 .. Config::accessPathLimit()] and
        not expensiveLen2unfolding(c1)
      } or
      TCons1(Content c, int len) {
        len in [1 .. Config::accessPathLimit()] and
        expensiveLen2unfolding(c)
      }

    /**
     * Conceptually a list of `Content`s where nested tails are also paired with a
     * `DataFlowType`, but only the first two elements of the list and its length
     * are tracked. If data flows from a source to a given node with a given
     * `AccessPathApprox`, this indicates the sequence of dereference operations
     * needed to get from the value in the node to the tracked object. The
     * `DataFlowType`s indicate the types of the stored values.
     */
    abstract private class AccessPathApprox extends TAccessPathApprox {
      abstract string toString();

      abstract Content getHead();

      abstract int len();

      abstract AccessPathFront getFront();

      /** Holds if this is a representation of `head` followed by the `typ,tail` pair. */
      abstract predicate isCons(Content head, DataFlowType typ, AccessPathApprox tail);
    }

    private class AccessPathApproxNil extends AccessPathApprox, TNil {
      override string toString() { result = "" }

      override Content getHead() { none() }

      override int len() { result = 0 }

      override AccessPathFront getFront() { result = TFrontNil() }

      override predicate isCons(Content head, DataFlowType typ, AccessPathApprox tail) { none() }
    }

    abstract private class AccessPathApproxCons extends AccessPathApprox { }

    private class AccessPathApproxConsNil extends AccessPathApproxCons, TConsNil {
      private Content c;
      private DataFlowType t;

      AccessPathApproxConsNil() { this = TConsNil(c, t) }

      override string toString() {
        // The `concat` becomes "" if `ppReprType` has no result.
        result = "[" + c.toString() + "]" + concat(" : " + ppReprType(t))
      }

      override Content getHead() { result = c }

      override int len() { result = 1 }

      override AccessPathFront getFront() { result = TFrontHead(c) }

      override predicate isCons(Content head, DataFlowType typ, AccessPathApprox tail) {
        head = c and typ = t and tail = TNil()
      }
    }

    private class AccessPathApproxConsCons extends AccessPathApproxCons, TConsCons {
      private Content c1;
      private DataFlowType t;
      private Content c2;
      private int len;

      AccessPathApproxConsCons() { this = TConsCons(c1, t, c2, len) }

      override string toString() {
        if len = 2
        then result = "[" + c1.toString() + ", " + c2.toString() + "]"
        else result = "[" + c1.toString() + ", " + c2.toString() + ", ... (" + len.toString() + ")]"
      }

      override Content getHead() { result = c1 }

      override int len() { result = len }

      override AccessPathFront getFront() { result = TFrontHead(c1) }

      override predicate isCons(Content head, DataFlowType typ, AccessPathApprox tail) {
        head = c1 and
        typ = t and
        (
          tail = TConsCons(c2, _, _, len - 1)
          or
          len = 2 and
          tail = TConsNil(c2, _)
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

      override predicate isCons(Content head, DataFlowType typ, AccessPathApprox tail) {
        head = c and
        (
          exists(Content c2 | Stage4::consCand(c, typ, TFrontHead(c2)) |
            tail = TConsCons(c2, _, _, len - 1)
            or
            len = 2 and
            tail = TConsNil(c2, _)
            or
            tail = TCons1(c2, len - 1)
          )
          or
          len = 1 and
          Stage4::consCand(c, typ, TFrontNil()) and
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

      bindingset[c, t, tail]
      Ap apCons(Content c, Typ t, Ap tail) { result.isCons(c, t, tail) }

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

      predicate localStep(
        NodeEx node1, FlowState state1, NodeEx node2, FlowState state2, boolean preservesValue,
        Typ t, LocalCc lcc
      ) {
        localFlowBigStep(node1, state1, node2, state2, preservesValue, t, lcc, _) and
        PrevStage::revFlow(node1, pragma[only_bind_into](state1), _) and
        PrevStage::revFlow(node2, pragma[only_bind_into](state2), _)
      }

      bindingset[node, state, t0, ap]
      predicate filter(NodeEx node, FlowState state, Typ t0, Ap ap, Typ t) {
        strengthenType(node, t0, t) and
        exists(state) and
        exists(ap)
      }

      bindingset[typ, contentType]
      predicate typecheckStore(Typ typ, DataFlowType contentType) {
        compatibleTypesFilter(typ, contentType)
      }
    }

    private module Stage5 = MkStage<Stage4>::Stage<Stage5Param>;

    pragma[nomagic]
    private predicate nodeMayUseSummary0(
      NodeEx n, ParamNodeEx p, FlowState state, AccessPathApprox apa
    ) {
      exists(AccessPathApprox apa0 |
        Stage5::parameterMayFlowThrough(p, _) and
        Stage5::revFlow(n, state, TReturnCtxMaybeFlowThrough(_), _, apa0) and
        Stage5::fwdFlow(n, state, any(Stage5Param::CcCall ccc), TParamNodeSome(p.asNode()), _,
          TAccessPathApproxSome(apa), _, apa0, _)
      )
    }

    pragma[nomagic]
    private predicate nodeMayUseSummary(NodeEx n, FlowState state, AccessPathApprox apa) {
      exists(ParamNodeEx p |
        Stage5::parameterMayFlowThrough(p, apa) and
        nodeMayUseSummary0(n, p, state, apa)
      )
    }

    private newtype TSummaryCtx =
      TSummaryCtxNone() or
      TSummaryCtxSome(ParamNodeEx p, FlowState state, DataFlowType t, AccessPath ap) {
        exists(AccessPathApprox apa | ap.getApprox() = apa |
          Stage5::parameterMayFlowThrough(p, apa) and
          Stage5::fwdFlow(p, state, _, _, Option<DataFlowType>::some(t), _, _, apa, _) and
          Stage5::revFlow(p, state, _)
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
      private DataFlowType t;
      private AccessPath ap;

      SummaryCtxSome() { this = TSummaryCtxSome(p, s, t, ap) }

      ParamNodeEx getParamNode() { result = p }

      override string toString() { result = p + concat(" : " + ppReprType(t)) + " " + ap }

      Location getLocation() { result = p.getLocation() }
    }

    pragma[nomagic]
    private predicate stage5ConsCand(Content c, DataFlowType t, AccessPathFront apf, int len) {
      Stage5::consCand(c, t, any(AccessPathApprox ap | ap.getFront() = apf and ap.len() = len - 1))
    }

    /**
     * Gets the number of length 2 access path approximations that correspond to `apa`.
     */
    private int count1to2unfold(AccessPathApproxCons1 apa) {
      exists(Content c, int len |
        c = apa.getHead() and
        len = apa.len() and
        result = strictcount(DataFlowType t, AccessPathFront apf | stage5ConsCand(c, t, apf, len))
      )
    }

    private int countNodesUsingAccessPath(AccessPathApprox apa) {
      result =
        strictcount(NodeEx n, FlowState state |
          Stage5::revFlow(n, state, apa) or nodeMayUseSummary(n, state, apa)
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

    private predicate hasTail(AccessPathApprox apa, DataFlowType t, AccessPathApprox tail) {
      exists(Content head |
        apa.isCons(head, t, tail) and
        Stage5::consCand(head, t, tail)
      )
    }

    private predicate forceUnfold(AccessPathApprox apa) {
      forceHighPrecision(apa.getHead())
      or
      exists(Content c2 |
        apa = TConsCons(_, _, c2, _) and
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
      result =
        strictsum(DataFlowType t, AccessPathApprox tail | hasTail(apa, t, tail) | countAps(tail))
    }

    private newtype TAccessPath =
      TAccessPathNil() or
      TAccessPathCons(Content head, DataFlowType t, AccessPath tail) {
        exists(AccessPathApproxCons apa |
          not evalUnfold(apa, false) and
          head = apa.getHead() and
          hasTail(apa, t, tail.getApprox())
        )
      } or
      TAccessPathCons2(Content head1, DataFlowType t, Content head2, int len) {
        exists(AccessPathApproxCons apa, AccessPathApprox tail |
          evalUnfold(apa, false) and
          not expensiveLen1to2unfolding(apa) and
          apa.len() = len and
          hasTail(apa, t, tail) and
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

    private module PrunedCallContextSensitivityStage5 {
      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = Stage5::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = Stage5::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          Stage5Param::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand = Stage5Param::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import LocalCallContext
    }

    private class CallContext = PrunedCallContextSensitivityStage5::Cc;

    private class CallContextCall = PrunedCallContextSensitivityStage5::CcCall;

    private class CallContextNoCall = PrunedCallContextSensitivityStage5::CcNoCall;

    private predicate callContextNone = PrunedCallContextSensitivityStage5::ccNone/0;

    private predicate callContextSomeCall = PrunedCallContextSensitivityStage5::ccSomeCall/0;

    private predicate sourceCallCtx(CallContext cc) {
      if hasSourceCallCtx() then cc = callContextSomeCall() else cc = callContextNone()
    }

    private newtype TPathNode =
      TPathNodeMid(
        NodeEx node, FlowState state, CallContext cc, SummaryCtx sc, DataFlowType t, AccessPath ap,
        string summaryLabel
      ) {
        // A PathNode is introduced by a source ...
        Stage5::revFlow(node, state) and
        sourceNode(node, state) and
        sourceCallCtx(cc) and
        sc instanceof SummaryCtxNone and
        t = node.getDataFlowType() and
        ap = TAccessPathNil() and
        summaryLabel = "-"
        or
        // ... or a step from an existing PathNode to another node.
        pathStep(_, node, state, cc, sc, t, ap, summaryLabel, _)
      } or
      TPathNodeSink(NodeEx node, FlowState state) {
        exists(PathNodeMid sink |
          sink.isAtSink(_) and
          node = sink.getNodeEx() and
          state = sink.getState()
        )
      } or
      TPathNodeSourceGroup(string sourceGroup) {
        exists(PathNodeImpl source | sourceGroup = source.getSourceGroup())
      } or
      TPathNodeSinkGroup(string sinkGroup) {
        exists(PathNodeSink sink | sinkGroup = sink.getSinkGroup())
      }

    /**
     * A list of `Content`s where nested tails are also paired with a
     * `DataFlowType`. If data flows from a source to a given node with a given
     * `AccessPath`, this indicates the sequence of dereference operations needed
     * to get from the value in the node to the tracked object. The
     * `DataFlowType`s indicate the types of the stored values.
     */
    private class AccessPath extends TAccessPath {
      /** Gets the head of this access path, if any. */
      abstract Content getHead();

      /** Holds if this is a representation of `head` followed by the `typ,tail` pair. */
      abstract predicate isCons(Content head, DataFlowType typ, AccessPath tail);

      /** Gets the front of this access path. */
      abstract AccessPathFront getFront();

      /** Gets the approximation of this access path. */
      abstract AccessPathApprox getApprox();

      /** Gets the length of this access path. */
      abstract int length();

      /** Gets a textual representation of this access path. */
      abstract string toString();

      /** Holds if `node`, which is the target of a store step, clears data stored in this access path. */
      pragma[nomagic]
      predicate storeTargetIsClearedAt(NodeEx node) {
        exists(AccessPathApprox apa |
          apa = this.getApprox() and
          Stage5::revFlowAp(node, apa) and
          Stage4Param::clearContent(node, apa.getHead(), true)
        )
      }
    }

    private class AccessPathNil extends AccessPath, TAccessPathNil {
      override Content getHead() { none() }

      override predicate isCons(Content head, DataFlowType typ, AccessPath tail) { none() }

      override AccessPathFrontNil getFront() { result = TFrontNil() }

      override AccessPathApproxNil getApprox() { result = TNil() }

      override int length() { result = 0 }

      override string toString() { result = "" }
    }

    private class AccessPathCons extends AccessPath, TAccessPathCons {
      private Content head_;
      private DataFlowType t;
      private AccessPath tail_;

      AccessPathCons() { this = TAccessPathCons(head_, t, tail_) }

      override Content getHead() { result = head_ }

      override predicate isCons(Content head, DataFlowType typ, AccessPath tail) {
        head = head_ and typ = t and tail = tail_
      }

      override AccessPathFrontHead getFront() { result = TFrontHead(head_) }

      override AccessPathApproxCons getApprox() {
        result = TConsNil(head_, t) and tail_ = TAccessPathNil()
        or
        result = TConsCons(head_, t, tail_.getHead(), this.length())
        or
        result = TCons1(head_, this.length())
      }

      override int length() { result = 1 + tail_.length() }

      private string toStringImpl(boolean needsSuffix) {
        tail_ = TAccessPathNil() and
        needsSuffix = false and
        result = head_.toString() + "]" + concat(" : " + ppReprType(t))
        or
        result = head_ + ", " + tail_.(AccessPathCons).toStringImpl(needsSuffix)
        or
        exists(Content c2, Content c3, int len | tail_ = TAccessPathCons2(c2, _, c3, len) |
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
      private DataFlowType t;
      private Content head2;
      private int len;

      AccessPathCons2() { this = TAccessPathCons2(head1, t, head2, len) }

      override Content getHead() { result = head1 }

      override predicate isCons(Content head, DataFlowType typ, AccessPath tail) {
        head = head1 and
        typ = t and
        Stage5::consCand(head1, t, tail.getApprox()) and
        tail.getHead() = head2 and
        tail.length() = len - 1
      }

      override AccessPathFrontHead getFront() { result = TFrontHead(head1) }

      override AccessPathApproxCons getApprox() {
        result = TConsCons(head1, t, head2, len) or
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

      override predicate isCons(Content head, DataFlowType typ, AccessPath tail) {
        head = head_ and
        Stage5::consCand(head_, typ, tail.getApprox()) and
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

    abstract private class PathNodeImpl extends TPathNode {
      /** Gets the `FlowState` of this node. */
      abstract FlowState getState();

      /** Holds if this node is a source. */
      abstract predicate isSource(string model);

      abstract PathNodeImpl getASuccessorImpl(string label);

      private PathNodeImpl getASuccessorIfHidden(string label) {
        this.isHidden() and
        result = this.getASuccessorImpl(label)
      }

      private PathNodeImpl getASuccessorFromNonHidden(string label) {
        result = this.getASuccessorImpl(label) and
        not this.isHidden()
        or
        exists(string l1, string l2 |
          result = this.getASuccessorFromNonHidden(l1).getASuccessorIfHidden(l2) and
          label = mergeLabels(l1, l2)
        )
      }

      final PathNodeImpl getANonHiddenSuccessor(string label) {
        result = this.getASuccessorFromNonHidden(label) and not result.isHidden()
      }

      abstract NodeEx getNodeEx();

      predicate isHidden() {
        not Config::includeHiddenNodes() and
        (
          hiddenNode(this.getNodeEx().asNode()) and
          not this.isSource(_) and
          not this instanceof PathNodeSink
          or
          this.getNodeEx() instanceof TNodeImplicitRead
          or
          hiddenNode(this.getNodeEx().asParamReturnNode())
        )
      }

      string getSourceGroup() {
        this.isSource(_) and
        Config::sourceGrouping(this.getNodeEx().asNode(), result)
      }

      predicate isFlowSource() {
        this.isSource(_) and not exists(this.getSourceGroup())
        or
        this instanceof PathNodeSourceGroup
      }

      predicate isFlowSink() {
        this = any(PathNodeSink sink | not exists(sink.getSinkGroup())) or
        this instanceof PathNodeSinkGroup
      }

      private string ppType() {
        this instanceof PathNodeSink and result = ""
        or
        exists(DataFlowType t | t = this.(PathNodeMid).getType() |
          // The `concat` becomes "" if `ppReprType` has no result.
          result = concat(" : " + ppReprType(t))
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

      private string ppSummaryCtx() {
        this instanceof PathNodeSink and result = ""
        or
        result = " <" + this.(PathNodeMid).getSummaryCtx().toString() + ">"
      }

      /** Gets a textual representation of this element. */
      string toString() { result = this.getNodeEx().toString() + this.ppType() + this.ppAp() }

      /**
       * Gets a textual representation of this element, including a textual
       * representation of the call context.
       */
      string toStringWithContext() {
        result =
          this.getNodeEx().toString() + this.ppType() + this.ppAp() + this.ppCtx() +
            this.ppSummaryCtx()
      }

      /** Gets the location of this node. */
      Location getLocation() { result = this.getNodeEx().getLocation() }
    }

    /** Holds if `n` can reach a sink. */
    private predicate directReach(PathNodeImpl n) {
      n instanceof PathNodeSink or
      n instanceof PathNodeSinkGroup or
      directReach(n.getANonHiddenSuccessor(_))
    }

    /** Holds if `n` can reach a sink or is used in a subpath that can reach a sink. */
    private predicate reach(PathNodeImpl n) { directReach(n) or Subpaths::retReach(n) }

    /** Holds if `n1.getASuccessor() = n2` and `n2` can reach a sink. */
    private predicate pathSucc(PathNodeImpl n1, PathNodeImpl n2) {
      n1.getANonHiddenSuccessor(_) = n2 and directReach(n2)
    }

    private predicate tcSrc(PathNodeImpl n) { n.isFlowSource() or n.isSource(_) }

    private predicate tcSink(PathNodeImpl n) { n.isFlowSink() or n instanceof PathNodeSink }

    private predicate pathSuccPlus(PathNodeImpl n1, PathNodeImpl n2) =
      doublyBoundedFastTC(pathSucc/2, tcSrc/1, tcSink/1)(n1, n2)

    /**
     * A `Node` augmented with a call context (except for sinks) and an access path.
     * Only those `PathNode`s that are reachable from a source, and which can reach a sink, are generated.
     */
    class PathNode instanceof PathNodeImpl {
      PathNode() { reach(this) }

      /** Gets a textual representation of this element. */
      final string toString() { result = super.toString() }

      /**
       * Gets a textual representation of this element, including a textual
       * representation of the call context.
       */
      final string toStringWithContext() { result = super.toStringWithContext() }

      /** Gets the location of this node. */
      Location getLocation() { result = super.getLocation() }

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
        this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      /** Gets the underlying `Node`. */
      final Node getNode() { super.getNodeEx().projectToNode() = result }

      /** Gets the parameter node through which data is returned, if any. */
      final ParameterNode asParameterReturnNode() { result = super.getNodeEx().asParamReturnNode() }

      /** Gets the `FlowState` of this node. */
      final FlowState getState() { result = super.getState() }

      /** Gets a successor of this node, if any. */
      final PathNode getASuccessor() { result = super.getANonHiddenSuccessor(_) }

      /** Holds if this node is a source. */
      final predicate isSource() { super.isSource(_) }

      /** Holds if this node is a grouping of source nodes. */
      final predicate isSourceGroup(string group) { this = TPathNodeSourceGroup(group) }

      /** Holds if this node is a grouping of sink nodes. */
      final predicate isSinkGroup(string group) { this = TPathNodeSinkGroup(group) }
    }

    private import codeql.dataflow.test.ProvenancePathGraph as ProvenancePathGraph

    /**
     * Provides the query predicates needed to include a graph in a path-problem query.
     */
    module PathGraph implements PathGraphSig<PathNode>, ProvenancePathGraph::PathGraphSig<PathNode> {
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
        Subpaths::subpaths(arg, par, ret, out)
      }
    }

    /**
     * An intermediate flow graph node. This is a tuple consisting of a `Node`,
     * a `FlowState`, a `CallContext`, a `SummaryCtx`, and an `AccessPath`.
     */
    private class PathNodeMid extends PathNodeImpl, TPathNodeMid {
      NodeEx node;
      FlowState state;
      CallContext cc;
      SummaryCtx sc;
      DataFlowType t;
      AccessPath ap;
      string summaryLabel;

      PathNodeMid() { this = TPathNodeMid(node, state, cc, sc, t, ap, summaryLabel) }

      override NodeEx getNodeEx() { result = node }

      pragma[inline]
      final NodeEx getNodeExOutgoing() { result = node and not outBarrier(node, state) }

      override FlowState getState() { result = state }

      CallContext getCallContext() { result = cc }

      SummaryCtx getSummaryCtx() { result = sc }

      DataFlowType getType() { result = t }

      AccessPath getAp() { result = ap }

      string getSummaryLabel() { result = summaryLabel }

      private PathNodeMid getSuccMid(string label) {
        pathStep(this, result.getNodeEx(), result.getState(), result.getCallContext(),
          result.getSummaryCtx(), result.getType(), result.getAp(), _, label)
      }

      private predicate isSourceWithLabel(string labelprefix) {
        exists(string model |
          this.isSource(model) and
          model != "" and
          labelprefix = "Src:" + model + " "
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
        exists(string l2, string sinkmodel | result = this.getSuccMid(l2).projectToSink(sinkmodel) |
          not this.isSourceWithLabel(_) and
          if sinkmodel != "" then label = l2 + " Sink:" + sinkmodel else label = l2
          or
          exists(string l1 |
            this.isSourceWithLabel(l1) and
            if sinkmodel != "" then label = l1 + l2 + " Sink:" + sinkmodel else label = l1 + l2
          )
        )
      }

      override predicate isSource(string model) {
        sourceNode(node, state) and
        sourceModel(node, model) and
        sourceCallCtx(cc) and
        sc instanceof SummaryCtxNone and
        t = node.getDataFlowType() and
        ap = TAccessPathNil()
      }

      predicate isAtSink(string model) {
        sinkNode(node, state) and
        sinkModel(node, model) and
        ap instanceof AccessPathNil and
        if hasSinkCallCtx()
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

      PathNodeSink projectToSink(string model) {
        this.isAtSink(model) and
        result.getNodeEx() = node and
        result.getState() = state
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

      PathNodeSink() { this = TPathNodeSink(node, state) }

      override NodeEx getNodeEx() { result = node }

      override FlowState getState() { result = state }

      override PathNodeImpl getASuccessorImpl(string label) {
        result = TPathNodeSinkGroup(this.getSinkGroup()) and label = ""
      }

      override predicate isSource(string model) {
        sourceNode(node, state) and sourceModel(node, model)
      }

      string getSinkGroup() { Config::sinkGrouping(node.asNode(), result) }
    }

    private class PathNodeSourceGroup extends PathNodeImpl, TPathNodeSourceGroup {
      string sourceGroup;

      PathNodeSourceGroup() { this = TPathNodeSourceGroup(sourceGroup) }

      override NodeEx getNodeEx() { none() }

      override FlowState getState() { none() }

      override PathNodeImpl getASuccessorImpl(string label) {
        result.getSourceGroup() = sourceGroup and label = ""
      }

      override predicate isSource(string model) { none() }

      override string toString() { result = sourceGroup }

      override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
    }

    private class PathNodeSinkGroup extends PathNodeImpl, TPathNodeSinkGroup {
      string sinkGroup;

      PathNodeSinkGroup() { this = TPathNodeSinkGroup(sinkGroup) }

      override NodeEx getNodeEx() { none() }

      override FlowState getState() { none() }

      override PathNodeImpl getASuccessorImpl(string label) { none() }

      override predicate isSource(string model) { none() }

      override string toString() { result = sinkGroup }

      override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
    }

    private predicate pathNode(
      PathNodeMid mid, NodeEx midnode, FlowState state, CallContext cc, SummaryCtx sc,
      DataFlowType t, AccessPath ap, string summaryLabel, LocalCallContext localCC
    ) {
      midnode = mid.getNodeEx() and
      state = mid.getState() and
      cc = mid.getCallContext() and
      sc = mid.getSummaryCtx() and
      localCC = PrunedCallContextSensitivityStage5::getLocalCc(cc) and
      t = mid.getType() and
      ap = mid.getAp() and
      summaryLabel = mid.getSummaryLabel()
    }

    private predicate pathStep(
      PathNodeMid mid, NodeEx node, FlowState state, CallContext cc, SummaryCtx sc, DataFlowType t,
      AccessPath ap, string summaryLabel, string label
    ) {
      exists(DataFlowType t0, boolean isStoreStep |
        pathStep0(mid, pragma[only_bind_into](node), pragma[only_bind_into](state), cc, sc, t0, ap,
          isStoreStep, summaryLabel, label) and
        Stage5::revFlow(pragma[only_bind_into](node), pragma[only_bind_into](state), ap.getApprox()) and
        strengthenType(node, t0, t) and
        not inBarrier(node, state) and
        if ap.storeTargetIsClearedAt(node) then isStoreStep = true else any()
      )
    }

    /**
     * Holds if data may flow from `mid` to `node`. The last step in or out of
     * a callable is recorded by `cc`.
     */
    pragma[nomagic]
    private predicate pathStep0(
      PathNodeMid mid, NodeEx node, FlowState state, CallContext cc, SummaryCtx sc, DataFlowType t,
      AccessPath ap, boolean isStoreStep, string summaryLabel, string label
    ) {
      exists(NodeEx midnode, FlowState state0, string sl, LocalCallContext localCC |
        pathNode(mid, midnode, state0, cc, sc, t, ap, sl, localCC) and
        localFlowBigStep(midnode, state0, node, state, true, _, localCC, label) and
        isStoreStep = false and
        summaryLabel = mergeLabels(sl, label)
      )
      or
      exists(NodeEx midnode, FlowState state0, string sl, LocalCallContext localCC |
        pathNode(mid, midnode, state0, cc, sc, _, ap, sl, localCC) and
        localFlowBigStep(midnode, state0, node, state, false, t, localCC, label) and
        ap instanceof AccessPathNil and
        isStoreStep = false and
        summaryLabel = mergeLabels(sl, label)
      )
      or
      jumpStepEx(mid.getNodeExOutgoing(), node) and
      state = mid.getState() and
      cc = callContextNone() and
      sc instanceof SummaryCtxNone and
      t = mid.getType() and
      ap = mid.getAp() and
      isStoreStep = false and
      summaryLabel = "-" and
      label = ""
      or
      additionalJumpStep(mid.getNodeExOutgoing(), node, label) and
      state = mid.getState() and
      cc = callContextNone() and
      sc instanceof SummaryCtxNone and
      mid.getAp() instanceof AccessPathNil and
      t = node.getDataFlowType() and
      ap = TAccessPathNil() and
      isStoreStep = false and
      summaryLabel = "-"
      or
      additionalJumpStateStep(mid.getNodeExOutgoing(), mid.getState(), node, state) and
      cc = callContextNone() and
      sc instanceof SummaryCtxNone and
      mid.getAp() instanceof AccessPathNil and
      t = node.getDataFlowType() and
      ap = TAccessPathNil() and
      isStoreStep = false and
      summaryLabel = "-" and
      label = "Config"
      or
      exists(Content c, DataFlowType t0, AccessPath ap0 |
        pathStoreStep(mid, node, state, t0, ap0, c, t, cc) and
        ap.isCons(c, t0, ap0) and
        sc = mid.getSummaryCtx() and
        isStoreStep = true and
        summaryLabel = mid.getSummaryLabel() and
        label = ""
      )
      or
      exists(Content c, AccessPath ap0 |
        pathReadStep(mid, node, state, ap0, c, cc) and
        ap0.isCons(c, t, ap) and
        sc = mid.getSummaryCtx() and
        isStoreStep = false and
        summaryLabel = mid.getSummaryLabel() and
        label = ""
      )
      or
      pathIntoCallable(mid, node, state, _, cc, sc, _) and
      t = mid.getType() and
      ap = mid.getAp() and
      isStoreStep = false and
      (if sc instanceof SummaryCtxNone then summaryLabel = "-" else summaryLabel = "") and
      label = ""
      or
      pathOutOfCallable(mid, node, state, cc) and
      t = mid.getType() and
      ap = mid.getAp() and
      sc instanceof SummaryCtxNone and
      isStoreStep = false and
      summaryLabel = "-" and
      label = ""
      or
      pathThroughCallable(mid, node, state, cc, t, ap, label) and
      sc = mid.getSummaryCtx() and
      isStoreStep = false and
      summaryLabel = mid.getSummaryLabel()
    }

    pragma[nomagic]
    private predicate pathReadStep(
      PathNodeMid mid, NodeEx node, FlowState state, AccessPath ap0, Content c, CallContext cc
    ) {
      ap0 = mid.getAp() and
      c = ap0.getHead() and
      Stage5::readStepCand(mid.getNodeExOutgoing(), c, node) and
      state = mid.getState() and
      cc = mid.getCallContext()
    }

    pragma[nomagic]
    private predicate pathStoreStep(
      PathNodeMid mid, NodeEx node, FlowState state, DataFlowType t0, AccessPath ap0, Content c,
      DataFlowType t, CallContext cc
    ) {
      exists(DataFlowType contentType |
        t0 = mid.getType() and
        ap0 = mid.getAp() and
        Stage5::storeStepCand(mid.getNodeExOutgoing(), _, c, node, contentType, t) and
        state = mid.getState() and
        cc = mid.getCallContext() and
        compatibleTypesFilter(t0, contentType)
      )
    }

    private predicate pathOutOfCallable0(
      PathNodeMid mid, ReturnPosition pos, FlowState state, CallContext innercc,
      AccessPathApprox apa
    ) {
      exists(RetNodeEx retNode |
        retNode = mid.getNodeEx() and
        pos = retNode.getReturnPosition() and
        state = mid.getState() and
        not outBarrier(retNode, state) and
        innercc = mid.getCallContext() and
        innercc instanceof CallContextNoCall and
        apa = mid.getAp().getApprox() and
        not outBarrier(retNode, state)
      )
    }

    pragma[nomagic]
    private predicate pathOutOfCallable1(
      PathNodeMid mid, DataFlowCall call, ReturnKindExt kind, FlowState state, CallContext cc,
      AccessPathApprox apa
    ) {
      exists(ReturnPosition pos, DataFlowCallable c, CallContext innercc |
        pathOutOfCallable0(mid, pos, state, innercc, apa) and
        c = pos.getCallable() and
        kind = pos.getKind() and
        PrunedCallContextSensitivityStage5::resolveReturn(innercc, c, call) and
        cc = PrunedCallContextSensitivityStage5::getCallContextReturn(c, call)
      )
    }

    pragma[noinline]
    private NodeEx getAnOutNodeFlow(ReturnKindExt kind, DataFlowCall call, AccessPathApprox apa) {
      result.asNode() = kind.getAnOutNode(call) and
      Stage5::revFlow(result, _, apa)
    }

    /**
     * Holds if data may flow from `mid` to `out`. The last step of this path
     * is a return from a callable and is recorded by `cc`, if needed.
     */
    pragma[noinline]
    private predicate pathOutOfCallable(PathNodeMid mid, NodeEx out, FlowState state, CallContext cc) {
      exists(ReturnKindExt kind, DataFlowCall call, AccessPathApprox apa |
        pathOutOfCallable1(mid, call, kind, state, cc, apa) and
        out = getAnOutNodeFlow(kind, call, apa) and
        not inBarrier(out, state)
      )
    }

    /**
     * Holds if data may flow from `mid` to the `i`th argument of `call` in `cc`.
     */
    pragma[noinline]
    private predicate pathIntoArg(
      PathNodeMid mid, ParameterPosition ppos, FlowState state, CallContext cc, DataFlowCall call,
      DataFlowType t, AccessPath ap, AccessPathApprox apa
    ) {
      exists(ArgNodeEx arg, ArgumentPosition apos |
        pathNode(mid, arg, state, cc, _, t, ap, _, _) and
        not outBarrier(arg, state) and
        arg.asNode().(ArgNode).argumentOf(call, apos) and
        apa = ap.getApprox() and
        parameterMatch(ppos, apos)
      )
    }

    pragma[nomagic]
    private predicate parameterCand(
      DataFlowCallable callable, ParameterPosition pos, AccessPathApprox apa
    ) {
      exists(ParamNodeEx p |
        Stage5::revFlow(p, _, apa) and
        p.isParameterOf(callable, pos)
      )
    }

    pragma[nomagic]
    private predicate pathIntoCallable0(
      PathNodeMid mid, DataFlowCallable callable, ParameterPosition pos, FlowState state,
      CallContext outercc, DataFlowCall call, DataFlowType t, AccessPath ap
    ) {
      exists(AccessPathApprox apa |
        pathIntoArg(mid, pragma[only_bind_into](pos), state, outercc, call, t, ap,
          pragma[only_bind_into](apa)) and
        callable = PrunedCallContextSensitivityStage5::resolveCall(call, outercc) and
        parameterCand(callable, pragma[only_bind_into](pos), pragma[only_bind_into](apa))
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
      SummaryCtx sc, DataFlowCall call
    ) {
      exists(ParameterPosition pos, DataFlowCallable callable, DataFlowType t, AccessPath ap |
        pathIntoCallable0(mid, callable, pos, state, outercc, call, t, ap) and
        p.isParameterOf(callable, pos) and
        not inBarrier(p, state) and
        (
          sc = TSummaryCtxSome(p, state, t, ap)
          or
          not exists(TSummaryCtxSome(p, state, t, ap)) and
          sc = TSummaryCtxNone() and
          // When the call contexts of source and sink needs to match then there's
          // never any reason to enter a callable except to find a summary. See also
          // the comment in `PathNodeMid::isAtSink`.
          not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
        ) and
        innercc = PrunedCallContextSensitivityStage5::getCallContextCall(call, callable)
      )
    }

    /** Holds if data may flow from a parameter given by `sc` to a return of kind `kind`. */
    pragma[nomagic]
    private predicate paramFlowsThrough(
      ReturnKindExt kind, FlowState state, CallContextCall cc, SummaryCtxSome sc, DataFlowType t,
      AccessPath ap, AccessPathApprox apa, string summaryLabel
    ) {
      exists(RetNodeEx ret |
        pathNode(_, ret, state, cc, sc, t, ap, summaryLabel, _) and
        kind = ret.getKind() and
        apa = ap.getApprox() and
        parameterFlowThroughAllowed(sc.getParamNode(), kind) and
        not outBarrier(ret, state)
      )
    }

    pragma[nomagic]
    private predicate pathThroughCallable0(
      DataFlowCall call, PathNodeMid mid, ReturnKindExt kind, FlowState state, CallContext cc,
      DataFlowType t, AccessPath ap, AccessPathApprox apa, string label
    ) {
      exists(CallContext innercc, SummaryCtx sc |
        pathIntoCallable(mid, _, _, cc, innercc, sc, call) and
        paramFlowsThrough(kind, state, innercc, sc, t, ap, apa, label)
      )
    }

    /**
     * Holds if data may flow from `mid` through a callable to the node `out`.
     * The context `cc` is restored to its value prior to entering the callable.
     */
    pragma[noinline]
    private predicate pathThroughCallable(
      PathNodeMid mid, NodeEx out, FlowState state, CallContext cc, DataFlowType t, AccessPath ap,
      string label
    ) {
      exists(DataFlowCall call, ReturnKindExt kind, AccessPathApprox apa |
        pathThroughCallable0(call, mid, kind, state, cc, t, ap, apa, label) and
        out = getAnOutNodeFlow(kind, call, apa)
      )
    }

    private module Subpaths {
      /**
       * Holds if `(arg, par, ret, out)` forms a subpath-tuple and `ret` is determined by
       * `kind`, `sc`, `apout`, and `innercc`.
       */
      pragma[nomagic]
      private predicate subpaths01(
        PathNodeImpl arg, ParamNodeEx par, SummaryCtxSome sc, CallContext innercc,
        ReturnKindExt kind, NodeEx out, FlowState sout, DataFlowType t, AccessPath apout
      ) {
        pathThroughCallable(arg, out, pragma[only_bind_into](sout), _, pragma[only_bind_into](t),
          pragma[only_bind_into](apout), _) and
        pathIntoCallable(arg, par, _, _, innercc, sc, _) and
        paramFlowsThrough(kind, pragma[only_bind_into](sout), innercc, sc,
          pragma[only_bind_into](t), pragma[only_bind_into](apout), _, _)
      }

      /**
       * Holds if `(arg, par, ret, out)` forms a subpath-tuple and `ret` is determined by
       * `kind`, `sc`, `sout`, `apout`, and `innercc`.
       */
      pragma[nomagic]
      private predicate subpaths02(
        PathNodeImpl arg, ParamNodeEx par, SummaryCtxSome sc, CallContext innercc,
        ReturnKindExt kind, NodeEx out, FlowState sout, DataFlowType t, AccessPath apout
      ) {
        subpaths01(arg, par, sc, innercc, kind, out, sout, t, apout) and
        out.asNode() = kind.getAnOutNode(_)
      }

      /**
       * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
       */
      pragma[nomagic]
      private predicate subpaths03(
        PathNodeImpl arg, ParamNodeEx par, PathNodeMid ret, NodeEx out, FlowState sout,
        DataFlowType t, AccessPath apout
      ) {
        exists(SummaryCtxSome sc, CallContext innercc, ReturnKindExt kind, RetNodeEx retnode |
          subpaths02(arg, par, sc, innercc, kind, out, sout, t, apout) and
          pathNode(ret, retnode, sout, innercc, sc, t, apout, _, _) and
          kind = retnode.getKind()
        )
      }

      private PathNodeImpl localStep(PathNodeImpl n) {
        n.getASuccessorImpl(_) = result and
        exists(NodeEx n1, NodeEx n2 | n1 = n.getNodeEx() and n2 = result.getNodeEx() |
          localFlowBigStep(n1, _, n2, _, _, _, _, _) or
          storeEx(n1, _, n2, _, _) or
          readSetEx(n1, _, n2)
        )
      }

      private PathNodeImpl summaryCtxStep(PathNodeImpl n) {
        n.getASuccessorImpl(_) = result and
        exists(SummaryCtxSome sc |
          pathNode(n, _, _, _, pragma[only_bind_into](sc), _, _, _, _) and
          pathNode(result, _, _, _, pragma[only_bind_into](sc), _, _, _, _)
        )
      }

      private predicate localStepToHidden(PathNodeImpl n1, PathNodeImpl n2) {
        n2 = localStep(n1) and
        n2.isHidden()
      }

      private predicate localStepFromHidden(PathNodeImpl n1, PathNodeImpl n2) {
        n2 = localStep(n1) and
        n1.isHidden()
      }

      pragma[nomagic]
      private predicate hasSuccessor(PathNodeImpl pred, PathNodeMid succ, NodeEx succNode) {
        succ = pred.getASuccessorImpl(_) and
        succNode = succ.getNodeEx()
      }

      /**
       * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
       *
       * All of the nodes may be hidden.
       */
      pragma[nomagic]
      private predicate subpaths04(
        PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
      ) {
        exists(
          ParamNodeEx p, NodeEx o, FlowState sout, DataFlowType t, AccessPath apout,
          PathNodeMid out0
        |
          pragma[only_bind_into](arg).getASuccessorImpl(_) = pragma[only_bind_into](out0) and
          subpaths03(pragma[only_bind_into](arg), p, ret, o, sout, t, apout) and
          hasSuccessor(pragma[only_bind_into](arg), par, p) and
          pathNode(out0, o, sout, _, _, t, apout, _, _)
        |
          out = out0 or out = out0.projectToSink(_)
        )
      }

      bindingset[par, ret]
      pragma[inline_late]
      private predicate summaryCtxStepStar(PathNodeImpl par, PathNodeImpl ret) {
        summaryCtxStep*(par) = ret
      }

      /**
       * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
       *
       * `par` and `ret` are not hidden.
       */
      pragma[nomagic]
      private predicate subpaths05(
        PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
      ) {
        // direct subpath
        subpaths04(arg, any(PathNodeImpl n | localStepFromHidden*(n, par)),
          any(PathNodeImpl n | localStepToHidden*(ret, n)), out) and
        not par.isHidden() and
        not ret.isHidden() and
        summaryCtxStepStar(par, ret)
        or
        // wrapped subpath using hidden nodes, e.g. flow through a callback inside
        // a summarized callable
        exists(PathNodeImpl par0, PathNodeImpl ret0 |
          subpaths05(any(PathNodeImpl n | localStepToHidden*(par0, n)), par, ret,
            any(PathNodeImpl n | localStepFromHidden*(n, ret0))) and
          subpaths04(arg, par0, ret0, out)
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
      predicate subpaths(PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out) {
        subpaths05(any(PathNodeImpl n | localStepToHidden*(arg, n)), par, ret,
          any(PathNodeImpl n | localStepFromHidden*(n, out))) and
        not arg.isHidden() and
        not out.isHidden()
      }

      /**
       * Holds if `n` can reach a return node in a summarized subpath that can reach a sink.
       */
      predicate retReach(PathNodeImpl n) {
        exists(PathNodeImpl out | subpaths(_, _, n, out) | directReach(out) or retReach(out))
        or
        exists(PathNodeImpl mid |
          retReach(mid) and
          n.getANonHiddenSuccessor(_) = mid and
          not subpaths(_, mid, _, _)
        )
      }
    }

    /**
     * Holds if data can flow from `source` to `sink`.
     *
     * The corresponding paths are generated from the end-points and the graph
     * included in the module `PathGraph`.
     */
    predicate flowPath(PathNode source, PathNode sink) {
      exists(PathNodeImpl flowsource, PathNodeImpl flowsink |
        source = flowsource and sink = flowsink
      |
        flowsource.isFlowSource() and
        (flowsource = flowsink or pathSuccPlus(flowsource, flowsink)) and
        flowsink.isFlowSink()
      )
    }

    /** DEPRECATED: Use `flowPath` instead. */
    deprecated predicate hasFlowPath = flowPath/2;

    private predicate flowsTo(PathNodeImpl flowsource, PathNodeSink flowsink, Node source, Node sink) {
      flowsource.isSource(_) and
      flowsource.getNodeEx().asNode() = source and
      (flowsource = flowsink or pathSuccPlus(flowsource, flowsink)) and
      flowsink.getNodeEx().asNode() = sink
    }

    /**
     * Holds if data can flow from `source` to `sink`.
     */
    predicate flow(Node source, Node sink) { flowsTo(_, _, source, sink) }

    /** DEPRECATED: Use `flow` instead. */
    deprecated predicate hasFlow = flow/2;

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowTo(Node sink) { sink = any(PathNodeSink n).getNodeEx().asNode() }

    /** DEPRECATED: Use `flowTo` instead. */
    deprecated predicate hasFlowTo = flowTo/1;

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowToExpr(DataFlowExpr sink) { flowTo(exprNode(sink)) }

    /** DEPRECATED: Use `flowToExpr` instead. */
    deprecated predicate hasFlowToExpr = flowToExpr/1;

    private predicate finalStats(
      boolean fwd, int nodes, int fields, int conscand, int states, int tuples
    ) {
      fwd = true and
      nodes = count(NodeEx n0 | exists(PathNodeImpl pn | pn.getNodeEx() = n0)) and
      fields = count(Content f0 | exists(PathNodeMid pn | pn.getAp().getHead() = f0)) and
      conscand = count(AccessPath ap | exists(PathNodeMid pn | pn.getAp() = ap)) and
      states = count(FlowState state | exists(PathNodeMid pn | pn.getState() = state)) and
      tuples = count(PathNodeImpl pn)
      or
      fwd = false and
      nodes = count(NodeEx n0 | exists(PathNodeImpl pn | pn.getNodeEx() = n0 and reach(pn))) and
      fields = count(Content f0 | exists(PathNodeMid pn | pn.getAp().getHead() = f0 and reach(pn))) and
      conscand = count(AccessPath ap | exists(PathNodeMid pn | pn.getAp() = ap and reach(pn))) and
      states = count(FlowState state | exists(PathNodeMid pn | pn.getState() = state and reach(pn))) and
      tuples = count(PathNode pn)
    }

    /**
     * INTERNAL: Only for debugging.
     *
     * Calculates per-stage metrics for data flow.
     */
    predicate stageStats = Debug::stageStats/10;

    private module Stage2alias = Stage2;

    private module Stage3alias = Stage3;

    private module Stage4alias = Stage4;

    private module Stage5alias = Stage5;

    /**
     * INTERNAL: Only for debugging.
     *
     * Contains references to individual pruning stages.
     */
    module Debug {
      module Stage2 = Stage2alias;

      module Stage3 = Stage3alias;

      module Stage4 = Stage4alias;

      module Stage5 = Stage5alias;

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
        finalStats(true, nodes, fields, conscand, states, tuples) and
        calledges = -1 and
        tfnodes = -1 and
        tftuples = -1
        or
        stage = "6 Rev" and
        n = 65 and
        finalStats(false, nodes, fields, conscand, states, tuples) and
        calledges = -1 and
        tfnodes = -1 and
        tftuples = -1
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
          additionalJumpStateStep(node1, _, node2, _)
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
        exists(Node n | Config::isSource(n, _) and c = getNodeEnclosingCallable(n))
        or
        exists(DataFlowCallable mid | interestingCallableSrc(mid) and callableStep(mid, c))
      }

      private predicate interestingCallableSink(DataFlowCallable c) {
        exists(Node n | c = getNodeEnclosingCallable(n) |
          Config::isSink(n, _) or
          Config::isSink(n)
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
          Config::isSource(n, _) and
          ce2 = TCallable(getNodeEnclosingCallable(n))
        )
        or
        exists(Node n |
          ce2 = TCallableSink() and
          ce1 = TCallable(getNodeEnclosingCallable(n))
        |
          Config::isSink(n, _) or
          Config::isSink(n)
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
        additionalLocalStateStep(_, state, _, _) or
        additionalLocalStateStep(_, _, _, state) or
        additionalJumpStateStep(_, state, _, _) or
        additionalJumpStateStep(_, _, _, state)
      }

      private predicate revSinkNode(NodeEx node, FlowState state) {
        sinkNodeWithState(node, state)
        or
        Config::isSink(node.asNode()) and
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
          clearsContentCached(n.asNode(), cs) and
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
            exists(DataFlowType t | t = this.(PartialPathNodeFwd).getType() |
              // The `concat` becomes "" if `ppReprType` has no result.
              result = concat(" : " + ppReprType(t))
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
          additionalLocalStateStep(mid.getNodeEx(), mid.getState(), node, state) and
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
        additionalJumpStateStep(mid.getNodeEx(), mid.getState(), node, state) and
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
          storeExUnrestricted(midNode, c, node, contentType, t2) and
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
          partialPathOutOfCallable1(mid, call, kind, state, cc, t, ap)
        |
          out.asNode() = kind.getAnOutNode(call)
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
          out.asNode() = kind.getAnOutNode(call)
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
            storeExUnrestricted(_, _, node, _, _)
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
        additionalLocalStateStep(node, state, mid.getNodeEx(), mid.getState()) and
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
        additionalJumpStateStep(node, state, mid.getNodeEx(), mid.getState()) and
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
          storeExUnrestricted(node, c, midNode, _, _) and
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
          node.asNode().(ArgNode).argumentOf(call, pos)
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
