/**
 * Provides default sources, sinks and sanitizers for detecting
 * improper LDAP authentication, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import ImproperLdapAuthCustomizations::ImproperLdapAuth

private module ImproperLdapAuthConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting improper LDAP authentication vulnerabilities.
 */
module ImproperLdapAuthFlow = TaintTracking::Global<ImproperLdapAuthConfig>;
