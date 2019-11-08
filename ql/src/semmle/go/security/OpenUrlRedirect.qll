/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the server side.
 *
 * Note, for performance reasons: only import this file if
 * `OpenUrlRedirect::Configuration` is needed, otherwise
 * `OpenUrlRedirectCustomizations` should be imported instead.
 */

import go
import UrlConcatenation

module OpenUrlRedirect {
  import OpenUrlRedirectCustomizations::OpenUrlRedirect

  /**
   * A taint-tracking configuration for reasoning about unvalidated URL redirections.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "OpenUrlRedirect" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      // A write to URL.Host
      exists(Write write, Field f, DataFlow::SsaNode var |
        write.writesField(var.getAUse(), f, pred) and
        succ = var.getAUse() and
        write.getASuccessor+() = succ.asInstruction() and
        f.getName() = "Host" and
        var.getType().hasQualifiedName("net/url", "URL")
      )
      or
      StringConcatenation::taintStep(pred, succ)
      or
      // Allow flow through functions that are considered for taint flow.
      exists(
        TaintTracking::FunctionModel m, DataFlow::CallNode c, DataFlow::FunctionInput inp,
        DataFlow::FunctionOutput outp
      |
        c = m.getACall() and
        m.hasTaintFlow(inp, outp) and
        pred = inp.getNode(c) and
        succ = outp.getNode(c)
      )
    }

    override predicate isBarrierOut(DataFlow::Node node) { hostnameSanitizingPrefixEdge(node, _) }

    override predicate isBarrierGuard(DataFlow::BarrierGuard guard) {
      guard instanceof BarrierGuard
    }
  }
}
