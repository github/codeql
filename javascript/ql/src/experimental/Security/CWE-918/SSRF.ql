/**
 * @id javascript/ssrf
 * @kind path-problem
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data as part of the URL allows for request forgery attacks.
 * @problem.severity error
 * @precision medium
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 */

import javascript
import SSRF
import SsrfFlow::PathGraph

from SsrfFlow::PathNode source, SsrfFlow::PathNode sink, DataFlow::Node request
where
  SsrfFlow::flowPath(source, sink) and request = sink.getNode().(RequestForgery::Sink).getARequest()
select sink, source, sink, "The URL of this request depends on a user-provided value."
