/**
 * @name Improper LDAP Authentication
 * @description A user-controlled query carries no authentication
 * @kind path-problem
 * @problem.severity warning
 * @id rb/improper-ldap-auth
 * @tags security
 *       experimental
 *       external/cwe/cwe-287
 */

import codeql.ruby.DataFlow
import codeql.ruby.security.ImproperLdapAuthQuery
import codeql.ruby.Concepts
import ImproperLdapAuthFlow::PathGraph

from ImproperLdapAuthFlow::PathNode source, ImproperLdapAuthFlow::PathNode sink
where ImproperLdapAuthFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This LDAP authencation depends on a $@.", source.getNode(),
  "user-provided value"
