private import go
private import DataFlowPrivate

/**
 * Holds if `call` is an interface call to method `m`, meaning that its receiver `recv` has
 * interface type `tp`.
 */
private predicate isInterfaceCallReceiver(
  DataFlow::CallNode call, DataFlow::Node recv, InterfaceType tp, string m
) {
  pragma[only_bind_out](call).getReceiver() = recv and
  recv.getType().getUnderlyingType() = tp and
  m = pragma[only_bind_out](call).getACalleeIncludingExternals().asFunction().getName()
}

/** Gets a data-flow node that may flow into the receiver value of `call`, which is an interface value. */
private DataFlow::Node getInterfaceCallReceiverSource(DataFlow::CallNode call) {
  exists(DataFlow::Node succ | basicLocalFlowStep*(result, succ) |
    isInterfaceCallReceiver(call, succ, _, _)
  )
}

/** Gets the type of `nd`, which must be a valid type and not an interface type. */
private Type getConcreteType(DataFlow::Node nd) {
  result = nd.getType() and
  not result.getUnderlyingType() instanceof InterfaceType and
  not result instanceof InvalidType
}

/**
 * Holds if all concrete (that is, non-interface) types of `nd` concrete types can be determined by
 * local reasoning.
 *
 * `nd` is restricted to nodes that flow into the receiver value of an interface call, since that is
 * all we are ultimately interested in.
 */
private predicate isConcreteValue(DataFlow::Node nd) {
  nd = getInterfaceCallReceiverSource(_) and
  (
    exists(getConcreteType(nd))
    or
    forex(DataFlow::Node pred | basicLocalFlowStep(pred, nd) | isConcreteValue(pred))
  )
}

/**
 * Holds if `call` is an interface call to method `m` with receiver `recv`, where the concrete
 * types of `recv` can be established by local reasoning.
 */
private predicate isConcreteInterfaceCall(DataFlow::Node call, DataFlow::Node recv, string m) {
  isInterfaceCallReceiver(call, recv, _, m) and isConcreteValue(recv)
}

private Function getRealOrSummarizedFunction(DataFlowCallable c) {
  result = c.asCallable().asFunction()
  or
  result = c.asSummarizedCallable().asFunction()
}

/**
 * Gets a function that might be called by `call`, where the receiver of `call` has interface type,
 * but its concrete types can be determined by local reasoning.
 */
private DataFlowCallable getConcreteTarget(DataFlow::CallNode call) {
  exists(string m | isConcreteInterfaceCall(call, _, m) |
    exists(Type concreteReceiverType |
      concreteReceiverType = getConcreteType(getInterfaceCallReceiverSource(call)) and
      getRealOrSummarizedFunction(result) = concreteReceiverType.getMethod(m)
    )
  )
}

/**
 * Holds if `call` is a method call whose receiver has an interface type.
 */
private predicate isInterfaceMethodCall(DataFlow::CallNode call) {
  isInterfaceCallReceiver(call, _, _, _)
}

/**
 * Gets a method that might be called by `call`, where we restrict the result to
 * implement the interface type of the receiver of `call`.
 */
private DataFlowCallable getRestrictedInterfaceTarget(DataFlow::CallNode call) {
  exists(InterfaceType tp, Type recvtp, string m |
    isInterfaceCallReceiver(call, _, tp, m) and
    getRealOrSummarizedFunction(result) = recvtp.getMethod(m) and
    recvtp.implements(tp)
  )
}

/**
 * Gets a function that might be called by `call`.
 */
DataFlowCallable viableCallable(DataFlowCall ma) {
  exists(DataFlow::CallNode call | call.asExpr() = ma |
    if isConcreteInterfaceCall(call, _, _)
    then result = getConcreteTarget(call)
    else
      if isInterfaceMethodCall(call)
      then result = getRestrictedInterfaceTarget(call)
      else
        [result.asCallable(), result.asSummarizedCallable()] = call.getACalleeIncludingExternals()
  )
}

private int parameterPosition() {
  result = [-1 .. any(DataFlowCallable c).getType().getNumParameter()]
}

/** A parameter position represented by an integer. */
class ParameterPosition extends int {
  ParameterPosition() { this = parameterPosition() }
}

/** An argument position represented by an integer. */
class ArgumentPosition extends int {
  ArgumentPosition() { this = parameterPosition() }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

private predicate isInterfaceMethod(Method c) {
  c.getReceiverBaseType().getUnderlyingType() instanceof InterfaceType
}

/**
 * Holds if `call` is passing `arg` to param `p` in any circumstance except passing
 * a receiver parameter to a concrete method.
 */
pragma[inline]
predicate golangSpecificParamArgFilter(
  DataFlowCall call, DataFlow::ParameterNode p, DataFlow::ArgumentNode arg
) {
  // Interface methods calls may be passed strictly to that exact method's model receiver:
  arg.getPosition() != -1
  or
  p instanceof DataFlow::SummarizedParameterNode
  or
  not isInterfaceMethod(call.getNode()
        .(DataFlow::CallNode)
        .getACalleeWithoutVirtualDispatch()
        .asFunction())
}
