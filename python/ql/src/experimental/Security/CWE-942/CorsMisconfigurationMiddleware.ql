/**
 * @name SOP protection weak with credentials
 * @description Disabling or weakening SOP protection may make the application
 *              vulnerable to a CORS attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision high
 * @id py/insecure-cors-setting
 * @tags security
 *       external/cwe/cwe-352
 */

import python
import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow

predicate containsStar(DataFlow::Node array) {
  array.asExpr() instanceof List and
  array.asExpr().getASubExpression().(StringLiteral).getText() = ["*", "null"]
  or
  array.asExpr().(StringLiteral).getText() = ["*", "null"]
}

predicate isCorsMiddleware(Http::Server::CorsMiddleware middleware) {
  middleware.middleware_name().matches("CORSMiddleware")
}

predicate credentialsAllowed(Http::Server::CorsMiddleware middleware) {
  middleware.allowed_credentials().asExpr() instanceof True
}

from Http::Server::CorsMiddleware a
where
  credentialsAllowed(a) and
  containsStar(a.allowed_origins().getALocalSource()) and
  isCorsMiddleware(a)
select a,
  "This CORS middleware uses a vulnerable configuration that leaves it open to attacks from arbitrary websites"
