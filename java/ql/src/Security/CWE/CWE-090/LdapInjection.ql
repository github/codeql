/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.LdapInjectionQuery
import LdapInjectionFlow::PathGraph

from LdapInjectionFlow::PathNode source, LdapInjectionFlow::PathNode sink
where LdapInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This LDAP query depends on a $@.", source.getNode(),
  "user-provided value"
