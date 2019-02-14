import DataFlowUtil
private import DataFlowPrivate
private import DataFlowDispatch

cached
private module ImplCommon {
  /**
   * Holds if `p` is the `i`th parameter of a viable dispatch target of `call`.
   * The instance parameter is considered to have index `-1`.
   */
  pragma[nomagic]
  private predicate viableParam(Call call, int i, ParameterNode p) {
    exists(Callable callable |
      callable = viableCallable(call) and
      p.isParameterOf(callable, i)
    )
  }

  /**
   * Holds if `arg` is a possible argument to `p` taking virtual dispatch into account.
   */
  cached
  predicate viableParamArg(ParameterNode p, ArgumentNode arg) {
    exists(int i, Call call |
      viableParam(call, i, p) and
      arg.argumentOf(call, i)
    )
  }

  /**
   * Holds if `p` can flow to `node` in the same callable using only
   * value-preserving steps.
   */
  private predicate parameterValueFlow(ParameterNode p, Node node) {
    p = node
    or
    exists(Node mid |
      parameterValueFlow(p, mid) and
      localFlowStep(mid, node) and
      compatibleTypes(p.getType(), node.getType())
    )
    or
    // flow through a callable
    exists(Node arg |
      parameterValueFlow(p, arg) and
      argumentValueFlowsThrough(arg, node) and
      compatibleTypes(p.getType(), node.getType())
    )
  }

  /**
   * Holds if `p` can flow to a `ReturnNode` in the same callable using only
   * value-preserving steps.
   */
  cached
  predicate parameterValueFlowsThrough(ParameterNode p) {
    exists(ReturnNode ret | parameterValueFlow(p, ret))
  }

  /**
   * Holds if `arg` flows through `call` using only value-preserving steps.
   */
  cached
  predicate argumentValueFlowsThrough(ArgumentNode arg, ExprNode call) {
    exists(ParameterNode param |
      viableParamArg(param, arg) and
      parameterValueFlowsThrough(param) and
      arg.argumentOf(call.getExpr(), _) and
      compatibleTypes(arg.getType(), call.getType())
    )
  }

  /**
   * Holds if `p` can flow to the pre-update node of `n` in the same callable
   * using only value-preserving steps.
   */
  cached
  predicate parameterValueFlowsToUpdate(ParameterNode p, PostUpdateNode n) {
    parameterValueFlow(p, n.getPreUpdateNode())
  }

  /**
   * Holds if data can flow from `node1` to `node2` in one local step or a step
   * through a value-preserving method.
   */
  private predicate localValueStep(Node node1, Node node2) {
    localFlowStep(node1, node2) or
    argumentValueFlowsThrough(node1, node2)
  }

  /*
   * Calculation of `predicate store(Node node1, Content f, Node node2)`:
   * There are three cases:
   * - The base case: A direct local assignment given by `storeStep`.
   * - A call to a method or constructor with two arguments, `arg1` and `arg2`,
   *   such the call has the side-effect `arg2.f = arg1`.
   * - A call to a method that returns an object in which an argument has been
   *   stored.
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
    storeReturn(node1, f, node2)
  }

  private predicate storeViaSideEffect(Node node1, Content f, PostUpdateNode node2) {
    storeStep(node1, f, node2) and readStep(_, f, _)
    or
    exists(Call call, int i1, int i2 |
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
      parameterValueFlow(p1, n1) and
      storeViaSideEffect(n1, f, n2) and
      parameterValueFlow(p2, n2.getPreUpdateNode()) and
      p1 != p2
    )
  }

  pragma[nomagic]
  private predicate setterCall(Call call, int i1, int i2, Content f) {
    exists(Callable callable, ParameterNode p1, ParameterNode p2 |
      setterInParam(p1, f, p2) and
      callable = viableCallable(call) and
      p1.isParameterOf(callable, i1) and
      p2.isParameterOf(callable, i2)
    )
  }

  private predicate storeReturn(Node node1, Content f, Node node2) {
    exists(ParameterNode p, ArgumentNode arg |
      arg = node1 and
      viableParamArg(p, arg) and
      setterReturn(p, f) and
      arg.argumentOf(node2.asExpr(), _) and
      compatibleTypes(node1.getTypeBound(), f.getType()) and
      compatibleTypes(node2.getTypeBound(), f.getContainerType())
    )
  }

  private predicate setterReturn(ParameterNode p, Content f) {
    exists(Node n1, Node n2, ReturnNode ret |
      parameterValueFlow(p, n1) and
      store(n1, f, n2) and
      localValueStep*(n2, ret)
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
    exists(ParameterNode p, ArgumentNode arg |
      arg = node1 and
      viableParamArg(p, arg) and
      getter(p, f) and
      arg.argumentOf(node2.asExpr(), _) and
      compatibleTypes(node1.getTypeBound(), f.getContainerType()) and
      compatibleTypes(node2.getTypeBound(), f.getType())
    )
  }

  private predicate getter(ParameterNode p, Content f) {
    exists(Node n1, Node n2, ReturnNode ret |
      parameterValueFlow(p, n1) and
      read(n1, f, n2) and
      localValueStep*(n2, ret)
    )
  }

  cached
  predicate localStoreReadStep(Node node1, Node node2) {
    exists(Node mid1, Node mid2, Content f |
      store(node1, f, mid1) and
      localValueStep*(mid1, mid2) and
      read(mid2, f, node2)
    )
  }

  /**
   * Holds if `call` passes an implicit or explicit instance argument, i.e., an
   * expression that reaches a `this` parameter.
   */
  private predicate callHasInstanceArgument(Call call) {
    exists(ArgumentNode arg | arg.argumentOf(call, -1))
  }

  cached
  newtype TCallContext =
    TAnyCallContext() or
    TSpecificCall(Call call, int i, boolean emptyAp) {
      reducedViableImplInCallContext(_, _, call) and
      (emptyAp = true or emptyAp = false) and
      (
        exists(call.getArgument(i))
        or
        i = -1 and callHasInstanceArgument(call)
      )
    } or
    TSomeCall(ParameterNode p, boolean emptyAp) { emptyAp = true or emptyAp = false } or
    TReturn(Method m, MethodAccess ma) { reducedViableImplInReturn(m, ma) }
}
import ImplCommon

/**
 * A call context to restrict the targets of virtual dispatch and match the
 * call sites of flow into a method with flow out of a method.
 *
 * There are four cases:
 * - `TAnyCallContext()` : No restrictions on method flow.
 * - `TSpecificCall(Call call, int i)` : Flow entered through the `i`th
 *    parameter at the given `call`. This call improves the set of viable
 *    dispatch targets for at least one method call in the current callable.
 * - `TSomeCall(ParameterNode p)` : Flow entered through parameter `p`. The
 *    originating call does not improve the set of dispatch targets for any
 *    method call in the current callable and was therefore not recorded.
 * - `TReturn(Method m, MethodAccess ma)` : Flow reached `ma` from `m` and
 *    this dispatch target of `ma` implies a reduced set of dispatch origins
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
  override string toString() { result = "CcCall" }
}

class CallContextSomeCall extends CallContextCall, TSomeCall {
  override string toString() { result = "CcSomeCall" }
}

class CallContextReturn extends CallContext, TReturn {
  override string toString() { result = "CcReturn" }
}

bindingset[cc, callable]
predicate resolveReturn(CallContext cc, Callable callable, Call call) {
  cc instanceof CallContextAny and callable = viableCallable(call)
  or
  exists(Method m0, MethodAccess ma0 |
    ma0.getEnclosingCallable() = callable and
    cc = TReturn(m0, ma0) and
    m0 = prunedViableImplInCallContextReverse(ma0, call)
  )
}

bindingset[call, cc]
Callable resolveCall(Call call, CallContext cc) {
  exists(Call ctx | cc = TSpecificCall(ctx, _, _) |
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
