/**
 * @name Sensitive data read from GET request
 * @description Placing sensitive data in a GET request increases the risk of
 *              the data being exposed to an attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id js/sensitive-get-query
 * @tags security
 *       external/cwe/cwe-598
 */

import javascript

from
  Express::RouteSetup setup, Express::RouteHandler handler, Express::RequestInputAccess input,
  SensitiveExpr sensitive
where
  setup.getRequestMethod() = "GET" and
  handler = setup.getARouteHandler() and
  input.getRouteHandler() = handler and
  input.getKind() = "parameter" and
  input.(DataFlow::SourceNode).flowsToExpr(sensitive) and
  not sensitive.getClassification() = SensitiveDataClassification::id()
select input, "$@ for GET requests uses query parameter as sensitive data.", handler,
  "Route handler"
