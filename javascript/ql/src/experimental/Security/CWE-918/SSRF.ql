/**
 * @id javascript/ssrf
 * @kind path-problem
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data as part of the URL allows for request forgery attacks.
 * @problem.severity error
 * @precision medium
 * @tags security
 *       external/cwe/cwe-918
 */

import javascript
import SSRF
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::Node request
where
  cfg.hasFlowPath(source, sink) and request = sink.getNode().(RequestForgery::Sink).getARequest()
select sink, source, sink, "The URL of this request depends on a user-provided value"
