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

private class UntrustedResultReceiverConf extends TaintTracking2::Configuration {
  UntrustedResultReceiverConf() { this = "UntrustedResultReceiverConf" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(ResultReceiverSendCall c).getReceiver()
  }
}

private predicate untrustedResultReceiverSend(DataFlow::Node src, ResultReceiverSendCall call) {
  any(UntrustedResultReceiverConf c).hasFlow(src, DataFlow::exprNode(call.getReceiver()))
}

private class SensitiveResultReceiverConf extends TaintTracking::Configuration {
  SensitiveResultReceiverConf() { this = "SensitiveResultReceiverConf" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node node) {
    exists(ResultReceiverSendCall call |
      untrustedResultReceiverSend(_, call) and
      node.asExpr() = call.getSentData()
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    super.allowImplicitRead(node, c)
    or
    this.isSink(node)
  }
}

/** Holds if there is a path from sensitive data at `src` to a result receiver at `sink`, and the receiver was obtained from an untrusted source `recSrc`. */
predicate sensitiveResultReceiver(
  DataFlow::PathNode src, DataFlow::PathNode sink, DataFlow::Node recSrc
) {
  exists(ResultReceiverSendCall call, SensitiveResultReceiverConf conf |
    conf.hasFlowPath(src, sink) and
    sink.getNode().asExpr() = call.getSentData() and
    untrustedResultReceiverSend(recSrc, call)
  )
}
