/** Definitions for the sensitive result receiver query. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SensitiveActions
private import semmle.code.java.dataflow.FlowSinks

private class ResultReceiverSendCall extends MethodCall {
  ResultReceiverSendCall() {
    this.getMethod()
        .getASourceOverriddenMethod*()
        .hasQualifiedName("android.os", "ResultReceiver", "send")
  }

  Expr getReceiver() { result = this.getQualifier() }

  Expr getSentData() { result = this.getArgument(1) }
}

private module UntrustedResultReceiverConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(ResultReceiverSendCall c).getReceiver()
  }
}

private module UntrustedResultReceiverFlow = TaintTracking::Global<UntrustedResultReceiverConfig>;

private predicate untrustedResultReceiverSend(DataFlow::Node src, ResultReceiverSendCall call) {
  UntrustedResultReceiverFlow::flow(src, DataFlow::exprNode(call.getReceiver()))
}

/**
 * A sensitive result receiver sink node.
 */
private class SensitiveResultReceiverSink extends ApiSinkNode {
  SensitiveResultReceiverSink() {
    exists(ResultReceiverSendCall call |
      untrustedResultReceiverSend(_, call) and
      this.asExpr() = call.getSentData()
    )
  }
}

private module SensitiveResultReceiverConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) { node instanceof SensitiveResultReceiverSink }

  predicate allowImplicitRead(DataFlow::Node n, DataFlow::ContentSet c) { isSink(n) and exists(c) }
}

/** Taint tracking flow for sensitive expressions flowing to untrusted result receivers. */
module SensitiveResultReceiverFlow = TaintTracking::Global<SensitiveResultReceiverConfig>;

/**
 * Holds if there is a path from sensitive data at `src` to a result receiver at `sink`, and the receiver was obtained from an untrusted source `recSrc`.
 */
predicate isSensitiveResultReceiver(
  SensitiveResultReceiverFlow::PathNode src, SensitiveResultReceiverFlow::PathNode sink,
  DataFlow::Node recSrc
) {
  exists(ResultReceiverSendCall call |
    SensitiveResultReceiverFlow::flowPath(src, sink) and
    sink.getNode().asExpr() = call.getSentData() and
    untrustedResultReceiverSend(recSrc, call)
  )
}
