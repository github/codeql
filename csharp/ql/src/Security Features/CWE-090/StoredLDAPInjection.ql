/**
 * @name LDAP query built from stored user-controlled sources
 * @description Building an LDAP query from stored user-controlled sources is vulnerable to
 *              insertion of malicious LDAP code by the user.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/stored-ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */
import csharp
import semmle.code.csharp.security.dataflow.LDAPInjection::LDAPInjection
import semmle.code.csharp.security.dataflow.flowsources.Stored

class StoredTaintTrackingConfiguration extends TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) {
    source instanceof StoredFlowSource
  }
}

from StoredTaintTrackingConfiguration c, StoredFlowSource source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in an LDAP query.", source, "Stored user-provided value"
