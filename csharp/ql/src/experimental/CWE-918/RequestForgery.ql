/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import csharp
import RequestForgery::RequestForgery
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from RequestForgeryConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in a server side web request.",
  source.getNode(), "User-provided value"
