/**
 * @name Server-side request forgery
 * @description Making a network request with user-controlled data in the URL allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id rb/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.security.ServerSideRequestForgeryQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "The URL of this request depends on $@.", source.getNode(),
  "a user-provided value"
