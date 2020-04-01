private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
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
      arg.argumentOf(call, i) and
      compatibleTypes(getErasedNodeTypeBound(arg), getErasedNodeTypeBound(p))
    )
  }

  /** Provides predicates for calculating flow-through summaries. */
  cached
  private module FlowThrough {
    /**
     * The first flow-through approximation:
     *
     * - Input/output access paths are abstracted with a Boolean parameter
     *   that indicates (non-)emptiness.
     */
    private module Cand {
      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps.
       *
       * `read` indicates whether it is contents of `p` that can flow to `node`,
       * and `stored` indicates whether it flows to contents of `node`.
       */
      pragma[nomagic]
      private predicate parameterValueFlowCand(
        ParameterNode p, Node node, boolean read, boolean stored
      ) {
        p = node and
        read = false and
        stored = false
        or
        // local flow
        exists(Node mid |
          parameterValueFlowCand(p, mid, read, stored) and
          simpleLocalFlowStep(mid, node)
        )
        or
        // read
        exists(Node mid, boolean readMid, boolean storedMid |
          parameterValueFlowCand(p, mid, readMid, storedMid) and
          readStep(mid, _, node) and
          stored = false
        |
          // value neither read nor stored prior to read
          readMid = false and
          storedMid = false and
          read = true
          or
          // value (possibly read and then) stored prior to read (same content)
          read = readMid and
          storedMid = true
        )
        or
        // store
        exists(Node mid |
          parameterValueFlowCand(p, mid, read, false) and
          storeStep(mid, _, node) and
          stored = true
        )
        or
        // flow through: no prior read or store
        exists(ArgumentNode arg |
          parameterValueFlowArgCand(p, arg, false, false) and
          argumentValueFlowsThroughCand(arg, node, read, stored)
        )
        or
        // flow through: no read or store inside method
        exists(ArgumentNode arg |
          parameterValueFlowArgCand(p, arg, read, stored) and
          argumentValueFlowsThroughCand(arg, node, false, false)
        )
        or
        // flow through: possible prior read and prior store with compatible
        // flow-through method
        exists(ArgumentNode arg, boolean mid |
          parameterValueFlowArgCand(p, arg, read, mid) and
          argumentValueFlowsThroughCand(arg, node, mid, stored)
        )
      }

      pragma[nomagic]
      private predicate parameterValueFlowArgCand(
        ParameterNode p, ArgumentNode arg, boolean read, boolean stored
      ) {
        parameterValueFlowCand(p, arg, read, stored)
      }

      pragma[nomagic]
      predicate parameterValueFlowsToPreUpdateCand(ParameterNode p, PostUpdateNode n) {
        parameterValueFlowCand(p, n.getPreUpdateNode(), false, false)
      }

      pragma[nomagic]
      private predicate parameterValueFlowsToPostUpdateCand(
        ParameterNode p, PostUpdateNode n, boolean read
      ) {
        parameterValueFlowCand(p, n, read, true)
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps, not taking call contexts
       * into account.
       *
       * `read` indicates whether it is contents of `p` that can flow to the return
       * node, and `stored` indicates whether it flows to contents of the return
       * node.
       */
      predicate parameterValueFlowReturnCand(
        ParameterNode p, ReturnKindExt kind, boolean read, boolean stored
      ) {
        exists(ReturnNode ret |
          parameterValueFlowCand(p, ret, read, stored) and
          kind = TValueReturn(ret.getKind())
        )
        or
        exists(ParameterNode p2, int pos2, PostUpdateNode n |
          parameterValueFlowsToPostUpdateCand(p, n, read) and
          parameterValueFlowsToPreUpdateCand(p2, n) and
          p2.isParameterOf(_, pos2) and
          kind = TParamUpdate(pos2) and
          p != p2 and
          stored = true
        )
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThroughCand0(
        DataFlowCall call, ArgumentNode arg, ReturnKindExt kind, boolean read, boolean stored
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
          parameterValueFlowReturnCand(param, kind, read, stored)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * not taking call contexts into account.
       *
       * `read` indicates whether it is contents of `arg` that can flow to `out`, and
       * `stored` indicates whether it flows to contents of `out`.
       */
      predicate argumentValueFlowsThroughCand(
        ArgumentNode arg, Node out, boolean read, boolean stored
      ) {
        exists(DataFlowCall call, ReturnKindExt kind |
          argumentValueFlowsThroughCand0(call, arg, kind, read, stored) and
          out = kind.getAnOutNode(call)
        )
      }

      predicate cand(ParameterNode p, Node n) {
        parameterValueFlowCand(p, n, _, _) and
        (
          parameterValueFlowReturnCand(p, _, _, _)
          or
          parameterValueFlowsToPreUpdateCand(p, _)
        )
      }
    }

    private module LocalFlowBigStep {
      private predicate localFlowEntry(Node n) {
        Cand::cand(_, n) and
        (
          n instanceof ParameterNode or
          n instanceof OutNode or
          n instanceof PostUpdateNode or
          readStep(_, _, n) or
          n instanceof CastNode
        )
      }

      private predicate localFlowExit(Node n) {
        Cand::cand(_, n) and
        (
          n instanceof ArgumentNode
          or
          n instanceof ReturnNode
          or
          Cand::parameterValueFlowsToPreUpdateCand(_, n)
          or
          storeStep(n, _, _)
          or
          readStep(n, _, _)
          or
          n instanceof CastNode
          or
          n =
            any(PostUpdateNode pun | Cand::parameterValueFlowsToPreUpdateCand(_, pun))
                .getPreUpdateNode()
        )
      }

      pragma[nomagic]
      private predicate localFlowStepPlus(Node node1, Node node2) {
        localFlowEntry(node1) and
        simpleLocalFlowStep(node1, node2) and
        node1 != node2
        or
        exists(Node mid |
          localFlowStepPlus(node1, mid) and
          simpleLocalFlowStep(mid, node2) and
          not mid instanceof CastNode
        )
      }

      pragma[nomagic]
      predicate localFlowBigStep(Node node1, Node node2) {
        localFlowStepPlus(node1, node2) and
        localFlowExit(node2)
      }
    }

    /**
     * The final flow-through calculation:
     *
     * - Input/output access paths are abstracted with a `ContentOption` parameter
     *   that represents the head of the access path. `TContentNone()` means that
     *   the access path is unrestricted.
     * - Types are checked using the `compatibleTypes()` relation.
     */
    cached
    private module Final {
      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps, not taking call contexts into account.
       *
       * `contentIn` describes the content of `p` that can flow to `node`
       * (if any), and `contentOut` describes the content of `node` that
       * it flows to (if any).
       */
      private predicate parameterValueFlow(
        ParameterNode p, Node node, ContentOption contentIn, ContentOption contentOut
      ) {
        parameterValueFlow0(p, node, contentIn, contentOut) and
        if node instanceof CastingNode
        then
          // normal flow through
          contentIn = TContentNone() and
          contentOut = TContentNone() and
          compatibleTypes(getErasedNodeTypeBound(p), getErasedNodeTypeBound(node))
          or
          // getter
          exists(Content fIn |
            contentIn.getContent() = fIn and
            contentOut = TContentNone() and
            compatibleTypes(fIn.getType(), getErasedNodeTypeBound(node))
          )
          or
          // (getter+)setter
          exists(Content fOut |
            contentOut.getContent() = fOut and
            compatibleTypes(fOut.getContainerType(), getErasedNodeTypeBound(node))
          )
        else any()
      }

      pragma[nomagic]
      private predicate parameterValueFlow0(
        ParameterNode p, Node node, ContentOption contentIn, ContentOption contentOut
      ) {
        p = node and
        Cand::cand(p, _) and
        contentIn = TContentNone() and
        contentOut = TContentNone()
        or
        // local flow
        exists(Node mid |
          parameterValueFlow(p, mid, contentIn, contentOut) and
          LocalFlowBigStep::localFlowBigStep(mid, node)
        )
        or
        // read
        exists(Node mid, Content f, ContentOption contentInMid, ContentOption contentOutMid |
          parameterValueFlow(p, mid, contentInMid, contentOutMid) and
          readStep(mid, f, node)
        |
          // value neither read nor stored prior to read
          contentInMid = TContentNone() and
          contentOutMid = TContentNone() and
          contentIn.getContent() = f and
          contentOut = TContentNone() and
          Cand::parameterValueFlowReturnCand(p, _, true, _) and
          compatibleTypes(getErasedNodeTypeBound(p), f.getContainerType())
          or
          // value (possibly read and then) stored prior to read (same content)
          contentIn = contentInMid and
          contentOutMid.getContent() = f and
          contentOut = TContentNone()
        )
        or
        // store
        exists(Node mid, Content f |
          parameterValueFlow(p, mid, contentIn, TContentNone()) and
          storeStep(mid, f, node) and
          contentOut.getContent() = f
        |
          contentIn = TContentNone() and
          compatibleTypes(getErasedNodeTypeBound(p), f.getType())
          or
          compatibleTypes(contentIn.getContent().getType(), f.getType())
        )
        or
        // flow through: no prior read or store
        exists(ArgumentNode arg |
          parameterValueFlowArg(p, arg, TContentNone(), TContentNone()) and
          argumentValueFlowsThrough(_, arg, contentIn, contentOut, node)
        )
        or
        // flow through: no read or store inside method
        exists(ArgumentNode arg |
          parameterValueFlowArg(p, arg, contentIn, contentOut) and
          argumentValueFlowsThrough(_, arg, TContentNone(), TContentNone(), node)
        )
        or
        // flow through: possible prior read and prior store with compatible
        // flow-through method
        exists(ArgumentNode arg, ContentOption contentMid |
          parameterValueFlowArg(p, arg, contentIn, contentMid) and
          argumentValueFlowsThrough(_, arg, contentMid, contentOut, node)
        )
      }

      pragma[nomagic]
      private predicate parameterValueFlowArg(
        ParameterNode p, ArgumentNode arg, ContentOption contentIn, ContentOption contentOut
      ) {
        parameterValueFlow(p, arg, contentIn, contentOut) and
        Cand::argumentValueFlowsThroughCand(arg, _, _, _)
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThrough0(
        DataFlowCall call, ArgumentNode arg, ReturnKindExt kind, ContentOption contentIn,
        ContentOption contentOut
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
          parameterValueFlowReturn(param, _, kind, contentIn, contentOut)
        )
      }

      /**
       * Holds if `arg` flows to `out` through `call` using only value-preserving steps,
       * not taking call contexts into account.
       *
       * `contentIn` describes the content of `arg` that can flow to `out` (if any), and
       * `contentOut` describes the content of `out` that it flows to (if any).
       */
      cached
      predicate argumentValueFlowsThrough(
        DataFlowCall call, ArgumentNode arg, ContentOption contentIn, ContentOption contentOut,
        Node out
      ) {
        exists(ReturnKindExt kind |
          argumentValueFlowsThrough0(call, arg, kind, contentIn, contentOut) and
          out = kind.getAnOutNode(call)
        |
          // normal flow through
          contentIn = TContentNone() and
          contentOut = TContentNone() and
          compatibleTypes(getErasedNodeTypeBound(arg), getErasedNodeTypeBound(out))
          or
          // getter
          exists(Content fIn |
            contentIn.getContent() = fIn and
            contentOut = TContentNone() and
            compatibleTypes(getErasedNodeTypeBound(arg), fIn.getContainerType()) and
            compatibleTypes(fIn.getType(), getErasedNodeTypeBound(out))
          )
          or
          // setter
          exists(Content fOut |
            contentIn = TContentNone() and
            contentOut.getContent() = fOut and
            compatibleTypes(getErasedNodeTypeBound(arg), fOut.getType()) and
            compatibleTypes(fOut.getContainerType(), getErasedNodeTypeBound(out))
          )
          or
          // getter+setter
          exists(Content fIn, Content fOut |
            contentIn.getContent() = fIn and
            contentOut.getContent() = fOut and
            compatibleTypes(getErasedNodeTypeBound(arg), fIn.getContainerType()) and
            compatibleTypes(fOut.getContainerType(), getErasedNodeTypeBound(out))
          )
        )
      }

      /**
       * Holds if `p` can flow to the pre-update node associated with post-update
       * node `n`, in the same callable, using only value-preserving steps.
       */
      cached
      predicate parameterValueFlowsToPreUpdate(ParameterNode p, PostUpdateNode n) {
        parameterValueFlow(p, n.getPreUpdateNode(), TContentNone(), TContentNone())
      }

      pragma[nomagic]
      private predicate parameterValueFlowsToPostUpdate(
        ParameterNode p, PostUpdateNode n, ContentOption contentIn, ContentOption contentOut
      ) {
        parameterValueFlow(p, n, contentIn, contentOut) and
        contentOut.hasContent()
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps.
       *
       * `contentIn` describes the content of `p` that can flow to the return
       * node (if any), and `contentOut` describes the content of the return
       * node that it flows to (if any).
       */
      cached
      predicate parameterValueFlowReturn(
        ParameterNode p, Node ret, ReturnKindExt kind, ContentOption contentIn,
        ContentOption contentOut
      ) {
        ret =
          any(ReturnNode n |
            parameterValueFlow(p, n, contentIn, contentOut) and
            kind = TValueReturn(n.getKind())
          )
        or
        ret =
          any(PostUpdateNode n |
            exists(ParameterNode p2, int pos2 |
              parameterValueFlowsToPostUpdate(p, n, contentIn, contentOut) and
              parameterValueFlowsToPreUpdate(p2, n) and
              p2.isParameterOf(_, pos2) and
              kind = TParamUpdate(pos2) and
              p != p2
            )
          )
      }
    }

    import Final
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a direct assignment to
   * `f`.
   *
   * This includes reverse steps through reads when the result of the read has
   * been stored into, in order to handle cases like `x.f1.f2 = y`.
   */
  cached
  predicate storeDirect(Node node1, Content f, Node node2) {
    storeStep(node1, f, node2) and readStep(_, f, _)
    or
    exists(Node n1, Node n2 |
      n1 = node1.(PostUpdateNode).getPreUpdateNode() and
      n2 = node2.(PostUpdateNode).getPreUpdateNode()
    |
      argumentValueFlowsThrough(_, n2, TContentSome(f), TContentNone(), n1)
      or
      readStep(n2, f, n1)
    )
  }

  import FlowThrough

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
}

/**
 * A `Node` at which a cast can occur such that the type should be checked.
 */
class CastingNode extends Node {
  CastingNode() {
    this instanceof ParameterNode or
    this instanceof CastNode or
    this instanceof OutNode or
    this.(PostUpdateNode).getPreUpdateNode() instanceof ArgumentNode
  }
}

newtype TContentOption =
  TContentNone() or
  TContentSome(Content f)

class ContentOption extends TContentOption {
  Content getContent() { this = TContentSome(result) }

  predicate hasContent() { exists(this.getContent()) }

  string toString() {
    result = this.getContent().toString()
    or
    not this.hasContent() and
    result = "<none>"
  }
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

class CallContextAny extends CallContext, TAnyCallContext {
  override string toString() { result = "CcAny" }

  override predicate relevantFor(DataFlowCallable callable) { any() }
}

abstract class CallContextCall extends CallContext { }

class CallContextSpecificCall extends CallContextCall, TSpecificCall {
  override string toString() {
    exists(DataFlowCall call | this = TSpecificCall(call) | result = "CcCall(" + call + ")")
  }

  override predicate relevantFor(DataFlowCallable callable) {
    recordDataFlowCallSite(getCall(), callable)
  }

  DataFlowCall getCall() { this = TSpecificCall(result) }
}

class CallContextSomeCall extends CallContextCall, TSomeCall {
  override string toString() { result = "CcSomeCall" }

  override predicate relevantFor(DataFlowCallable callable) {
    exists(ParameterNode p | p.getEnclosingCallable() = callable)
  }
}

class CallContextReturn extends CallContext, TReturn {
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
  exists(Node n | n.getEnclosingCallable() = callable and isUnreachableInCall(n, call))
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
 * An extended return kind. A return kind describes how data can be returned
 * from a callable. This can either be through a returned value or an updated
 * parameter.
 */
abstract class ReturnKindExt extends TReturnKindExt {
  /** Gets a textual representation of this return kind. */
  abstract string toString();

  /** Gets a node corresponding to data flow out of `call`. */
  abstract Node getAnOutNode(DataFlowCall call);
}

class ValueReturnKind extends ReturnKindExt, TValueReturn {
  private ReturnKind kind;

  ValueReturnKind() { this = TValueReturn(kind) }

  ReturnKind getKind() { result = kind }

  override string toString() { result = kind.toString() }

  override Node getAnOutNode(DataFlowCall call) { result = getAnOutNode(call, this.getKind()) }
}

class ParamUpdateReturnKind extends ReturnKindExt, TParamUpdate {
  private int pos;

  ParamUpdateReturnKind() { this = TParamUpdate(pos) }

  int getPosition() { result = pos }

  override string toString() { result = "param update " + pos }

  override PostUpdateNode getAnOutNode(DataFlowCall call) {
    exists(ArgumentNode arg |
      result.getPreUpdateNode() = arg and
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

pragma[noinline]
private DataFlowCallable returnNodeGetEnclosingCallable(ReturnNodeExt ret) {
  result = ret.getEnclosingCallable()
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
  exists(DataFlowCall ctx | cc = TSpecificCall(ctx) |
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

newtype TSummary =
  TSummaryVal() or
  TSummaryTaint() or
  TSummaryReadVal(Content f) or
  TSummaryReadTaint(Content f) or
  TSummaryTaintStore(Content f)

/**
 * A summary of flow through a callable. This can either be value-preserving
 * if no additional steps are used, taint-flow if at least one additional step
 * is used, or any one of those combined with a store or a read. Summaries
 * recorded at a return node are restricted to include at least one additional
 * step, as the value-based summaries are calculated independent of the
 * configuration.
 */
class Summary extends TSummary {
  string toString() {
    result = "Val" and this = TSummaryVal()
    or
    result = "Taint" and this = TSummaryTaint()
    or
    exists(Content f |
      result = "ReadVal " + f.toString() and this = TSummaryReadVal(f)
      or
      result = "ReadTaint " + f.toString() and this = TSummaryReadTaint(f)
      or
      result = "TaintStore " + f.toString() and this = TSummaryTaintStore(f)
    )
  }

  /** Gets the summary that results from extending this with an additional step. */
  Summary additionalStep() {
    this = TSummaryVal() and result = TSummaryTaint()
    or
    this = TSummaryTaint() and result = TSummaryTaint()
    or
    exists(Content f | this = TSummaryReadVal(f) and result = TSummaryReadTaint(f))
    or
    exists(Content f | this = TSummaryReadTaint(f) and result = TSummaryReadTaint(f))
  }

  /** Gets the summary that results from extending this with a read. */
  Summary readStep(Content f) { this = TSummaryVal() and result = TSummaryReadVal(f) }

  /** Gets the summary that results from extending this with a store. */
  Summary storeStep(Content f) { this = TSummaryTaint() and result = TSummaryTaintStore(f) }

  /** Gets the summary that results from extending this with `step`. */
  bindingset[this, step]
  Summary compose(Summary step) {
    this = TSummaryVal() and result = step
    or
    this = TSummaryTaint() and
    (step = TSummaryTaint() or step = TSummaryTaintStore(_)) and
    result = step
    or
    exists(Content f |
      this = TSummaryReadVal(f) and step = TSummaryTaint() and result = TSummaryReadTaint(f)
    )
    or
    this = TSummaryReadTaint(_) and step = TSummaryTaint() and result = this
  }

  /** Holds if this summary does not include any taint steps. */
  predicate isPartial() {
    this = TSummaryVal() or
    this = TSummaryReadVal(_)
  }
}

pragma[noinline]
DataFlowType getErasedNodeTypeBound(Node n) { result = getErasedRepr(n.getTypeBound()) }

predicate readDirect = readStep/3;
