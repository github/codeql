/**
 * @name SSRF
 * @description Server Side Request Forgery
 * @kind path-problem
 */

import java
import RequestForgery

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess call
where
  sink.getNode().asExpr() = call.getQualifier() and
  (
    any(UnsafeURLSpecFlowConfiguration c).hasFlowPath(source, sink) or
    any(UnsafeURLHostFlowConfiguration c).hasFlowPath(source, sink)
  )
select call, source, sink,
  "URL on which openConnection is called may have been constructed from remote source"
