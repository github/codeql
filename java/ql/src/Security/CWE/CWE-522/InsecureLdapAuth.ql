/**
 * @name Insecure LDAP authentication
 * @description LDAP authentication with credentials sent in cleartext makes sensitive information vulnerable to remote attackers
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id java/insecure-ldap-auth
 * @tags security
 *       external/cwe/cwe-522
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.security.InsecureLdapAuthQuery
import InsecureLdapUrlFlow::PathGraph

from InsecureLdapUrlFlow::PathNode source, InsecureLdapUrlFlow::PathNode sink
where
  InsecureLdapUrlFlow::flowPath(source, sink) and
  BasicAuthFlow::flowTo(sink.getNode()) and
  not RequiresSslFlow::flowTo(sink.getNode())
select sink.getNode(), source, sink, "Insecure LDAP authentication from $@.", source.getNode(),
  "LDAP connection string"
