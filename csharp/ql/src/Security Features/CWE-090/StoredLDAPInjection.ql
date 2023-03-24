/**
 * @name LDAP query built from stored user-controlled sources
 * @description Building an LDAP query from stored user-controlled sources is vulnerable to
 *              insertion of malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id cs/stored-ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */

import csharp
import semmle.code.csharp.security.dataflow.LDAPInjectionQuery
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class StoredTaintTrackingConfiguration extends TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }
}

from StoredTaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This LDAP query depends on a $@.", source.getNode(),
  "stored (potentially user-provided) value"
