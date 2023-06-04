/**
 * @name Improper LDAP Authentication
 * @description A user-controlled query carries no authentication
 * @kind path-problem
 * @problem.severity warning
 * @id go/improper-ldap-auth
 * @tags security
 *       experimental
 *       external/cwe/cwe-287
 */

import go
import ImproperLdapAuth
import DataFlow::PathGraph

from ImproperLdapAuthConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "LDAP binding password depends on a $@.", source.getNode(),
  "user-provided value"
