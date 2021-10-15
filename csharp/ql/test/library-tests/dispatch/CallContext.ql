import csharp
import semmle.code.csharp.dispatch.Dispatch

query predicate getADynamicTargetInCallContext(
  DispatchCall call, Callable callable, DispatchCall ctx
) {
  callable = call.getADynamicTargetInCallContext(ctx)
}

query predicate mayBenefitFromCallContext(DispatchCall call) { call.mayBenefitFromCallContext() }
