/**
 * Provides a taint-tracking configuration for detecting LDAP injection vulnerabilities
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

module LdapInjection {
  import LdapInjectionCustomizations::LdapInjection

  class DnConfiguration extends TaintTracking::Configuration {
    DnConfiguration() { this = "LdapDnInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof DnSink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof DnSanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof DnSanitizerGuard
    }
  }

  class FilterConfiguration extends TaintTracking::Configuration {
    FilterConfiguration() { this = "LdapFilterInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof FilterSink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof FilterSanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof FilterSanitizerGuard
    }
  }

  import DataFlow::PathGraph

  predicate ldapInjection(DataFlow::PathNode source, DataFlow::PathNode sink) {
    any(DnConfiguration dnConfig).hasFlowPath(source, sink)
    or
    any(FilterConfiguration filterConfig).hasFlowPath(source, sink)
  }
}
