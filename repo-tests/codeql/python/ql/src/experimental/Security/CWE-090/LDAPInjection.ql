/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id py/ldap-injection
 * @tags experimental	
 *       security	
 *       external/cwe/cwe-090
 */

// Determine precision above
import python
import experimental.semmle.python.security.injection.LDAP
import DataFlow::PathGraph

from LDAPInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ LDAP query parameter comes from $@.", sink.getNode(),
  "This", source.getNode(), "a user-provided value"
