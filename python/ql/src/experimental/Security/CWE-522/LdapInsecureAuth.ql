/**
 * @name Python Insecure LDAP Authentication
 * @description Python LDAP Insecure LDAP Authentication
 * @kind path-problem
 * @problem.severity error
 * @id py/insecure-ldap-auth
 * @tags security
 *       experimental
 *       external/cwe/cwe-522
 *       external/cwe/cwe-523
 */

// determine precision above
import python
import experimental.semmle.python.security.LdapInsecureAuth
import LdapInsecureAuthFlow::PathGraph

from LdapInsecureAuthFlow::PathNode source, LdapInsecureAuthFlow::PathNode sink
where LdapInsecureAuthFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This LDAP host is authenticated insecurely."
