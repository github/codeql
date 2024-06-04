/**
 * Provides default sources, sinks and sanitizers for detecting
 * improper LDAP authentication, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import ImproperLdapAuthCustomizations::ImproperLdapAuth

/**
 * A taint-tracking configuration for detecting improper LDAP authentication vulnerabilities.
 * DEPRECATED: Use `ImproperLdapAuthFlow` instead
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ImproperLdapAuth" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

private module ImproperLdapAuthConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for detecting improper LDAP authentication vulnerabilities.
 */
module ImproperLdapAuthFlow = TaintTracking::Global<ImproperLdapAuthConfig>;
