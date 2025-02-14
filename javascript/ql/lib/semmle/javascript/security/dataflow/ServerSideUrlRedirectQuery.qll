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
module ServerSideUrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isBarrierOut(DataFlow::Node node) { hostnameSanitizingPrefixEdge(node, _) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(HtmlSanitizerCall call |
      node1 = call.getInput() and
      node2 = call
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about unvalidated URL redirections.
 */
module ServerSideUrlRedirectFlow = TaintTracking::Global<ServerSideUrlRedirectConfig>;

/**
 * DEPRECATED. Use the `ServerSideUrlRedirectFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ServerSideUrlRedirect" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerOut(DataFlow::Node node) {
    ServerSideUrlRedirectConfig::isBarrierOut(node)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof LocalUrlSanitizingGuard or
    guard instanceof HostnameSanitizerGuard
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    ServerSideUrlRedirectConfig::isAdditionalFlowStep(pred, succ)
  }
}

/**
 * A call to a function called `isLocalUrl` or similar, which is
 * considered to sanitize a variable for purposes of URL redirection.
 */
class LocalUrlSanitizingGuard extends DataFlow::CallNode {
  LocalUrlSanitizingGuard() { this.getCalleeName().regexpMatch("(?i)(is_?)?local_?url") }

  /** DEPRECATED. Use `blocksExpr` instead. */
  deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

  /** Holds if this node blocks flow through `e`, provided it evaluates to `outcome`. */
  predicate blocksExpr(boolean outcome, Expr e) {
    this.getAnArgument().asExpr() = e and
    outcome = true
  }
}

deprecated private class LocalUrlSanitizingGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof LocalUrlSanitizingGuard
{
  override predicate sanitizes(boolean outcome, Expr e) {
    LocalUrlSanitizingGuard.super.sanitizes(outcome, e)
  }
}
