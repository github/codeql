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
   * A taint-tracking configuration for reasoning about email-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "Email Injection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSanitizerOut(DataFlow::Node node) {
      exists(DataFlow::CallNode call |
        call.getTarget().hasQualifiedName("hash.Hash", "Write") and
        (
          call.getReceiver().getType().getName() = "Hash" or
          call.getReceiver().getType().getName() = "Hash32" or
          call.getReceiver().getType().getName() = "Hash64"
        )
      |
        node = call.getArgument(0)
      )
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  }
}
