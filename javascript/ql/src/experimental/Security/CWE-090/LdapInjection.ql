/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id javascript/ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */

import javascript
import DataFlow::PathGraph
import LdapInjection::LdapInjection

from LdapInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ might include code from $@.",
  sink.getNode().(Sink).getQueryCall(), "LDAP query call", source.getNode(), "user-provided value"
