/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the client side.
 *
 * Note, for performance reasons: only import this file if
 * `ClientSideUrlRedirect::Configuration` is needed, otherwise
 * `ClientSideUrlRedirectCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import UrlConcatenation

module ClientSideUrlRedirect {
  import ClientSideUrlRedirectCustomizations::ClientSideUrlRedirect

  // Materialize flow labels
  private class ConcreteDocumentUrl extends DocumentUrl {
    ConcreteDocumentUrl() { this = this }
  }

  /**
   * A taint-tracking configuration for reasoning about unvalidated URL redirections.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ClientSideUrlRedirect" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
      source.(Source).getAFlowLabel() = lbl
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerEdge(DataFlow::Node source, DataFlow::Node sink) {
      hostnameSanitizingPrefixEdge(source, sink)
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel f, DataFlow::FlowLabel g
    ) {
      untrustedUrlSubstring(pred, succ) and
      f instanceof DocumentUrl and
      g.isTaint()
      or
      // preserve document.url label in step from `location` to `location.href`
      f instanceof DocumentUrl and
      g instanceof DocumentUrl and
      succ.(DataFlow::PropRead).accesses(pred, "href")
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof HostnameSanitizerGuard
    }
  }

  /**
   * Improper use of openExternal can be leveraged to compromise the user's host.
   * When openExternal is used with untrusted content, it can be leveraged to execute arbitrary commands.
   */
  class ElectronShellOpenExternalSink extends Sink {
    ElectronShellOpenExternalSink() {
      this =
        DataFlow::moduleMember("electron", "shell").getAMemberCall("openExternal").getArgument(0)
    }
  }
}
