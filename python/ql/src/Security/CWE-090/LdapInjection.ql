/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id py/ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */

// Determine precision above
import python
import semmle.python.security.dataflow.LdapInjectionQuery
import LdapInjectionFlow::PathGraph

from LdapInjectionFlow::PathNode source, LdapInjectionFlow::PathNode sink, string parameterName
where
  LdapInjectionDnFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) and
  parameterName = "DN"
  or
  LdapInjectionFilterFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
  parameterName = "filter"
select sink.getNode(), source, sink,
  "LDAP query parameter (" + parameterName + ") depends on a $@.", source.getNode(),
  "user-provided value"
