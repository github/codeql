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
      compatibleTypes(getNodeType(arg), getNodeType(p))
    )
  }

  pragma[nomagic]
  private ReturnPosition viableReturnPos(DataFlowCall call, ReturnKindExt kind) {
    viableCallable(call) = result.getCallable() and
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
     * Holds if the call context `ctx` reduces the set of viable run-time
     * dispatch targets of call `call` in `c`.
     */
    cached
    predicate reducedViableImplInCallContext(DataFlowCall call, DataFlowCallable c, DataFlowCall ctx) {
      exists(int tgts, int ctxtgts |
        mayBenefitFromCallContext(call, c) and
        c = viableCallable(ctx) and
        ctxtgts = count(viableImplInCallContext(call, ctx)) and
        tgts = strictcount(viableCallable(call)) and
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
      result = viableImplInCallContext(call, ctx) and
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
        mayBenefitFromCallContext(call, _) and
        c = viableCallable(call) and
        ctxtgts = count(DataFlowCall ctx | c = viableImplInCallContext(call, ctx)) and
        tgts = strictcount(DataFlowCall ctx | viableCallable(ctx) = call.getEnclosingCallable()) and
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
      result = viableImplInCallContext(call, ctx) and
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
    exists(ParameterNode p | p.getEnclosingCallable() = callable)
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

predicate read = readStep/3;

/** An optional Boolean value. */
class BooleanOption extends TBooleanOption {
  string toString() {
    this = TBooleanNone() and result = "<none>"
    or
    this = TBooleanSome(any(boolean b | result = b.toString()))
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

  predicate headUsesContent(TypedContent tc) { this = TFrontHead(tc) }

  predicate isClearedAt(Node n) {
    exists(TypedContent tc |
      this.headUsesContent(tc) and
      clearsContent(n, tc.getContent())
    )
  }
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
