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
  Routing::RouteSetup setup, Routing::RouteHandler handler, Http::RequestInputAccess input,
  SensitiveNode sensitive
where
  setup.getOwnHttpMethod() = "GET" and
  setup.getAChild+() = handler and
  input.getRouteHandler() = handler.getFunction() and
  input.getKind() = "parameter" and
  input.(DataFlow::SourceNode).flowsTo(sensitive) and
  not sensitive.getClassification() = SensitiveDataClassification::id()
select input, "$@ for GET requests uses query parameter as sensitive data.", handler,
  "Route handler"
