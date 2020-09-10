import javascript

module LdapInjection {
  import LdapInjectionCustomizations::LdapInjection

  /**
   * A taint-tracking configuration for reasoning about LDAP injection vulnerabilities.
   */
  class LdapInjectionConfiguration extends TaintTracking::Configuration {
    LdapInjectionConfiguration() { this = "LdapInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }
}
