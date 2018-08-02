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
 * restricted to those `ma`s for which a context might make a difference.
 */
private Method viableImplInCallContext(MethodAccess ma, Call ctx) {
  // stub implementation
  result = viableImpl(ma) and
  viableCallable(ctx) = ma.getEnclosingFunction()
}

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s for which the context makes a difference.
 */
Method prunedViableImplInCallContext(MethodAccess ma, Call ctx) {
  result = viableImplInCallContext(ma, ctx) and
  reducedViableImplInCallContext(ma, _, ctx)
}

/**
 * Holds if flow returning from `m` to `ma` might return further and if
 * this path restricts the set of call sites that can be returned to.
 */
predicate reducedViableImplInReturn(Method m, MethodAccess ma) {
  exists(int tgts, int ctxtgts |
    m = viableImpl(ma) and
    ctxtgts = count(Call ctx | m = viableImplInCallContext(ma, ctx)) and
    tgts = strictcount(Call ctx | viableCallable(ctx) = ma.getEnclosingFunction()) and
    ctxtgts < tgts
  )
}

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s and results for which the return flow from the
 * result to `ma` restricts the possible context `ctx`.
 */
Method prunedViableImplInCallContextReverse(MethodAccess ma, Call ctx) {
  result = viableImplInCallContext(ma, ctx) and
  reducedViableImplInReturn(result, ma)
}
