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

private class SourceNode extends DataFlow::Node {
  SourceNode() { this.getLocation().getFile().fromSource() }
}

from DataFlowCallAdjusted call, SourceNode n, ReturnKind kind
where n = getAnOutNode(call, kind)
select call, kind, n
