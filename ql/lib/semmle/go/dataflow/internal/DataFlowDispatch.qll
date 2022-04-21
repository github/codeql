private import go
private import DataFlowPrivate

/**
 * Holds if `call` is an interface call to method `m`, meaning that its receiver `recv` has
 * interface type `tp`.
 */
private predicate isInterfaceCallReceiver(
  DataFlow::CallNode call, DataFlow::Node recv, InterfaceType tp, string m
) {
  call.getReceiver() = recv and
  recv.getType().getUnderlyingType() = tp and
  m = call.getACalleeIncludingExternals().asFunction().getName()
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

/**
 * Gets a function that might be called by `call`, where the receiver of `call` has interface type,
 * but its concrete types can be determined by local reasoning.
 */
private DataFlowCallable getConcreteTarget(DataFlow::CallNode call) {
  exists(DataFlow::Node recv, string m | isConcreteInterfaceCall(call, recv, m) |
    exists(Type concreteReceiverType |
      concreteReceiverType = getConcreteType(getInterfaceCallReceiverSource(call)) and
      result.asFunction() = concreteReceiverType.getMethod(m)
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
    result.asFunction() = recvtp.getMethod(m) and
    recvtp.implements(tp)
  )
}

/**
 * Gets a function that might be called by `call`.
 */
DataFlowCallable viableCallable(CallExpr ma) {
  exists(DataFlow::CallNode call | call.asExpr() = ma |
    if isConcreteInterfaceCall(call, _, _)
    then result = getConcreteTarget(call)
    else
      if isInterfaceMethodCall(call)
      then result = getRestrictedInterfaceTarget(call)
      else result.asCallable() = call.getACalleeIncludingExternals()
  )
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable f) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }
