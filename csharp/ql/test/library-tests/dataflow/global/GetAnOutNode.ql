import csharp
import semmle.code.csharp.dataflow.internal.DataFlowDispatch
import semmle.code.csharp.dataflow.internal.DataFlowPrivate

private class DataFlowCallAdjusted extends TDataFlowCall {
  string toString() { result = this.(DataFlowCall).toString() }

  Location getLocation() {
    exists(Location l |
      l = this.(DataFlowCall).getLocation() and
      if l instanceof SourceLocation then result = l else result instanceof EmptyLocation
    )
  }
}

private class NodeAdjusted extends TNode {
  string toString() { result = this.(DataFlow::Node).toString() }

  Location getLocation() {
    exists(Location l |
      l = this.(DataFlow::Node).getLocation() and
      if l instanceof SourceLocation then result = l else result instanceof EmptyLocation
    )
  }
}

from DataFlowCallAdjusted call, NodeAdjusted n, ReturnKind kind
where n = getAnOutNode(call, kind)
select call, kind, n
