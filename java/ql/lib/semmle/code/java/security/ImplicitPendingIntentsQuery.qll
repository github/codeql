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
module ImplicitPendingIntentStartConfig implements DataFlow::StateConfigSig {
  class FlowState = PendingIntentState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof ImplicitPendingIntentSource and state instanceof NoState
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof ImplicitPendingIntentSink and state instanceof MutablePendingIntent
  }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof ExplicitIntentSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(ImplicitPendingIntentAdditionalTaintStep c).step(node1, node2)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    any(ImplicitPendingIntentAdditionalTaintStep c).mutablePendingIntentCreation(node1, node2) and
    state1 instanceof NoState and
    state2 instanceof MutablePendingIntent
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    isSink(node, _) and
    allowIntentExtrasImplicitRead(node, c)
    or
    isAdditionalFlowStep(node, _) and
    c.(DataFlow::FieldContent).getType() instanceof PendingIntent
    or
    // Allow implicit reads of Intent arrays for steps like getActivities
    // or sinks like startActivities
    (isSink(node, _) or isAdditionalFlowStep(node, _, _, _)) and
    node.getType().(Array).getElementType() instanceof TypeIntent and
    c instanceof DataFlow::ArrayContent
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module ImplicitPendingIntentStartFlow =
  TaintTracking::GlobalWithState<ImplicitPendingIntentStartConfig>;
