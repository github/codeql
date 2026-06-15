/**
 * @name Cors misconfiguration with credentials
 * @description Disabling or weakening SOP protection may make the application
 *              vulnerable to a CORS attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision high
 * @id py/cors-misconfiguration-with-credentials
 * @tags security
 *       experimental
 *       external/cwe/cwe-942
 */

import python
import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow

predicate containsStar(DataFlow::Node array) {
  array.asExpr() instanceof List and
  array.asExpr().getASubExpression().(StringLiteral).getText() in ["*", "null"]
  or
  array.asExpr().(StringLiteral).getText() in ["*", "null"]
}

predicate isCorsMiddleware(Http::Server::CorsMiddleware middleware) {
  middleware.getMiddlewareName() = "CORSMiddleware"
}

predicate credentialsAllowed(Http::Server::CorsMiddleware middleware) {
  middleware.getCredentialsAllowed().asExpr() instanceof True
}

from Http::Server::CorsMiddleware a
where
  credentialsAllowed(a) and
  containsStar(a.getOrigins().getALocalSource()) and
  isCorsMiddleware(a)
select a,
  "This CORS middleware uses a vulnerable configuration that allows arbitrary websites to make authenticated cross-site requests"
