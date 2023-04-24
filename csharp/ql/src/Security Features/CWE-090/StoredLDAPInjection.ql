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
import StoredLdapInjection::PathGraph

module StoredLdapInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }

  predicate isSink = LdapInjectionConfig::isSink/1;

  predicate isBarrier = LdapInjectionConfig::isBarrier/1;
}

module StoredLdapInjection = TaintTracking::Global<StoredLdapInjectionConfig>;

from StoredLdapInjection::PathNode source, StoredLdapInjection::PathNode sink
where StoredLdapInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This LDAP query depends on a $@.", source.getNode(),
  "stored (potentially user-provided) value"
