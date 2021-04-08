/**
 * @name Improper LDAP Authentication
 * @description A user-controlled query carries no authentication
 * @kind path-problem
 * @problem.severity warning
 * @id py/improper-ldap-auth
 * @tags experimental
 *       security
 *       external/cwe/cwe-287
 */

// Determine precision above
import python
import experimental.semmle.python.security.LDAPImproperAuth
import DataFlow::PathGraph

from LDAPImproperAuthenticationConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ LDAP query parameter contains $@ and is executed without authentication.", sink.getNode(),
  "This", source.getNode(), "a user-provided value"
