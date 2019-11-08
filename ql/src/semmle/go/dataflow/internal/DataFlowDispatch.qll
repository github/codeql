private import go
private import DataFlowPrivate

DataFlowCallable viableImpl(DataFlowCall ma) { result = viableCallable(ma) }

/**
 * Gets a function that might be called by `call`.
 */
DataFlowCallable viableCallable(CallExpr ma) {
  result = ma.getACallee()
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
