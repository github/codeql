/**
 * @name Full server-side request forgery
 * @description Making a network request to a URL that is fully user-controlled allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id py/full-ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import python
import semmle.python.security.dataflow.ServerSideRequestForgeryQuery
import FullServerSideRequestForgeryFlow::PathGraph

from
  FullServerSideRequestForgeryFlow::PathNode source,
  FullServerSideRequestForgeryFlow::PathNode sink, Http::Client::Request request
where
  request = sink.getNode().(Sink).getRequest() and
  FullServerSideRequestForgeryFlow::flowPath(source, sink) and
  fullyControlledRequest(request)
select request, source, sink, "The full URL of this request depends on a $@.", source.getNode(),
  "user-provided value"
