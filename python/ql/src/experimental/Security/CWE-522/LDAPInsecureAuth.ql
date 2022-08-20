/**
 * @name Python Insecure LDAP Authentication
 * @description Python LDAP Insecure LDAP Authentication
 * @kind path-problem
 * @problem.severity error
 * @id py/insecure-ldap-auth
 * @tags security
 *       external/cwe/cwe-522
 *       external/cwe/cwe-523
 */

// determine precision above
import python
import DataFlow::PathGraph
import experimental.semmle.python.security.LDAPInsecureAuth

from LdapInsecureAuthConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is authenticated insecurely.", sink.getNode(),
  "This LDAP host"
