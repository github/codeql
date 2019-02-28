private import cpp
private import DataFlowPrivate

Function viableImpl(MethodAccess ma) {
  result = ma.getTarget()
}

Function viableCallable(Call call) {
  result = call.getTarget()
}

/**
 * Holds if the call context `ctx` reduces the set of viable dispatch
 * targets of `ma` in `c`.
 */
predicate reducedViableImplInCallContext(MethodAccess ma, Callable c, Call ctx) {
  none()
}

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s for which the context makes a difference.
 */
Method prunedViableImplInCallContext(MethodAccess ma, Call ctx) {
  none()
}

/**
 * Holds if flow returning from `m` to `ma` might return further and if
 * this path restricts the set of call sites that can be returned to.
 */
predicate reducedViableImplInReturn(Method m, MethodAccess ma) {
  none()
}

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s and results for which the return flow from the
 * result to `ma` restricts the possible context `ctx`.
 */
Method prunedViableImplInCallContextReverse(MethodAccess ma, Call ctx) {
  none()
}
