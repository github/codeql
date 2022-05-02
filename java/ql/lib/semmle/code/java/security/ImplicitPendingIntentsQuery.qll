/** Provides taint tracking configurations to be used in queries related to implicit `PendingIntent`s. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.android.PendingIntent
import semmle.code.java.security.ImplicitPendingIntents

/**
 * A taint tracking configuration for implicit `PendingIntent`s
 * being wrapped in another implicit `Intent` that gets started.
 */
class ImplicitPendingIntentStartConf extends TaintTracking::Configuration {
  ImplicitPendingIntentStartConf() { this = "ImplicitPendingIntentStartConf" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.(ImplicitPendingIntentSource).hasState(state)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink.(ImplicitPendingIntentSink).hasState(state)
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof ExplicitIntentSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(ImplicitPendingIntentAdditionalTaintStep c).step(node1, node2)
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    any(ImplicitPendingIntentAdditionalTaintStep c).step(node1, state1, node2, state2)
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    super.allowImplicitRead(node, c)
    or
    this.isSink(node, _) and
    allowIntentExtrasImplicitRead(node, c)
    or
    this.isAdditionalTaintStep(node, _) and
    c.(DataFlow::FieldContent).getType() instanceof PendingIntent
    or
    // Allow implicit reads of Intent arrays for steps like getActivities
    // or sinks like startActivities
    (this.isSink(node, _) or this.isAdditionalFlowStep(node, _, _, _)) and
    node.getType().(Array).getElementType() instanceof TypeIntent and
    c instanceof DataFlow::ArrayContent
  }
}
