/**
 * Provides a taint-tracking configuration for detecting LDAP injection vulnerabilities
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting LDAP injections.
 */
class LDAPInjectionFlowConfig extends TaintTracking::Configuration {
  LDAPInjectionFlowConfig() { this = "LDAPInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(LDAPQuery ldapQuery).getQuery() }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(LDAPEscape ldapEsc).getAnInput()
  }
}
