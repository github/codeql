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
import LDAPInsecureAuthFlow::PathGraph
import experimental.semmle.python.security.LDAPInsecureAuth

from LDAPInsecureAuthFlow::PathNode source, LDAPInsecureAuthFlow::PathNode sink
where LDAPInsecureAuthFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This LDAP host is authenticated insecurely."
