import csharp
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowDispatch

query predicate delegateCall(DelegateLikeCall dc, Callable c) { c = dc.getARuntimeTarget() }

private class LocatableCallOption extends CallOption {
  Location getLocation() {
    this = TCallNone() and
    result instanceof EmptyLocation
    or
    exists(DataFlowCall call |
      this = TCallSome(call) and
      result = call.getLocation()
    )
  }
}

private class LocatableCall extends TDataFlowCall {
  string toString() { result = this.(DataFlowCall).toString() }

  Location getLocation() {
    exists(Location l |
      l = this.(DataFlowCall).getLocation() and
      if l instanceof SourceLocation then result = l else result instanceof EmptyLocation
    )
  }
}

query predicate viableLambda(
  LocatableCall call, LocatableCallOption lastCall, DataFlowCallable target
) {
  target = viableCallableLambda(call, lastCall)
}
