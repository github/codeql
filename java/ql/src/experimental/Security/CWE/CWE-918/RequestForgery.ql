import java
import RequestForgery

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess call
where
  sink.getNode().asExpr() = call.getQualifier() and
  any(RemoteURLToOpenConnectionFlowConfig c).hasFlowPath(source, sink)
select call, source, sink,
  "URL on which openConnection is called may have been constructed from remote source"
