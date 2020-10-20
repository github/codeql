import csharp
import semmle.code.csharp.dataflow.TaintTracking

from StringLiteral l, DataFlow::Node n
where
  TaintTracking::localTaintStep+(DataFlow::exprNode(l), n) and
  n.getLocation().getFile().fromSource()
select l, n
