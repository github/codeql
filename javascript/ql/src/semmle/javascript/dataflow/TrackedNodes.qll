/**
 * DEPRECATED: Use `TypeTracking.qll` instead.
 *
 * The following `TrackedNode` usage is usually equivalent to the type tracking usage below.
 *
 * ```
 * class MyTrackedNode extends TrackedNode {
 *    MyTrackedNode() { isInteresting(this) }
 * }
 *
 * DataFlow::Node getMyTrackedNodeLocation(MyTrackedNode n) {
 *   n.flowsTo(result)
 * }
 * ```
 *
 * ```
 * DataFlow::SourceNode getMyTrackedNodeLocation(DataFlow::SourceNode start, DataFlow::TypeTracker t) {
 *   t.start() and
 *   isInteresting(result) and
 *   result = start
 *   or
 *   exists (DataFlow::TypeTracker t2 |
 *     result = getMyTrackedNodeLocation(start, t2).track(t2, t)
 *   )
 * }
 *
 * DataFlow::SourceNode getMyTrackedNodeLocation(DataFlow::SourceNode n) {
 *   result = getMyTrackedNodeLocation(n, DataFlow::TypeTracker::end())
 * }
 * ```
 *
 * In rare cases, additional tracking is required, for instance when tracking string constants, and the following type tracking formulation is required instead.
 *
 * ```
 * DataFlow::Node getMyTrackedNodeLocation(DataFlow::Node start, DataFlow::TypeTracker t) {
 *   t.start() and
 *   isInteresting(result) and
 *   result = start
 *   or
 *   exists(DataFlow::TypeTracker t2 |
 *     t = t2.smallstep(getMyTrackedNodeLocation(start, t2), result)
 *   )
 * }
 *
 * DataFlow::Node getMyTrackedNodeLocation(DataFlow::Node n) {
 *   result = getMyTrackedNodeLocation(n, DataFlow::TypeTracker::end())
 * }
 * ```
 *
 * Provides support for inter-procedural tracking of a customizable
 * set of data flow nodes.
 */

private import javascript
private import internal.FlowSteps as FlowSteps

/**
 * A data flow node that should be tracked inter-procedurally.
 *
 * To track additional values, extends this class with additional
 * subclasses.
 */
abstract deprecated class TrackedNode extends DataFlow::Node {
  /**
   * Holds if this node flows into `sink` in zero or more (possibly
   * inter-procedural) steps.
   */
  predicate flowsTo(DataFlow::Node sink) { NodeTracking::flowsTo(this, sink, _) }
}

/**
 * An expression whose value should be tracked inter-procedurally.
 *
 * To track additional expressions, extends this class with additional
 * subclasses.
 */
abstract deprecated class TrackedExpr extends Expr {
  predicate flowsTo(Expr sink) {
    exists(TrackedExprNode ten | ten.asExpr() = this | ten.flowsTo(DataFlow::valueNode(sink)))
  }
}

/**
 * Turn all `TrackedExpr`s into `TrackedNode`s.
 */
deprecated private class TrackedExprNode extends TrackedNode {
  TrackedExprNode() { asExpr() instanceof TrackedExpr }
}

/**
 * A simplified copy of `Configuration.qll` that implements tracking
 * of `TrackedNode`s without barriers or additional flow steps.
 */
private module NodeTracking {
  private import internal.FlowSteps

  /**
   * Holds if data can flow in one step from `pred` to `succ`,  taking
   * additional steps into account.
   */
  pragma[inline]
  predicate localFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    pred = succ.getAPredecessor()
    or
    any(DataFlow::AdditionalFlowStep afs).step(pred, succ)
    or
    localExceptionStep(pred, succ)
  }

  /**
   * Holds if there is a flow step from `pred` to `succ` described by `summary`.
   *
   * Summary steps through function calls are not taken into account.
   */
  deprecated private predicate basicFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, PathSummary summary
  ) {
    isRelevant(pred) and
    (
      // Local flow
      localFlowStep(pred, succ) and
      summary = PathSummary::level()
      or
      // Flow through properties of objects
      propertyFlowStep(pred, succ) and
      summary = PathSummary::level()
      or
      // Flow through global variables
      globalFlowStep(pred, succ) and
      summary = PathSummary::level()
      or
      // Flow into function
      callStep(pred, succ) and
      summary = PathSummary::call()
      or
      // Flow out of function
      returnStep(pred, succ) and
      summary = PathSummary::return()
    )
  }

  /**
   * Holds if `nd` may be reachable from a tracked node.
   *
   * No call/return matching is done, so this is a relatively coarse over-approximation.
   */
  deprecated private predicate isRelevant(DataFlow::Node nd) {
    nd instanceof TrackedNode
    or
    exists(DataFlow::Node mid | isRelevant(mid) |
      basicFlowStep(mid, nd, _)
      or
      basicStoreStep(mid, nd, _)
      or
      basicLoadStep(mid, nd, _)
      or
      callback(mid, nd)
      or
      nd = mid.(DataFlow::FunctionNode).getAParameter()
    )
  }

  /**
   * Holds if `pred` is an input to `f` which is passed to `succ` at `invk`; that is,
   * either `pred` is an argument of `f` and `succ` the corresponding parameter, or
   * `pred` is a variable definition whose value is captured by `f` at `succ`.
   */
  deprecated private predicate callInputStep(
    Function f, DataFlow::Node invk, DataFlow::Node pred, DataFlow::Node succ
  ) {
    isRelevant(pred) and
    (
      argumentPassing(invk, pred, f, succ)
      or
      exists(LocalVariable variable, SsaDefinition def |
        pred = DataFlow::capturedVariableNode(variable) and
        calls(invk, f) and
        captures(f, variable, def) and
        succ = DataFlow::ssaDefinitionNode(def)
      )
    )
  }

  /**
   * Holds if `input`, which is either an argument to `f` at `invk` or a definition
   * that is captured by `f`, may flow to `nd` (possibly through callees, but not containing
   * any unmatched calls or returns) along a path summarized by `summary`.
   */
  deprecated private predicate reachableFromInput(
    Function f, DataFlow::Node invk, DataFlow::Node input, DataFlow::Node nd, PathSummary summary
  ) {
    callInputStep(f, invk, input, nd) and
    summary = PathSummary::level()
    or
    exists(DataFlow::Node mid, PathSummary oldSummary, PathSummary newSummary |
      reachableFromInput(f, invk, input, mid, oldSummary) and
      flowStep(mid, nd, newSummary) and
      newSummary.isLevel() and
      summary = oldSummary.append(newSummary)
    )
  }

  /**
   * Holds if `nd` may flow into a return statement of `f`
   * (possibly through callees) along a path summarized by `summary`.
   */
  deprecated private predicate reachesReturn(Function f, DataFlow::Node nd, PathSummary summary) {
    returnExpr(f, nd, _) and
    summary = PathSummary::level()
    or
    exists(DataFlow::Node mid, PathSummary oldSummary, PathSummary newSummary |
      flowStep(nd, mid, oldSummary) and
      reachesReturn(f, mid, newSummary) and
      summary = oldSummary.append(newSummary)
    )
  }

  /**
   * Holds if a function invoked at `invk` may return an expression into which `input`,
   * which is either an argument or a definition captured by the function, flows,
   * possibly through callees.
   */
  deprecated private predicate flowThroughCall(DataFlow::Node input, DataFlow::Node output) {
    exists(Function f, DataFlow::ValueNode ret |
      ret.asExpr() = f.getAReturnedExpr() and
      reachableFromInput(f, output, input, ret, _)
    )
    or
    exists(Function f, DataFlow::Node invk, DataFlow::Node ret |
      DataFlow::exceptionalFunctionReturnNode(ret, f) and
      DataFlow::exceptionalInvocationReturnNode(output, invk.asExpr()) and
      calls(invk, f) and
      reachableFromInput(f, invk, input, ret, _)
    )
  }

  /**
   * Holds if `pred` may flow into property `prop` of `succ` along a path summarized by `summary`.
   */
  deprecated private predicate storeStep(
    DataFlow::Node pred, DataFlow::SourceNode succ, string prop, PathSummary summary
  ) {
    basicStoreStep(pred, succ, prop) and
    summary = PathSummary::level()
    or
    exists(Function f, DataFlow::Node mid | not f.isAsyncOrGenerator() |
      // `f` stores its parameter `pred` in property `prop` of a value that flows back to the caller,
      // and `succ` is an invocation of `f`
      reachableFromInput(f, succ, pred, mid, summary) and
      (
        returnedPropWrite(f, _, prop, mid)
        or
        succ instanceof DataFlow::NewNode and
        receiverPropWrite(f, prop, mid)
      )
    )
  }

  /**
   * Holds if property `prop` of `pred` may flow into `succ` along a path summarized by
   * `summary`.
   */
  deprecated private predicate loadStep(
    DataFlow::Node pred, DataFlow::Node succ, string prop, PathSummary summary
  ) {
    basicLoadStep(pred, succ, prop) and
    summary = PathSummary::level()
    or
    exists(Function f, DataFlow::SourceNode parm | not f.isAsyncOrGenerator() |
      argumentPassing(succ, pred, f, parm) and
      reachesReturn(f, parm.getAPropertyRead(prop), summary)
    )
  }

  /**
   * Holds if `rhs` is the right-hand side of a write to property `prop`, and `nd` is reachable
   * from the base of that write (possibly through callees) along a path summarized by `summary`.
   */
  deprecated private predicate reachableFromStoreBase(
    string prop, DataFlow::Node rhs, DataFlow::Node nd, PathSummary summary
  ) {
    storeStep(rhs, nd, prop, summary)
    or
    exists(DataFlow::Node mid, PathSummary oldSummary, PathSummary newSummary |
      reachableFromStoreBase(prop, rhs, mid, oldSummary) and
      flowStep(mid, nd, newSummary) and
      summary = oldSummary.append(newSummary)
    )
  }

  /**
   * Holds if the value of `pred` is written to a property of some base object, and that base
   * object may flow into the base of property read `succ` along a path summarized by `summary`.
   *
   * In other words, `pred` may flow to `succ` through a property.
   */
  deprecated private predicate flowThroughProperty(
    DataFlow::Node pred, DataFlow::Node succ, PathSummary summary
  ) {
    exists(string prop, DataFlow::Node base, PathSummary oldSummary, PathSummary newSummary |
      reachableFromStoreBase(prop, pred, base, oldSummary) and
      loadStep(base, succ, prop, newSummary) and
      summary = oldSummary.append(newSummary)
    )
  }

  /**
   * Holds if `arg` and `cb` are passed as arguments to a function which in turn
   * invokes `cb`, passing `arg` as its `i`th argument. `arg` flows along a path summarized
   * by `summary`, while `cb` is only tracked locally.
   */
  deprecated private predicate summarizedHigherOrderCall(
    DataFlow::Node arg, DataFlow::Node cb, int i, PathSummary summary
  ) {
    exists(
      Function f, DataFlow::InvokeNode outer, DataFlow::InvokeNode inner, int j,
      DataFlow::Node innerArg, DataFlow::SourceNode cbParm, PathSummary oldSummary
    |
      reachableFromInput(f, outer, arg, innerArg, oldSummary) and
      argumentPassing(outer, cb, f, cbParm) and
      innerArg = inner.getArgument(j)
    |
      // direct higher-order call
      cbParm.flowsTo(inner.getCalleeNode()) and
      i = j and
      summary = oldSummary
      or
      // indirect higher-order call
      exists(DataFlow::Node cbArg, PathSummary newSummary |
        cbParm.flowsTo(cbArg) and
        summarizedHigherOrderCall(innerArg, cbArg, i, newSummary) and
        summary = oldSummary.append(PathSummary::call()).append(newSummary)
      )
    )
  }

  /**
   * Holds if `arg` is passed as the `i`th argument to `callback` through a callback invocation.
   *
   * This can be a summarized call, that is, `arg` and `callback` flow into a call,
   * `f(arg, callback)`, which  performs the invocation.
   *
   * Alternatively, the callback can flow into a call `f(callback)` which itself provides the `arg`.
   * That is, `arg` refers to a value defined in `f` or one of its callees.
   */
  deprecated predicate higherOrderCall(
    DataFlow::Node arg, DataFlow::SourceNode callback, int i, PathSummary summary
  ) {
    // Summarized call
    exists(DataFlow::Node cb |
      summarizedHigherOrderCall(arg, cb, i, summary) and
      callback.flowsTo(cb)
    )
    or
    // Local invocation of a parameter
    isRelevant(arg) and
    exists(DataFlow::InvokeNode invoke |
      arg = invoke.getArgument(i) and
      invoke = callback.(DataFlow::ParameterNode).getACall() and
      summary = PathSummary::call()
    )
    or
    // Forwarding of the callback parameter  (but not the argument).
    // We use a return summary since flow moves back towards the call site.
    // This ensures that an argument that is only tainted in some contexts cannot flow
    // out to every callback.
    exists(DataFlow::Node cbArg, DataFlow::SourceNode innerCb, PathSummary oldSummary |
      higherOrderCall(arg, innerCb, i, oldSummary) and
      callStep(cbArg, innerCb) and
      callback.flowsTo(cbArg) and
      summary = PathSummary::return().append(oldSummary)
    )
  }

  /**
   * Holds if `pred` is passed as an argument to a function `f` which also takes a
   * callback parameter `cb` and then invokes `cb`, passing `pred` into parameter `succ`
   * of `cb`. `arg` flows along a path summarized by `summary`, while `cb` is only tracked
   * locally.
   */
  deprecated private predicate flowIntoHigherOrderCall(
    DataFlow::Node pred, DataFlow::Node succ, PathSummary summary
  ) {
    exists(DataFlow::FunctionNode cb, int i, PathSummary oldSummary |
      higherOrderCall(pred, cb, i, oldSummary) and
      succ = cb.getParameter(i) and
      summary = oldSummary.append(PathSummary::call())
    )
  }

  /**
   * Holds if there is a flow step from `pred` to `succ` described by `summary`.
   */
  deprecated private predicate flowStep(
    DataFlow::Node pred, DataFlow::Node succ, PathSummary summary
  ) {
    basicFlowStep(pred, succ, summary)
    or
    // Flow through a function that returns a value that depends on one of its arguments
    // or a captured variable
    flowThroughCall(pred, succ) and
    summary = PathSummary::level()
    or
    // Flow through a property write/read pair
    flowThroughProperty(pred, succ, summary)
    or
    // Flow into higher-order call
    flowIntoHigherOrderCall(pred, succ, summary)
  }

  /**
   * Holds if there is a path from `source` to `nd` along a path summarized by
   * `summary`.
   */
  deprecated predicate flowsTo(TrackedNode source, DataFlow::Node nd, PathSummary summary) {
    source = nd and
    summary = PathSummary::level()
    or
    exists(DataFlow::Node pred, PathSummary oldSummary, PathSummary newSummary |
      flowsTo(source, pred, oldSummary) and
      flowStep(pred, nd, newSummary) and
      summary = oldSummary.append(newSummary)
    )
  }
}
