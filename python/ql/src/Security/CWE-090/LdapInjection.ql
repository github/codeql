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
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, string parameterName
where
  any(DnConfiguration dnConfig).hasFlowPath(source, sink) and
  parameterName = "DN"
  or
  any(FilterConfiguration filterConfig).hasFlowPath(source, sink) and
  parameterName = "filter"
select sink.getNode(), source, sink,
  "$@ LDAP query parameter (" + parameterName + ") comes from $@.", sink.getNode(), "This",
  source.getNode(), "a user-provided value"
