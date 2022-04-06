/**
 * Provides taint-tracking configurations for detecting LDAP injection vulnerabilities
 *
 * Note, for performance reasons: only import this file if
 * `LdapInjection::Configuration` is needed, otherwise
 * `LdapInjectionCustomizations` should be imported instead.
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import LdapInjectionCustomizations::LdapInjection

/**
 * A taint-tracking configuration for detecting LDAP injection vulnerabilities
 * via the distinguished name (DN) parameter of an LDAP search.
 */
class DnConfiguration extends TaintTracking::Configuration {
  DnConfiguration() { this = "LdapDnInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DnSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof DnSanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof DnSanitizerGuard
  }
}

/**
 * A taint-tracking configuration for detecting LDAP injection vulnerabilities
 * via the filter parameter of an LDAP search.
 */
class FilterConfiguration extends TaintTracking::Configuration {
  FilterConfiguration() { this = "LdapFilterInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FilterSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof FilterSanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof FilterSanitizerGuard
  }
}
