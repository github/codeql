private import ql
private import DataFlowUtil

/**
 * Gets a function that might be called by `call`.
 */
DataFlowCallable viableCallable(Call call) { result.asPredicate() = call.getTarget() }

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(Call call, DataFlowCallable f) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(Call call, Call ctx) { none() }
