/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @id go/ssrf
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 */

import go
import SSRF
import ServerSideRequestForgery::Flow::PathGraph

from
  ServerSideRequestForgery::Flow::PathNode source, ServerSideRequestForgery::Flow::PathNode sink,
  DataFlow::Node request
where
  ServerSideRequestForgery::Flow::flowPath(source, sink) and
  request = sink.getNode().(ServerSideRequestForgery::Sink).getARequest()
select request, source, sink, "The URL of this request depends on a user-provided value."
