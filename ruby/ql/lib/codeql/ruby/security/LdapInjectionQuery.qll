/**
 * Provides default sources, sinks and sanitizers for detecting
 * LDAP Injections, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking

/** Provides a taint-tracking configuration for detecting LDAP Injections vulnerabilities. */
module LdapInjection {
  import LdapInjectionCustomizations::LdapInjection

  /**
   * A taint-tracking configuration for detecting LDAP Injections vulnerabilities.
   */
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      LdapInjection::isAdditionalFlowStep(node1, node2)
    }
  }

  import TaintTracking::Global<Config>
}
