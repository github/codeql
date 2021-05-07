private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
import Cached

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
 * Provides a simple data-flow analysis for resolving lambda calls. The analysis
 * currently excludes read-steps, store-steps, and flow-through.
 *
 * The analysis uses non-linear recursion: When computing a flow path in or out
 * of a call, we use the results of the analysis recursively to resolve lambda
 * calls. For this reason, we cannot reuse the code from `DataFlowImpl.qll` directly.
 */
private module LambdaFlow {
  private predicate viableParamNonLambda(DataFlowCall call, int i, ParameterNode p) {
    p.isParameterOf(viableCallable(call), i)
  }

  private predicate viableParamLambda(DataFlowCall call, int i, ParameterNode p) {
    p.isParameterOf(viableCallableLambda(call, _), i)
  }

  private predicate viableParamArgNonLambda(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
    exists(int i |
      viableParamNonLambda(call, i, p) and
      arg.argumentOf(call, i)
    )
  }

  private predicate viableParamArgLambda(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
    exists(int i |
      viableParamLambda(call, i, p) and
      arg.argumentOf(call, i)
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
    if node instanceof CastNode or node instanceof ArgumentNode or node instanceof ReturnNode
    then compatibleTypes(t, getNodeType(node))
    else any()
  }

  pragma[nomagic]
  predicate revLambdaFlow0(
    DataFlowCall lambdaCall, LambdaCallKind kind, Node node, DataFlowType t, boolean toReturn,
    boolean toJump, DataFlowCallOption lastCall
  ) {
    lambdaCall(lambdaCall, kind, node) and
    t = getNodeType(node) and
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
        t = getNodeType(node)
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
      jumpStep(node, mid) and
      t = t0
      or
      exists(boolean preservesValue |
        additionalLambdaFlowStep(node, mid, preservesValue) and
        getNodeEnclosingCallable(node) != getNodeEnclosingCallable(mid)
      |
        preservesValue = false and
        t = getNodeType(node)
        or
        preservesValue = true and
        t = t0
      )
    )
    or
    // flow into a callable
    exists(ParameterNode p, DataFlowCallOption lastCall0, DataFlowCall call |
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
    DataFlowCall lambdaCall, LambdaCallKind kind, ParameterNode p, DataFlowType t, boolean toJump,
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
   * Holds if `p` is the `i`th parameter of a viable dispatch target of `call`.
   * The instance parameter is considered to have index `-1`.
   */
  pragma[nomagic]
  private predicate viableParam(DataFlowCall call, int i, ParameterNode p) {
    p.isParameterOf(viableCallableExt(call), i)
  }

  /**
   * Holds if `arg` is a possible argument to `p` in `call`, taking virtual
   * dispatch into account.
   */
  cached
  predicate viableParamArg(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
    exists(int i |
      viableParam(call, i, p) and
      arg.argumentOf(call, i) and
      compatibleTypes(getNodeType(arg), getNodeType(p))
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
      private predicate parameterValueFlowCand(ParameterNode p, Node node, boolean read) {
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
          readStep(mid, _, node) and
          read = true
        )
        or
        // flow through: no prior read
        exists(ArgumentNode arg |
          parameterValueFlowArgCand(p, arg, false) and
          argumentValueFlowsThroughCand(arg, node, read)
        )
        or
        // flow through: no read inside method
        exists(ArgumentNode arg |
          parameterValueFlowArgCand(p, arg, read) and
          argumentValueFlowsThroughCand(arg, node, false)
        )
      }

      pragma[nomagic]
      private predicate parameterValueFlowArgCand(ParameterNode p, ArgumentNode arg, boolean read) {
        parameterValueFlowCand(p, arg, read)
      }

      pragma[nomagic]
      predicate parameterValueFlowsToPreUpdateCand(ParameterNode p, PostUpdateNode n) {
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
      predicate parameterValueFlowReturnCand(ParameterNode p, ReturnKind kind, boolean read) {
        exists(ReturnNode ret |
          parameterValueFlowCand(p, ret, read) and
          kind = ret.getKind()
        )
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThroughCand0(
        DataFlowCall call, ArgumentNode arg, ReturnKind kind, boolean read
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
          parameterValueFlowReturnCand(param, kind, read)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * not taking call contexts into account.
       *
       * `read` indicates whether it is contents of `arg` that can flow to `out`.
       */
      predicate argumentValueFlowsThroughCand(ArgumentNode arg, Node out, boolean read) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThroughCand0(call, arg, kind, read) and
          out = getAnOutNode(call, kind)
        )
      }

      predicate cand(ParameterNode p, Node n) {
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
      predicate parameterValueFlow(ParameterNode p, Node node, ReadStepTypesOption read) {
        parameterValueFlow0(p, node, read) and
        if node instanceof CastingNode
        then
          // normal flow through
          read = TReadStepTypesNone() and
          compatibleTypes(getNodeType(p), getNodeType(node))
          or
          // getter
          compatibleTypes(read.getContentType(), getNodeType(node))
        else any()
      }

      pragma[nomagic]
      private predicate parameterValueFlow0(ParameterNode p, Node node, ReadStepTypesOption read) {
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
          compatibleTypes(getNodeType(p), read.getContainerType())
        )
        or
        parameterValueFlow0_0(TReadStepTypesNone(), p, node, read)
      }

      pragma[nomagic]
      private predicate parameterValueFlow0_0(
        ReadStepTypesOption mustBeNone, ParameterNode p, Node node, ReadStepTypesOption read
      ) {
        // flow through: no prior read
        exists(ArgumentNode arg |
          parameterValueFlowArg(p, arg, mustBeNone) and
          argumentValueFlowsThrough(arg, read, node)
        )
        or
        // flow through: no read inside method
        exists(ArgumentNode arg |
          parameterValueFlowArg(p, arg, read) and
          argumentValueFlowsThrough(arg, mustBeNone, node)
        )
      }

      pragma[nomagic]
      private predicate parameterValueFlowArg(
        ParameterNode p, ArgumentNode arg, ReadStepTypesOption read
      ) {
        parameterValueFlow(p, arg, read) and
        Cand::argumentValueFlowsThroughCand(arg, _, _)
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThrough0(
        DataFlowCall call, ArgumentNode arg, ReturnKind kind, ReadStepTypesOption read
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
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
      predicate argumentValueFlowsThrough(ArgumentNode arg, ReadStepTypesOption read, Node out) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThrough0(call, arg, kind, read) and
          out = getAnOutNode(call, kind)
        |
          // normal flow through
          read = TReadStepTypesNone() and
          compatibleTypes(getNodeType(arg), getNodeType(out))
          or
          // getter
          compatibleTypes(getNodeType(arg), read.getContainerType()) and
          compatibleTypes(read.getContentType(), getNodeType(out))
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only
       * value-preserving steps and a single read step, not taking call
       * contexts into account, thus representing a getter-step.
       */
      predicate getterStep(ArgumentNode arg, Content c, Node out) {
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
        ParameterNode p, ReturnKind kind, ReadStepTypesOption read
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
      callable = call.getEnclosingCallable() and
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
        tgts = strictcount(DataFlowCall ctx | viableCallableExt(ctx) = call.getEnclosingCallable()) and
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
  cached
  predicate parameterValueFlowsToPreUpdate(ParameterNode p, PostUpdateNode n) {
    parameterValueFlow(p, n.getPreUpdateNode(), TReadStepTypesNone())
  }

  private predicate store(
    Node node1, Content c, Node node2, DataFlowType contentType, DataFlowType containerType
  ) {
    storeStep(node1, c, node2) and
    readStep(_, c, _) and
    contentType = getNodeType(node1) and
    containerType = getNodeType(node2)
    or
    exists(Node n1, Node n2 |
      n1 = node1.(PostUpdateNode).getPreUpdateNode() and
      n2 = node2.(PostUpdateNode).getPreUpdateNode()
    |
      argumentValueFlowsThrough(n2, TReadStepTypesSome(containerType, c, contentType), n1)
      or
      readStep(n2, c, n1) and
      contentType = getNodeType(n1) and
      containerType = getNodeType(n2)
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
  cached
  predicate reverseStepThroughInputOutputAlias(PostUpdateNode fromNode, PostUpdateNode toNode) {
    exists(Node fromPre, Node toPre |
      fromPre = fromNode.getPreUpdateNode() and
      toPre = toNode.getPreUpdateNode()
    |
      exists(DataFlowCall c |
        // Does the language-specific simpleLocalFlowStep already model flow
        // from function input to output?
        fromPre = getAnOutNode(c, _) and
        toPre.(ArgumentNode).argumentOf(c, _) and
        simpleLocalFlowStep(toPre.(ArgumentNode), fromPre)
      )
      or
      argumentValueFlowsThrough(toPre, TReadStepTypesNone(), fromPre)
    )
  }

  /**
   * Holds if the call context `call` either improves virtual dispatch in
   * `callable` or if it allows us to prune unreachable nodes in `callable`.
   */
  cached
  predicate recordDataFlowCallSite(DataFlowCall call, DataFlowCallable callable) {
    reducedViableImplInCallContext(_, callable, call)
    or
    exists(Node n | getNodeEnclosingCallable(n) = callable | isUnreachableInCall(n, call))
  }

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
    TSpecificLocalCall(DataFlowCall call) { isUnreachableInCall(_, call) }

  cached
  newtype TReturnKindExt =
    TValueReturn(ReturnKind kind) or
    TParamUpdate(int pos) { exists(ParameterNode p | p.isParameterOf(_, pos)) }

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
 * A `Node` at which a cast can occur such that the type should be checked.
 */
class CastingNode extends Node {
  CastingNode() {
    this instanceof ParameterNode or
    this instanceof CastNode or
    this instanceof OutNodeExt or
    // For reads, `x.f`, we want to check that the tracked type after the read (which
    // is obtained by popping the head of the access path stack) is compatible with
    // the type of `x.f`.
    readStep(_, _, this)
  }
}

private predicate readStepWithTypes(
  Node n1, DataFlowType container, Content c, Node n2, DataFlowType content
) {
  readStep(n1, c, n2) and
  container = getNodeType(n1) and
  content = getNodeType(n2)
}

private newtype TReadStepTypesOption =
  TReadStepTypesNone() or
  TReadStepTypesSome(DataFlowType container, Content c, DataFlowType content) {
    readStepWithTypes(_, container, c, _, content)
  }

private class ReadStepTypesOption extends TReadStepTypesOption {
  predicate isSome() { this instanceof TReadStepTypesSome }

  DataFlowType getContainerType() { this = TReadStepTypesSome(result, _, _) }

  Content getContent() { this = TReadStepTypesSome(_, result, _) }

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
    recordDataFlowCallSite(getCall(), callable)
  }

  override predicate matchesCall(DataFlowCall call) { call = this.getCall() }

  DataFlowCall getCall() { this = TSpecificCall(result) }
}

class CallContextSomeCall extends CallContextCall, TSomeCall {
  override string toString() { result = "CcSomeCall" }

  override predicate relevantFor(DataFlowCallable callable) {
    exists(ParameterNode p | getNodeEnclosingCallable(p) = callable)
  }

  override predicate matchesCall(DataFlowCall call) { any() }
}

class CallContextReturn extends CallContextNoCall, TReturn {
  override string toString() {
    exists(DataFlowCall call | this = TReturn(_, call) | result = "CcReturn(" + call + ")")
  }

  override predicate relevantFor(DataFlowCallable callable) {
    exists(DataFlowCall call | this = TReturn(_, call) and call.getEnclosingCallable() = callable)
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
  exists(Node n | getNodeEnclosingCallable(n) = callable and isUnreachableInCall(n, call))
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
 * A node from which flow can return to the caller. This is either a regular
 * `ReturnNode` or a `PostUpdateNode` corresponding to the value of a parameter.
 */
class ReturnNodeExt extends Node {
  ReturnNodeExt() {
    this instanceof ReturnNode or
    parameterValueFlowsToPreUpdate(_, this)
  }

  /** Gets the kind of this returned value. */
  ReturnKindExt getKind() {
    result = TValueReturn(this.(ReturnNode).getKind())
    or
    exists(ParameterNode p, int pos |
      parameterValueFlowsToPreUpdate(p, this) and
      p.isParameterOf(_, pos) and
      result = TParamUpdate(pos)
    )
  }
}

/**
 * A node to which data can flow from a call. Either an ordinary out node
 * or a post-update node associated with a call argument.
 */
class OutNodeExt extends Node {
  OutNodeExt() {
    this instanceof OutNode
    or
    this.(PostUpdateNode).getPreUpdateNode() instanceof ArgumentNode
  }
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
  abstract OutNodeExt getAnOutNode(DataFlowCall call);
}

class ValueReturnKind extends ReturnKindExt, TValueReturn {
  private ReturnKind kind;

  ValueReturnKind() { this = TValueReturn(kind) }

  ReturnKind getKind() { result = kind }

  override string toString() { result = kind.toString() }

  override OutNodeExt getAnOutNode(DataFlowCall call) {
    result = getAnOutNode(call, this.getKind())
  }
}

class ParamUpdateReturnKind extends ReturnKindExt, TParamUpdate {
  private int pos;

  ParamUpdateReturnKind() { this = TParamUpdate(pos) }

  int getPosition() { result = pos }

  override string toString() { result = "param update " + pos }

  override OutNodeExt getAnOutNode(DataFlowCall call) {
    exists(ArgumentNode arg |
      result.(PostUpdateNode).getPreUpdateNode() = arg and
      arg.argumentOf(call, this.getPosition())
    )
  }
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
  exists(Node n0 |
    pragma[only_bind_into](n0) = n and
    pragma[only_bind_into](result) = n0.getEnclosingCallable()
  )
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

bindingset[cc, callable]
predicate resolveReturn(CallContext cc, DataFlowCallable callable, DataFlowCall call) {
  cc instanceof CallContextAny and callable = viableCallableExt(call)
  or
  exists(DataFlowCallable c0, DataFlowCall call0 |
    call0.getEnclosingCallable() = callable and
    cc = TReturn(c0, call0) and
    c0 = prunedViableImplInCallContextReverse(call0, call)
  )
}

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

predicate read = readStep/3;

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

/** Content tagged with the type of a containing object. */
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
}

/**
 * The front of an access path. This is either a head or a nil.
 */
abstract class AccessPathFront extends TAccessPathFront {
  abstract string toString();

  abstract DataFlowType getType();

  abstract boolean toBoolNonEmpty();

  TypedContent getHead() { this = TFrontHead(result) }

  predicate isClearedAt(Node n) { clearsContent(n, getHead().getContent()) }
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
