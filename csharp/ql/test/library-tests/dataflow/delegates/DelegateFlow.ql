import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DelegateDataFlow

private class NodeAdjusted extends TNode {
  string toString() { result = this.(DataFlow::Node).toString() }

  Location getLocation() {
    exists(Location l |
      l = this.(DataFlow::Node).getLocation() and
      if l instanceof SourceLocation then result = l else result instanceof EmptyLocation
    )
  }
}

query predicate summaryDelegateCall(NodeAdjusted sink, Callable c, CallContext::CallContext cc) {
  c = sink.(SummaryDelegateParameterSink).getARuntimeTarget(cc)
}

query predicate delegateCall(DelegateCall dc, Callable c, CallContext::CallContext cc) {
  c = dc.getARuntimeTarget(cc)
}
