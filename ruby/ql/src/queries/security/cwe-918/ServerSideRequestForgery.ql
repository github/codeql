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

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.security.ServerSideRequestForgeryQuery
import ServerSideRequestForgeryFlow::PathGraph

from ServerSideRequestForgeryFlow::PathNode source, ServerSideRequestForgeryFlow::PathNode sink
where ServerSideRequestForgeryFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "The URL of this request depends on a $@.", source.getNode(),
  "user-provided value"
