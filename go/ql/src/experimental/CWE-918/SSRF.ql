/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @id go/ssrf
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-918
 */

import go
import SSRF
import DataFlow::PathGraph

from
  ServerSideRequestForgery::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::Node request
where
  cfg.hasFlowPath(source, sink) and
  request = sink.getNode().(ServerSideRequestForgery::Sink).getARequest()
select request, source, sink, "The URL of this request depends on a user-provided value"
