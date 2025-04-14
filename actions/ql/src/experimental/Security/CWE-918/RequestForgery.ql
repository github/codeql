/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id actions/request-forgery
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-918
 */

import actions
import codeql.actions.security.RequestForgeryQuery
import RequestForgeryFlow::PathGraph

from RequestForgeryFlow::PathNode source, RequestForgeryFlow::PathNode sink
where RequestForgeryFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Potential request forgery in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
