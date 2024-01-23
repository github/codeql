/** Definitions for Android Sensitive UI queries */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.SensitiveActions

/** A configuration for tracking sensitive information to system notifications. */
private module NotificationTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "notification") }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    isSink(node) and exists(c)
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/** Taint tracking flow for sensitive data flowing to system notifications. */
module NotificationTracking = TaintTracking::Global<NotificationTrackingConfig>;
