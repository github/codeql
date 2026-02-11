import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored

from StoredFlowSource source
where source.asExpr().fromSource()
select source
