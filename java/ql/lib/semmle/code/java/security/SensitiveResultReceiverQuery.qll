/** Definitions for the sensitive result receiver query. */

import java
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SensitiveActions

private class ResultReceiverSendCall extends MethodAccess {
  ResultReceiverSendCall() {
    this.getMethod()
        .getASourceOverriddenMethod*()
        .hasQualifiedName("android.os", "ResultReceiver", "send")
  }

  Expr getReceiver() { result = this.getQualifier() }

  Expr getSentData() { result = this.getArgument(1) }
}

private module UntrustedResultReceiverConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(ResultReceiverSendCall c).getReceiver()
  }
}

private module UntrustedResultReceiverFlow = TaintTracking::Global<UntrustedResultReceiverConfig>;

private predicate untrustedResultReceiverSend(DataFlow::Node src, ResultReceiverSendCall call) {
  UntrustedResultReceiverFlow::flow(src, DataFlow::exprNode(call.getReceiver()))
}

private module SensitiveResultReceiverConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) {
    exists(ResultReceiverSendCall call |
      untrustedResultReceiverSend(_, call) and
      node.asExpr() = call.getSentData()
    )
  }

  predicate allowImplicitRead(DataFlow::Node n, DataFlow::ContentSet c) { isSink(n) and exists(c) }
}

module SensitiveResultReceiverFlow = TaintTracking::Global<SensitiveResultReceiverConfig>;

/**
 * DEPRECATED: Use `isSensitiveResultReceiver` instead.
 *
 * Holds if there is a path from sensitive data at `src` to a result receiver at `sink`, and the receiver was obtained from an untrusted source `recSrc`.
 */
deprecated predicate sensitiveResultReceiver(
  DataFlow::PathNode src, DataFlow::PathNode sink, DataFlow::Node recSrc
) {
  exists(
    ResultReceiverSendCall call, SensitiveResultReceiverFlow::PathNode srrSrc,
    SensitiveResultReceiverFlow::PathNode srrSink
  |
    src.getNode() = srrSrc.getNode() and sink.getNode() = srrSink.getNode()
  |
    SensitiveResultReceiverFlow::flowPath(srrSrc, srrSink) and
    sink.getNode().asExpr() = call.getSentData() and
    untrustedResultReceiverSend(recSrc, call)
  )
}

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
