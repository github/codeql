/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @id java/request-forgery
 * @tags security
 *       external/cwe/cwe-918
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
