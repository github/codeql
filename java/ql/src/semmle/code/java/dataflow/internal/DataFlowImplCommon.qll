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

  /** Gets a viable return position of kind `kind` for call `call`. */
  cached
  ReturnPosition viableReturnPos(DataFlowCall call, ReturnKindExt kind) {
    viableCallable(call) = result.getCallable() and
    kind = result.getKind()
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
      predicate parameterValueFlowReturnCand(ParameterNode p, ReturnKindExt kind, boolean read) {
        exists(ReturnNode ret |
          parameterValueFlowCand(p, ret, read) and
          kind = TValueReturn(ret.getKind())
        )
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThroughCand0(
        DataFlowCall call, ArgumentNode arg, ReturnKindExt kind, boolean read
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
        exists(DataFlowCall call, ReturnKindExt kind |
          argumentValueFlowsThroughCand0(call, arg, kind, read) and
          out = kind.getAnOutNode(call)
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
     * - Input access paths are abstracted with a `ContentOption` parameter
     *   that represents the head of the access path. `TContentNone()` means that
     *   the access path is unrestricted.
     * - Types are checked using the `compatibleTypes()` relation.
     */
    private module Final {
      /**
       * Holds if `p` can flow to `node` in the same callable using only
       * value-preserving steps, not taking call contexts into account.
       *
       * `contentIn` describes the content of `p` that can flow to `node`
       * (if any).
       */
      predicate parameterValueFlow(ParameterNode p, Node node, ContentOption contentIn) {
        parameterValueFlow0(p, node, contentIn) and
        if node instanceof CastingNode
        then
          // normal flow through
          contentIn = TContentNone() and
          compatibleTypes(getErasedNodeTypeBound(p), getErasedNodeTypeBound(node))
          or
          // getter
          exists(Content fIn |
            contentIn.getContent() = fIn and
            compatibleTypes(fIn.getType(), getErasedNodeTypeBound(node))
          )
        else any()
      }

      pragma[nomagic]
      private predicate parameterValueFlow0(ParameterNode p, Node node, ContentOption contentIn) {
        p = node and
        Cand::cand(p, _) and
        contentIn = TContentNone()
        or
        // local flow
        exists(Node mid |
          parameterValueFlow(p, mid, contentIn) and
          LocalFlowBigStep::localFlowBigStep(mid, node)
        )
        or
        // read
        exists(Node mid, Content f |
          parameterValueFlow(p, mid, TContentNone()) and
          readStep(mid, f, node) and
          contentIn.getContent() = f and
          Cand::parameterValueFlowReturnCand(p, _, true) and
          compatibleTypes(getErasedNodeTypeBound(p), f.getContainerType())
        )
        or
        // flow through: no prior read
        exists(ArgumentNode arg |
          parameterValueFlowArg(p, arg, TContentNone()) and
          argumentValueFlowsThrough(arg, contentIn, node)
        )
        or
        // flow through: no read inside method
        exists(ArgumentNode arg |
          parameterValueFlowArg(p, arg, contentIn) and
          argumentValueFlowsThrough(arg, TContentNone(), node)
        )
      }

      pragma[nomagic]
      private predicate parameterValueFlowArg(
        ParameterNode p, ArgumentNode arg, ContentOption contentIn
      ) {
        parameterValueFlow(p, arg, contentIn) and
        Cand::argumentValueFlowsThroughCand(arg, _, _)
      }

      pragma[nomagic]
      private predicate argumentValueFlowsThrough0(
        DataFlowCall call, ArgumentNode arg, ReturnKindExt kind, ContentOption contentIn
      ) {
        exists(ParameterNode param | viableParamArg(call, param, arg) |
          parameterValueFlowReturn(param, kind, contentIn)
        )
      }

      /**
       * Holds if `arg` flows to `out` through a call using only value-preserving steps,
       * not taking call contexts into account.
       *
       * `contentIn` describes the content of `arg` that can flow to `out` (if any).
       */
      pragma[nomagic]
      predicate argumentValueFlowsThrough(ArgumentNode arg, ContentOption contentIn, Node out) {
        exists(DataFlowCall call, ReturnKindExt kind |
          argumentValueFlowsThrough0(call, arg, kind, contentIn) and
          out = kind.getAnOutNode(call)
        |
          // normal flow through
          contentIn = TContentNone() and
          compatibleTypes(getErasedNodeTypeBound(arg), getErasedNodeTypeBound(out))
          or
          // getter
          exists(Content fIn |
            contentIn.getContent() = fIn and
            compatibleTypes(getErasedNodeTypeBound(arg), fIn.getContainerType()) and
            compatibleTypes(fIn.getType(), getErasedNodeTypeBound(out))
          )
        )
      }

      /**
       * Holds if `p` can flow to a return node of kind `kind` in the same
       * callable using only value-preserving steps.
       *
       * `contentIn` describes the content of `p` that can flow to the return
       * node (if any).
       */
      private predicate parameterValueFlowReturn(
        ParameterNode p, ReturnKindExt kind, ContentOption contentIn
      ) {
        exists(ReturnNode ret |
          parameterValueFlow(p, ret, contentIn) and
          kind = TValueReturn(ret.getKind())
        )
      }
    }

    import Final
  }

  /**
   * Holds if `p` can flow to the pre-update node associated with post-update
   * node `n`, in the same callable, using only value-preserving steps.
   */
  cached
  predicate parameterValueFlowsToPreUpdate(ParameterNode p, PostUpdateNode n) {
    parameterValueFlow(p, n.getPreUpdateNode(), TContentNone())
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a direct assignment to
   * `f`.
   *
   * This includes reverse steps through reads when the result of the read has
   * been stored into, in order to handle cases like `x.f1.f2 = y`.
   */
  cached
  predicate store(Node node1, Content f, Node node2) {
    storeStep(node1, f, node2) and readStep(_, f, _)
    or
    exists(Node n1, Node n2 |
      n1 = node1.(PostUpdateNode).getPreUpdateNode() and
      n2 = node2.(PostUpdateNode).getPreUpdateNode()
    |
      argumentValueFlowsThrough(n2, TContentSome(f), n1)
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

  cached
  newtype TBooleanOption =
    TBooleanNone() or
    TBooleanSome(boolean b) { b = true or b = false }

  cached
  newtype TAccessPathFront =
    TFrontNil(DataFlowType t) or
    TFrontHead(Content f)

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
    this instanceof OutNode or
    this.(PostUpdateNode).getPreUpdateNode() instanceof ArgumentNode
  }
}

newtype TContentOption =
  TContentNone() or
  TContentSome(Content f)

private class ContentOption extends TContentOption {
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

pragma[noinline]
DataFlowType getErasedNodeTypeBound(Node n) { result = getErasedRepr(n.getTypeBound()) }

predicate read = readStep/3;

/** An optional Boolean value. */
class BooleanOption extends TBooleanOption {
  string toString() {
    this = TBooleanNone() and result = "<none>"
    or
    this = TBooleanSome(any(boolean b | result = b.toString()))
  }
}

/**
 * The front of an access path. This is either a head or a nil.
 */
abstract class AccessPathFront extends TAccessPathFront {
  abstract string toString();

  abstract DataFlowType getType();

  abstract boolean toBoolNonEmpty();

  predicate headUsesContent(Content f) { this = TFrontHead(f) }
}

class AccessPathFrontNil extends AccessPathFront, TFrontNil {
  override string toString() {
    exists(DataFlowType t | this = TFrontNil(t) | result = ppReprType(t))
  }

  override DataFlowType getType() { this = TFrontNil(result) }

  override boolean toBoolNonEmpty() { result = false }
}

class AccessPathFrontHead extends AccessPathFront, TFrontHead {
  override string toString() { exists(Content f | this = TFrontHead(f) | result = f.toString()) }

  override DataFlowType getType() {
    exists(Content head | this = TFrontHead(head) | result = head.getContainerType())
  }

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
