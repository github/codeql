/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the client side.
 *
 * Note, for performance reasons: only import this file if
 * `ClientSideUrlRedirect::Configuration` is needed, otherwise
 * `ClientSideUrlRedirectCustomizations` should be imported instead.
 */

import javascript
import UrlConcatenation
import ClientSideUrlRedirectCustomizations::ClientSideUrlRedirect
import semmle.javascript.security.TaintedUrlSuffix

// Materialize flow labels
deprecated private class ConcreteDocumentUrl extends DocumentUrl {
  ConcreteDocumentUrl() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about unvalidated URL redirections.
 */
module ClientSideUrlRedirectConfig implements DataFlow::StateConfigSig {
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and state.isTaint()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = HostnameSanitizerGuard::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    TaintedUrlSuffix::isStateBarrier(node, state)
  }

  predicate isBarrierOut(DataFlow::Node node) { hostnameSanitizingPrefixEdge(node, _) }

  predicate isBarrierOut(DataFlow::Node node, FlowState state) { isSink(node, state) }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedUrlSuffix::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    exists(HtmlSanitizerCall call |
      node1 = call.getInput() and
      node2 = call and
      state1 = state2
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow for reasoning about unvalidated URL redirections.
 */
module ClientSideUrlRedirectFlow = TaintTracking::GlobalWithState<ClientSideUrlRedirectConfig>;
