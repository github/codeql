import csharp
import semmle.code.csharp.dataflow.internal.DataFlowDispatch

from DataFlowCall call, ReturnKind kind
select call, kind, getAnOutNode(call, kind)
