/**
 * Provides a taint tracking configuration for reasoning about host header
 * poisoning in email generation.
 */

import javascript

/**
 * A taint tracking configuration for host header poisoning in email generation.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "TaintedHostHeader" }

  override predicate isSource(DataFlow::Node node) {
    exists(HTTP::RequestHeaderAccess input | node = input |
      input.getKind() = "header" and
      input.getAHeaderName() = "host"
    )
  }

  override predicate isSink(DataFlow::Node node) {
    exists(EmailSender email | node = email.getABody())
  }
}
