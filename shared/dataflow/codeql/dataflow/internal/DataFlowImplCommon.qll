private import codeql.dataflow.DataFlow
private import codeql.typetracking.TypeTracking as Tt
private import codeql.util.Location
private import codeql.util.Option
private import codeql.util.Unit
private import codeql.util.Option

module MakeImplCommon<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  import Cached

  module DataFlowImplCommonPublic {
    /**
     * DEPRECATED: Generally, a custom `FlowState` type should be used instead,
     * but `string` can of course still be used without referring to this
     * module.
     *
     * Provides `FlowState = string`.
     */
    deprecated module FlowStateString {
      /** A state value to track during data flow. */
      deprecated class FlowState = string;

      /**
       * The default state, which is used when the state is unspecified for a source
       * or a sink.
       */
      deprecated class FlowStateEmpty extends FlowState {
        FlowStateEmpty() { this = "" }
      }
    }

    private newtype TFlowFeature =
      TFeatureHasSourceCallContext() or
      TFeatureHasSinkCallContext() or
      TFeatureEqualSourceSinkCallContext()

    /** A flow configuration feature for use in `Configuration::getAFeature()`. */
    class FlowFeature extends TFlowFeature {
      string toString() { none() }
    }

    /**
     * A flow configuration feature that implies that sources have some existing
     * call context.
     */
    class FeatureHasSourceCallContext extends FlowFeature, TFeatureHasSourceCallContext {
      override string toString() { result = "FeatureHasSourceCallContext" }
    }

    /**
     * A flow configuration feature that implies that sinks have some existing
     * call context.
     */
    class FeatureHasSinkCallContext extends FlowFeature, TFeatureHasSinkCallContext {
      override string toString() { result = "FeatureHasSinkCallContext" }
    }

    /**
     * A flow configuration feature that implies that source-sink pairs have some
     * shared existing call context.
     */
    class FeatureEqualSourceSinkCallContext extends FlowFeature, TFeatureEqualSourceSinkCallContext {
      override string toString() { result = "FeatureEqualSourceSinkCallContext" }
    }

    /**
     * Holds if `source` is a relevant data flow source.
     */
    signature predicate sourceNode(Node source);

    /**
     * EXPERIMENTAL: This API is subject to change without notice.
     *
     * Given a source definition, this constructs a simple forward flow
     * computation with an access path limit of 1.
     */
    module SimpleGlobal<sourceNode/1 source> {
      import TypeTracking::TypeTrack<source/1>
    }
  }

  private module TypeTrackingInput implements Tt::TypeTrackingInput<Location> {
    final class Node = Lang::Node;

    class LocalSourceNode extends Node {
      LocalSourceNode() {
        storeStep(_, this, _) or
        loadStep0(_, this, _) or
        jumpStepCached(_, this) or
        this instanceof ParamNode or
        this instanceof OutNodeExt
      }
    }

    final private class LangContentSet = Lang::ContentSet;

    class Content extends LangContentSet {
      string toString() { result = "Content" }
    }

    class ContentFilter extends Unit {
      Content getAMatchingContent() { none() }
    }

    predicate compatibleContents(Content storeContents, Content loadContents) {
      storeContents.getAStoreContent() = loadContents.getAReadContent()
    }

    predicate simpleLocalSmallStep(Node node1, Node node2) {
      simpleLocalFlowStepExt(node1, node2, _)
    }

    predicate levelStepNoCall(Node n1, LocalSourceNode n2) { none() }

    predicate levelStepCall(Node n1, LocalSourceNode n2) {
      argumentValueFlowsThrough(n1, TReadStepTypesNone(), n2, _)
    }

    // TODO: support setters
    predicate storeStep(Node n1, Node n2, Content f) { storeSet(n1, f, n2, _, _) }

    private predicate loadStep0(Node n1, Node n2, Content f) {
      readSet(n1, f, n2)
      or
      argumentValueFlowsThrough(n1, TReadStepTypesSome(_, f, _), n2, _)
    }

    predicate loadStep(Node n1, LocalSourceNode n2, Content f) { loadStep0(n1, n2, f) }

    predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content f1, Content f2) { none() }

    predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter f) { none() }

    predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter f) { none() }

    predicate jumpStep(Node n1, LocalSourceNode n2) { jumpStepCached(n1, n2) }

    predicate callStep(Node n1, LocalSourceNode n2) { viableParamArg(_, n2, n1) }

    predicate returnStep(Node n1, LocalSourceNode n2) {
      viableReturnPosOut(_, [getValueReturnPosition(n1), getParamReturnPosition(n1, _)], n2)
    }

    predicate hasFeatureBacktrackStoreTarget() { none() }
  }

  private module TypeTracking = Tt::TypeTracking<Location, TypeTrackingInput>;

  /**
   * The cost limits for the `AccessPathFront` to `AccessPathApprox` expansion.
   *
   * `apLimit` bounds the acceptable fan-out, and `tupleLimit` bounds the
   * estimated per-`AccessPathFront` tuple cost. Access paths exceeding both of
   * these limits are represented with lower precision during pruning.
   */
  predicate accessPathApproxCostLimits(int apLimit, int tupleLimit) {
    apLimit = 10 and
    tupleLimit = 10000
  }

  /**
   * The cost limits for the `AccessPathApprox` to `AccessPath` expansion.
   *
   * `apLimit` bounds the acceptable fan-out, and `tupleLimit` bounds the
   * estimated per-`AccessPathApprox` tuple cost. Access paths exceeding both of
   * these limits are represented with lower precision.
   */
  predicate accessPathCostLimits(int apLimit, int tupleLimit) {
    apLimit = 5 and
    tupleLimit = 1000
  }

  /**
   * Holds if `arg` is an argument of `call` with an argument position that matches
   * parameter position `ppos`.
   */
  pragma[noinline]
  predicate argumentPositionMatch(DataFlowCall call, ArgNode arg, ParameterPosition ppos) {
    exists(ArgumentPosition apos |
      arg.argumentOf(call, apos) and
      parameterMatch(ppos, apos)
    )
  }

  /**
   * Provides a simple data-flow analysis for resolving lambda calls. The analysis
   * currently excludes read-steps, store-steps, and flow-through.
   *
   * The analysis uses non-linear recursion: When computing a flow path in or out
   * of a call, we use the results of the analysis recursively to resolve lambda
   * calls. For this reason, we cannot reuse the code from `DataFlowImpl.qll` directly.
   */
  private module LambdaFlow {
    pragma[noinline]
    private predicate viableParamNonLambda(DataFlowCall call, ParameterPosition ppos, ParamNode p) {
      p.isParameterOf(viableCallable(call), ppos)
    }

    pragma[noinline]
    private predicate viableParamLambda(DataFlowCall call, ParameterPosition ppos, ParamNode p) {
      p.isParameterOf(viableCallableLambda(call, _), ppos)
    }

    private predicate viableParamArgNonLambda(DataFlowCall call, ParamNode p, ArgNode arg) {
      exists(ParameterPosition ppos |
        viableParamNonLambda(call, ppos, p) and
        argumentPositionMatch(call, arg, ppos)
      )
    }

    private predicate viableParamArgLambda(DataFlowCall call, ParamNode p, ArgNode arg) {
      exists(ParameterPosition ppos |
        viableParamLambda(call, ppos, p) and
        argumentPositionMatch(call, arg, ppos)
      )
    }

    private newtype TReturnPositionSimple =
      TReturnPositionSimple0(DataFlowCallable c, ReturnKind kind) {
        exists(ReturnNode ret |
          c = getNodeEnclosingCallable(ret) and
          kind = ret.getKind()
        )
      }

    pragma[nomagic]
    private predicate hasSimpleReturnKindIn(ReturnNode ret, ReturnKind kind, DataFlowCallable c) {
      c = getNodeEnclosingCallable(ret) and
      kind = ret.getKind()
    }

    pragma[nomagic]
    private TReturnPositionSimple getReturnPositionSimple(ReturnNode ret) {
      exists(ReturnKind kind, DataFlowCallable c |
        hasSimpleReturnKindIn(ret, kind, c) and
        result = TReturnPositionSimple0(c, kind)
      )
    }

    pragma[nomagic]
    private TReturnPositionSimple viableReturnPosNonLambda(DataFlowCall call, ReturnKind kind) {
      result = TReturnPositionSimple0(viableCallable(call), kind)
    }

    pragma[nomagic]
    private TReturnPositionSimple viableReturnPosLambda(DataFlowCall call, ReturnKind kind) {
      result = TReturnPositionSimple0(viableCallableLambda(call, _), kind)
    }

    private predicate viableReturnPosOutNonLambda(
      DataFlowCall call, TReturnPositionSimple pos, OutNode out
    ) {
      exists(ReturnKind kind |
        pos = viableReturnPosNonLambda(call, kind) and
        out = getAnOutNode(call, kind)
      )
    }

    pragma[nomagic]
    private predicate viableReturnPosOutLambda(
      DataFlowCall call, TReturnPositionSimple pos, OutNode out
    ) {
      exists(ReturnKind kind |
        pos = viableReturnPosLambda(call, kind) and
        out = getAnOutNode(call, kind)
      )
    }

    /**
     * Holds if data can flow (inter-procedurally) from `node` (of type `t`) to
     * the lambda call `lambdaCall`.
     *
     * The parameter `toReturn` indicates whether the path from `node` to
     * `lambdaCall` goes through a return, and `toJump` whether the path goes
     * through a jump step.
     *
     * The call context `lastCall` records the last call on the path from `node`
     * to `lambdaCall`, if any. That is, `lastCall` is able to target the enclosing
     * callable of `lambdaCall`.
     */
    pragma[nomagic]
    predicate revLambdaFlow(
      DataFlowCall lambdaCall, LambdaCallKind kind, Node node, DataFlowType t, boolean toReturn,
      boolean toJump, DataFlowCallOption lastCall
    ) {
      revLambdaFlow0(lambdaCall, kind, node, t, toReturn, toJump, lastCall) and
      not expectsContent(node, _) and
      if node instanceof CastNode or node instanceof ArgNode or node instanceof ReturnNode
      then compatibleTypesFilter(t, getNodeDataFlowType(node))
      else any()
    }

    pragma[nomagic]
    predicate revLambdaFlow0(
      DataFlowCall lambdaCall, LambdaCallKind kind, Node node, DataFlowType t, boolean toReturn,
      boolean toJump, DataFlowCallOption lastCall
    ) {
      lambdaCall(lambdaCall, kind, node) and
      t = getNodeDataFlowType(node) and
      toReturn = false and
      toJump = false and
      lastCall = TDataFlowCallNone()
      or
      // local flow
      exists(Node mid, DataFlowType t0 |
        revLambdaFlow(lambdaCall, kind, mid, t0, toReturn, toJump, lastCall)
      |
        simpleLocalFlowStep(node, mid, _) and
        t = t0
        or
        exists(boolean preservesValue |
          additionalLambdaFlowStep(node, mid, preservesValue) and
          getNodeEnclosingCallable(node) = getNodeEnclosingCallable(mid)
        |
          preservesValue = false and
          t = getNodeDataFlowType(node)
          or
          preservesValue = true and
          t = t0
        )
      )
      or
      // jump step
      exists(Node mid, DataFlowType t0 |
        revLambdaFlow(lambdaCall, kind, mid, t0, _, _, lastCall) and
        toReturn = false and
        toJump = true
      |
        jumpStepCached(node, mid) and
        t = t0
        or
        exists(boolean preservesValue |
          additionalLambdaFlowStep(node, mid, preservesValue) and
          getNodeEnclosingCallable(node) != getNodeEnclosingCallable(mid)
        |
          preservesValue = false and
          t = getNodeDataFlowType(node)
          or
          preservesValue = true and
          t = t0
        )
      )
      or
      // flow into a callable
      exists(ParamNode p, DataFlowCallOption lastCall0, DataFlowCall call |
        revLambdaFlowIn(lambdaCall, kind, p, t, toJump, lastCall0) and
        (
          if lastCall0 = TDataFlowCallNone() and toJump = false
          then lastCall = TDataFlowCallSome(call)
          else lastCall = lastCall0
        ) and
        toReturn = false
      |
        viableParamArgNonLambda(call, p, node)
        or
        viableParamArgLambda(call, p, node) // non-linear recursion
      )
      or
      // flow out of a callable
      exists(TReturnPositionSimple pos |
        revLambdaFlowOut(lambdaCall, kind, pos, t, toJump, lastCall) and
        pos = getReturnPositionSimple(node) and
        toReturn = true
      )
    }

    pragma[nomagic]
    predicate revLambdaFlowOutLambdaCall(
      DataFlowCall lambdaCall, LambdaCallKind kind, OutNode out, DataFlowType t, boolean toJump,
      DataFlowCall call, DataFlowCallOption lastCall
    ) {
      revLambdaFlow(lambdaCall, kind, out, t, _, toJump, lastCall) and
      exists(ReturnKindExt rk |
        out = getAnOutNodeExt(call, rk) and
        lambdaCall(call, _, _)
      )
    }

    pragma[nomagic]
    predicate revLambdaFlowOut(
      DataFlowCall lambdaCall, LambdaCallKind kind, TReturnPositionSimple pos, DataFlowType t,
      boolean toJump, DataFlowCallOption lastCall
    ) {
      exists(DataFlowCall call, OutNode out |
        revLambdaFlow(lambdaCall, kind, out, t, _, toJump, lastCall) and
        viableReturnPosOutNonLambda(call, pos, out)
        or
        // non-linear recursion
        revLambdaFlowOutLambdaCall(lambdaCall, kind, out, t, toJump, call, lastCall) and
        viableReturnPosOutLambda(call, pos, out)
      )
    }

    pragma[nomagic]
    predicate revLambdaFlowIn(
      DataFlowCall lambdaCall, LambdaCallKind kind, ParamNode p, DataFlowType t, boolean toJump,
      DataFlowCallOption lastCall
    ) {
      revLambdaFlow(lambdaCall, kind, p, t, false, toJump, lastCall)
    }
  }

  private DataFlowCallable viableCallableExt(DataFlowCall call) {
    result = viableCallableCached(call)
    or
    result = viableCallableLambda(call, _)
  }

  signature module CallContextSensitivityInputSig {
    /** Holds if the edge is possibly needed in the direction `call` to `c`. */
    predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c);

    /** Holds if the edge is possibly needed in the direction `c` to `call`. */
    predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c);

    /**
     * Holds if the call context `ctx` may reduce the set of viable run-time
     * dispatch targets of call `call` in `c`.
     */
    default predicate reducedViableImplInCallContextCand(
      DataFlowCall call, DataFlowCallable c, DataFlowCall ctx
    ) {
      relevantCallEdgeIn(ctx, c) and
      mayBenefitFromCallContextExt(call, c)
    }

    /**
     * Holds if flow returning from callable `c` to call `call` might return
     * further and if this path may restrict the set of call sites that can be
     * returned to.
     */
    default predicate reducedViableImplInReturnCand(DataFlowCallable c, DataFlowCall call) {
      relevantCallEdgeOut(call, c) and
      mayBenefitFromCallContextExt(call, _)
    }
  }

  /** Provides predicates releated to call-context sensitivity. */
  module CallContextSensitivity<CallContextSensitivityInputSig Input> {
    private import Input

    pragma[nomagic]
    private DataFlowCallable viableImplInCallContextExtIn(DataFlowCall call, DataFlowCall ctx) {
      reducedViableImplInCallContextCand(call, _, ctx) and
      result = viableImplInCallContextExt(call, ctx) and
      relevantCallEdgeIn(call, result)
    }

    /**
     * Holds if the call context `ctx` reduces the set of viable run-time
     * dispatch targets of call `call` in `c`.
     */
    pragma[nomagic]
    predicate reducedViableImplInCallContext(DataFlowCall call, DataFlowCallable c, DataFlowCall ctx) {
      exists(int tgts, int ctxtgts |
        reducedViableImplInCallContextCand(call, c, ctx) and
        ctxtgts = count(viableImplInCallContextExtIn(call, ctx)) and
        tgts = strictcount(DataFlowCallable tgt | relevantCallEdgeIn(call, tgt)) and
        ctxtgts < tgts
      )
    }

    /**
     * Holds if the call context `call` allows us to prune unreachable nodes in `callable`.
     */
    pragma[nomagic]
    predicate recordDataFlowCallSiteUnreachable(DataFlowCall call, DataFlowCallable callable) {
      exists(NodeRegion nr |
        relevantCallEdgeIn(call, callable) and
        getNodeRegionEnclosingCallable(nr) = callable and
        isUnreachableInCallCached(nr, call)
      )
    }

    pragma[nomagic]
    private DataFlowCallable viableImplInCallContextExtOut(DataFlowCall call, DataFlowCall ctx) {
      exists(DataFlowCallable c |
        reducedViableImplInReturnCand(result, call) and
        result = viableImplInCallContextExt(call, ctx) and
        mayBenefitFromCallContextExt(call, c) and
        relevantCallEdgeOut(ctx, c)
      )
    }

    /**
     * Holds if flow returning from callable `c` to call `call` might return
     * further and if this path restricts the set of call sites that can be
     * returned to.
     */
    pragma[nomagic]
    predicate reducedViableImplInReturn(DataFlowCallable c, DataFlowCall call) {
      exists(int tgts, int ctxtgts |
        reducedViableImplInReturnCand(c, call) and
        ctxtgts = count(DataFlowCall ctx | c = viableImplInCallContextExtOut(call, ctx)) and
        tgts =
          strictcount(DataFlowCall ctx |
            callEnclosingCallable(call, any(DataFlowCallable encl | relevantCallEdgeOut(ctx, encl)))
          ) and
        ctxtgts < tgts
      )
    }

    private DataFlowCall getACallWithReducedViableImpl(TCallEdge ctxEdge) {
      exists(DataFlowCall ctx, DataFlowCallable c |
        ctxEdge = TMkCallEdge(ctx, c) and
        reducedViableImplInCallContext(result, c, ctx)
      )
    }

    private module CallSets =
      QlBuiltins::InternSets<TCallEdge, DataFlowCall, getACallWithReducedViableImpl/1>;

    private class CallSet0 extends CallSets::Set {
      string toString() { result = "CallSet" }
    }

    private module CallSetOption = Option<CallSet0>;

    /**
     * A set of call sites for which dispatch is affected by the call context.
     *
     * A `None` value indicates the empty set.
     */
    private class CallSet = CallSetOption::Option;

    private TCallEdge getAReducedViableEdge(TCallEdge ctxEdge) {
      exists(DataFlowCall ctx, DataFlowCallable c, DataFlowCall call, DataFlowCallable tgt |
        ctxEdge = mkCallEdge(ctx, c) and
        result = mkCallEdge(call, tgt) and
        viableImplInCallContextExtIn(call, ctx) = tgt and
        reducedViableImplInCallContext(call, c, ctx)
      )
    }

    private module DispatchSets =
      QlBuiltins::InternSets<TCallEdge, TCallEdge, getAReducedViableEdge/1>;

    private class DispatchSet0 extends DispatchSets::Set {
      string toString() { result = "DispatchSet" }
    }

    private module DispatchSetsOption = Option<DispatchSet0>;

    /**
     * A set of call edges that are allowed in the call context. This applies to
     * all calls in the associated `CallSet`, in particular, this means that if
     * a call has no associated edges in the `DispatchSet`, then either all
     * edges are allowed or none are depending on whether the call is in the
     * `CallSet`.
     *
     * A `None` value indicates the empty set.
     */
    private class DispatchSet = DispatchSetsOption::Option;

    private predicate relevantCtx(TCallEdge ctx) {
      exists(CallSets::getSet(ctx)) or exists(getUnreachableSet(ctx))
    }

    pragma[nomagic]
    private predicate hasCtx(
      TCallEdge ctx, CallSet calls, DispatchSet tgts, UnreachableSetOption unreachable
    ) {
      relevantCtx(ctx) and
      (
        CallSets::getSet(ctx) = calls.asSome()
        or
        not exists(CallSets::getSet(ctx)) and calls.isNone()
      ) and
      (
        DispatchSets::getSet(ctx) = tgts.asSome()
        or
        not exists(DispatchSets::getSet(ctx)) and tgts.isNone()
      ) and
      (
        getUnreachableSet(ctx) = unreachable.asSome()
        or
        not exists(getUnreachableSet(ctx)) and unreachable.isNone()
      )
    }

    private newtype TCallContext =
      TAnyCallContext() or
      TSpecificCall(CallSet calls, DispatchSet tgts, UnreachableSetOption unreachable) {
        hasCtx(_, calls, tgts, unreachable)
      } or
      TSomeCall() or
      TReturn(DataFlowCallable c, DataFlowCall call) { reducedViableImplInReturn(c, call) }

    /**
     * A call context to restrict the targets of virtual dispatch and prune local flow.
     *
     * There are four cases:
     * - `TAnyCallContext()` : No restrictions on method flow.
     * - `TSpecificCall(CallSet calls, DispatchSet tgts, UnreachableSetOption unreachable)` :
     *    Flow entered through a specific call that improves the set of viable
     *    dispatch targets for all of `calls` to the set of dispatch targets in
     *    `tgts`, and/or the specific call prunes unreachable nodes in the
     *    current callable as given by `unreachable`.
     * - `TSomeCall()` : Flow entered through a parameter. The
     *    originating call does not improve the set of dispatch targets for any
     *    method call in the current callable and was therefore not recorded.
     * - `TReturn(Callable c, DataFlowCall call)` : Flow reached `call` from `c` and
     *    this dispatch target of `call` implies a reduced set of dispatch origins
     *    to which data may flow if it should reach a `return` statement.
     */
    abstract private class CallContext extends TCallContext {
      abstract string toString();
    }

    abstract private class CallContextCall extends CallContext { }

    abstract private class CallContextNoCall extends CallContext { }

    private class CallContextAny extends CallContextNoCall, TAnyCallContext {
      override string toString() { result = "CcAny" }
    }

    private class CallContextSpecificCall extends CallContextCall, TSpecificCall {
      override string toString() { result = "CcCallSpecific" }
    }

    private class CallContextSomeCall extends CallContextCall, TSomeCall {
      override string toString() { result = "CcSomeCall" }
    }

    private class CallContextReturn extends CallContextNoCall, TReturn {
      override string toString() {
        exists(DataFlowCall call | this = TReturn(_, call) | result = "CcReturn(" + call + ")")
      }
    }

    pragma[nomagic]
    CallContextCall getSpecificCallContextCall(DataFlowCall call, DataFlowCallable c) {
      exists(CallSet calls, DispatchSet tgts, UnreachableSetOption unreachable |
        hasCtx(TMkCallEdge(call, c), calls, tgts, unreachable) and
        result = TSpecificCall(calls, tgts, unreachable)
      )
    }

    pragma[nomagic]
    predicate callContextAffectsDispatch(DataFlowCall call, CallContext ctx) {
      exists(CallSet calls | ctx = TSpecificCall(calls, _, _) | calls.asSome().contains(call))
    }

    CallContextNoCall getSpecificCallContextReturn(DataFlowCallable c, DataFlowCall call) {
      result = TReturn(c, call)
    }

    signature module PrunedViableImplInputSig {
      predicate reducedViableImplInCallContext(
        DataFlowCall call, DataFlowCallable c, DataFlowCall ctx
      );

      predicate recordDataFlowCallSiteUnreachable(DataFlowCall call, DataFlowCallable c);

      CallContextCall getSpecificCallContextCall(DataFlowCall call, DataFlowCallable c);

      predicate callContextAffectsDispatch(DataFlowCall call, CallContext ctx);

      CallContextNoCall getSpecificCallContextReturn(DataFlowCallable c, DataFlowCall call);
    }

    /**
     * This module is only parameterized so that we can refer to cached versions
     * of the input predicates in `CachedCallContextSensitivity`.
     */
    module PrunedViableImpl<PrunedViableImplInputSig Input2> {
      class Cc = CallContext;

      class CcCall = CallContextCall;

      pragma[inline]
      predicate matchesCall(CcCall cc, DataFlowCall call) {
        cc = Input2::getSpecificCallContextCall(call, _) or
        cc = ccSomeCall()
      }

      class CcNoCall = CallContextNoCall;

      class CcReturn = CallContextReturn;

      Cc ccNone() { result instanceof CallContextAny }

      CcCall ccSomeCall() { result instanceof CallContextSomeCall }

      predicate instanceofCc(Cc cc) { any() }

      predicate instanceofCcCall(CcCall cc) { any() }

      predicate instanceofCcNoCall(CcNoCall cc) { any() }

      /**
       * Gets a viable run-time dispatch target for the call `call` in the
       * context `ctx`. This is restricted to those calls for which a context
       * makes a difference.
       */
      pragma[nomagic]
      DataFlowCallable viableImplCallContextReduced(DataFlowCall call, CallContextCall ctx) {
        exists(DispatchSet tgts | ctx = TSpecificCall(_, tgts, _) |
          tgts.asSome().contains(TMkCallEdge(call, result))
        )
      }

      /** Holds if `call` does not have a reduced set of dispatch targets in call context `ctx`. */
      bindingset[call, ctx]
      predicate viableImplNotCallContextReduced(DataFlowCall call, CallContext ctx) {
        not Input2::callContextAffectsDispatch(call, ctx)
      }

      /**
       * Resolves a call from `call` in `cc` to `result`, where `result` is
       * restricted by `relevantResolveTarget`.
       */
      bindingset[call, cc]
      DataFlowCallable resolveCall(DataFlowCall call, CallContext cc) {
        result = viableImplCallContextReduced(call, cc)
        or
        viableImplNotCallContextReduced(call, cc) and
        relevantCallEdgeIn(call, result)
      }

      /**
       * Gets a viable call site for the return from `callable` in call context
       * `ctx`. This is restricted to those callables and contexts for which
       * the possible call sites are restricted.
       */
      pragma[nomagic]
      DataFlowCall viableImplCallContextReducedReverse(
        DataFlowCallable callable, CallContextNoCall ctx
      ) {
        exists(DataFlowCallable c0, DataFlowCall call0 |
          callEnclosingCallable(call0, callable) and
          ctx = TReturn(c0, call0) and
          c0 = viableImplInCallContextExtOut(call0, result) and
          reducedViableImplInReturn(c0, call0)
        )
      }

      /**
       * Holds if a return does not have a reduced set of viable call sites to
       * return to in call context `ctx`.
       */
      predicate viableImplNotCallContextReducedReverse(CallContextNoCall ctx) {
        ctx instanceof CallContextAny
      }

      /**
       * Resolves a return from `callable` in `cc` to `call`.
       */
      bindingset[cc, callable]
      predicate resolveReturn(CallContextNoCall cc, DataFlowCallable callable, DataFlowCall call) {
        cc instanceof CallContextAny and relevantCallEdgeOut(call, callable)
        or
        call = viableImplCallContextReducedReverse(callable, cc)
      }

      /** Gets the call context when returning from `c` to `call`. */
      bindingset[call, c]
      CallContextNoCall getCallContextReturn(DataFlowCallable c, DataFlowCall call) {
        result = Input2::getSpecificCallContextReturn(c, call)
        or
        not exists(Input2::getSpecificCallContextReturn(c, call)) and result = TAnyCallContext()
      }

      /**
       * Holds if the call context `call` improves virtual dispatch in `callable`.
       */
      pragma[nomagic]
      private predicate recordDataFlowCallSiteDispatch(DataFlowCall call, DataFlowCallable callable) {
        Input2::reducedViableImplInCallContext(_, callable, call)
      }

      /**
       * Holds if the call context `call` either improves virtual dispatch in
       * `callable` or if it allows us to prune unreachable nodes in `callable`.
       */
      predicate recordDataFlowCallSite(DataFlowCall call, DataFlowCallable c) {
        Input2::recordDataFlowCallSiteUnreachable(call, c) or
        recordDataFlowCallSiteDispatch(call, c)
      }

      module NoLocalCallContext {
        class LocalCc = Unit;

        bindingset[cc]
        LocalCc getLocalCc(CallContext cc) { any() }

        bindingset[call, c]
        CallContextCall getCallContextCall(DataFlowCall call, DataFlowCallable c) {
          if recordDataFlowCallSiteDispatch(call, c)
          then result = Input2::getSpecificCallContextCall(call, c)
          else result = TSomeCall()
        }
      }

      module LocalCallContext {
        class LocalCc = LocalCallContext;

        private UnreachableSet getUnreachable(CallContext ctx) {
          exists(UnreachableSetOption unreachable | ctx = TSpecificCall(_, _, unreachable) |
            result = unreachable.asSome()
          )
        }

        private LocalCallContext getLocalCallContext(CallContext ctx) {
          result = TSpecificLocalCall(getUnreachable(ctx))
          or
          not exists(getUnreachable(ctx)) and
          result instanceof LocalCallContextAny
        }

        bindingset[cc]
        pragma[inline_late]
        LocalCc getLocalCc(CallContext cc) { result = getLocalCallContext(cc) }

        bindingset[call, c]
        CallContextCall getCallContextCall(DataFlowCall call, DataFlowCallable c) {
          if recordDataFlowCallSite(call, c)
          then result = Input2::getSpecificCallContextCall(call, c)
          else result = TSomeCall()
        }
      }
    }

    private predicate reducedViableImplInCallContextAlias = reducedViableImplInCallContext/3;

    private predicate recordDataFlowCallSiteUnreachableAlias = recordDataFlowCallSiteUnreachable/2;

    private predicate getSpecificCallContextCallAlias = getSpecificCallContextCall/2;

    private predicate callContextAffectsDispatchAlias = callContextAffectsDispatch/2;

    private predicate getSpecificCallContextReturnAlias = getSpecificCallContextReturn/2;

    private module DefaultPrunedViableImplInput implements PrunedViableImplInputSig {
      predicate reducedViableImplInCallContext = reducedViableImplInCallContextAlias/3;

      predicate recordDataFlowCallSiteUnreachable = recordDataFlowCallSiteUnreachableAlias/2;

      predicate getSpecificCallContextCall = getSpecificCallContextCallAlias/2;

      predicate callContextAffectsDispatch = callContextAffectsDispatchAlias/2;

      predicate getSpecificCallContextReturn = getSpecificCallContextReturnAlias/2;
    }

    import PrunedViableImpl<DefaultPrunedViableImplInput>
  }

  module SndLevelScopeOption = Option<DataFlowSecondLevelScope>;

  class SndLevelScopeOption = SndLevelScopeOption::Option;

  final class NodeEx extends TNodeEx {
    string toString() {
      result = this.asNode().toString()
      or
      exists(Node n | this.isImplicitReadNode(n) | result = n.toString() + " [Ext]")
      or
      result = this.asParamReturnNode().toString() + " [Return]"
    }

    Node asNode() { this = TNodeNormal(result) }

    /** Gets the corresponding Node if this is a normal node or its post-implicit read node. */
    Node asNodeOrImplicitRead() { this = TNodeNormal(result) or this = TNodeImplicitRead(result) }

    predicate isImplicitReadNode(Node n) { this = TNodeImplicitRead(n) }

    ParameterNode asParamReturnNode() { this = TParamReturnNode(result, _) }

    Node projectToNode() {
      this = TNodeNormal(result) or
      this = TNodeImplicitRead(result) or
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
      or
      isTopType(result) and this.isImplicitReadNode(_)
    }

    pragma[inline]
    DataFlowType getDataFlowType() {
      pragma[only_bind_out](this).getDataFlowType0() = pragma[only_bind_into](result)
    }

    Location getLocation() { result = this.projectToNode().getLocation() }
  }

  /**
   * A `Node` at which a cast can occur such that the type should be checked.
   */
  final class CastingNodeEx extends NodeEx {
    CastingNodeEx() { castingNodeEx(this) }
  }

  final class ArgNodeEx extends NodeEx {
    private DataFlowCall call_;
    private ArgumentPosition pos_;

    ArgNodeEx() { this.asNode().(ArgNode).argumentOf(call_, pos_) }

    predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call = call_ and
      pos = pos_
    }

    DataFlowCall getCall() { result = call_ }
  }

  final class ParamNodeEx extends NodeEx {
    private DataFlowCallable c_;
    private ParameterPosition pos_;

    ParamNodeEx() { this.asNode().(ParamNode).isParameterOf(c_, pos_) }

    predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) { c = c_ and pos = pos_ }

    ParameterPosition getPosition() { result = pos_ }
  }

  /**
   * A node from which flow can return to the caller. This is either a regular
   * `ReturnNode` or a synthesized node for flow out via a parameter.
   */
  final class RetNodeEx extends NodeEx {
    private ReturnPosition pos;

    RetNodeEx() { pos = getReturnPositionEx(this) }

    ReturnPosition getReturnPosition() { result = pos }

    ReturnKindExt getKind() { result = pos.getKind() }
  }

  final class OutNodeEx extends NodeEx {
    OutNodeEx() { this.asNode() instanceof OutNodeExt }
  }

  pragma[nomagic]
  private SndLevelScopeOption getSecondLevelScope0(Node n) {
    result = SndLevelScopeOption::some(getSecondLevelScope(n))
    or
    result instanceof SndLevelScopeOption::None and
    not exists(getSecondLevelScope(n))
  }

  cached
  private module Cached {
    /**
     * If needed, call this predicate from `DataFlowImplSpecific.qll` in order to
     * force a stage-dependency on the `DataFlowImplCommon.qll` stage and thereby
     * collapsing the two stages.
     */
    cached
    predicate forceCachingInSameStage() { any() }

    cached
    SndLevelScopeOption getSecondLevelScopeEx(NodeEx n) {
      result = getSecondLevelScope0(n.asNode())
    }

    cached
    predicate nodeEnclosingCallable(Node n, DataFlowCallable c) { c = nodeGetEnclosingCallable(n) }

    cached
    predicate callEnclosingCallable(DataFlowCall call, DataFlowCallable c) {
      c = call.getEnclosingCallable()
    }

    cached
    predicate nodeDataFlowType(Node n, DataFlowType t) { t = getNodeType(n) }

    cached
    predicate compatibleTypesCached(DataFlowType t1, DataFlowType t2) { compatibleTypes(t1, t2) }

    private predicate relevantType(DataFlowType t) { t = getNodeType(_) }

    cached
    predicate isTopType(DataFlowType t) {
      strictcount(DataFlowType t0 | relevantType(t0)) =
        strictcount(DataFlowType t0 | relevantType(t0) and compatibleTypesCached(t, t0))
    }

    cached
    predicate typeStrongerThanCached(DataFlowType t1, DataFlowType t2) { typeStrongerThan(t1, t2) }

    cached
    predicate jumpStepCached(Node node1, Node node2) { jumpStep(node1, node2) }

    cached
    predicate clearsContentSet(NodeEx n, ContentSet c) { clearsContent(n.asNode(), c) }

    cached
    predicate expectsContentCached(Node n, ContentSet c) { expectsContent(n, c) }

    cached
    predicate expectsContentSet(NodeEx n, ContentSet c) { expectsContent(n.asNode(), c) }

    cached
    predicate isUnreachableInCallCached(NodeRegion nr, DataFlowCall call) {
      isUnreachableInCall(nr, call)
    }

    cached
    predicate outNodeExt(Node n) {
      n instanceof OutNode
      or
      n.(PostUpdateNode).getPreUpdateNode() instanceof ArgNode
    }

    cached
    predicate hiddenNode(NodeEx n) {
      nodeIsHidden([n.asNode(), n.asParamReturnNode()])
      or
      n instanceof TNodeImplicitRead
    }

    cached
    OutNodeEx getAnOutNodeEx(DataFlowCall call, ReturnKindExt k) {
      result.asNode() = getAnOutNodeExt(call, k)
    }

    pragma[nomagic]
    private predicate paramReturnNode(
      PostUpdateNode n, ParamNode p, SndLevelScopeOption scope, ReturnKindExt k
    ) {
      exists(ParameterPosition pos |
        parameterValueFlowsToPreUpdate(p, n) and
        p.isParameterOf(_, pos) and
        k = TParamUpdate(pos) and
        scope = getSecondLevelScope0(n)
      )
    }

    cached
    predicate flowCheckNode(NodeEx n) {
      n.asNode() instanceof CastNode or
      clearsContentSet(n, _) or
      expectsContentSet(n, _) or
      neverSkipInPathGraph(n.asNode())
    }

    cached
    predicate castingNodeEx(NodeEx n) {
      n.asNode() instanceof CastingNode or
      exists(n.asParamReturnNode())
    }

    cached
    string getSourceModel(NodeEx node) { knownSourceModel(node.asNode(), result) }

    cached
    string getSinkModel(NodeEx node) { knownSinkModel(node.asNodeOrImplicitRead(), result) }

    cached
    predicate parameterNode(Node p, DataFlowCallable c, ParameterPosition pos) {
      isParameterNode(p, c, pos)
    }

    cached
    predicate argumentNode(Node n, DataFlowCall call, ArgumentPosition pos) {
      isArgumentNode(n, call, pos)
    }

    cached
    DataFlowCallable viableCallableCached(DataFlowCall call) { result = viableCallable(call) }

    /**
     * Gets a viable target for the lambda call `call`.
     *
     * `lastCall` records the call required to reach `call` in order for the result
     * to be a viable target, if any.
     */
    cached
    DataFlowCallable viableCallableLambda(DataFlowCall call, DataFlowCallOption lastCall) {
      exists(Node creation, LambdaCallKind kind |
        LambdaFlow::revLambdaFlow(call, kind, creation, _, _, _, lastCall) and
        lambdaCreation(creation, kind, result)
      )
    }

    /**
     * Holds if the set of viable implementations that can be called by `call`
     * might be improved by knowing the call context.
     */
    cached
    predicate mayBenefitFromCallContextExt(DataFlowCall call, DataFlowCallable callable) {
      (
        mayBenefitFromCallContext(call)
        or
        exists(viableCallableLambda(call, TDataFlowCallSome(_)))
      ) and
      callEnclosingCallable(call, callable)
    }

    /**
     * Gets a viable dispatch target of `call` in the context `ctx`. This is
     * restricted to those `call`s for which a context might make a difference.
     */
    cached
    DataFlowCallable viableImplInCallContextExt(DataFlowCall call, DataFlowCall ctx) {
      result = viableImplInCallContext(call, ctx) and
      result = viableCallable(call)
      or
      result = viableCallableLambda(call, TDataFlowCallSome(ctx))
      or
      exists(DataFlowCallable enclosing |
        mayBenefitFromCallContextExt(call, enclosing) and
        enclosing = viableCallableExt(ctx) and
        result = viableCallableLambda(call, TDataFlowCallNone())
      )
    }

    /**
     * A cached version of the `CallContextSensitivity` module. Only used in
     * pruning stages 1+2 and flow exploration; all subsequent pruning stages use a
     * pruned version, based on the relevant call edges from the previous stage.
     */
    cached
    module CachedCallContextSensitivity {
      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c) {
          c = viableCallableExt(call)
        }

        predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c) {
          c = viableCallableExt(call)
        }
      }

      private module Impl1 = CallContextSensitivity<CallContextSensitivityInput>;

      cached
      predicate reducedViableImplInCallContext(
        DataFlowCall call, DataFlowCallable c, DataFlowCall ctx
      ) {
        Impl1::reducedViableImplInCallContext(call, c, ctx)
      }

      cached
      predicate recordDataFlowCallSiteUnreachable(DataFlowCall call, DataFlowCallable c) {
        Impl1::recordDataFlowCallSiteUnreachable(call, c)
      }

      cached
      predicate reducedViableImplInReturn(DataFlowCallable c, DataFlowCall call) {
        Impl1::reducedViableImplInReturn(c, call)
      }

      cached
      CcCall getSpecificCallContextCall(DataFlowCall call, DataFlowCallable c) {
        result = Impl1::getSpecificCallContextCall(call, c)
      }

      cached
      predicate callContextAffectsDispatch(DataFlowCall call, Cc ctx) {
        Impl1::callContextAffectsDispatch(call, ctx)
      }

      cached
      CcNoCall getSpecificCallContextReturn(DataFlowCallable c, DataFlowCall call) {
        result = Impl1::getSpecificCallContextReturn(c, call)
      }

      private module PrunedViableImplInput implements Impl1::PrunedViableImplInputSig {
        predicate reducedViableImplInCallContext =
          CachedCallContextSensitivity::reducedViableImplInCallContext/3;

        predicate recordDataFlowCallSiteUnreachable =
          CachedCallContextSensitivity::recordDataFlowCallSiteUnreachable/2;

        predicate getSpecificCallContextCall =
          CachedCallContextSensitivity::getSpecificCallContextCall/2;

        predicate callContextAffectsDispatch =
          CachedCallContextSensitivity::callContextAffectsDispatch/2;

        predicate getSpecificCallContextReturn =
          CachedCallContextSensitivity::getSpecificCallContextReturn/2;
      }

      private module Impl2 = Impl1::PrunedViableImpl<PrunedViableImplInput>;

      import Impl2

      cached
      predicate instanceofCc(Cc cc) { any() }

      cached
      predicate instanceofCcCall(CcCall cc) { any() }

      cached
      predicate instanceofCcNoCall(CcNoCall cc) { any() }

      cached
      DataFlowCallable viableImplCallContextReduced(DataFlowCall call, CcCall ctx) {
        result = Impl2::viableImplCallContextReduced(call, ctx)
      }

      cached
      DataFlowCall viableImplCallContextReducedReverse(DataFlowCallable callable, CcNoCall ctx) {
        result = Impl2::viableImplCallContextReducedReverse(callable, ctx)
      }
    }

    /**
     * Holds if `p` is the parameter of a viable dispatch target of `call`,
     * and `p` has position `ppos`.
     */
    pragma[nomagic]
    private predicate viableParam(DataFlowCall call, ParameterPosition ppos, ParamNode p) {
      p.isParameterOf(viableCallableExt(call), ppos)
    }

    /**
     * Holds if `arg` is a possible argument to `p` in `call`, taking virtual
     * dispatch into account.
     */
    cached
    predicate viableParamArg(DataFlowCall call, ParamNode p, ArgNode arg) {
      exists(ParameterPosition ppos |
        viableParam(call, ppos, p) and
        argumentPositionMatch(call, arg, ppos) and
        compatibleTypesFilter(getNodeDataFlowType(arg), getNodeDataFlowType(p)) and
        golangSpecificParamArgFilter(call, p, arg)
      )
    }

    /**
     * Holds if `arg` is a possible argument to `p` in `call`, taking virtual
     * dispatch into account.
     */
    cached
    predicate viableParamArgEx(DataFlowCall call, ParamNodeEx p, ArgNodeEx arg) {
      viableParamArg(call, p.asNode(), arg.asNode())
    }

    pragma[nomagic]
    private ReturnPosition viableReturnPos(DataFlowCall call, ReturnKindExt kind) {
      viableCallableExt(call) = result.getCallable() and
      kind = result.getKind()
    }

    /**
     * Holds if a value at return position `pos` can be returned to `out` via `call`,
     * taking virtual dispatch into account.
     */
    cached
    predicate viableReturnPosOut(DataFlowCall call, ReturnPosition pos, OutNodeExt out) {
      exists(ReturnKindExt kind |
        pos = viableReturnPos(call, kind) and
        out = getAnOutNodeExt(call, kind)
      )
    }

    /**
     * Holds if a value at return position `pos` can be returned to `out` via `call`,
     * taking virtual dispatch into account.
     */
    cached
    predicate viableReturnPosOutEx(DataFlowCall call, ReturnPosition pos, OutNodeEx out) {
      viableReturnPosOut(call, pos, out.asNode())
    }

    /** Provides predicates for calculating flow-through summaries. */
    private module FlowThrough {
      /**
       * The first flow-through approximation:
       *
       * - Input access paths are abstracted with a Boolean parameter
       *   that indicates (non-)emptiness.
       */
      private module Cand {
        /**
         * Holds if `p` can flow to `node` in the same callable using only
         * value-preserving steps.
         *
         * `read` indicates whether it is contents of `p` that can flow to `node`.
         */
        pragma[nomagic]
        private predicate parameterValueFlowCand(ParamNode p, Node node, boolean read) {
          (
            p = node and
            read = false
            or
            // local flow
            exists(Node mid |
              parameterValueFlowCand(p, mid, read) and
              simpleLocalFlowStep(mid, node, _) and
              validParameterAliasStep(mid, node)
            )
            or
            // read
            exists(Node mid |
              parameterValueFlowCand(p, mid, false) and
              readSet(mid, _, node) and
              read = true
            )
            or
            // flow through: no prior read
            exists(ArgNode arg |
              parameterValueFlowArgCand(p, arg, false) and
              argumentValueFlowsThroughCand(arg, node, read)
            )
            or
            // flow through: no read inside method
            exists(ArgNode arg |
              parameterValueFlowArgCand(p, arg, read) and
              argumentValueFlowsThroughCand(arg, node, false)
            )
          ) and
          not expectsContentCached(node, _)
        }

        pragma[nomagic]
        private predicate parameterValueFlowArgCand(ParamNode p, ArgNode arg, boolean read) {
          parameterValueFlowCand(p, arg, read)
        }

        pragma[nomagic]
        predicate parameterValueFlowsToPreUpdateCand(ParamNode p, PostUpdateNode n) {
          parameterValueFlowCand(p, n.getPreUpdateNode(), false)
        }

        /**
         * Holds if `p` can flow to a return node of kind `kind` in the same
         * callable using only value-preserving steps, not taking call contexts
         * into account.
         *
         * `read` indicates whether it is contents of `p` that can flow to the return
         * node.
         */
        predicate parameterValueFlowReturnCand(ParamNode p, ReturnKind kind, boolean read) {
          exists(ReturnNode ret |
            parameterValueFlowCand(p, ret, read) and
            kind = ret.getKind()
          )
        }

        pragma[nomagic]
        private predicate argumentValueFlowsThroughCand0(
          DataFlowCall call, ArgNode arg, ReturnKind kind, boolean read
        ) {
          exists(ParamNode param | viableParamArg(call, param, arg) |
            parameterValueFlowReturnCand(param, kind, read)
          )
        }

        /**
         * Holds if `arg` flows to `out` through a call using only value-preserving steps,
         * not taking call contexts into account.
         *
         * `read` indicates whether it is contents of `arg` that can flow to `out`.
         */
        predicate argumentValueFlowsThroughCand(ArgNode arg, Node out, boolean read) {
          exists(DataFlowCall call, ReturnKind kind |
            argumentValueFlowsThroughCand0(call, arg, kind, read) and
            out = getAnOutNode(call, kind)
          )
        }

        predicate cand(ParamNode p, Node n) {
          parameterValueFlowCand(p, n, _) and
          (
            parameterValueFlowReturnCand(p, _, _)
            or
            parameterValueFlowsToPreUpdateCand(p, _)
          )
        }
      }

      /**
       * The final flow-through calculation:
       *
       * - Calculated flow is either value-preserving (`read = TReadStepTypesNone()`)
       *   or summarized as a single read step with before and after types recorded
       *   in the `ReadStepTypesOption` parameter.
       * - Types are checked using the `compatibleTypes()` relation.
       * - Call contexts are taken into account.
       */
      private module Final {
        /**
         * Holds if `p` can flow to `node` in the same callable using only
         * value-preserving steps and possibly a single read step, not taking
         * call contexts into account.
         *
         * If a read step was taken, then `read` captures the `Content`, the
         * container type, and the content type.
         */
        predicate parameterValueFlow(
          ParamNode p, Node node, ReadStepTypesOption read, string model,
          CachedCallContextSensitivity::CcNoCall ctx
        ) {
          parameterValueFlow0(p, node, read, model, ctx) and
          Cand::cand(p, node) and
          if node instanceof CastingNode
          then
            // normal flow through
            read = TReadStepTypesNone() and
            compatibleTypesFilter(getNodeDataFlowType(p), getNodeDataFlowType(node))
            or
            // getter
            compatibleTypesFilter(read.getContentType(), getNodeDataFlowType(node))
          else any()
        }

        bindingset[model1, model2]
        pragma[inline_late]
        private string mergeModels(string model1, string model2) {
          if model1 = "" then result = model2 else result = model1
        }

        pragma[nomagic]
        private predicate parameterValueFlow0(
          ParamNode p, Node node, ReadStepTypesOption read, string model,
          CachedCallContextSensitivity::CcNoCall ctx
        ) {
          p = node and
          Cand::cand(p, _) and
          read = TReadStepTypesNone() and
          model = "" and
          CachedCallContextSensitivity::viableImplNotCallContextReducedReverse(ctx)
          or
          // local flow
          exists(Node mid, string model1, string model2 |
            parameterValueFlow(p, mid, read, model1, ctx) and
            simpleLocalFlowStep(mid, node, model2) and
            validParameterAliasStep(mid, node) and
            model = mergeModels(model1, model2)
          )
          or
          // read
          exists(Node mid |
            parameterValueFlow(p, mid, TReadStepTypesNone(), model, ctx) and
            readStepWithTypes(mid, read.getContainerType(), read.getContent(), node,
              read.getContentType()) and
            Cand::parameterValueFlowReturnCand(p, _, true) and
            compatibleTypesFilter(getNodeDataFlowType(p), read.getContainerType())
          )
          or
          parameterValueFlow0_0(TReadStepTypesNone(), p, node, read, model, ctx)
        }

        bindingset[ctx1, ctx2]
        pragma[inline_late]
        private CachedCallContextSensitivity::CcNoCall mergeContexts(
          CachedCallContextSensitivity::CcNoCall ctx1, CachedCallContextSensitivity::CcNoCall ctx2
        ) {
          if CachedCallContextSensitivity::viableImplNotCallContextReducedReverse(ctx1)
          then result = ctx2
          else
            if CachedCallContextSensitivity::viableImplNotCallContextReducedReverse(ctx2)
            then result = ctx1
            else
              // check that `ctx1` is compatible with `ctx2` for at least _some_ outer call,
              // and then (arbitrarily) continue with `ctx2`
              exists(DataFlowCall someOuterCall, DataFlowCallable callable |
                someOuterCall =
                  CachedCallContextSensitivity::viableImplCallContextReducedReverse(callable, ctx1) and
                someOuterCall =
                  CachedCallContextSensitivity::viableImplCallContextReducedReverse(callable, ctx2) and
                result = ctx2
              )
        }

        pragma[nomagic]
        private predicate parameterValueFlow0_0(
          ReadStepTypesOption mustBeNone, ParamNode p, Node node, ReadStepTypesOption read,
          string model, CachedCallContextSensitivity::CcNoCall ctx
        ) {
          exists(
            ArgNode arg, string model1, string model2, CachedCallContextSensitivity::CcNoCall ctx1,
            CachedCallContextSensitivity::CcNoCall ctx2
          |
            model = mergeModels(model1, model2) and
            ctx = mergeContexts(ctx1, ctx2)
          |
            // flow through: no prior read
            parameterValueFlowArg(p, arg, mustBeNone, model1, ctx1) and
            argumentValueFlowsThrough(arg, read, node, model2, ctx2)
            or
            // flow through: no read inside method
            parameterValueFlowArg(p, arg, read, model1, ctx1) and
            argumentValueFlowsThrough(arg, mustBeNone, node, model2, ctx2)
          )
        }

        pragma[nomagic]
        private predicate parameterValueFlowArg(
          ParamNode p, ArgNode arg, ReadStepTypesOption read, string model,
          CachedCallContextSensitivity::CcNoCall ctx
        ) {
          parameterValueFlow(p, arg, read, model, ctx) and
          Cand::argumentValueFlowsThroughCand(arg, _, _)
        }

        pragma[nomagic]
        private predicate argumentValueFlowsThrough0(
          DataFlowCall call, ArgNode arg, ReturnKind kind, ReadStepTypesOption read, string model,
          CachedCallContextSensitivity::CcNoCall outerCtx
        ) {
          exists(
            ParamNode param, DataFlowCallable callable,
            CachedCallContextSensitivity::CcNoCall innerCtx
          |
            viableParamArg(call, param, arg) and
            parameterValueFlowReturn(param, kind, read, model, innerCtx) and
            callable = nodeGetEnclosingCallable(param) and
            outerCtx = CachedCallContextSensitivity::getCallContextReturn(callable, call)
          |
            CachedCallContextSensitivity::viableImplNotCallContextReducedReverse(innerCtx)
            or
            call =
              CachedCallContextSensitivity::viableImplCallContextReducedReverse(callable, innerCtx)
          )
        }

        pragma[nomagic]
        private predicate argumentValueFlowsThrough(
          ArgNode arg, ReadStepTypesOption read, Node out, string model,
          CachedCallContextSensitivity::CcNoCall ctx
        ) {
          exists(DataFlowCall call, ReturnKind kind |
            argumentValueFlowsThrough0(call, arg, kind, read, model, ctx) and
            out = getAnOutNode(call, kind)
          |
            // normal flow through
            read = TReadStepTypesNone() and
            compatibleTypesFilter(getNodeDataFlowType(arg), getNodeDataFlowType(out))
            or
            // getter
            compatibleTypesFilter(getNodeDataFlowType(arg), read.getContainerType()) and
            compatibleTypesFilter(read.getContentType(), getNodeDataFlowType(out))
          )
        }

        /**
         * Holds if `arg` flows to `out` through a call using only
         * value-preserving steps and possibly a single read step, not taking
         * call contexts into account.
         *
         * If a read step was taken, then `read` captures the `Content`, the
         * container type, and the content type.
         */
        cached
        predicate argumentValueFlowsThrough(
          ArgNode arg, ReadStepTypesOption read, Node out, string model
        ) {
          argumentValueFlowsThrough(arg, read, out, model, _)
        }

        /**
         * Holds if `arg` flows to `out` through a call using only
         * value-preserving steps and a single read step, not taking call
         * contexts into account, thus representing a getter-step.
         *
         * This predicate is exposed for testing only.
         */
        predicate getterStep(ArgNode arg, ContentSet c, Node out) {
          argumentValueFlowsThrough(arg, TReadStepTypesSome(_, c, _), out, _)
        }

        /**
         * Holds if `p` can flow to a return node of kind `kind` in the same
         * callable using only value-preserving steps and possibly a single read
         * step.
         *
         * If a read step was taken, then `read` captures the `Content`, the
         * container type, and the content type.
         */
        private predicate parameterValueFlowReturn(
          ParamNode p, ReturnKind kind, ReadStepTypesOption read, string model,
          CachedCallContextSensitivity::CcNoCall ctx
        ) {
          exists(ReturnNode ret |
            parameterValueFlow(p, ret, read, model, ctx) and
            kind = ret.getKind()
          )
        }
      }

      import Final
    }

    import FlowThrough

    /**
     * Holds if `p` can flow to the pre-update node associated with post-update
     * node `n`, in the same callable, using only value-preserving steps.
     */
    private predicate parameterValueFlowsToPreUpdate(ParamNode p, PostUpdateNode n) {
      parameterValueFlow(p, n.getPreUpdateNode(), TReadStepTypesNone(), _, _)
    }

    cached
    predicate readSet(Node node1, ContentSet c, Node node2) { readStep(node1, c, node2) }

    cached
    predicate readEx(NodeEx node1, ContentSet c, NodeEx node2) {
      readSet(pragma[only_bind_into](node1.asNode()), c, pragma[only_bind_into](node2.asNode()))
    }

    cached
    predicate storeSet(
      Node node1, ContentSet c, Node node2, DataFlowType contentType, DataFlowType containerType
    ) {
      storeStep(node1, c, node2) and
      contentType = getNodeDataFlowType(node1) and
      containerType = getNodeDataFlowType(node2)
      or
      exists(Node n1, Node n2 |
        n1 = node1.(PostUpdateNode).getPreUpdateNode() and
        n2 = node2.(PostUpdateNode).getPreUpdateNode()
      |
        argumentValueFlowsThrough(n2, TReadStepTypesSome(containerType, c, contentType), n1, _) // TODO
        or
        readSet(n2, c, n1) and
        contentType = getNodeDataFlowType(n1) and
        containerType = getNodeDataFlowType(n2)
      )
    }

    /**
     * Holds if data can flow from `node1` to `node2` via a direct assignment to
     * `c`.
     *
     * This includes reverse steps through reads when the result of the read has
     * been stored into, in order to handle cases like `x.f1.f2 = y`.
     */
    cached
    predicate storeEx(
      NodeEx node1, Content c, NodeEx node2, DataFlowType contentType, DataFlowType containerType
    ) {
      exists(ContentSet cs |
        c = cs.getAStoreContent() and
        storeSet(pragma[only_bind_into](node1.asNode()), cs, pragma[only_bind_into](node2.asNode()),
          contentType, containerType)
      )
    }

    /**
     * Holds if data can flow from `fromNode` to `toNode` because they are the post-update
     * nodes of some function output and input respectively, where the output and input
     * are aliases. A typical example is a function returning `this`, implementing a fluent
     * interface.
     */
    private predicate reverseStepThroughInputOutputAlias(
      PostUpdateNode fromNode, PostUpdateNode toNode, string model
    ) {
      exists(Node fromPre, Node toPre |
        fromPre = fromNode.getPreUpdateNode() and
        toPre = toNode.getPreUpdateNode()
      |
        exists(DataFlowCall c |
          // Does the language-specific simpleLocalFlowStep already model flow
          // from function input to output?
          fromPre = getAnOutNode(c, _) and
          toPre.(ArgNode).argumentOf(c, _) and
          simpleLocalFlowStep(toPre.(ArgNode), fromPre, model)
        )
        or
        argumentValueFlowsThrough(toPre, TReadStepTypesNone(), fromPre, model)
      )
    }

    cached
    predicate simpleLocalFlowStepExt(Node node1, Node node2, string model) {
      simpleLocalFlowStep(node1, node2, model) or
      reverseStepThroughInputOutputAlias(node1, node2, model)
    }

    cached
    predicate allowParameterReturnInSelfEx(ParamNodeEx p) { allowParameterReturnInSelf(p.asNode()) }

    cached
    predicate paramMustFlow(ParamNode p, ArgNode arg) { localMustFlowStep+(p, arg) }

    cached
    ContentApprox getContentApproxCached(Content c) { result = getContentApprox(c) }

    cached
    newtype TCallEdge =
      TMkCallEdge(DataFlowCall call, DataFlowCallable tgt) { viableCallableExt(call) = tgt }

    private NodeRegion getAnUnreachableRegion(TCallEdge edge) {
      exists(DataFlowCall call, DataFlowCallable tgt |
        edge = mkCallEdge(call, tgt) and
        getNodeRegionEnclosingCallable(result) = tgt and
        isUnreachableInCallCached(result, call)
      )
    }

    private module UnreachableSets =
      QlBuiltins::InternSets<TCallEdge, NodeRegion, getAnUnreachableRegion/1>;

    /** A set of nodes that is unreachable in some call context. */
    cached
    class UnreachableSet instanceof UnreachableSets::Set {
      cached
      string toString() { result = "Unreachable" }

      cached
      predicate contains(NodeEx n) {
        exists(NodeRegion nr | super.contains(nr) and nr.contains(n.asNode()))
      }

      cached
      DataFlowCallable getEnclosingCallable() {
        exists(NodeRegion nr | super.contains(nr) and result = getNodeRegionEnclosingCallable(nr))
      }
    }

    cached
    UnreachableSet getUnreachableSet(TCallEdge edge) { result = UnreachableSets::getSet(edge) }

    private module UnreachableSetOption = Option<UnreachableSet>;

    class UnreachableSetOption = UnreachableSetOption::Option;

    pragma[nomagic]
    private predicate hasValueReturnKindIn(ReturnNode ret, ReturnKindExt kind, DataFlowCallable c) {
      c = getNodeEnclosingCallable(ret) and
      kind = TValueReturn(ret.getKind())
    }

    pragma[nomagic]
    private predicate hasParamReturnKindIn(
      PostUpdateNode n, ParamNode p, ReturnKindExt kind, DataFlowCallable c
    ) {
      c = getNodeEnclosingCallable(n) and
      paramReturnNode(n, p, _, kind)
    }

    cached
    newtype TReturnPosition =
      TReturnPosition0(DataFlowCallable c, ReturnKindExt kind) {
        hasValueReturnKindIn(_, kind, c)
        or
        hasParamReturnKindIn(_, _, kind, c)
      }

    cached
    ReturnPosition getValueReturnPosition(ReturnNode ret) {
      exists(ReturnKindExt kind, DataFlowCallable c |
        hasValueReturnKindIn(ret, kind, c) and
        result = TReturnPosition0(c, kind)
      )
    }

    cached
    ReturnPosition getParamReturnPosition(PostUpdateNode n, ParamNode p) {
      exists(ReturnKindExt kind, DataFlowCallable c |
        hasParamReturnKindIn(n, p, kind, c) and
        result = TReturnPosition0(c, kind)
      )
    }

    cached
    newtype TLocalFlowCallContext =
      TAnyLocalCall() or
      TSpecificLocalCall(UnreachableSets::Set ns)

    cached
    newtype TReturnKindExt =
      TValueReturn(ReturnKind kind) or
      TParamUpdate(ParameterPosition pos) { exists(ParamNode p | p.isParameterOf(_, pos)) }

    cached
    newtype TBooleanOption =
      TBooleanNone() or
      TBooleanSome(boolean b) { b = true or b = false }

    cached
    newtype TDataFlowCallOption =
      TDataFlowCallNone() or
      TDataFlowCallSome(DataFlowCall call)

    cached
    newtype TReturnCtx =
      TReturnCtxNone() or
      TReturnCtxNoFlowThrough() or
      TReturnCtxMaybeFlowThrough(ReturnPosition pos)

    cached
    newtype TAccessPathFront =
      TFrontNil() or
      TFrontHead(Content c)

    cached
    newtype TApproxAccessPathFront =
      TApproxFrontNil() or
      TApproxFrontHead(ContentApprox c)

    cached
    newtype TAccessPathFrontOption =
      TAccessPathFrontNone() or
      TAccessPathFrontSome(AccessPathFront apf)

    cached
    newtype TApproxAccessPathFrontOption =
      TApproxAccessPathFrontNone() or
      TApproxAccessPathFrontSome(ApproxAccessPathFront apf)

    cached
    newtype TNodeEx =
      TNodeNormal(Node n) or
      TNodeImplicitRead(Node n) or // will be restricted to nodes with actual implicit reads in `DataFlowImpl.qll`
      TParamReturnNode(ParameterNode p, SndLevelScopeOption scope) {
        paramReturnNode(_, p, scope, _)
      }

    /**
     * Holds if data can flow in one local step from `node1` to `node2`.
     */
    cached
    predicate localFlowStepExImpl(NodeEx node1, NodeEx node2, string model) {
      exists(Node n1, Node n2 |
        node1.asNode() = n1 and
        node2.asNode() = n2 and
        simpleLocalFlowStepExt(pragma[only_bind_into](n1), pragma[only_bind_into](n2), model)
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

    cached
    ReturnPosition getReturnPositionEx(NodeEx ret) {
      result = getValueReturnPosition(ret.asNode())
      or
      exists(ParamNode p |
        ret = TParamReturnNode(p, _) and
        result = getParamReturnPosition(_, p)
      )
    }
  }

  bindingset[call, tgt]
  pragma[inline_late]
  private TCallEdge mkCallEdge(DataFlowCall call, DataFlowCallable tgt) {
    result = TMkCallEdge(call, tgt)
  }

  bindingset[t1, t2]
  pragma[inline_late]
  predicate compatibleTypesFilter(DataFlowType t1, DataFlowType t2) {
    compatibleTypesCached(t1, t2)
  }

  bindingset[t1, t2]
  pragma[inline_late]
  predicate typeStrongerThanFilter(DataFlowType t1, DataFlowType t2) {
    typeStrongerThanCached(t1, t2)
  }

  private predicate callEdge(DataFlowCall call, DataFlowCallable c, ArgNode arg, ParamNode p) {
    viableParamArg(call, p, arg) and
    c = getNodeEnclosingCallable(p)
  }

  signature module TypeFlowInput {
    predicate enableTypeFlow();

    /** Holds if the edge is possibly needed in the direction `call` to `c`. */
    predicate relevantCallEdgeIn(DataFlowCall call, DataFlowCallable c);

    /** Holds if the edge is possibly needed in the direction `c` to `call`. */
    predicate relevantCallEdgeOut(DataFlowCall call, DataFlowCallable c);

    /**
     * Holds if the edge is followed in data flow in the direction `call` to `c`
     * and the call context `cc`.
     */
    predicate dataFlowTakenCallEdgeIn(DataFlowCall call, DataFlowCallable c, boolean cc);

    /**
     * Holds if the edge is followed in data flow in the direction `c` to `call`.
     */
    predicate dataFlowTakenCallEdgeOut(DataFlowCall call, DataFlowCallable c);

    /**
     * Holds if data flow enters `c` with call context `cc` without using a call
     * edge.
     */
    predicate dataFlowNonCallEntry(DataFlowCallable c, boolean cc);
  }

  /**
   * Given a call graph for a set of flow paths, this module calculates the type
   * flow between parameter and argument nodes in the cases where it is possible
   * for a type to first be weakened and then strengthened again. When the
   * stronger types at the end-points of such a type flow path are incompatible,
   * the relevant call edges can be excluded as impossible.
   *
   * The predicates `relevantCallEdgeIn` and `relevantCallEdgeOut` give the
   * graph to be explored prior to the recursion, and the other three predicates
   * are calculated in mutual recursion with the output of this module, which is
   * given in `typeFlowValidEdgeIn` and `typeFlowValidEdgeOut`.
   */
  module TypeFlow<TypeFlowInput Input> {
    private predicate relevantCallEdge(
      DataFlowCall call, DataFlowCallable c, ArgNode arg, ParamNode p
    ) {
      callEdge(call, c, arg, p) and
      (
        Input::relevantCallEdgeIn(call, c) or
        Input::relevantCallEdgeOut(call, c)
      )
    }

    /**
     * Holds if a sequence of calls may propagate the value of `p` to some
     * argument-to-parameter call edge that strengthens the static type.
     */
    pragma[nomagic]
    private predicate trackedParamTypeCand(ParamNode p) {
      exists(ArgNode arg |
        trackedArgTypeCand(arg) and
        paramMustFlow(p, arg)
      )
    }

    /**
     * Holds if a sequence of calls may propagate the value of `arg` to some
     * argument-to-parameter call edge that strengthens the static type.
     */
    pragma[nomagic]
    private predicate trackedArgTypeCand(ArgNode arg) {
      Input::enableTypeFlow() and
      (
        exists(ParamNode p, DataFlowType at, DataFlowType pt |
          nodeDataFlowType(arg, at) and
          nodeDataFlowType(p, pt) and
          relevantCallEdge(_, _, arg, p) and
          typeStrongerThanFilter(pt, at)
        )
        or
        exists(ParamNode p, DataFlowType at, DataFlowType pt |
          // A call edge may implicitly strengthen a type by ensuring that a
          // specific argument node was reached if the type of that argument was
          // strengthened via a cast.
          nodeDataFlowType(arg, at) and
          nodeDataFlowType(p, pt) and
          paramMustFlow(p, arg) and
          relevantCallEdge(_, _, arg, _) and
          typeStrongerThanFilter(at, pt)
        )
        or
        exists(ParamNode p |
          trackedParamTypeCand(p) and
          relevantCallEdge(_, _, arg, p)
        )
      )
    }

    /**
     * Holds if `p` is part of a value-propagating call path where the
     * end-points have stronger types than the intermediate parameter and
     * argument nodes.
     */
    private predicate trackedParamType(ParamNode p) {
      exists(
        DataFlowCall call1, DataFlowCallable c1, ArgNode argOut, DataFlowCall call2,
        DataFlowCallable c2, ArgNode argIn
      |
        // Data flow may exit `call1` and enter `call2`. If a stronger type is
        // known for `argOut`, `argIn` may reach a strengthening, and both are
        // determined by the same parameter `p` so we know they're equal, then
        // we should track those nodes.
        trackedParamTypeCand(p) and
        callEdge(call1, c1, argOut, _) and
        Input::relevantCallEdgeOut(call1, c1) and
        trackedArgTypeCand(argOut) and
        paramMustFlow(p, argOut) and
        callEdge(call2, c2, argIn, _) and
        Input::relevantCallEdgeIn(call2, c2) and
        trackedArgTypeCand(argIn) and
        paramMustFlow(p, argIn)
      )
      or
      exists(ArgNode arg, DataFlowType at, DataFlowType pt |
        trackedParamTypeCand(p) and
        nodeDataFlowType(arg, at) and
        nodeDataFlowType(p, pt) and
        relevantCallEdge(_, _, arg, p) and
        typeStrongerThanFilter(at, pt)
      )
      or
      exists(ArgNode arg |
        trackedArgType(arg) and
        relevantCallEdge(_, _, arg, p) and
        trackedParamTypeCand(p)
      )
    }

    /**
     * Holds if `arg` is part of a value-propagating call path where the
     * end-points have stronger types than the intermediate parameter and
     * argument nodes.
     */
    private predicate trackedArgType(ArgNode arg) {
      exists(ParamNode p |
        trackedParamType(p) and
        paramMustFlow(p, arg) and
        trackedArgTypeCand(arg)
      )
    }

    pragma[nomagic]
    private predicate returnCallDeterminesParam(DataFlowCall call, ParamNode p) {
      exists(ArgNode arg |
        trackedArgType(arg) and
        arg.argumentOf(call, _) and
        paramMustFlow(p, arg)
      )
    }

    private predicate returnCallLeavesParamUndetermined(DataFlowCall call, ParamNode p) {
      trackedParamType(p) and
      call.getEnclosingCallable() = getNodeEnclosingCallable(p) and
      not returnCallDeterminesParam(call, p)
    }

    pragma[nomagic]
    private predicate trackedParamWithType(ParamNode p, DataFlowType t, DataFlowCallable c) {
      trackedParamType(p) and
      c = getNodeEnclosingCallable(p) and
      nodeDataFlowType(p, t)
    }

    pragma[nomagic]
    private predicate dataFlowTakenCallEdgeIn(
      DataFlowCall call, DataFlowCallable c, ArgNode arg, ParamNode p, boolean cc
    ) {
      Input::dataFlowTakenCallEdgeIn(call, c, cc) and
      callEdge(call, c, arg, p) and
      trackedParamType(p)
    }

    pragma[nomagic]
    private predicate dataFlowTakenCallEdgeOut(
      DataFlowCall call, DataFlowCallable c, ArgNode arg, ParamNode p
    ) {
      Input::dataFlowTakenCallEdgeOut(call, c) and
      callEdge(call, c, arg, p) and
      trackedArgType(arg) and
      paramMustFlow(_, arg)
    }

    /**
     * Gets the strongest of the two types `t1` and `t2`. If neither type is
     * stronger then compatibility is checked and `t1` is returned.
     */
    bindingset[t1, t2]
    pragma[inline_late]
    DataFlowType getStrongestType(DataFlowType t1, DataFlowType t2) {
      if typeStrongerThanCached(t2, t1)
      then result = t2
      else (
        compatibleTypesFilter(t1, t2) and result = t1
      )
    }

    /**
     * Holds if `t` is a possible type for an argument reaching the tracked
     * parameter `p` through an in-going edge in the current data flow stage.
     */
    pragma[nomagic]
    private predicate typeFlowParamTypeCand(ParamNode p, DataFlowType t) {
      exists(ArgNode arg, boolean outercc |
        dataFlowTakenCallEdgeIn(_, _, arg, p, outercc) and
        if trackedArgType(arg) then typeFlowArgType(arg, t, outercc) else nodeDataFlowType(arg, t)
      )
    }

    /**
     * Holds if `t` is a possible type for the tracked parameter `p` in the call
     * context `cc` and that the current data flow stage has reached this
     * context.
     */
    private predicate typeFlowParamType(ParamNode p, DataFlowType t, boolean cc) {
      exists(DataFlowCallable c |
        Input::dataFlowNonCallEntry(c, cc) and
        trackedParamWithType(p, t, c)
      )
      or
      exists(DataFlowType t1, DataFlowType t2 |
        cc = true and
        typeFlowParamTypeCand(p, t1) and
        nodeDataFlowType(p, t2) and
        t = getStrongestType(t1, t2)
      )
      or
      exists(ArgNode arg, DataFlowType t1, DataFlowType t2 |
        cc = false and
        typeFlowArgTypeFromReturn(arg, t1) and
        paramMustFlow(p, arg) and
        nodeDataFlowType(p, t2) and
        t = getStrongestType(t1, t2)
      )
      or
      exists(DataFlowCall call |
        cc = false and
        Input::dataFlowTakenCallEdgeOut(call, _) and
        returnCallLeavesParamUndetermined(call, p) and
        nodeDataFlowType(p, t)
      )
    }

    /**
     * Holds if `t` is a possible type for the tracked argument `arg` and that
     * the current data flow stage has reached the call of `arg` from one of its
     * call targets.
     */
    private predicate typeFlowArgTypeFromReturn(ArgNode arg, DataFlowType t) {
      exists(ParamNode p, DataFlowType t1, DataFlowType t2 |
        dataFlowTakenCallEdgeOut(_, _, arg, p) and
        (if trackedParamType(p) then typeFlowParamType(p, t1, false) else nodeDataFlowType(p, t1)) and
        nodeDataFlowType(arg, t2) and
        t = getStrongestType(t1, t2)
      )
    }

    /**
     * Holds if `t` is a possible type for the tracked argument `arg` in the call
     * context `cc` and that the current data flow stage has reached this
     * context.
     */
    private predicate typeFlowArgType(ArgNode arg, DataFlowType t, boolean cc) {
      trackedArgType(arg) and
      (
        exists(ParamNode p, DataFlowType t1, DataFlowType t2 |
          paramMustFlow(p, arg) and
          typeFlowParamType(p, t1, cc) and
          nodeDataFlowType(arg, t2) and
          t = getStrongestType(t1, t2)
        )
        or
        cc = [true, false] and
        not paramMustFlow(_, arg) and
        nodeDataFlowType(arg, t)
      )
    }

    predicate typeFlowStats(int nodes, int tuples) {
      nodes =
        count(Node n |
          typeFlowParamType(n, _, _) or typeFlowArgTypeFromReturn(n, _) or typeFlowArgType(n, _, _)
        ) and
      tuples =
        count(Node n, DataFlowType t, boolean cc |
          typeFlowParamType(n, t, cc)
          or
          typeFlowArgTypeFromReturn(n, t) and cc = false
          or
          typeFlowArgType(n, t, cc)
        )
    }

    /**
     * Holds if the `arg`-to-`p` edge should be considered for validation of the
     * corresponding call edge in the in-going direction.
     */
    private predicate relevantArgParamIn(ArgNode arg, ParamNode p, DataFlowType pt) {
      exists(DataFlowCall call, DataFlowCallable c |
        Input::relevantCallEdgeIn(call, c) and
        callEdge(call, c, arg, p) and
        paramMustFlow(_, arg) and
        trackedArgType(arg) and
        nodeDataFlowType(p, pt)
      )
    }

    /**
     * Holds if there is a possible type for `arg` in the call context `cc` that
     * is consistent with the static type of `p`.
     */
    private predicate validArgParamIn(ArgNode arg, ParamNode p, boolean cc) {
      exists(DataFlowType t1, DataFlowType t2 |
        typeFlowArgType(arg, t1, cc) and
        relevantArgParamIn(arg, p, t2) and
        compatibleTypesFilter(t1, t2)
      )
    }

    /**
     * Holds if the edge `call`-to-`c` is valid in the in-going direction in the
     * call context `cc`.
     */
    pragma[nomagic]
    predicate typeFlowValidEdgeIn(DataFlowCall call, DataFlowCallable c, boolean cc) {
      Input::relevantCallEdgeIn(call, c) and
      cc = [true, false] and
      (
        not Input::enableTypeFlow()
        or
        forall(ArgNode arg, ParamNode p |
          callEdge(call, c, arg, p) and trackedArgType(arg) and paramMustFlow(_, arg)
        |
          validArgParamIn(arg, p, cc)
        )
      )
    }

    /**
     * Holds if the `arg`-to-`p` edge should be considered for validation of the
     * corresponding call edge in the out-going direction.
     */
    private predicate relevantArgParamOut(ArgNode arg, ParamNode p, DataFlowType argt) {
      exists(DataFlowCall call, DataFlowCallable c |
        Input::relevantCallEdgeOut(call, c) and
        callEdge(call, c, arg, p) and
        trackedParamType(p) and
        nodeDataFlowType(arg, argt)
      )
    }

    /**
     * Holds if there is a possible type for `p` in the call context `false`
     * that is consistent with the static type of `arg`.
     */
    private predicate validArgParamOut(ArgNode arg, ParamNode p) {
      exists(DataFlowType t1, DataFlowType t2 |
        typeFlowParamType(p, t1, false) and
        relevantArgParamOut(arg, p, t2) and
        compatibleTypesFilter(t1, t2)
      )
    }

    /**
     * Holds if the edge `call`-to-`c` is valid in the out-going direction.
     */
    pragma[nomagic]
    predicate typeFlowValidEdgeOut(DataFlowCall call, DataFlowCallable c) {
      Input::relevantCallEdgeOut(call, c) and
      (
        not Input::enableTypeFlow()
        or
        forall(ArgNode arg, ParamNode p | callEdge(call, c, arg, p) and trackedParamType(p) |
          validArgParamOut(arg, p)
        )
      )
    }
  }

  final private class NodeFinal = Node;

  /**
   * A `Node` at which a cast can occur such that the type should be checked.
   */
  class CastingNode extends NodeFinal {
    CastingNode() {
      this instanceof CastNode or
      this instanceof ParamNode or
      this instanceof OutNodeExt or
      // For reads, `x.f`, we want to check that the tracked type after the read (which
      // is obtained by popping the head of the access path stack) is compatible with
      // the type of `x.f`.
      readSet(_, _, this)
    }
  }

  private predicate readStepWithTypes(
    Node n1, DataFlowType container, ContentSet c, Node n2, DataFlowType content
  ) {
    readSet(n1, c, n2) and
    container = getNodeDataFlowType(n1) and
    content = getNodeDataFlowType(n2)
  }

  private newtype TReadStepTypesOption =
    TReadStepTypesNone() or
    TReadStepTypesSome(DataFlowType container, ContentSet c, DataFlowType content) {
      readStepWithTypes(_, container, c, _, content)
    }

  private class ReadStepTypesOption extends TReadStepTypesOption {
    predicate isSome() { this instanceof TReadStepTypesSome }

    DataFlowType getContainerType() { this = TReadStepTypesSome(result, _, _) }

    ContentSet getContent() { this = TReadStepTypesSome(_, result, _) }

    DataFlowType getContentType() { this = TReadStepTypesSome(_, _, result) }

    string toString() { if this.isSome() then result = "Some(..)" else result = "None()" }
  }

  /**
   * A call context that is relevant for pruning local flow.
   */
  abstract class LocalCallContext extends TLocalFlowCallContext {
    abstract string toString();

    /** Holds if this call context is relevant for `callable`. */
    abstract predicate relevantFor(DataFlowCallable callable);
  }

  class LocalCallContextAny extends LocalCallContext, TAnyLocalCall {
    override string toString() { result = "LocalCcAny" }

    override predicate relevantFor(DataFlowCallable callable) { any() }
  }

  class LocalCallContextSpecificCall extends LocalCallContext, TSpecificLocalCall {
    LocalCallContextSpecificCall() { this = TSpecificLocalCall(ns) }

    UnreachableSet ns;

    override string toString() { result = "LocalCcCall" }

    override predicate relevantFor(DataFlowCallable callable) {
      ns.getEnclosingCallable() = callable
    }

    /** Holds if this call context makes `n` unreachable. */
    predicate unreachable(NodeEx n) { ns.contains(n) }
  }

  private DataFlowCallable getNodeRegionEnclosingCallable(NodeRegion nr) {
    exists(Node n | nr.contains(n) | getNodeEnclosingCallable(n) = result)
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class ParamNode extends NodeFinal {
    ParamNode() { parameterNode(this, _, _) }

    /**
     * Holds if this node is the parameter of callable `c` at the specified
     * position.
     */
    predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      parameterNode(this, c, pos)
    }
  }

  /** A data-flow node that represents a call argument. */
  class ArgNode extends NodeFinal {
    ArgNode() { argumentNode(this, _, _) }

    /** Holds if this argument occurs at the given position in the given call. */
    final predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      argumentNode(this, call, pos)
    }
  }

  /**
   * A node to which data can flow from a call. Either an ordinary out node
   * or a post-update node associated with a call argument.
   */
  class OutNodeExt extends NodeFinal {
    OutNodeExt() { outNodeExt(this) }
  }

  pragma[nomagic]
  OutNodeExt getAnOutNodeExt(DataFlowCall call, ReturnKindExt k) {
    result = getAnOutNode(call, k.(ValueReturnKind).getKind())
    or
    exists(ArgNode arg |
      result.(PostUpdateNode).getPreUpdateNode() = arg and
      arg.argumentOf(call, k.(ParamUpdateReturnKind).getAMatchingArgumentPosition())
    )
  }

  /**
   * An extended return kind. A return kind describes how data can be returned
   * from a callable. This can either be through a returned value or an updated
   * parameter.
   */
  abstract class ReturnKindExt extends TReturnKindExt {
    /** Gets a textual representation of this return kind. */
    abstract string toString();

    /** Gets a node corresponding to data flow out of `call`. */
    final OutNodeEx getAnOutNodeEx(DataFlowCall call) { result = getAnOutNodeEx(call, this) }
  }

  class ValueReturnKind extends ReturnKindExt, TValueReturn {
    private ReturnKind kind;

    ValueReturnKind() { this = TValueReturn(kind) }

    ReturnKind getKind() { result = kind }

    override string toString() { result = kind.toString() }
  }

  class ParamUpdateReturnKind extends ReturnKindExt, TParamUpdate {
    private ParameterPosition pos;

    ParamUpdateReturnKind() { this = TParamUpdate(pos) }

    ParameterPosition getPosition() { result = pos }

    pragma[nomagic]
    ArgumentPosition getAMatchingArgumentPosition() { parameterMatch(pos, result) }

    override string toString() { result = "param update " + pos }
  }

  class ReturnKindExtOption = Option<ReturnKindExt>::Option;

  /** A callable tagged with a relevant return kind. */
  class ReturnPosition extends TReturnPosition0 {
    private DataFlowCallable c;
    private ReturnKindExt kind;

    ReturnPosition() { this = TReturnPosition0(c, kind) }

    /** Gets the callable. */
    DataFlowCallable getCallable() { result = c }

    /** Gets the return kind. */
    ReturnKindExt getKind() { result = kind }

    /** Gets a textual representation of this return position. */
    string toString() { result = "[" + kind + "] " + c }
  }

  /**
   * Gets the enclosing callable of `n`. Unlike `n.getEnclosingCallable()`, this
   * predicate ensures that joins go from `n` to the result instead of the other
   * way around.
   */
  pragma[inline]
  DataFlowCallable getNodeEnclosingCallable(Node n) {
    nodeEnclosingCallable(pragma[only_bind_out](n), pragma[only_bind_into](result))
  }

  /** Gets the type of `n` used for type pruning. */
  pragma[inline]
  DataFlowType getNodeDataFlowType(Node n) {
    nodeDataFlowType(pragma[only_bind_out](n), pragma[only_bind_into](result))
  }

  /** An optional Boolean value. */
  class BooleanOption extends TBooleanOption {
    string toString() {
      this = TBooleanNone() and result = "<none>"
      or
      this = TBooleanSome(any(boolean b | result = b.toString()))
    }
  }

  /** An optional `DataFlowCall`. */
  class DataFlowCallOption extends TDataFlowCallOption {
    string toString() {
      this = TDataFlowCallNone() and
      result = "(none)"
      or
      exists(DataFlowCall call |
        this = TDataFlowCallSome(call) and
        result = call.toString()
      )
    }
  }

  /**
   * A return context used to calculate flow summaries in reverse flow.
   *
   * The possible values are:
   *
   * - `TReturnCtxNone()`: no return flow.
   * - `TReturnCtxNoFlowThrough()`: return flow, but flow through is not possible.
   * - `TReturnCtxMaybeFlowThrough(ReturnPosition pos)`: return flow, of kind `pos`, and
   *    flow through may be possible.
   */
  class ReturnCtx extends TReturnCtx {
    string toString() {
      this = TReturnCtxNone() and
      result = "(none)"
      or
      this = TReturnCtxNoFlowThrough() and
      result = "(no flow through)"
      or
      exists(ReturnPosition pos |
        this = TReturnCtxMaybeFlowThrough(pos) and
        result = pos.toString()
      )
    }
  }

  /**
   * The front of an approximated access path. This is either a head or a nil.
   */
  abstract class ApproxAccessPathFront extends TApproxAccessPathFront {
    abstract string toString();

    abstract boolean toBoolNonEmpty();

    ContentApprox getHead() { this = TApproxFrontHead(result) }

    pragma[nomagic]
    Content getAHead() {
      exists(ContentApprox cont |
        this = TApproxFrontHead(cont) and
        cont = getContentApproxCached(result)
      )
    }
  }

  class ApproxAccessPathFrontNil extends ApproxAccessPathFront, TApproxFrontNil {
    override string toString() { result = "nil" }

    override boolean toBoolNonEmpty() { result = false }
  }

  class ApproxAccessPathFrontHead extends ApproxAccessPathFront, TApproxFrontHead {
    private ContentApprox c;

    ApproxAccessPathFrontHead() { this = TApproxFrontHead(c) }

    override string toString() { result = c.toString() }

    override boolean toBoolNonEmpty() { result = true }
  }

  /** An optional approximated access path front. */
  class ApproxAccessPathFrontOption extends TApproxAccessPathFrontOption {
    string toString() {
      this = TApproxAccessPathFrontNone() and result = "<none>"
      or
      this = TApproxAccessPathFrontSome(any(ApproxAccessPathFront apf | result = apf.toString()))
    }
  }

  /**
   * The front of an access path. This is either a head or a nil.
   */
  abstract class AccessPathFront extends TAccessPathFront {
    abstract string toString();

    abstract ApproxAccessPathFront toApprox();

    Content getHead() { this = TFrontHead(result) }
  }

  class AccessPathFrontNil extends AccessPathFront, TFrontNil {
    override string toString() { result = "nil" }

    override ApproxAccessPathFront toApprox() { result = TApproxFrontNil() }
  }

  class AccessPathFrontHead extends AccessPathFront, TFrontHead {
    private Content c;

    AccessPathFrontHead() { this = TFrontHead(c) }

    override string toString() { result = c.toString() }

    override ApproxAccessPathFront toApprox() { result.getAHead() = c }
  }

  /** An optional access path front. */
  class AccessPathFrontOption extends TAccessPathFrontOption {
    string toString() {
      this = TAccessPathFrontNone() and result = "<none>"
      or
      this = TAccessPathFrontSome(any(AccessPathFront apf | result = apf.toString()))
    }
  }
}
