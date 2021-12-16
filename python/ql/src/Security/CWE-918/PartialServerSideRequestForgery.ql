/**
 * @name Partial server-side request forgery
 * @description Making a network request to a URL that is partially user-controlled allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision medium
 * @id py/partial-ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import python
import semmle.python.security.dataflow.ServerSideRequestForgery
import DataFlow::PathGraph

from
  PartialServerSideRequestForgery::Configuration partialConfig, DataFlow::PathNode source,
  DataFlow::PathNode sink, HTTP::Client::Request request
where
  request = sink.getNode().(PartialServerSideRequestForgery::Sink).getRequest() and
  partialConfig.hasFlowPath(source, sink) and
  not fullyControlledRequest(request)
select request, source, sink, "Part of the URL of this request depends on $@.", source.getNode(),
  "a user-provided value"
