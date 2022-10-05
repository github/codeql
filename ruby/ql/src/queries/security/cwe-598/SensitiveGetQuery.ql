/**
 * @name Sensitive data read from GET request
 * @description Placing sensitive data in a GET request increases the risk of
 *              the data being exposed to an attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id rb/sensitive-get-query
 * @tags security
 *       external/cwe/cwe-598
 */

import ruby
import codeql.ruby.Concepts
import codeql.ruby.security.SensitiveActions

// Local flow augmented with flow through element references
private predicate localFlowWithElementReference(DataFlow::LocalSourceNode src, DataFlow::Node to) {
  src.flowsTo(to)
  or
  exists(DataFlow::Node midRecv, DataFlow::LocalSourceNode mid, Ast::ElementReference ref |
    src.flowsTo(midRecv) and
    midRecv.asExpr().getExpr() = ref.getReceiver() and
    mid.asExpr().getExpr() = ref
  |
    localFlowWithElementReference(mid, to)
  )
}

from
  Http::Server::RequestHandler handler, Http::Server::RequestInputAccess input,
  SensitiveNode sensitive
where
  handler.getAnHttpMethod() = "get" and
  input.asExpr().getExpr().getEnclosingMethod() = handler and
  input.getKind() = "parameter" and
  localFlowWithElementReference(input, sensitive) and
  not sensitive.getClassification() = SensitiveDataClassification::id()
select input, "$@ for GET requests uses query parameter as sensitive data.", handler,
  "Route handler"
