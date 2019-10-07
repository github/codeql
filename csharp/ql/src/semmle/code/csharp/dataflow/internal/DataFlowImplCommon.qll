private import DataFlowImplSpecific::Private
import DataFlowImplSpecific::Public

private ReturnNode getAReturnNodeOfKind(ReturnKind kind) { result.getKind() = kind }

module Public {
  import ImplCommon
  import FlowThrough_v2
}

private module ImplCommon {
  import Cached

  cached
  private module Cached {
    /**
     * Holds if `p` is the `i`th parameter of a viable dispatch target of `call`.
     * The instance parameter is considered to have index `-1`.
     */
    pragma[nomagic]
    private predicate viableParam(DataFlowCall call, int i, ParameterNode p) {
      p.isParameterOf(viableCallable(call), i)
    }

    /**
     * Holds if `arg` is a possible argument to `p` in `call`, taking virtual
     * dispatch into account.
     */
    cached
    predicate viableParamArg(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
      exists(int i |
        viableParam(call, i, p) and
        arg.argumentOf(call, i)
      )
    }

    /*
     * The `FlowThrough_*` modules take a `step` relation as input and provide
     * an `argumentValueFlowsThrough` relation as output.
     *
     * `FlowThrough_v1` includes just `simpleLocalFlowStep`, which is then used
     * to detect getters and setters.
     * `FlowThrough_v2` then includes a little bit of local field flow on top
     * of `simpleLocalFlowStep`.
     */

    private module FlowThrough_v1 {
      private predicate step = simpleLocalFlowStep/2;

      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps, not taking call contexts into account.
       */
      private predicate parameterValueFlowCand(ParameterNode p, Node node) {
        p = node
        or
        exists(Node mid |
          parameterValueFlowCand(p, mid) and
          step(mid, node) and
          compatibleTypes(p.getType(), node.getType())
        )
        or
        // flow through a callable
        exists(Node arg |
          parameterValueFlowCand(p, arg) and
          argumentValueFlowsThroughCand(arg, node) and
          compatibleTypes(p.getType(), node.getType())
        )
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps, not taking call contexts
       * into account.
       */
      private predicate parameterValueFlowsThroughCand(ParameterNode p, ReturnKind kind) {
        parameterValueFlowCand(p, getAReturnNodeOfKind(kind))
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThroughCand0(
        DataFlowCall call, ArgumentNode arg, ReturnKind kind
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
          parameterValueFlowsThroughCand(param, kind)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * not taking call contexts into account.
       */
      private predicate argumentValueFlowsThroughCand(ArgumentNode arg, OutNode out) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThroughCand0(call, arg, kind)
        |
          out = getAnOutNode(call, kind) and
          compatibleTypes(arg.getType(), out.getType())
        )
      }

      /**
       * Holds if `arg` is the `i`th argument of `call` inside the callable
       * `enclosing`, and `arg` may flow through `call`.
       */
      pragma[noinline]
      private predicate argumentOf(
        DataFlowCall call, int i, ArgumentNode arg, DataFlowCallable enclosing
      ) {
        arg.argumentOf(call, i) and
        argumentValueFlowsThroughCand(arg, _) and
        enclosing = arg.getEnclosingCallable()
      }

      pragma[noinline]
      private ParameterNode getAParameter(DataFlowCallable c) { result.getEnclosingCallable() = c }

      pragma[noinline]
      private predicate viableParamArg0(
        int i, ArgumentNode arg, CallContext outercc, DataFlowCall call
      ) {
        exists(DataFlowCallable c | argumentOf(call, i, arg, c) |
          (
            outercc = TAnyCallContext()
            or
            outercc = TSomeCall(getAParameter(c), _)
            or
            exists(DataFlowCall other | outercc = TSpecificCall(other, _, _) |
              recordDataFlowCallSite(other, c)
            )
          ) and
          not isUnreachableInCall(arg, outercc.(CallContextSpecificCall).getCall())
        )
      }

      pragma[noinline]
      private predicate viableParamArg1(
        ParameterNode p, DataFlowCallable callable, int i, ArgumentNode arg, CallContext outercc,
        DataFlowCall call
      ) {
        viableParamArg0(i, arg, outercc, call) and
        callable = resolveCall(call, outercc) and
        p.isParameterOf(callable, any(int j | j <= i and j >= i))
      }

      /**
       * Holds if `arg` is a possible argument to `p`, in the call `call`, and
       * `arg` may flow through `call`. The possible contexts before and after
       * entering the callable are `outercc` and `innercc`, respectively.
       */
      private predicate viableParamArg(
        DataFlowCall call, ParameterNode p, ArgumentNode arg, CallContext outercc,
        CallContextCall innercc
      ) {
        exists(int i, DataFlowCallable callable |
          viableParamArg1(p, callable, i, arg, outercc, call)
        |
          if recordDataFlowCallSite(call, callable)
          then innercc = TSpecificCall(call, i, true)
          else innercc = TSomeCall(p, true)
        )
      }

      private CallContextCall getAValidCallContextForParameter(ParameterNode p) {
        result = TSomeCall(p, _)
        or
        exists(DataFlowCall call, int i, DataFlowCallable callable |
          result = TSpecificCall(call, i, _) and
          p.isParameterOf(callable, i) and
          recordDataFlowCallSite(call, callable)
        )
      }

      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps, in call context `cc`.
       */
      private predicate parameterValueFlow(ParameterNode p, Node node, CallContextCall cc) {
        p = node and
        parameterValueFlowsThroughCand(p, _) and
        cc = getAValidCallContextForParameter(p)
        or
        exists(Node mid |
          parameterValueFlow(p, mid, cc) and
          step(mid, node) and
          compatibleTypes(p.getType(), node.getType()) and
          not isUnreachableInCall(node, cc.(CallContextSpecificCall).getCall())
        )
        or
        // flow through a callable
        exists(Node arg |
          parameterValueFlow(p, arg, cc) and
          argumentValueFlowsThrough(arg, node, cc) and
          compatibleTypes(p.getType(), node.getType()) and
          not isUnreachableInCall(node, cc.(CallContextSpecificCall).getCall())
        )
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps, in call context `cc`.
       */
      private predicate parameterValueFlowsThrough(
        ParameterNode p, ReturnKind kind, CallContextCall cc
      ) {
        parameterValueFlow(p, getAReturnNodeOfKind(kind), cc)
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThrough0(
        DataFlowCall call, ArgumentNode arg, ReturnKind kind, CallContext cc
      ) {
        exists(ParameterNode param, CallContext innercc |
          viableParamArg(call, param, arg, cc, innercc) and
          parameterValueFlowsThrough(param, kind, innercc)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * in call context cc.
       */
      predicate argumentValueFlowsThrough(ArgumentNode arg, OutNode out, CallContext cc) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThrough0(call, arg, kind, cc)
        |
          out = getAnOutNode(call, kind) and
          not isUnreachableInCall(out, cc.(CallContextSpecificCall).getCall()) and
          compatibleTypes(arg.getType(), out.getType())
        )
      }
    }

    /**
     * Holds if `p` can flow to the pre-update node of `n` in the same callable
     * using only value-preserving steps.
     */
    cached
    predicate parameterValueFlowsToUpdate(ParameterNode p, PostUpdateNode n) {
      parameterValueFlowNoCtx(p, n.getPreUpdateNode())
    }

    /**
     * Holds if data can flow from `node1` to `node2` in one local step or a step
     * through a value-preserving method.
     */
    private predicate localValueStep(Node node1, Node node2) {
      simpleLocalFlowStep(node1, node2) or
      FlowThrough_v1::argumentValueFlowsThrough(node1, node2, _)
    }

    /**
     * Holds if `p` can flow to `node` in the same callable allowing local flow
     * steps and value flow through methods. Call contexts are only accounted
     * for in the nested calls.
     */
    private predicate parameterValueFlowNoCtx(ParameterNode p, Node node) {
      p = node
      or
      exists(Node mid |
        parameterValueFlowNoCtx(p, mid) and
        localValueStep(mid, node) and
        compatibleTypes(p.getType(), node.getType())
      )
    }

    /*
     * Calculation of `predicate store(Node node1, Content f, Node node2)`:
     * There are four cases:
     * - The base case: A direct local assignment given by `storeStep`.
     * - A call to a method or constructor with two arguments, `arg1` and `arg2`,
     *   such that the call has the side-effect `arg2.f = arg1`.
     * - A call to a method that returns an object in which an argument has been
     *   stored.
     * - A reverse step through a read when the result of the read has been
     *   stored into. This handles cases like `x.f1.f2 = y`.
     * `storeViaSideEffect` covers the first two cases, and `storeReturn` covers
     * the third case.
     */

    /**
     * Holds if data can flow from `node1` to `node2` via a direct assignment to
     * `f` or via a call that acts as a setter.
     */
    cached
    predicate store(Node node1, Content f, Node node2) {
      storeViaSideEffect(node1, f, node2) or
      storeReturn(node1, f, node2) or
      read(node2.(PostUpdateNode).getPreUpdateNode(), f, node1.(PostUpdateNode).getPreUpdateNode())
    }

    private predicate storeViaSideEffect(Node node1, Content f, PostUpdateNode node2) {
      storeStep(node1, f, node2) and readStep(_, f, _)
      or
      exists(DataFlowCall call, int i1, int i2 |
        setterCall(call, i1, i2, f) and
        node1.(ArgumentNode).argumentOf(call, i1) and
        node2.getPreUpdateNode().(ArgumentNode).argumentOf(call, i2) and
        compatibleTypes(node1.getTypeBound(), f.getType()) and
        compatibleTypes(node2.getTypeBound(), f.getContainerType())
      )
    }

    pragma[nomagic]
    private predicate setterInParam(ParameterNode p1, Content f, ParameterNode p2) {
      exists(Node n1, PostUpdateNode n2 |
        parameterValueFlowNoCtx(p1, n1) and
        storeViaSideEffect(n1, f, n2) and
        parameterValueFlowNoCtx(p2, n2.getPreUpdateNode()) and
        p1 != p2
      )
    }

    pragma[nomagic]
    private predicate setterCall(DataFlowCall call, int i1, int i2, Content f) {
      exists(DataFlowCallable callable, ParameterNode p1, ParameterNode p2 |
        setterInParam(p1, f, p2) and
        callable = viableCallable(call) and
        p1.isParameterOf(callable, i1) and
        p2.isParameterOf(callable, i2)
      )
    }

    pragma[noinline]
    private predicate storeReturn0(DataFlowCall call, ReturnKind kind, ArgumentNode arg, Content f) {
      exists(ParameterNode p |
        viableParamArg(call, p, arg) and
        setterReturn(p, f, kind)
      )
    }

    private predicate storeReturn(Node node1, Content f, Node node2) {
      exists(DataFlowCall call, ReturnKind kind |
        storeReturn0(call, kind, node1, f) and
        node2 = getAnOutNode(call, kind) and
        compatibleTypes(node1.getTypeBound(), f.getType()) and
        compatibleTypes(node2.getTypeBound(), f.getContainerType())
      )
    }

    private predicate setterReturn(ParameterNode p, Content f, ReturnKind kind) {
      exists(Node n1, Node n2 |
        parameterValueFlowNoCtx(p, n1) and
        store(n1, f, n2) and
        localValueStep*(n2, getAReturnNodeOfKind(kind))
      )
    }

    pragma[noinline]
    private predicate read0(DataFlowCall call, ReturnKind kind, ArgumentNode arg, Content f) {
      exists(ParameterNode p |
        viableParamArg(call, p, arg) and
        getter(p, f, kind)
      )
    }

    /**
     * Holds if data can flow from `node1` to `node2` via a direct read of `f` or
     * via a getter.
     */
    cached
    predicate read(Node node1, Content f, Node node2) {
      readStep(node1, f, node2) and storeStep(_, f, _)
      or
      exists(DataFlowCall call, ReturnKind kind |
        read0(call, kind, node1, f) and
        node2 = getAnOutNode(call, kind) and
        compatibleTypes(node1.getTypeBound(), f.getContainerType()) and
        compatibleTypes(node2.getTypeBound(), f.getType())
      )
    }

    private predicate getter(ParameterNode p, Content f, ReturnKind kind) {
      exists(Node n1, Node n2 |
        parameterValueFlowNoCtx(p, n1) and
        read(n1, f, n2) and
        localValueStep*(n2, getAReturnNodeOfKind(kind))
      )
    }

    cached
    predicate localStoreReadStep(Node node1, Node node2) {
      exists(Node mid1, Node mid2, Content f |
        store(node1, f, mid1) and
        localValueStep*(mid1, mid2) and
        read(mid2, f, node2) and
        compatibleTypes(node1.getTypeBound(), node2.getTypeBound())
      )
    }

    cached
    module FlowThrough_v2 {
      private predicate step(Node node1, Node node2) {
        simpleLocalFlowStep(node1, node2) or
        localStoreReadStep(node1, node2)
      }

      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps, not taking call contexts into account.
       */
      private predicate parameterValueFlowCand(ParameterNode p, Node node) {
        p = node
        or
        exists(Node mid |
          parameterValueFlowCand(p, mid) and
          step(mid, node) and
          compatibleTypes(p.getType(), node.getType())
        )
        or
        // flow through a callable
        exists(Node arg |
          parameterValueFlowCand(p, arg) and
          argumentValueFlowsThroughCand(arg, node) and
          compatibleTypes(p.getType(), node.getType())
        )
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps, not taking call contexts
       * into account.
       */
      private predicate parameterValueFlowsThroughCand(ParameterNode p, ReturnKind kind) {
        parameterValueFlowCand(p, getAReturnNodeOfKind(kind))
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThroughCand0(
        DataFlowCall call, ArgumentNode arg, ReturnKind kind
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
          parameterValueFlowsThroughCand(param, kind)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * not taking call contexts into account.
       */
      private predicate argumentValueFlowsThroughCand(ArgumentNode arg, OutNode out) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThroughCand0(call, arg, kind)
        |
          out = getAnOutNode(call, kind) and
          compatibleTypes(arg.getType(), out.getType())
        )
      }

      /**
       * Holds if `arg` is the `i`th argument of `call` inside the callable
       * `enclosing`, and `arg` may flow through `call`.
       */
      pragma[noinline]
      private predicate argumentOf(
        DataFlowCall call, int i, ArgumentNode arg, DataFlowCallable enclosing
      ) {
        arg.argumentOf(call, i) and
        argumentValueFlowsThroughCand(arg, _) and
        enclosing = arg.getEnclosingCallable()
      }

      pragma[noinline]
      private ParameterNode getAParameter(DataFlowCallable c) { result.getEnclosingCallable() = c }

      pragma[noinline]
      private predicate viableParamArg0(
        int i, ArgumentNode arg, CallContext outercc, DataFlowCall call
      ) {
        exists(DataFlowCallable c | argumentOf(call, i, arg, c) |
          (
            outercc = TAnyCallContext()
            or
            outercc = TSomeCall(getAParameter(c), _)
            or
            exists(DataFlowCall other | outercc = TSpecificCall(other, _, _) |
              recordDataFlowCallSite(other, c)
            )
          ) and
          not isUnreachableInCall(arg, outercc.(CallContextSpecificCall).getCall())
        )
      }

      pragma[noinline]
      private predicate viableParamArg1(
        ParameterNode p, DataFlowCallable callable, int i, ArgumentNode arg, CallContext outercc,
        DataFlowCall call
      ) {
        viableParamArg0(i, arg, outercc, call) and
        callable = resolveCall(call, outercc) and
        p.isParameterOf(callable, any(int j | j <= i and j >= i))
      }

      /**
       * Holds if `arg` is a possible argument to `p`, in the call `call`, and
       * `arg` may flow through `call`. The possible contexts before and after
       * entering the callable are `outercc` and `innercc`, respectively.
       */
      private predicate viableParamArg(
        DataFlowCall call, ParameterNode p, ArgumentNode arg, CallContext outercc,
        CallContextCall innercc
      ) {
        exists(int i, DataFlowCallable callable |
          viableParamArg1(p, callable, i, arg, outercc, call)
        |
          if recordDataFlowCallSite(call, callable)
          then innercc = TSpecificCall(call, i, true)
          else innercc = TSomeCall(p, true)
        )
      }

      private CallContextCall getAValidCallContextForParameter(ParameterNode p) {
        result = TSomeCall(p, _)
        or
        exists(DataFlowCall call, int i, DataFlowCallable callable |
          result = TSpecificCall(call, i, _) and
          p.isParameterOf(callable, i) and
          recordDataFlowCallSite(call, callable)
        )
      }

      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps, in call context `cc`.
       */
      private predicate parameterValueFlow(ParameterNode p, Node node, CallContextCall cc) {
        p = node and
        parameterValueFlowsThroughCand(p, _) and
        cc = getAValidCallContextForParameter(p)
        or
        exists(Node mid |
          parameterValueFlow(p, mid, cc) and
          step(mid, node) and
          compatibleTypes(p.getType(), node.getType()) and
          not isUnreachableInCall(node, cc.(CallContextSpecificCall).getCall())
        )
        or
        // flow through a callable
        exists(Node arg |
          parameterValueFlow(p, arg, cc) and
          argumentValueFlowsThrough(arg, node, cc) and
          compatibleTypes(p.getType(), node.getType()) and
          not isUnreachableInCall(node, cc.(CallContextSpecificCall).getCall())
        )
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps, in call context `cc`.
       */
      cached
      predicate parameterValueFlowsThrough(ParameterNode p, ReturnKind kind, CallContextCall cc) {
        parameterValueFlow(p, getAReturnNodeOfKind(kind), cc)
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThrough0(
        DataFlowCall call, ArgumentNode arg, ReturnKind kind, CallContext cc
      ) {
        exists(ParameterNode param, CallContext innercc |
          viableParamArg(call, param, arg, cc, innercc) and
          parameterValueFlowsThrough(param, kind, innercc)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * in call context cc.
       */
      cached
      predicate argumentValueFlowsThrough(ArgumentNode arg, OutNode out, CallContext cc) {
        exists(DataFlowCall call, ReturnKind kind |
          argumentValueFlowsThrough0(call, arg, kind, cc)
        |
          out = getAnOutNode(call, kind) and
          not isUnreachableInCall(out, cc.(CallContextSpecificCall).getCall()) and
          compatibleTypes(arg.getType(), out.getType())
        )
      }
    }

    /**
     * Holds if `call` passes an implicit or explicit instance argument, i.e., an
     * expression that reaches a `this` parameter.
     */
    private predicate callHasInstanceArgument(DataFlowCall call) {
      exists(ArgumentNode arg | arg.argumentOf(call, -1))
    }

    /**
     * Holds if the call context `call` either improves virtual dispatch in
     * `callable` or if it allows us to prune unreachable nodes in `callable`.
     */
    cached
    predicate recordDataFlowCallSite(DataFlowCall call, DataFlowCallable callable) {
      reducedViableImplInCallContext(_, callable, call)
      or
      exists(Node n | n.getEnclosingCallable() = callable | isUnreachableInCall(n, call))
    }

    cached
    newtype TCallContext =
      TAnyCallContext() or
      TSpecificCall(DataFlowCall call, int i, boolean emptyAp) {
        recordDataFlowCallSite(call, _) and
        (emptyAp = true or emptyAp = false) and
        (
          exists(call.getArgument(i))
          or
          i = -1 and callHasInstanceArgument(call)
        )
      } or
      TSomeCall(ParameterNode p, boolean emptyAp) { emptyAp = true or emptyAp = false } or
      TReturn(DataFlowCallable c, DataFlowCall call) { reducedViableImplInReturn(c, call) }

    cached
    newtype TReturnPosition =
      TReturnPosition0(DataFlowCallable c, ReturnKind kind) { returnPosition(_, c, kind) }

    cached
    newtype TLocalFlowCallContext =
      TAnyLocalCall() or
      TSpecificLocalCall(DataFlowCall call) { isUnreachableInCall(_, call) }
  }

  pragma[noinline]
  private predicate returnPosition(ReturnNode ret, DataFlowCallable c, ReturnKind kind) {
    c = returnNodeGetEnclosingCallable(ret) and
    kind = ret.getKind()
  }

  /**
   * A call context to restrict the targets of virtual dispatch, prune local flow,
   * and match the call sites of flow into a method with flow out of a method.
   *
   * There are four cases:
   * - `TAnyCallContext()` : No restrictions on method flow.
   * - `TSpecificCall(DataFlowCall call, int i)` : Flow entered through the `i`th
   *    parameter at the given `call`. This call improves the set of viable
   *    dispatch targets for at least one method call in the current callable
   *    or helps prune unreachable nodes in the current callable.
   * - `TSomeCall(ParameterNode p)` : Flow entered through parameter `p`. The
   *    originating call does not improve the set of dispatch targets for any
   *    method call in the current callable and was therefore not recorded.
   * - `TReturn(Callable c, DataFlowCall call)` : Flow reached `call` from `c` and
   *    this dispatch target of `call` implies a reduced set of dispatch origins
   *    to which data may flow if it should reach a `return` statement.
   */
  abstract class CallContext extends TCallContext {
    abstract string toString();
  }

  class CallContextAny extends CallContext, TAnyCallContext {
    override string toString() { result = "CcAny" }
  }

  abstract class CallContextCall extends CallContext { }

  class CallContextSpecificCall extends CallContextCall, TSpecificCall {
    override string toString() {
      exists(DataFlowCall call, int i | this = TSpecificCall(call, i, _) |
        result = "CcCall(" + call + ", " + i + ")"
      )
    }

    DataFlowCall getCall() { this = TSpecificCall(result, _, _) }
  }

  class CallContextSomeCall extends CallContextCall, TSomeCall {
    override string toString() { result = "CcSomeCall" }
  }

  class CallContextReturn extends CallContext, TReturn {
    override string toString() {
      exists(DataFlowCall call | this = TReturn(_, call) | result = "CcReturn(" + call + ")")
    }
  }

  /**
   * A call context that is relevant for pruning local flow.
   */
  abstract class LocalCallContext extends TLocalFlowCallContext {
    abstract string toString();

    abstract predicate validFor(Node n);
  }

  /**
   * Gets a matching local call context given the call context and a node which is in
   * the callable the call is targeting.
   */
  LocalCallContext getMatchingLocalCallContext(CallContext ctx, Node n) {
    if hasUnreachableNode(ctx.(CallContextSpecificCall).getCall(), n.getEnclosingCallable())
    then result.(LocalCallContextSpecificCall).getCall() = ctx.(CallContextSpecificCall).getCall()
    else result instanceof LocalCallContextAny
  }

  class LocalCallContextAny extends LocalCallContext, TAnyLocalCall {
    override string toString() { result = "LocalCcAny" }

    override predicate validFor(Node n) { any() }
  }

  pragma[noinline]
  private predicate hasUnreachableNode(DataFlowCall call, DataFlowCallable callable) {
    isUnreachableInCall(any(Node n | n.getEnclosingCallable() = callable), call)
  }

  class LocalCallContextSpecificCall extends LocalCallContext, TSpecificLocalCall {
    LocalCallContextSpecificCall() { this = TSpecificLocalCall(call) }

    DataFlowCall call;

    DataFlowCall getCall() { result = call }

    override string toString() { result = "LocalCcCall(" + call + ")" }

    override predicate validFor(Node n) { hasUnreachableNode(call, n.getEnclosingCallable()) }
  }

  /** A callable tagged with a relevant return kind. */
  class ReturnPosition extends TReturnPosition0 {
    private DataFlowCallable c;
    private ReturnKind kind;

    ReturnPosition() { this = TReturnPosition0(c, kind) }

    /** Gets the callable. */
    DataFlowCallable getCallable() { result = c }

    /** Gets the return kind. */
    ReturnKind getKind() { result = kind }

    /** Gets a textual representation of this return position. */
    string toString() { result = "[" + kind + "] " + c }
  }

  pragma[noinline]
  DataFlowCallable returnNodeGetEnclosingCallable(ReturnNode ret) {
    result = ret.getEnclosingCallable()
  }

  pragma[noinline]
  ReturnPosition getReturnPosition(ReturnNode ret) {
    exists(DataFlowCallable c, ReturnKind k | returnPosition(ret, c, k) |
      result = TReturnPosition0(c, k)
    )
  }

  bindingset[cc, callable]
  predicate resolveReturn(CallContext cc, DataFlowCallable callable, DataFlowCall call) {
    cc instanceof CallContextAny and callable = viableCallable(call)
    or
    exists(DataFlowCallable c0, DataFlowCall call0 |
      call0.getEnclosingCallable() = callable and
      cc = TReturn(c0, call0) and
      c0 = prunedViableImplInCallContextReverse(call0, call)
    )
  }

  bindingset[call, cc]
  DataFlowCallable resolveCall(DataFlowCall call, CallContext cc) {
    exists(DataFlowCall ctx | cc = TSpecificCall(ctx, _, _) |
      if reducedViableImplInCallContext(call, _, ctx)
      then result = prunedViableImplInCallContext(call, ctx)
      else result = viableCallable(call)
    )
    or
    result = viableCallable(call) and cc instanceof CallContextSomeCall
    or
    result = viableCallable(call) and cc instanceof CallContextAny
    or
    result = viableCallable(call) and cc instanceof CallContextReturn
  }
}
