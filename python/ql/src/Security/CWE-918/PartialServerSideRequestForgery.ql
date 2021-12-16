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
  FullServerSideRequestForgery::Configuration fullConfig,
  PartialServerSideRequestForgery::Configuration partialConfig, DataFlow::PathNode source,
  DataFlow::PathNode sink
where
  partialConfig.hasFlowPath(source, sink) and
  not fullConfig.hasFlow(source.getNode(), sink.getNode())
select sink.getNode(), source, sink, "Part of the URL of this request depends on $@.",
  source.getNode(), "a user-provided value"
