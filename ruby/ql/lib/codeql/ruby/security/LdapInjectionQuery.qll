/**
 * Provides default sources, sinks and sanitizers for detecting
 * LDAP Injections, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import LdapInjectionCustomizations::LdapInjection as LI

private module LdapInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LI::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof LI::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof LI::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    LI::isAdditionalFlowStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting LDAP Injections vulnerabilities.
 */
module LdapInjectionFlow = TaintTracking::Global<LdapInjectionConfig>;
