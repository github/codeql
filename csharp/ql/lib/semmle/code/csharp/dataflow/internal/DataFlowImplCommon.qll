private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
import Cached

module DataFlowImplCommonPublic {
  /** A state value to track during data flow. */
  class FlowState = string;

  /**
   * The default state, which is used when the state is unspecified for a source
   * or a sink.
   */
  class FlowStateEmpty extends FlowState {
    FlowStateEmpty() { this = "" }
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
}

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

  pragma[noinline]
  private TReturnPositionSimple getReturnPositionSimple(ReturnNode ret, ReturnKind kind) {
    result = TReturnPositionSimple0(getNodeEnclosingCallable(ret), kind)
  }

  pragma[nomagic]
  private TReturnPositionSimple viableReturnPosNonLambda(DataFlowCall call, ReturnKind kind) {
    result = TReturnPositionSimple0(viableCallable(call), kind)
  }

  pragma[nomagic]
  private TReturnPositionSimple viableReturnPosLambda(
    DataFlowCall call, DataFlowCallOption lastCall, ReturnKind kind
  ) {
    result = TReturnPositionSimple0(viableCallableLambda(call, lastCall), kind)
  }

  private predicate viableReturnPosOutNonLambda(
    DataFlowCall call, TReturnPositionSimple pos, OutNode out
  ) {
    exists(ReturnKind kind |
      pos = viableReturnPosNonLambda(call, kind) and
      out = getAnOutNode(call, kind)
    )
  }

  private predicate viableReturnPosOutLambda(
    DataFlowCall call, DataFlowCallOption lastCall, TReturnPositionSimple pos, OutNode out
  ) {
    exists(ReturnKind kind |
      pos = viableReturnPosLambda(call, lastCall, kind) and
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
    if castNode(node) or node instanceof ArgNode or node instanceof ReturnNode
    then compatibleTypes(t, getNodeDataFlowType(node))
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
      simpleLocalFlowStep(node, mid) and
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
      revLambdaFlow(lambdaCall, kind, mid, t0, _, _, _) and
      toReturn = false and
      toJump = true and
      lastCall = TDataFlowCallNone()
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
      getReturnPositionSimple(node, node.(ReturnNode).getKind()) = pos and
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
      out = rk.getAnOutNode(call) and
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
      viableReturnPosOutLambda(call, _, pos, out)
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
  result = viableCallable(call)
  or
  result = viableCallableLambda(call, _)
}

cached
private module Cached {
  /**
   * If needed, call this predicate from `DataFlowImplSpecific.qll` in order to
   * force a stage-dependency on the `DataFlowImplCommon.qll` stage and therby
   * collapsing the two stages.
   */
  cached
  predicate forceCachingInSameStage() { any() }

  cached
  predicate nodeEnclosingCallable(Node n, DataFlowCallable c) { c = nodeGetEnclosingCallable(n) }

  cached
  predicate callEnclosingCallable(DataFlowCall call, DataFlowCallable c) {
    c = call.getEnclosingCallable()
  }

  cached
  predicate nodeDataFlowType(Node n, DataFlowType t) { t = getNodeType(n) }

  cached
  predicate jumpStepCached(Node node1, Node node2) { jumpStep(node1, node2) }

  cached
  predicate clearsContentCached(Node n, ContentSet c) { clearsContent(n, c) }

  cached
  predicate isUnreachableInCallCached(Node n, DataFlowCall call) { isUnreachableInCall(n, call) }

  cached
  predicate outNodeExt(Node n) {
    n instanceof OutNode
    or
    n.(PostUpdateNode).getPreUpdateNode() instanceof ArgNode
  }

  cached
  predicate hiddenNode(Node n) { nodeIsHidden(n) }

  cached
  OutNodeExt getAnOutNodeExt(DataFlowCall call, ReturnKindExt k) {
    result = getAnOutNode(call, k.(ValueReturnKind).getKind())
    or
    exists(ArgNode arg |
      result.(PostUpdateNode).getPreUpdateNode() = arg and
      arg.argumentOf(call, k.(ParamUpdateReturnKind).getAMatchingArgumentPosition())
    )
  }

  cached
  predicate returnNodeExt(Node n, ReturnKindExt k) {
    k = TValueReturn(n.(ReturnNode).getKind())
    or
    exists(ParamNode p, ParameterPosition pos |
      parameterValueFlowsToPreUpdate(p, n) and
      p.isParameterOf(_, pos) and
      k = TParamUpdate(pos)
    )
  }

  cached
  predicate castNode(Node n) { n instanceof CastNode }

  cached
  predicate castingNode(Node n) {
    castNode(n) or
    n instanceof ParamNode or
    n instanceof OutNodeExt or
    // For reads, `x.f`, we want to check that the tracked type after the read (which
    // is obtained by popping the head of the access path stack) is compatible with
    // the type of `x.f`.
    readSet(_, _, n)
  }

  cached
  predicate parameterNode(Node p, DataFlowCallable c, ParameterPosition pos) {
    isParameterNode(p, c, pos)
  }

  cached
  predicate argumentNode(Node n, DataFlowCall call, ArgumentPosition pos) {
    isArgumentNode(n, call, pos)
  }

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
      compatibleTypes(getNodeDataFlowType(arg), getNodeDataFlowType(p))
    )
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
  predicate viableReturnPosOut(DataFlowCall call, ReturnPosition pos, Node out) {
    exists(ReturnKindExt kind |
      pos = viableReturnPos(call, kind) and
      out = kind.getAnOutNode(call)
    )
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
        p = node and
        read = false
        or
        // local flow
        exists(Node mid |
          parameterValueFlowCand(p, mid, read) and
          simpleLocalFlowStep(mid, node)
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
      predicate parameterValueFlow(ParamNode p, Node node, ReadStepTypesOption read) {
        parameterValueFlow0(p, node, read) and
        if node instanceof CastingNode
        then
          // normal flow through
          read = TReadStepTypesNone() and
          compatibleTypes(getNodeDataFlowType(p), getNodeDataFlowType(node))
          or
          // getter
          compatibleTypes(read.getContentType(), getNodeDataFlowType(node))
        else any()
      }

      pragma[nomagic]
      private predicate parameterValueFlow0(ParamNode p, Node node, ReadStepTypesOption read) {
        p = node and
        Cand::cand(p, _) and
        read = TReadStepTypesNone()
        or
        // local flow
        exists(Node mid |
          parameterValueFlow(p, mid, read) and
          simpleLocalFlowStep(mid, node)
        )
        or
        // read
        exists(Node mid |
          parameterValueFlow(p, mid, TReadStepTypesNone()) and
          readStepWithTypes(mid, read.getContainerType(), read.getContent(), node,
            read.getContentType()) and
          Cand::parameterValueFlowReturnCand(p, _, true) and
          compatibleTypes(getNodeDataFlowType(p), read.getContainerType())
        )
        or
        parameterValueFlow0_0(TReadStepTypesNone(), p, node, read)
      }

      pragma[nomagic]
      private predicate parameterValueFlow0_0(
        ReadStepTypesOption mustBeNone, ParamNode p, Node node, ReadStepTypesOption read
      ) {
        // flow through: no prior read
        exists(ArgNode arg |
          parameterValueFlowArg(p, arg, mustBeNone) and
          argumentValueFlowsThrough(arg, read, node)
        )
        or
        // flow through: no read inside method
        exists(ArgNode arg |
          parameterValueFlowArg(p, arg, read) and
          argumentValueFlowsThrough(arg, mustBeNone, node)
        )
      }

      pragma[nomagic]
      private predicate parameterValueFlowArg(ParamNode p, ArgNode arg, ReadStepTypesOption read) {
        parameterValueFlow(p, arg, read) and
        Cand::argumentValueFlowsThroughCand(arg, _, _)
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThrough0(
        DataFlowCall call, ArgNode arg, ReturnKind kind, ReadStepTypesOption read
      ) {
        exists(ParamNode param | viableParamArg(call, param, arg) |
          parameterValueFlowReturn(param, kind, read)
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
      pragma[nomagic]
      predicate argumentValueFlowsThrough(ArgNode arg, ReadStepTypesOption read, Node out) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThrough0(call, arg, kind, read) and
          out = getAnOutNode(call, kind)
        |
          // normal flow through
          read = TReadStepTypesNone() and
          compatibleTypes(getNodeDataFlowType(arg), getNodeDataFlowType(out))
          or
          // getter
          compatibleTypes(getNodeDataFlowType(arg), read.getContainerType()) and
          compatibleTypes(read.getContentType(), getNodeDataFlowType(out))
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only
       * value-preserving steps and a single read step, not taking call
       * contexts into account, thus representing a getter-step.
       *
       * This predicate is exposed for testing only.
       */
      predicate getterStep(ArgNode arg, ContentSet c, Node out) {
        argumentValueFlowsThrough(arg, TReadStepTypesSome(_, c, _), out)
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
        ParamNode p, ReturnKind kind, ReadStepTypesOption read
      ) {
        exists(ReturnNode ret |
          parameterValueFlow(p, ret, read) and
          kind = ret.getKind()
        )
      }
    }

    import Final
  }

  import FlowThrough

  cached
  private module DispatchWithCallContext {
    /**
     * Holds if the set of viable implementations that can be called by `call`
     * might be improved by knowing the call context.
     */
    pragma[nomagic]
    private predicate mayBenefitFromCallContextExt(DataFlowCall call, DataFlowCallable callable) {
      mayBenefitFromCallContext(call, callable)
      or
      callEnclosingCallable(call, callable) and
      exists(viableCallableLambda(call, TDataFlowCallSome(_)))
    }

    /**
     * Gets a viable dispatch target of `call` in the context `ctx`. This is
     * restricted to those `call`s for which a context might make a difference.
     */
    pragma[nomagic]
    private DataFlowCallable viableImplInCallContextExt(DataFlowCall call, DataFlowCall ctx) {
      result = viableImplInCallContext(call, ctx)
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
     * Holds if the call context `ctx` reduces the set of viable run-time
     * dispatch targets of call `call` in `c`.
     */
    cached
    predicate reducedViableImplInCallContext(DataFlowCall call, DataFlowCallable c, DataFlowCall ctx) {
      exists(int tgts, int ctxtgts |
        mayBenefitFromCallContextExt(call, c) and
        c = viableCallableExt(ctx) and
        ctxtgts = count(viableImplInCallContextExt(call, ctx)) and
        tgts = strictcount(viableCallableExt(call)) and
        ctxtgts < tgts
      )
    }

    /**
     * Gets a viable run-time dispatch target for the call `call` in the
     * context `ctx`. This is restricted to those calls for which a context
     * makes a difference.
     */
    cached
    DataFlowCallable prunedViableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
      result = viableImplInCallContextExt(call, ctx) and
      reducedViableImplInCallContext(call, _, ctx)
    }

    /**
     * Holds if flow returning from callable `c` to call `call` might return
     * further and if this path restricts the set of call sites that can be
     * returned to.
     */
    cached
    predicate reducedViableImplInReturn(DataFlowCallable c, DataFlowCall call) {
      exists(int tgts, int ctxtgts |
        mayBenefitFromCallContextExt(call, _) and
        c = viableCallableExt(call) and
        ctxtgts = count(DataFlowCall ctx | c = viableImplInCallContextExt(call, ctx)) and
        tgts = strictcount(DataFlowCall ctx | callEnclosingCallable(call, viableCallableExt(ctx))) and
        ctxtgts < tgts
      )
    }

    /**
     * Gets a viable run-time dispatch target for the call `call` in the
     * context `ctx`. This is restricted to those calls and results for which
     * the return flow from the result to `call` restricts the possible context
     * `ctx`.
     */
    cached
    DataFlowCallable prunedViableImplInCallContextReverse(DataFlowCall call, DataFlowCall ctx) {
      result = viableImplInCallContextExt(call, ctx) and
      reducedViableImplInReturn(result, call)
    }
  }

  import DispatchWithCallContext

  /**
   * Holds if `p` can flow to the pre-update node associated with post-update
   * node `n`, in the same callable, using only value-preserving steps.
   */
  private predicate parameterValueFlowsToPreUpdate(ParamNode p, PostUpdateNode n) {
    parameterValueFlow(p, n.getPreUpdateNode(), TReadStepTypesNone())
  }

  cached
  predicate readSet(Node node1, ContentSet c, Node node2) { readStep(node1, c, node2) }

  private predicate store(
    Node node1, Content c, Node node2, DataFlowType contentType, DataFlowType containerType
  ) {
    exists(ContentSet cs | c = cs.getAStoreContent() |
      storeStep(node1, cs, node2) and
      contentType = getNodeDataFlowType(node1) and
      containerType = getNodeDataFlowType(node2)
      or
      exists(Node n1, Node n2 |
        n1 = node1.(PostUpdateNode).getPreUpdateNode() and
        n2 = node2.(PostUpdateNode).getPreUpdateNode()
      |
        argumentValueFlowsThrough(n2, TReadStepTypesSome(containerType, cs, contentType), n1)
        or
        readSet(n2, cs, n1) and
        contentType = getNodeDataFlowType(n1) and
        containerType = getNodeDataFlowType(n2)
      )
    )
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a direct assignment to
   * `f`.
   *
   * This includes reverse steps through reads when the result of the read has
   * been stored into, in order to handle cases like `x.f1.f2 = y`.
   */
  cached
  predicate store(Node node1, TypedContent tc, Node node2, DataFlowType contentType) {
    store(node1, tc.getContent(), node2, contentType, tc.getContainerType())
  }

  /**
   * Holds if data can flow from `fromNode` to `toNode` because they are the post-update
   * nodes of some function output and input respectively, where the output and input
   * are aliases. A typical example is a function returning `this`, implementing a fluent
   * interface.
   */
  private predicate reverseStepThroughInputOutputAlias(
    PostUpdateNode fromNode, PostUpdateNode toNode
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
        simpleLocalFlowStep(toPre.(ArgNode), fromPre)
      )
      or
      argumentValueFlowsThrough(toPre, TReadStepTypesNone(), fromPre)
    )
  }

  cached
  predicate simpleLocalFlowStepExt(Node node1, Node node2) {
    simpleLocalFlowStep(node1, node2) or
    reverseStepThroughInputOutputAlias(node1, node2)
  }

  /**
   * Holds if the call context `call` improves virtual dispatch in `callable`.
   */
  cached
  predicate recordDataFlowCallSiteDispatch(DataFlowCall call, DataFlowCallable callable) {
    reducedViableImplInCallContext(_, callable, call)
  }

  /**
   * Holds if the call context `call` allows us to prune unreachable nodes in `callable`.
   */
  cached
  predicate recordDataFlowCallSiteUnreachable(DataFlowCall call, DataFlowCallable callable) {
    exists(Node n | getNodeEnclosingCallable(n) = callable | isUnreachableInCallCached(n, call))
  }

  cached
  predicate allowParameterReturnInSelfCached(ParamNode p) { allowParameterReturnInSelf(p) }

  cached
  newtype TCallContext =
    TAnyCallContext() or
    TSpecificCall(DataFlowCall call) { recordDataFlowCallSite(call, _) } or
    TSomeCall() or
    TReturn(DataFlowCallable c, DataFlowCall call) { reducedViableImplInReturn(c, call) }

  cached
  newtype TReturnPosition =
    TReturnPosition0(DataFlowCallable c, ReturnKindExt kind) {
      exists(ReturnNodeExt ret |
        c = returnNodeGetEnclosingCallable(ret) and
        kind = ret.getKind()
      )
    }

  cached
  newtype TLocalFlowCallContext =
    TAnyLocalCall() or
    TSpecificLocalCall(DataFlowCall call) { isUnreachableInCallCached(_, call) }

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
  newtype TTypedContent = MkTypedContent(Content c, DataFlowType t) { store(_, c, _, _, t) }

  cached
  newtype TAccessPathFront =
    TFrontNil(DataFlowType t) or
    TFrontHead(TypedContent tc)

  cached
  newtype TAccessPathFrontOption =
    TAccessPathFrontNone() or
    TAccessPathFrontSome(AccessPathFront apf)
}

/**
 * Holds if the call context `call` either improves virtual dispatch in
 * `callable` or if it allows us to prune unreachable nodes in `callable`.
 */
predicate recordDataFlowCallSite(DataFlowCall call, DataFlowCallable callable) {
  recordDataFlowCallSiteDispatch(call, callable) or
  recordDataFlowCallSiteUnreachable(call, callable)
}

/**
 * A `Node` at which a cast can occur such that the type should be checked.
 */
class CastingNode extends Node {
  CastingNode() { castingNode(this) }
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
 * A call context to restrict the targets of virtual dispatch, prune local flow,
 * and match the call sites of flow into a method with flow out of a method.
 *
 * There are four cases:
 * - `TAnyCallContext()` : No restrictions on method flow.
 * - `TSpecificCall(DataFlowCall call)` : Flow entered through the
 *    given `call`. This call improves the set of viable
 *    dispatch targets for at least one method call in the current callable
 *    or helps prune unreachable nodes in the current callable.
 * - `TSomeCall()` : Flow entered through a parameter. The
 *    originating call does not improve the set of dispatch targets for any
 *    method call in the current callable and was therefore not recorded.
 * - `TReturn(Callable c, DataFlowCall call)` : Flow reached `call` from `c` and
 *    this dispatch target of `call` implies a reduced set of dispatch origins
 *    to which data may flow if it should reach a `return` statement.
 */
abstract class CallContext extends TCallContext {
  abstract string toString();

  /** Holds if this call context is relevant for `callable`. */
  abstract predicate relevantFor(DataFlowCallable callable);
}

abstract class CallContextNoCall extends CallContext { }

class CallContextAny extends CallContextNoCall, TAnyCallContext {
  override string toString() { result = "CcAny" }

  override predicate relevantFor(DataFlowCallable callable) { any() }
}

abstract class CallContextCall extends CallContext {
  /** Holds if this call context may be `call`. */
  bindingset[call]
  abstract predicate matchesCall(DataFlowCall call);
}

class CallContextSpecificCall extends CallContextCall, TSpecificCall {
  override string toString() {
    exists(DataFlowCall call | this = TSpecificCall(call) | result = "CcCall(" + call + ")")
  }

  override predicate relevantFor(DataFlowCallable callable) {
    recordDataFlowCallSite(this.getCall(), callable)
  }

  override predicate matchesCall(DataFlowCall call) { call = this.getCall() }

  DataFlowCall getCall() { this = TSpecificCall(result) }
}

class CallContextSomeCall extends CallContextCall, TSomeCall {
  override string toString() { result = "CcSomeCall" }

  override predicate relevantFor(DataFlowCallable callable) {
    exists(ParamNode p | getNodeEnclosingCallable(p) = callable)
  }

  override predicate matchesCall(DataFlowCall call) { any() }
}

class CallContextReturn extends CallContextNoCall, TReturn {
  override string toString() {
    exists(DataFlowCall call | this = TReturn(_, call) | result = "CcReturn(" + call + ")")
  }

  override predicate relevantFor(DataFlowCallable callable) {
    exists(DataFlowCall call | this = TReturn(_, call) and callEnclosingCallable(call, callable))
  }
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
  LocalCallContextSpecificCall() { this = TSpecificLocalCall(call) }

  DataFlowCall call;

  DataFlowCall getCall() { result = call }

  override string toString() { result = "LocalCcCall(" + call + ")" }

  override predicate relevantFor(DataFlowCallable callable) { relevantLocalCCtx(call, callable) }
}

private predicate relevantLocalCCtx(DataFlowCall call, DataFlowCallable callable) {
  exists(Node n | getNodeEnclosingCallable(n) = callable and isUnreachableInCallCached(n, call))
}

/**
 * Gets the local call context given the call context and the callable that
 * the contexts apply to.
 */
LocalCallContext getLocalCallContext(CallContext ctx, DataFlowCallable callable) {
  ctx.relevantFor(callable) and
  if relevantLocalCCtx(ctx.(CallContextSpecificCall).getCall(), callable)
  then result.(LocalCallContextSpecificCall).getCall() = ctx.(CallContextSpecificCall).getCall()
  else result instanceof LocalCallContextAny
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParamNode extends Node {
  ParamNode() { parameterNode(this, _, _) }

  /**
   * Holds if this node is the parameter of callable `c` at the specified
   * position.
   */
  predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) { parameterNode(this, c, pos) }
}

/** A data-flow node that represents a call argument. */
class ArgNode extends Node {
  ArgNode() { argumentNode(this, _, _) }

  /** Holds if this argument occurs at the given position in the given call. */
  final predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    argumentNode(this, call, pos)
  }
}

/**
 * A node from which flow can return to the caller. This is either a regular
 * `ReturnNode` or a `PostUpdateNode` corresponding to the value of a parameter.
 */
class ReturnNodeExt extends Node {
  ReturnNodeExt() { returnNodeExt(this, _) }

  /** Gets the kind of this returned value. */
  ReturnKindExt getKind() { returnNodeExt(this, result) }
}

/**
 * A node to which data can flow from a call. Either an ordinary out node
 * or a post-update node associated with a call argument.
 */
class OutNodeExt extends Node {
  OutNodeExt() { outNodeExt(this) }
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
  final OutNodeExt getAnOutNode(DataFlowCall call) { result = getAnOutNodeExt(call, this) }
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

pragma[noinline]
private DataFlowCallable returnNodeGetEnclosingCallable(ReturnNodeExt ret) {
  result = getNodeEnclosingCallable(ret)
}

pragma[noinline]
private ReturnPosition getReturnPosition0(ReturnNodeExt ret, ReturnKindExt kind) {
  result.getCallable() = returnNodeGetEnclosingCallable(ret) and
  kind = result.getKind()
}

pragma[noinline]
ReturnPosition getReturnPosition(ReturnNodeExt ret) {
  result = getReturnPosition0(ret, ret.getKind())
}

/**
 * Checks whether `inner` can return to `call` in the call context `innercc`.
 * Assumes a context of `inner = viableCallableExt(call)`.
 */
bindingset[innercc, inner, call]
predicate checkCallContextReturn(CallContext innercc, DataFlowCallable inner, DataFlowCall call) {
  innercc instanceof CallContextAny
  or
  exists(DataFlowCallable c0, DataFlowCall call0 |
    callEnclosingCallable(call0, inner) and
    innercc = TReturn(c0, call0) and
    c0 = prunedViableImplInCallContextReverse(call0, call)
  )
}

/**
 * Checks whether `call` can resolve to `calltarget` in the call context `cc`.
 * Assumes a context of `calltarget = viableCallableExt(call)`.
 */
bindingset[cc, call, calltarget]
predicate checkCallContextCall(CallContext cc, DataFlowCall call, DataFlowCallable calltarget) {
  exists(DataFlowCall ctx | cc = TSpecificCall(ctx) |
    if reducedViableImplInCallContext(call, _, ctx)
    then calltarget = prunedViableImplInCallContext(call, ctx)
    else any()
  )
  or
  cc instanceof CallContextSomeCall
  or
  cc instanceof CallContextAny
  or
  cc instanceof CallContextReturn
}

/**
 * Resolves a return from `callable` in `cc` to `call`. This is equivalent to
 * `callable = viableCallableExt(call) and checkCallContextReturn(cc, callable, call)`.
 */
bindingset[cc, callable]
predicate resolveReturn(CallContext cc, DataFlowCallable callable, DataFlowCall call) {
  cc instanceof CallContextAny and callable = viableCallableExt(call)
  or
  exists(DataFlowCallable c0, DataFlowCall call0 |
    callEnclosingCallable(call0, callable) and
    cc = TReturn(c0, call0) and
    c0 = prunedViableImplInCallContextReverse(call0, call)
  )
}

/**
 * Resolves a call from `call` in `cc` to `result`. This is equivalent to
 * `result = viableCallableExt(call) and checkCallContextCall(cc, call, result)`.
 */
bindingset[call, cc]
DataFlowCallable resolveCall(DataFlowCall call, CallContext cc) {
  exists(DataFlowCall ctx | cc = TSpecificCall(ctx) |
    if reducedViableImplInCallContext(call, _, ctx)
    then result = prunedViableImplInCallContext(call, ctx)
    else result = viableCallableExt(call)
  )
  or
  result = viableCallableExt(call) and cc instanceof CallContextSomeCall
  or
  result = viableCallableExt(call) and cc instanceof CallContextAny
  or
  result = viableCallableExt(call) and cc instanceof CallContextReturn
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

/** A `Content` tagged with the type of a containing object. */
class TypedContent extends MkTypedContent {
  private Content c;
  private DataFlowType t;

  TypedContent() { this = MkTypedContent(c, t) }

  /** Gets the content. */
  Content getContent() { result = c }

  /** Gets the container type. */
  DataFlowType getContainerType() { result = t }

  /** Gets a textual representation of this content. */
  string toString() { result = c.toString() }

  /**
   * Holds if access paths with this `TypedContent` at their head always should
   * be tracked at high precision. This disables adaptive access path precision
   * for such access paths.
   */
  predicate forceHighPrecision() { forceHighPrecision(c) }
}

/**
 * The front of an access path. This is either a head or a nil.
 */
abstract class AccessPathFront extends TAccessPathFront {
  abstract string toString();

  abstract DataFlowType getType();

  abstract boolean toBoolNonEmpty();

  TypedContent getHead() { this = TFrontHead(result) }
}

class AccessPathFrontNil extends AccessPathFront, TFrontNil {
  private DataFlowType t;

  AccessPathFrontNil() { this = TFrontNil(t) }

  override string toString() { result = ppReprType(t) }

  override DataFlowType getType() { result = t }

  override boolean toBoolNonEmpty() { result = false }
}

class AccessPathFrontHead extends AccessPathFront, TFrontHead {
  private TypedContent tc;

  AccessPathFrontHead() { this = TFrontHead(tc) }

  override string toString() { result = tc.toString() }

  override DataFlowType getType() { result = tc.getContainerType() }

  override boolean toBoolNonEmpty() { result = true }
}

/** An optional access path front. */
class AccessPathFrontOption extends TAccessPathFrontOption {
  string toString() {
    this = TAccessPathFrontNone() and result = "<none>"
    or
    this = TAccessPathFrontSome(any(AccessPathFront apf | result = apf.toString()))
  }
}
