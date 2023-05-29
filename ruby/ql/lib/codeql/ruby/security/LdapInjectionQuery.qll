/**
 * Provides default sources, sinks and sanitizers for detecting
 * LDAP Injections, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import LdapInjectionCustomizations
private import LdapInjectionCustomizations::LdapInjection

/**
 * A taint-tracking configuration for detecting LDAP Injections vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "LdapInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    LdapInjection::isAdditionalTaintStep(node1, node2)
  }
}
