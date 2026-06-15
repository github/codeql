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
import codeql.ruby.security.SensitiveGetQueryQuery
import codeql.ruby.security.SensitiveGetQueryCustomizations::SensitiveGetQuery
import codeql.ruby.security.SensitiveActions

from Source source, DataFlow::Node sink
where SensitiveGetQueryFlow::flow(source, sink)
select source, "$@ for GET requests uses query parameter as sensitive data.", source.getHandler(),
  "Route handler"
