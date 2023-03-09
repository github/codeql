/**
 * @name Insecure LDAP authentication
 * @description LDAP authentication with credentials sent in cleartext.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision medium
 * @id java/insecure-ldap-auth
 * @tags security
 *       experimental
 *       external/cwe/cwe-522
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.security.InsecureLdapAuthQuery
import InsecureLdapAuthQuery::PathGraph

from InsecureUrlFlowConfiguration::PathNode source, InsecureUrlFlowConfiguration::PathNode sink
where
  InsecureUrlFlowConfiguration::hasFlowPath(source, sink) and
  BasicAuthFlowConfiguration::hasFlowTo(sink.getNode()) and
  not SslFlowConfiguration::hasFlowTo(sink.getNode())
select sink.getNode(), source, sink, "Insecure LDAP authentication from $@.", source.getNode(),
  "LDAP connection string"
