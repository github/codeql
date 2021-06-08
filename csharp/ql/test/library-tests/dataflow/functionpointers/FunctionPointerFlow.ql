import csharp
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowDispatch

query predicate fptrCall(FunctionPointerCall dc, Callable c) { c = dc.getARuntimeTarget() }

private class LocatableDataFlowCallOption extends DataFlowCallOption {
  Location getLocation() {
    this = TDataFlowCallNone() and
    result instanceof EmptyLocation
    or
    exists(DataFlowCall call |
      this = TDataFlowCallSome(call) and
      result = call.getLocation()
    )
  }
}

private class LocatableDataFlowCall extends TDataFlowCall {
  LocatableDataFlowCall() {
    this.(ExplicitDelegateLikeDataFlowCall).getCall() instanceof FunctionPointerCall
  }

  string toString() { result = this.(DataFlowCall).toString() }

  Location getLocation() {
    exists(Location l |
      l = this.(DataFlowCall).getLocation() and
      if l instanceof SourceLocation then result = l else result instanceof EmptyLocation
    )
  }
}

query predicate fptrCallContext(
  LocatableDataFlowCall call, LocatableDataFlowCallOption lastCall, DataFlowCallable target
) {
  target = viableCallableLambda(call, lastCall)
}
