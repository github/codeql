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
  m = call.getCalleeName()
}

/** Gets a data-flow node that may flow into the receiver value of `call`, which is an interface value. */
private DataFlow::Node getInterfaceCallReceiverSource(DataFlow::CallNode call) {
  isInterfaceCallReceiver(call, result.getASuccessor*(), _, _)
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
    forex(DataFlow::Node pred | pred = nd.getAPredecessor() | isConcreteValue(pred))
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
private FuncDecl getConcreteTarget(DataFlow::CallNode call) {
  exists(DataFlow::Node recv, string m | isConcreteInterfaceCall(call, recv, m) |
    exists(Type concreteReceiverType, DeclaredFunction concreteTarget |
      concreteReceiverType = getConcreteType(getInterfaceCallReceiverSource(call)) and
      concreteTarget = concreteReceiverType.getMethod(m) and
      result = concreteTarget.getFuncDecl()
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
private MethodDecl getRestrictedInterfaceTarget(DataFlow::CallNode call) {
  exists(InterfaceType tp, Type recvtp, string m |
    isInterfaceCallReceiver(call, _, tp, m) and
    result = recvtp.getMethod(m).(DeclaredFunction).getFuncDecl() and
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
      else result = call.getACallee()
  )
}

/**
 * Holds if the call context `ctx` reduces the set of viable dispatch
 * targets of `ma` in `c`.
 */
predicate reducedViableImplInCallContext(DataFlowCall ma, DataFlowCallable c, DataFlowCall ctx) {
  none()
}

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s for which the context makes a difference.
 */
DataFlowCallable prunedViableImplInCallContext(DataFlowCall ma, DataFlowCall ctx) { none() }

/**
 * Holds if flow returning from `m` to `ma` might return further and if
 * this path restricts the set of call sites that can be returned to.
 */
predicate reducedViableImplInReturn(DataFlowCallable m, DataFlowCall ma) { none() }

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s and results for which the return flow from the
 * result to `ma` restricts the possible context `ctx`.
 */
DataFlowCallable prunedViableImplInCallContextReverse(DataFlowCall ma, DataFlowCall ctx) { none() }
