/**
 * Provides a taint-tracking configuration for detecting LDAP injection vulnerabilities
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

class LDAPInjectionSink extends DataFlow::Node {
  // DataFlow::Node attrs;
  DataFlow::Node ldapNode;
  string ldapPart;

  LDAPInjectionSink() {
    exists(LDAPQuery ldapQuery |
      this = ldapQuery and
      ldapNode = ldapQuery.getLDAPNode() and
      ldapPart = ldapQuery.getLDAPPart() // and
      // if exists(ldapQuery.getAttrs()) then attrs = ldapQuery.getAttrs()
    )
  }

  DataFlow::Node getLDAPNode() { result = ldapNode }

  string getLDAPPart() { result = ldapPart }
  // DataFlow::Node getAttrs() { result = attrs }
}

/**
 * A taint-tracking configuration for detecting regular expression injections.
 */
class LDAPInjectionFlowConfig extends TaintTracking::Configuration {
  LDAPInjectionFlowConfig() { this = "LDAPInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(LDAPInjectionSink ldapInjSink).getLDAPNode()
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(LDAPEscape ldapEsc).getEscapeNode()
  }
}
