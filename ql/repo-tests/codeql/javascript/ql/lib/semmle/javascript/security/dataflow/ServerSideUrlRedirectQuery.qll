/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the server side.
 *
 * Note, for performance reasons: only import this file if
 * `ServerSideUrlRedirect::Configuration` is needed, otherwise
 * `ServerSideUrlRedirectCustomizations` should be imported instead.
 */

import javascript
import RemoteFlowSources
import UrlConcatenation
import ServerSideUrlRedirectCustomizations::ServerSideUrlRedirect

/**
 * A taint-tracking configuration for reasoning about unvalidated URL redirections.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ServerSideUrlRedirect" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerEdge(DataFlow::Node source, DataFlow::Node sink) {
    hostnameSanitizingPrefixEdge(source, sink)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof LocalUrlSanitizingGuard or
    guard instanceof HostnameSanitizerGuard
  }
}
