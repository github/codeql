/**
 * @name Python LDAP Injection
 * @description Python LDAP Injection through search filter
 * @kind path-problem
 * @problem.severity error
 * @id python/ldap-injection
 * @tags experimental	
 *       security	
 *       external/cwe/cwe-090
 */

// Determine precision above
import python
import experimental.semmle.python.security.injection.LDAPInjection
import DataFlow::PathGraph

from
  LDAPInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
  LDAPInjectionSink castedSink
where
  config.hasFlowPath(source, sink) and
  castedSink.getLDAPNode() = sink.getNode()
select sink.getNode(), source, sink, "$@ LDAP query executes $@ as a $@.", castedSink, "This",
  source.getNode(), "a user-provided value", castedSink.getLDAPNode(), castedSink.getLDAPPart()
