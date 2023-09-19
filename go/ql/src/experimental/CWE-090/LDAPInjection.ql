/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id go/ldap-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-90
 */

import go
import LDAPInjection
import LdapInjectionFlow::PathGraph

from LdapInjectionFlow::PathNode source, LdapInjectionFlow::PathNode sink
where LdapInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "LDAP query parameter depends on a $@.", source.getNode(),
  "user-provided value"
