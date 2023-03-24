/**
 * @name Sensitive data read from GET request
 * @description Placing sensitive data in a GET request increases the risk of
 *              the data being exposed to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id rb/sensitive-get-query
 * @tags security
 *       external/cwe/cwe-598
 */

import ruby
import DataFlow::PathGraph
import codeql.ruby.security.SensitiveGetQueryQuery
import codeql.ruby.security.SensitiveActions

from DataFlow::PathNode source, DataFlow::PathNode sink, SensitiveGetQuery::Configuration config
where config.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "$@ for GET requests uses query parameter as sensitive data.",
  source.getNode().(SensitiveGetQuery::Source).getHandler(), "Route handler"
