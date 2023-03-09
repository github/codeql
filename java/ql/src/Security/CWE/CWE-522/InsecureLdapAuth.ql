/**
 * @name Insecure LDAP authentication
 * @description LDAP authentication with credentials sent in cleartext.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/insecure-ldap-auth
 * @tags security
 *       experimental
 *       external/cwe/cwe-522
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.security.InsecureLdapAuthQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, InsecureUrlFlowConfig config
where
  config.hasFlowPath(source, sink) and
  any(BasicAuthFlowConfig bc).hasFlowTo(sink.getNode()) and
  not any(SslFlowConfig sc).hasFlowTo(sink.getNode())
select sink.getNode(), source, sink, "Insecure LDAP authentication from $@.", source.getNode(),
  "LDAP connection string"
