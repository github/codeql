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
private import codeql.ruby.DataFlow
private import codeql.ruby.security.SensitiveActions
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.ActionDispatch
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.core.Array

// Local flow augmented with flow through element references
private predicate localFlowWithElementReference(DataFlow::LocalSourceNode src, DataFlow::Node to) {
  src.flowsTo(to)
  or
  exists(DataFlow::Node midRecv, DataFlow::LocalSourceNode mid, ElementReference ref |
    src.flowsTo(midRecv) and
    midRecv.asExpr().getExpr() = ref.getReceiver() and
    mid.asExpr().getExpr() = ref
  |
    localFlowWithElementReference(mid, to)
  )
}

from
  HTTP::Server::RequestHandler handler, HTTP::Server::RequestInputAccess input,
  DataFlow::Node sensitive
where
  handler.getAnHttpMethod() = "get" and
  input.asExpr().getExpr().getEnclosingMethod() = handler and
  sensitive.asExpr().getExpr() instanceof SensitiveExpr and
  localFlowWithElementReference(input, sensitive)
select input, "$@ for GET requests uses query parameter as sensitive data.", handler,
  "Route handler"
