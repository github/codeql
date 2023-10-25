/**
 * Provides a taint-tracking configuration for reasoning about
 * server-side email-injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `EmailInjection::Configuration` is needed, otherwise
 * `EmailInjectionCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about
 * email-injection vulnerabilities.
 */
module EmailInjection {
  import EmailInjectionCustomizations::EmailInjection

  /**
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about email-injection vulnerabilities.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "Email Injection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  }

  /** Tracks taint flow for reasoning about email-injection vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
}
